class PrivacyPolicySection {
  final String title;
  final String body;

  const PrivacyPolicySection({required this.title, required this.body});
}

class PrivacyPolicyContent {
  static const String effectiveDate = '27 de enero de 2026';

  static const List<PrivacyPolicySection> sections = [
    // 1. Introducción
    PrivacyPolicySection(
      title: 'Introduccion',
      body: '''Esta Politica de Privacidad (la "Politica") describe las practicas de Bikain OU (en adelante "Biblia Chat", "nosotros" o "nos") con respecto a la informacion personal recopilada, almacenada, utilizada, transferida, compartida y procesada de nuestros usuarios ("tu" o "usted") en conexion con la aplicacion movil Biblia Chat y todos los servicios relacionados (colectivamente, la "App" o los "Servicios").

Bikain OU es una sociedad de responsabilidad limitada constituida bajo las leyes de Estonia, con domicilio social en Harju maakond, Tallinn, Kristiine linnaosa, Kotkapoja tn 2a-10, 10615, identificada con el codigo de registro 16315409 y numero de IVA EE102419777.

"Informacion Personal" significa, segun corresponda, la informacion relacionada con una persona fisica identificada o identificable segun lo definido por el Reglamento (UE) 2016/679 ("RGPD"), la Ley de Privacidad del Consumidor de California ("CCPA") y otras leyes de privacidad aplicables.

Biblia Chat se proporciona "tal cual" y existe unicamente con fines informativos y devocionales. La app no proporciona asesoramiento medico, psicologico, legal ni pastoral. Los usuarios que experimenten angustia emocional o problemas de salud mental deben buscar apoyo personalizado de un profesional cualificado. En situaciones de emergencia, los usuarios deben llamar a los servicios de emergencia locales (por ejemplo, 911 en EE.UU. o 112 en Europa).

Para preguntas o solicitudes relacionadas con esta Politica, puedes contactarnos en info@releasemvps.com.''',
    ),

    // 2. Información que recopilamos
    PrivacyPolicySection(
      title: 'Informacion que recopilamos',
      body: '''Datos de perfil proporcionados por ti:
- Correo electronico (opcional, solo si vinculas tu cuenta)
- Nombre (opcional)
- Genero
- Denominacion religiosa
- Pais de origen y grupo cultural
- Grupo de edad
- Motivo principal de uso
- Preferencias de recordatorio (habilitado/deshabilitado, hora)
- Zona horaria (detectada automaticamente)

Datos del chat con IA:
- Mensajes enviados y recibidos en conversaciones con la IA
- Memoria de la IA (hechos que la IA recuerda sobre ti para personalizar respuestas)
- Resumenes de conversaciones
- Mensajes guardados como favoritos

Datos de actividad:
- Actividad diaria (racha de dias consecutivos, stories visualizadas)
- Progreso en planes de estudio
- Contador de mensajes enviados por dia

Datos del dispositivo:
- Tokens de dispositivo para notificaciones push (Firebase Cloud Messaging)
- Tipo de dispositivo y sistema operativo

Datos de pago:
- Gestionados por RevenueCat. Almacenamos tu identificador de usuario de RevenueCat y estado de suscripcion, pero NO almacenamos datos de tarjetas de credito ni informacion financiera.

Datos de uso y analiticas:
- Firebase Analytics y Mixpanel recopilan patrones de uso agregados, vistas de pantalla y eventos de interaccion.''',
    ),

    // 3. Cómo usamos tu información
    PrivacyPolicySection(
      title: 'Como usamos tu informacion',
      body: '''Utilizamos tu informacion personal para los siguientes propositos:

- Proporcionar respuestas de IA personalizadas adaptadas a tu denominacion religiosa, origen cultural y grupo de edad.
- Mantener el contexto y la memoria de las conversaciones para una mejor experiencia de chat.
- Entregar lecturas biblicas diarias y contenido de Stories.
- Registrar tu racha de dias consecutivos y progreso en planes de estudio.
- Enviar notificaciones push (si las has habilitado).
- Procesar suscripciones a traves de RevenueCat.
- Mejorar la app, su contenido y funcionalidades.
- Prevenir fraude y uso indebido de los servicios.
- Cumplir con obligaciones legales aplicables.''',
    ),

    // 4. Base legal del tratamiento (GDPR)
    PrivacyPolicySection(
      title: 'Base legal del tratamiento (RGPD)',
      body: '''Cuando el RGPD es aplicable, procesamos tu informacion personal basandonos en las siguientes bases legales:

Consentimiento: Para datos opcionales como la vinculacion de correo electronico, activacion de notificaciones push y preferencias de recordatorio. Puedes retirar tu consentimiento en cualquier momento contactandonos en info@releasemvps.com.

Ejecucion del contrato: Para proporcionar el servicio de chat con IA, planes de estudio y contenido diario que forman parte de los Servicios que te ofrecemos.

Interes legitimo: Para analiticas, mejora de la app y prevencion de fraude. Nuestro interes legitimo no prevalece sobre tus derechos y libertades fundamentales.

Obligacion legal: Para cumplir con las regulaciones de la Union Europea y otras leyes aplicables.

Ten en cuenta que algunos datos que proporcionas pueden considerarse datos sensibles (creencias religiosas). Solo procesamos estos datos con tu consentimiento expreso, que otorgas al utilizar la App y proporcionar dicha informacion voluntariamente.''',
    ),

    // 5. Inteligencia Artificial y tus datos
    PrivacyPolicySection(
      title: 'Inteligencia Artificial y tus datos',
      body: '''Biblia Chat utiliza inteligencia artificial para generar respuestas personalizadas. Es importante que entiendas como se procesan tus datos en este contexto:

- Tus mensajes son procesados por modelos de OpenAI (GPT-4o y GPT-5.2) a traves de funciones del servidor (Supabase Edge Functions). Las claves de la API de IA nunca se exponen en la app del cliente.

- Segun la politica de uso de datos de la API de OpenAI, los datos enviados a traves de su API no se utilizan para entrenar sus modelos.

- La App mantiene una "memoria de IA" (ai_memory) que almacena hechos relevantes sobre ti para personalizar las respuestas (por ejemplo, tu situacion familiar o temas recurrentes). Puedes solicitar la eliminacion de esta memoria contactandonos.

- Cada 20 mensajes, se genera automaticamente un resumen de la conversacion para mantener el contexto sin necesidad de enviar todo el historial.

- Puedes eliminar mensajes individuales o conversaciones completas desde la App.

- El contenido generado por la IA es orientativo y no sustituye el consejo pastoral, medico o profesional.''',
    ),

    // 6. Con quién compartimos tu información
    PrivacyPolicySection(
      title: 'Con quien compartimos tu informacion',
      body: '''Compartimos tu informacion personal con los siguientes terceros, unicamente para los fines descritos en esta Politica:

Supabase: Alojamiento de base de datos, autenticacion y funciones del servidor.

OpenAI: Procesamiento de mensajes de chat mediante inteligencia artificial. OpenAI esta establecida en EE.UU. y opera bajo su acuerdo de procesamiento de datos.

RevenueCat: Procesamiento de suscripciones y pagos.

Firebase (Google): Notificaciones push y analiticas.

Mixpanel: Analiticas de producto.

Apple y Google: Distribucion de la app y procesamiento de compras dentro de la app.

Autoridades legales: Cuando sea requerido por ley o necesario para proteger nuestros derechos legales.

NO vendemos tu informacion personal a terceros.
NO compartimos tu informacion personal con fines de publicidad dirigida.''',
    ),

    // 7. Seguridad de los datos
    PrivacyPolicySection(
      title: 'Seguridad de los datos',
      body: '''Hemos implementado medidas tecnicas y organizativas razonables y apropiadas para proteger tu informacion personal:

- Seguridad a nivel de base de datos (Row Level Security) que garantiza que cada usuario solo puede acceder a sus propios datos.
- Conexiones cifradas (HTTPS/TLS) en todas las comunicaciones.
- Procesamiento de IA del lado del servidor (las claves de API nunca estan en la app del cliente).
- Autenticacion anonima por defecto, con opcion voluntaria de vincular correo electronico.
- Alojamiento en Supabase con cifrado en reposo.

Ningun sistema es completamente seguro. Si descubres una vulnerabilidad de seguridad, por favor contactanos inmediatamente en info@releasemvps.com.''',
    ),

    // 8. Retención de datos
    PrivacyPolicySection(
      title: 'Retencion de datos',
      body: '''Cuenta activa: Tu informacion personal se conserva mientras tu cuenta exista y utilices los Servicios.

Eliminacion de cuenta: Cuando solicitas la eliminacion de tu cuenta (disponible en Ajustes > Zona de peligro > Borrar mi cuenta):
- Tu informacion personal identificable (nombre, correo electronico, tokens de dispositivo, identificador de RevenueCat) se elimina inmediatamente.
- Se crea un archivo pseudonimizado con fines de defensa legal, conforme al Articulo 17(3) del RGPD. Este archivo utiliza un hash SHA256 de tu identificador de usuario (no reversible) y contiene: datos demograficos sin informacion identificable, mensajes de chat sin identificacion de usuario y metricas agregadas.
- El archivo pseudonimizado se conserva durante 3 anos desde la fecha de archivo y se elimina automaticamente despues.

Si deseas que eliminemos tus datos antes del periodo de retencion, puedes contactarnos en info@releasemvps.com.''',
    ),

    // 9. Tus derechos (GDPR)
    PrivacyPolicySection(
      title: 'Tus derechos (RGPD)',
      body: '''Si resides en la Union Europea o el Espacio Economico Europeo, tienes los siguientes derechos:

Derecho de acceso: Puedes solicitar una copia de la informacion personal que tenemos sobre ti.

Derecho de rectificacion: Puedes corregir tu informacion personal desde la pantalla "Editar Perfil" en la App, o contactandonos.

Derecho de supresion: Puedes eliminar tu cuenta y todos tus datos desde Ajustes > Zona de peligro > Borrar mi cuenta.

Derecho a la limitacion del tratamiento: Puedes solicitar que limitemos el procesamiento de tu informacion en determinadas circunstancias.

Derecho a la portabilidad: Puedes solicitar una copia de tus datos en un formato estructurado y de uso comun.

Derecho de oposicion: Puedes oponerte al procesamiento de tu informacion personal en determinadas circunstancias, incluido el marketing directo.

Derecho a retirar el consentimiento: Puedes retirar tu consentimiento en cualquier momento, sin que ello afecte a la licitud del tratamiento basado en el consentimiento previo a su retirada.

Derecho a presentar una reclamacion: Puedes presentar una reclamacion ante la Inspeccion de Proteccion de Datos de Estonia (Andmekaitse Inspektsioon) o ante la autoridad de proteccion de datos de tu pais de residencia.

Para ejercer cualquiera de estos derechos, contactanos en info@releasemvps.com. Responderemos a tu solicitud en un plazo maximo de 30 dias.''',
    ),

    // 10. Derechos de privacidad en EE.UU.
    PrivacyPolicySection(
      title: 'Derechos de privacidad en EE.UU.',
      body: '''Si resides en los Estados Unidos, puedes tener derechos adicionales segun las leyes de privacidad estatales, incluyendo la Ley de Privacidad del Consumidor de California (CCPA/CPRA) y la Ley de Proteccion de Datos del Consumidor de Virginia (VCDPA), entre otras.

Tus derechos como consumidor incluyen:
- Derecho a conocer que informacion personal recopilamos y como la usamos.
- Derecho a acceder a tu informacion personal.
- Derecho a corregir inexactitudes en tu informacion personal.
- Derecho a eliminar tu informacion personal.
- Derecho a obtener una copia de tu informacion personal.
- Derecho a optar por no participar en la venta de datos personales.

Declaracion importante: NO vendemos tu informacion personal. NO compartimos tu informacion personal con fines de publicidad dirigida. NO realizamos perfilado con efectos legales o similarmente significativos.

No discriminacion: No te discriminaremos por ejercer tus derechos de privacidad.

Para ejercer tus derechos, contactanos en info@releasemvps.com. Responderemos en un plazo de 45 dias, ampliable por otros 45 dias si fuera necesario, notificandote la extension.''',
    ),

    // 11. Menores de edad
    PrivacyPolicySection(
      title: 'Menores de edad',
      body: '''Los Servicios estan destinados a personas mayores de 18 anos. No recopilamos intencionadamente informacion personal de menores de 18 anos.

Si descubrimos que hemos recopilado informacion personal de un menor de 18 anos, la eliminaremos de inmediato.

Si eres padre o tutor y crees que tu hijo nos ha proporcionado informacion personal, contactanos en info@releasemvps.com para que podamos tomar las medidas necesarias.''',
    ),

    // 12. Transferencias internacionales
    PrivacyPolicySection(
      title: 'Transferencias internacionales',
      body: '''Bikain OU esta establecida en Estonia, miembro de la Union Europea. Sin embargo, algunos de nuestros proveedores de servicios externos estan establecidos fuera de la UE, principalmente en los Estados Unidos.

Cuando transferimos tu informacion personal fuera de la UE, nos aseguramos de que se aplique una de las siguientes garantias:

- Solo transferimos datos a paises que la Comision Europea ha considerado que proporcionan un nivel adecuado de proteccion de datos personales.

- Cuando utilizamos determinados proveedores de servicios, empleamos Clausulas Contractuales Tipo (CCT) aprobadas por la Comision Europea, que proporcionan la misma proteccion para los datos personales que en la UE.

- Cuando sea aplicable, nos amparamos en el Marco de Privacidad de Datos UE-EE.UU. (EU-US Data Privacy Framework).

Para mas informacion sobre las garantias aplicadas, contactanos en info@releasemvps.com.''',
    ),

    // 13. Cambios a esta política
    PrivacyPolicySection(
      title: 'Cambios a esta politica',
      body: '''Podemos actualizar esta Politica periodicamente. Si realizamos cambios materiales en la forma en que recopilamos o utilizamos tu informacion, haremos esfuerzos razonables para notificarte (por ejemplo, mediante un aviso en la App o por correo electronico si lo has proporcionado).

El uso continuado de los Servicios despues de la actualizacion de esta Politica indica tu aceptacion de los cambios realizados. En algunos casos, se te dara la opcion de aceptar los cambios expresamente.

Si no aceptas los terminos de la Politica actualizada, debes dejar de utilizar los Servicios.''',
    ),

    // 14. Contacto
    PrivacyPolicySection(
      title: 'Contacto',
      body: '''Si tienes preguntas, comentarios o solicitudes relacionadas con esta Politica de Privacidad o el ejercicio de tus derechos, puedes contactarnos en:

Bikain OU
Harju maakond, Tallinn, Kristiine linnaosa
Kotkapoja tn 2a-10, 10615
Estonia

Codigo de registro: 16315409
Numero de IVA: EE102419777

Correo electronico: info@releasemvps.com''',
    ),
  ];
}
