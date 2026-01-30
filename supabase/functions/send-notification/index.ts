import { serve } from "https://deno.land/std@0.224.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.49.1";
import { encodeBase64Url } from "https://deno.land/std@0.224.0/encoding/base64url.ts";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

interface NotificationPayload {
  user_id: string;
  title: string;
  body: string;
  data?: Record<string, string>; // { screen: "home" | "stories" | "study" | "chat" }
}

interface ServiceAccount {
  project_id: string;
  private_key: string;
  client_email: string;
}

/**
 * Genera un JWT firmado con RS256 para autenticación con Google APIs
 */
async function createSignedJwt(serviceAccount: ServiceAccount): Promise<string> {
  const header = { alg: "RS256", typ: "JWT" };
  const now = Math.floor(Date.now() / 1000);
  const payload = {
    iss: serviceAccount.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
  };

  const encodedHeader = encodeBase64Url(new TextEncoder().encode(JSON.stringify(header)));
  const encodedPayload = encodeBase64Url(new TextEncoder().encode(JSON.stringify(payload)));
  const unsignedToken = `${encodedHeader}.${encodedPayload}`;

  // Importar la clave privada para firmar
  const pemContents = serviceAccount.private_key
    .replace(/-----BEGIN PRIVATE KEY-----/g, '')
    .replace(/-----END PRIVATE KEY-----/g, '')
    .replace(/\n/g, '');

  const binaryKey = Uint8Array.from(atob(pemContents), c => c.charCodeAt(0));

  const cryptoKey = await crypto.subtle.importKey(
    "pkcs8",
    binaryKey,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"]
  );

  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    cryptoKey,
    new TextEncoder().encode(unsignedToken)
  );

  const encodedSignature = encodeBase64Url(new Uint8Array(signature));
  return `${unsignedToken}.${encodedSignature}`;
}

/**
 * Obtiene un access token de Google usando el JWT firmado
 */
async function getAccessToken(serviceAccount: ServiceAccount): Promise<string> {
  const jwt = await createSignedJwt(serviceAccount);

  const response = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${jwt}`,
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Failed to get access token: ${error}`);
  }

  const data = await response.json();
  return data.access_token;
}

/**
 * Envía una notificación push a un dispositivo específico
 */
async function sendPushNotification(
  token: string,
  title: string,
  body: string,
  data: Record<string, string>,
  platform: string,
  accessToken: string,
  projectId: string
): Promise<{ success: boolean; error?: string }> {
  const message: Record<string, unknown> = {
    message: {
      token,
      notification: { title, body },
      data,
    }
  };

  // Configuración específica por plataforma
  if (platform === 'android') {
    (message.message as Record<string, unknown>).android = {
      priority: "high",
      notification: {
        channel_id: "biblia_chat_channel",
        sound: "default",
      }
    };
  } else if (platform === 'ios') {
    (message.message as Record<string, unknown>).apns = {
      payload: {
        aps: {
          sound: "default",
          badge: 1,
        }
      }
    };
  }

  try {
    const response = await fetch(
      `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
      {
        method: "POST",
        headers: {
          "Authorization": `Bearer ${accessToken}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(message),
      }
    );

    if (!response.ok) {
      const error = await response.text();
      console.error(`FCM error for token ${token.substring(0, 20)}...: ${error}`);
      return { success: false, error };
    }

    return { success: true };
  } catch (error) {
    console.error(`FCM error for token ${token.substring(0, 20)}...: ${error}`);
    return { success: false, error: String(error) };
  }
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const { user_id, title, body, data = {} } = await req.json() as NotificationPayload;

    if (!user_id || !title || !body) {
      throw new Error('Missing required fields: user_id, title, body');
    }

    console.log(`Sending notification to user ${user_id}: "${title}"`);

    // Obtener configuración
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;
    const firebaseServiceAccountJson = Deno.env.get('FIREBASE_SERVICE_ACCOUNT');

    if (!firebaseServiceAccountJson) {
      throw new Error('FIREBASE_SERVICE_ACCOUNT secret not configured');
    }

    const serviceAccount: ServiceAccount = JSON.parse(firebaseServiceAccountJson);
    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // Obtener dispositivos del usuario
    const { data: devices, error: devicesError } = await supabase
      .from('user_devices')
      .select('device_token, platform')
      .eq('user_id', user_id);

    if (devicesError) {
      throw new Error(`Failed to get devices: ${devicesError.message}`);
    }

    if (!devices || devices.length === 0) {
      console.log(`No devices found for user ${user_id}`);
      return new Response(
        JSON.stringify({ success: true, sent: 0, message: 'No devices found' }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      );
    }

    console.log(`Found ${devices.length} device(s) for user ${user_id}`);

    // Obtener access token de Firebase
    const accessToken = await getAccessToken(serviceAccount);

    // Enviar a todos los dispositivos
    const results = await Promise.all(
      devices.map(device =>
        sendPushNotification(
          device.device_token,
          title,
          body,
          data,
          device.platform,
          accessToken,
          serviceAccount.project_id
        )
      )
    );

    const successCount = results.filter(r => r.success).length;
    const failureCount = results.filter(r => !r.success).length;

    console.log(`Notification sent: ${successCount} success, ${failureCount} failures`);

    // Si hay tokens inválidos, eliminarlos de la BD
    const invalidTokenIndices = results
      .map((r, i) => r.error?.includes('UNREGISTERED') ? i : -1)
      .filter(i => i !== -1);

    if (invalidTokenIndices.length > 0) {
      const invalidTokens = invalidTokenIndices.map(i => devices[i].device_token);
      await supabase
        .from('user_devices')
        .delete()
        .in('device_token', invalidTokens);
      console.log(`Removed ${invalidTokens.length} invalid token(s)`);
    }

    return new Response(
      JSON.stringify({
        success: true,
        sent: successCount,
        failed: failureCount,
        removed_invalid: invalidTokenIndices.length
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );

  } catch (error) {
    console.error('send-notification error:', error);
    return new Response(
      JSON.stringify({
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error'
      }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    );
  }
});
