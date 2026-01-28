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
      body: '''Esta Politica de Privacidad (la "Politica") describe las practicas de Bikain OU (en adelante "Biblia Chat Cristiano", "nosotros" o "nos") con respecto a la informacion personal de nuestros usuarios ("tu" o "usted") en conexion con la aplicacion movil Biblia Chat Cristiano y todos los servicios relacionados (la "App" o los "Servicios"). Esta Politica forma parte de nuestros Terminos y Condiciones.

"Informacion Personal" significa, segun corresponda, la informacion relacionada con una persona fisica identificada o identificable segun lo definido por el Reglamento (UE) 2016/679 ("RGPD"), la Ley de Proteccion de Datos del Reino Unido de 2018 ("UK Data Act"), la Ley de Privacidad del Consumidor de California ("CCPA"), la Ley de Proteccion de Datos del Consumidor de Virginia ("VCDPA") y otras leyes de privacidad aplicables (el RGPD, la UK Data Act, la CCPA y cualquier otra ley de proteccion de datos aplicable, cuando y segun corresponda, denominadas conjuntamente la "Ley"), incluyendo tambien datos sensibles, si fuera el caso ("Informacion Personal"). Las disposiciones aplicables de esta Politica pueden variar segun tu residencia y se ajustaran a la Ley aplicable.

El responsable del tratamiento es Bikain OU, sociedad de responsabilidad limitada constituida bajo las leyes de Estonia, con domicilio social en Harju maakond, Tallinn, Kristiine linnaosa, Kotkapoja tn 2a-10, 10615 (codigo de registro: 16315409, IVA: EE102419777).

Esta Politica establece tus derechos y recursos en virtud de la Ley, por lo que te rogamos que la leas detenidamente.

Biblia Chat Cristiano se proporciona "tal cual" y existe unicamente con fines informativos y devocionales. La App no proporciona asesoramiento medico, psicologico, legal ni pastoral. En situaciones de emergencia, contacta a los servicios de emergencia locales (911 en EE.UU. o 112 en Europa).

Para cualquier consulta relacionada con esta Politica, puedes contactarnos en info@releasemvps.com.''',
    ),

    // 2. Información que recopilamos
    PrivacyPolicySection(
      title: 'Informacion que recopilamos',
      body: '''Datos de perfil:
- Correo electronico (opcional, solo si vinculas tu cuenta)
- Nombre (opcional)
- Genero, denominacion religiosa, pais de origen, grupo de edad
- Preferencias de recordatorio y zona horaria

Datos del chat:
- Mensajes enviados y recibidos en conversaciones con la IA
- Mensajes guardados como favoritos

Datos de actividad:
- Racha de dias consecutivos y progreso en planes de estudio

Datos del dispositivo:
- Informacion basica del dispositivo para notificaciones push

Datos de pago:
- Gestionados por terceros (RevenueCat, Apple, Google). NO almacenamos datos de tarjetas de credito ni informacion financiera.

Datos de analiticas:
- Patrones de uso agregados y eventos de interaccion, recopilados mediante servicios de analiticas de terceros.''',
    ),

    // 3. Cómo usamos tu información
    PrivacyPolicySection(
      title: 'Como usamos tu informacion',
      body: '''Utilizamos tu informacion para:

- Proporcionar respuestas personalizadas adaptadas a tu perfil.
- Mantener el contexto de las conversaciones para una mejor experiencia.
- Entregar lecturas biblicas diarias y contenido devocional.
- Registrar tu progreso y actividad en la App.
- Enviar notificaciones push (si las has habilitado).
- Procesar suscripciones.
- Mejorar la App y sus funcionalidades.
- Prevenir fraude y uso indebido.
- Cumplir con obligaciones legales.''',
    ),

    // 4. Base legal del tratamiento (GDPR)
    PrivacyPolicySection(
      title: 'Base legal del tratamiento',
      body: '''Procesamos tu informacion basandonos en: tu consentimiento, la ejecucion del contrato de servicio, nuestro interes legitimo (analiticas, mejora y prevencion de fraude) y obligaciones legales aplicables.

Algunos datos que proporcionas pueden considerarse datos sensibles (creencias religiosas). Solo procesamos estos datos con tu consentimiento expreso, que otorgas al utilizar la App y proporcionar dicha informacion voluntariamente. Puedes retirar tu consentimiento en cualquier momento contactandonos en info@releasemvps.com.''',
    ),

    // 5. Inteligencia Artificial y tus datos
    PrivacyPolicySection(
      title: 'Inteligencia Artificial y tus datos',
      body: '''Biblia Chat Cristiano utiliza servicios de inteligencia artificial de terceros para generar respuestas personalizadas. Tus mensajes se procesan en nuestros servidores y se envian a estos servicios para generar las respuestas.

La App puede recordar informacion relevante de tus conversaciones para personalizar futuras respuestas. Puedes eliminar mensajes individuales o conversaciones completas desde la App, y puedes solicitar la eliminacion de cualquier dato almacenado contactandonos.

El contenido generado por la IA es orientativo y no sustituye el consejo pastoral, medico o profesional.''',
    ),

    // 6. Con quién compartimos tu información
    PrivacyPolicySection(
      title: 'Con quien compartimos tu informacion',
      body: '''Para ofrecer nuestros Servicios, trabajamos con los siguientes proveedores externos:

- Supabase: Alojamiento y gestion de datos.
- OpenAI: Servicios de inteligencia artificial.
- RevenueCat: Gestion de suscripciones.
- Firebase (Google): Notificaciones y analiticas.
- Apple y Google: Distribucion de la App y compras.

Tambien podemos compartir informacion con autoridades legales cuando sea requerido por ley.

NO vendemos tu informacion personal a terceros.
NO compartimos tu informacion con fines de publicidad dirigida.''',
    ),

    // 7. Seguridad de los datos
    PrivacyPolicySection(
      title: 'Seguridad de los datos',
      body: '''Hemos implementado medidas tecnicas y organizativas para proteger tu informacion personal, incluyendo conexiones cifradas, controles de acceso a nivel de base de datos y procesamiento seguro en el servidor.

Ningun sistema es completamente seguro. Si descubres una vulnerabilidad, contactanos en info@releasemvps.com.''',
    ),

    // 8. Retención de datos
    PrivacyPolicySection(
      title: 'Retencion de datos',
      body: '''Tu informacion se conserva mientras tu cuenta exista y utilices los Servicios.

Al eliminar tu cuenta (disponible en Ajustes), tu informacion personal identificable se elimina inmediatamente. Por motivos legales, podemos conservar un archivo anonimizado durante un periodo maximo de 3 anos.

Si deseas que eliminemos tus datos antes de ese periodo, contactanos en info@releasemvps.com.''',
    ),

    // 9. Tus derechos
    PrivacyPolicySection(
      title: 'Tus derechos',
      body: '''Si resides en la Union Europea o el Espacio Economico Europeo, tienes todos los derechos contemplados por el Reglamento General de Proteccion de Datos (RGPD), incluyendo el acceso, rectificacion, supresion, portabilidad y oposicion al tratamiento de tus datos personales. Puedes presentar una reclamacion ante la autoridad de proteccion de datos de tu pais de residencia.

Si resides en los Estados Unidos, tienes los derechos contemplados por las leyes de privacidad estatales aplicables (CCPA, CPRA, VCDPA, entre otras), incluyendo el derecho a conocer, acceder, corregir y eliminar tu informacion personal.

NO vendemos tu informacion personal. NO realizamos perfilado con efectos legales. No te discriminaremos por ejercer tus derechos de privacidad.

Para ejercer cualquiera de tus derechos, contactanos en info@releasemvps.com.''',
    ),

    // 10. Menores de edad
    PrivacyPolicySection(
      title: 'Menores de edad',
      body: '''Los Servicios estan destinados a personas mayores de 18 anos. No recopilamos intencionadamente informacion personal de menores de 18 anos. Si descubrimos que lo hemos hecho, la eliminaremos de inmediato.

Si eres padre o tutor y crees que tu hijo nos ha proporcionado informacion personal, contactanos en info@releasemvps.com.''',
    ),

    // 11. Transferencias internacionales
    PrivacyPolicySection(
      title: 'Transferencias internacionales',
      body: '''Bikain OU esta establecida en Estonia (Union Europea). Algunos de nuestros proveedores de servicios estan establecidos fuera de la UE, principalmente en los Estados Unidos.

Cuando transferimos datos fuera de la UE, aplicamos las garantias legales correspondientes, como las Clausulas Contractuales Tipo o el Marco de Privacidad de Datos UE-EE.UU., segun corresponda.''',
    ),

    // 12. Cambios a esta politica
    PrivacyPolicySection(
      title: 'Cambios a esta politica',
      body: '''Podemos actualizar esta Politica periodicamente. Si realizamos cambios significativos, te notificaremos a traves de la App. El uso continuado de los Servicios tras la actualizacion indica tu aceptacion de los cambios.''',
    ),

    // 13. Contacto
    PrivacyPolicySection(
      title: 'Contacto',
      body: '''Para cualquier consulta relacionada con esta Politica de Privacidad, puedes contactarnos en:

Bikain OU
Harju maakond, Tallinn, Kristiine linnaosa
Kotkapoja tn 2a-10, 10615, Estonia

Correo electronico: info@releasemvps.com''',
    ),
  ];
}
