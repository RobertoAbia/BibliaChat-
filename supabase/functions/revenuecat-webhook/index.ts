// =====================================================================
// revenuecat-webhook — Mantiene user_entitlements sincronizada con
// RevenueCat para que el BACKEND conozca el estado premium (límite de
// mensajes exacto en chat-send-message, gates server-side, analytics SQL).
//
// CONFIGURACIÓN (una vez):
//  1. Supabase → Edge Functions → Secrets: añadir RC_WEBHOOK_SECRET con un
//     valor aleatorio largo.
//  2. Desplegar esta función con "Enforce JWT verification" DESACTIVADO
//     (RevenueCat no envía un JWT de Supabase; la autenticación es el
//     header secreto).
//  3. RevenueCat → Project → Integrations → Webhooks → Add:
//     - URL: https://popqvhrgsokuviwtscid.supabase.co/functions/v1/revenuecat-webhook
//     - Authorization header value: el MISMO valor de RC_WEBHOOK_SECRET
//
// NOTA: RevenueCat no reenvía eventos pasados — las filas se van poblando
// con compras/renovaciones nuevas. Por eso chat-send-message trata la
// AUSENCIA de fila como "desconocido" (tope alto), no como "free".
// =====================================================================

import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";

const UUID_RE =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

// Eventos mientras los cuales el entitlement sigue ACTIVO. CANCELLATION es
// solo "auto-renovación desactivada": el usuario sigue siendo premium hasta
// expiration_at. BILLING_ISSUE entra en periodo de gracia.
const PREMIUM_EVENTS = new Set([
  "INITIAL_PURCHASE",
  "RENEWAL",
  "UNCANCELLATION",
  "PRODUCT_CHANGE",
  "CANCELLATION",
  "BILLING_ISSUE",
  "SUBSCRIPTION_EXTENDED",
  "NON_RENEWING_PURCHASE",
]);

interface RCEvent {
  type: string;
  app_user_id?: string;
  original_app_user_id?: string;
  period_type?: string; // NORMAL | TRIAL | INTRO
  purchased_at_ms?: number;
  expiration_at_ms?: number | null;
  environment?: string; // PRODUCTION | SANDBOX
  transferred_from?: string[];
  transferred_to?: string[];
}

function pickUserId(event: RCEvent): string | null {
  for (const candidate of [event.app_user_id, event.original_app_user_id]) {
    if (candidate && UUID_RE.test(candidate)) return candidate;
  }
  return null;
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok");
  }

  try {
    // --- Autenticación: header secreto compartido con RevenueCat ---
    const secret = Deno.env.get("RC_WEBHOOK_SECRET");
    const auth = req.headers.get("Authorization") ?? "";
    if (!secret || (auth !== secret && auth !== `Bearer ${secret}`)) {
      return new Response(
        JSON.stringify({ error: "Unauthorized" }),
        { status: 401, headers: { "Content-Type": "application/json" } },
      );
    }

    const body = await req.json();
    const event: RCEvent | undefined = body?.event;
    if (!event?.type) {
      return new Response(
        JSON.stringify({ error: "Missing event" }),
        { status: 400, headers: { "Content-Type": "application/json" } },
      );
    }

    console.log(
      `RC webhook: ${event.type} (${event.environment ?? "?"}) for ${event.app_user_id ?? "?"}`,
    );

    // Evento de prueba del dashboard de RevenueCat
    if (event.type === "TEST") {
      return new Response(
        JSON.stringify({ success: true, message: "Test event received" }),
        { headers: { "Content-Type": "application/json" } },
      );
    }

    const supabase = createClient(
      Deno.env.get("SUPABASE_URL")!,
      Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!,
    );
    const nowIso = new Date().toISOString();
    const source = event.environment === "SANDBOX"
      ? "revenuecat_sandbox"
      : "revenuecat";

    // TRANSFER: el entitlement cambia de usuario (restaurar compras en otra
    // cuenta). Activar al receptor y desactivar al emisor.
    if (event.type === "TRANSFER") {
      for (const id of event.transferred_to ?? []) {
        if (!UUID_RE.test(id)) continue;
        await supabase.from("user_entitlements").upsert({
          user_id: id,
          is_premium: true,
          last_synced_at: nowIso,
          source,
        });
      }
      for (const id of event.transferred_from ?? []) {
        if (!UUID_RE.test(id)) continue;
        await supabase.from("user_entitlements").upsert({
          user_id: id,
          is_premium: false,
          trial_active: false,
          last_synced_at: nowIso,
          source,
        });
      }
      return new Response(
        JSON.stringify({ success: true }),
        { headers: { "Content-Type": "application/json" } },
      );
    }

    const userId = pickUserId(event);
    if (!userId) {
      // app_user_id no es un UUID de Supabase (p.ej. alias anónimo de RC).
      // 200 para que RevenueCat no reintente eternamente.
      console.warn(`RC webhook: no Supabase UUID in event, ignoring`);
      return new Response(
        JSON.stringify({ success: true, message: "No Supabase user id" }),
        { headers: { "Content-Type": "application/json" } },
      );
    }

    const isPremium = PREMIUM_EVENTS.has(event.type);
    const isExpiration = event.type === "EXPIRATION";
    if (!isPremium && !isExpiration) {
      // Evento informativo (SUBSCRIBER_ALIAS, etc.): solo refrescar sync
      await supabase.from("user_entitlements").upsert({
        user_id: userId,
        last_synced_at: nowIso,
        source,
      });
      return new Response(
        JSON.stringify({ success: true, message: `Ignored ${event.type}` }),
        { headers: { "Content-Type": "application/json" } },
      );
    }

    const trialActive = isPremium && event.period_type === "TRIAL";
    const row: Record<string, unknown> = {
      user_id: userId,
      is_premium: isPremium,
      trial_active: trialActive,
      expires_at: event.expiration_at_ms
        ? new Date(event.expiration_at_ms).toISOString()
        : null,
      last_synced_at: nowIso,
      source,
    };
    if (trialActive && event.purchased_at_ms) {
      row.trial_started_at = new Date(event.purchased_at_ms).toISOString();
    }

    const { error } = await supabase.from("user_entitlements").upsert(row);
    if (error) {
      console.error("RC webhook upsert failed:", error.message);
      // 500 → RevenueCat reintenta con backoff
      return new Response(
        JSON.stringify({ success: false, error: "DB upsert failed" }),
        { status: 500, headers: { "Content-Type": "application/json" } },
      );
    }

    console.log(
      `RC webhook: ${userId} → is_premium=${isPremium}, trial=${trialActive}, expires=${row.expires_at}`,
    );
    return new Response(
      JSON.stringify({ success: true }),
      { headers: { "Content-Type": "application/json" } },
    );
  } catch (error) {
    console.error("RC webhook error:", error);
    return new Response(
      JSON.stringify({ success: false, error: "Internal error" }),
      { status: 500, headers: { "Content-Type": "application/json" } },
    );
  }
});
