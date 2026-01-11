-- Migration: Seed 7 Study Plans (Seven Deadly Sins)
-- Each plan has 7 days focused on overcoming a sin by cultivating its opposing virtue

-- First, clear any existing plans (in case we need to re-run)
DELETE FROM plan_days;
DELETE FROM plans;

-- ============================================================================
-- PLAN 1: SOBERBIA → HUMILDAD
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'a1000000-0000-0000-0000-000000000001',
  'Venciendo la Soberbia',
  'Un viaje de 7 días para reconocer la soberbia en tu vida y cultivar la humildad verdadera. Descubrirás cómo el orgullo nos separa de Dios y de los demás, y aprenderás a caminar con un corazón humilde.',
  'Cultiva la humildad y reconoce el orgullo oculto',
  7,
  '👑',
  'Todos los que desean crecer en humildad',
  false,
  true,
  1
);

-- Día 1: Reconociendo la soberbia
INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000001',
  1,
  ARRAY['Proverbios 16:18', 'Santiago 4:6'],
  'La soberbia es quizás el pecado más sutil y peligroso. No siempre se manifiesta como arrogancia obvia; a menudo se esconde detrás de la autosuficiencia, la necesidad de tener razón, o el desprecio silencioso hacia otros. Proverbios nos advierte que "antes del quebrantamiento es la soberbia" - el orgullo siempre precede a la caída.

Santiago nos recuerda que "Dios resiste a los soberbios, y da gracia a los humildes". Esto significa que nuestra soberbia literalmente bloquea la gracia de Dios en nuestras vidas. Cuando creemos que no necesitamos ayuda, cuando pensamos que somos mejores que otros, cuando nos cuesta pedir perdón... ahí está la soberbia actuando.

Hoy te invito a hacer un inventario honesto. ¿En qué áreas de tu vida te cuesta reconocer que necesitas a Dios y a los demás?',
  'Hoy, identifica una situación reciente donde actuaste con orgullo (no pediste ayuda, no admitiste un error, juzgaste a alguien). Escríbelo en una nota.',
  '¿En qué área de tu vida te cuesta más admitir que necesitas ayuda?'
);

-- Día 2: El ejemplo de Cristo
INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000001',
  2,
  ARRAY['Filipenses 2:5-8', 'Mateo 11:29'],
  'Jesús, siendo Dios, "se despojó a sí mismo, tomando forma de siervo". El Creador del universo lavó los pies de sus discípulos. El Rey de reyes nació en un pesebre. Este es el modelo de humildad que estamos llamados a seguir.

Jesús nos dice: "Aprended de mí, que soy manso y humilde de corazón". No dice "aprended mi doctrina" o "imiten mis milagros", sino "aprendan mi humildad". La humildad no es pensar menos de ti mismo, sino pensar menos en ti mismo. Es poner a otros primero, no por debilidad, sino por amor.

¿Qué significaría para ti "tomar forma de siervo" en tu contexto actual? ¿En tu familia? ¿En tu trabajo? ¿Con tus amigos?',
  'Realiza un acto de servicio anónimo hoy. Algo que nadie sepa que fuiste tú quien lo hizo.',
  '¿Qué te cuesta más del ejemplo de humildad de Jesús? ¿Por qué crees que es difícil para ti?'
);

-- Día 3: La trampa de la comparación
INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000001',
  3,
  ARRAY['Gálatas 6:4', '2 Corintios 10:12'],
  'Gran parte de nuestra soberbia viene de compararnos con otros. Nos sentimos bien cuando somos "mejores" que alguien en algo, y nos sentimos mal cuando alguien nos supera. Pero Pablo nos advierte que "los que se miden a sí mismos por sí mismos, y se comparan consigo mismos, no son juiciosos".

La comparación es una trampa porque siempre encontrarás a alguien "peor" que tú para sentirte superior, o alguien "mejor" para sentirte inferior. Ninguna de las dos cosas es saludable. Dios no te compara con nadie; Él te ve como su hijo amado, único e irrepetible.

Tu valor no viene de ser mejor que otros, sino de ser amado por Dios. Cuando internalizamos esto, la necesidad de compararnos desaparece.',
  'Cada vez que te descubras comparándote con alguien hoy (en redes sociales, en el trabajo, en cualquier lugar), di en voz baja: "Soy amado por Dios tal como soy".',
  '¿Con quién te comparas más frecuentemente? ¿Qué sientes cuando lo haces?'
);

-- Día 4: Aprendiendo a recibir corrección
INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000001',
  4,
  ARRAY['Proverbios 12:1', 'Proverbios 15:31-32'],
  'Una de las señales más claras de soberbia es la incapacidad de recibir corrección. "El que ama la instrucción ama la sabiduría; mas el que aborrece la reprensión es ignorante". Cuando alguien nos señala un error y nuestra primera reacción es defendernos, justificarnos o atacar... ahí está el orgullo.

La persona humilde ve la corrección como un regalo, no como un ataque. Entiende que tiene puntos ciegos y que necesita de otros para crecer. No significa que toda crítica sea válida, pero sí que debemos examinarla con corazón abierto antes de descartarla.

Piensa en la última vez que alguien te corrigió. ¿Cuál fue tu reacción inmediata? ¿Defensa? ¿Enojo? ¿O gratitud?',
  'Piensa en una persona que te ha corregido recientemente. Envíale un mensaje agradeciéndole por su honestidad, aunque en el momento no lo hayas recibido bien.',
  '¿Por qué crees que nos cuesta tanto recibir corrección? ¿Qué nos dice eso sobre nosotros mismos?'
);

-- Día 5: El orgullo espiritual
INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000001',
  5,
  ARRAY['Lucas 18:9-14', 'Mateo 23:12'],
  'Quizás la forma más peligrosa de soberbia es la espiritual. Es la del fariseo que oraba: "Dios, te doy gracias porque no soy como los otros hombres". Podemos caer en esto cuando juzgamos a otros por no ser "tan espirituales" como nosotros, cuando nos sentimos superiores por nuestras prácticas religiosas, o cuando usamos nuestra fe para mirar por encima del hombro a los demás.

Jesús fue durísimo con este tipo de orgullo. Prefirió la compañía de pecadores reconocidos que de religiosos soberbios. El publicano que simplemente dijo "Dios, sé propicio a mí, pecador" fue justificado, no el fariseo con su larga lista de logros espirituales.

La verdadera espiritualidad siempre produce humildad, nunca superioridad.',
  'Hoy, en tu tiempo de oración, confiesa específicamente cualquier sentimiento de superioridad espiritual que hayas tenido hacia alguien.',
  '¿Has sentido alguna vez que eres "mejor cristiano" que alguien? ¿Qué crees que Jesús pensaría de esa actitud?'
);

-- Día 6: Pidiendo perdón
INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000001',
  6,
  ARRAY['Mateo 5:23-24', '1 Juan 1:9'],
  'Pocas cosas requieren más humildad que pedir perdón sinceramente. No un "perdón si te ofendí" (que pone la responsabilidad en el otro), sino un "perdóname, me equivoqué" claro y sin excusas. El orgullo siempre busca justificaciones; la humildad asume responsabilidad.

Jesús dice que si estás ofreciendo tu ofrenda y recuerdas que tu hermano tiene algo contra ti, dejes tu ofrenda y vayas primero a reconciliarte. La relación con los demás es tan importante para Dios que debe venir incluso antes de la adoración.

¿Hay alguien a quien le debes una disculpa? ¿Alguien con quien tienes una relación rota por tu orgullo? Hoy puede ser el día de dar ese paso.',
  'Identifica a una persona a quien necesitas pedirle perdón (puede ser algo grande o pequeño). Hazlo hoy, en persona o por mensaje.',
  '¿Qué es lo más difícil para ti al pedir perdón? ¿El miedo al rechazo, admitir el error, o algo más?'
);

-- Día 7: Viviendo en humildad
INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000001',
  7,
  ARRAY['Miqueas 6:8', '1 Pedro 5:5-6'],
  'Hemos llegado al final de esta semana, pero el camino de la humildad es de toda la vida. Miqueas resume lo que Dios quiere de nosotros: "hacer justicia, amar misericordia, y humillarte ante tu Dios". La humildad no es un destino, es una forma de caminar.

Pedro nos dice que nos revistamos de humildad, como quien se pone una prenda cada mañana. Es una decisión diaria, no un logro de una vez. Y la promesa es hermosa: "Humillaos bajo la poderosa mano de Dios, para que él os exalte cuando fuere tiempo".

No se trata de humillarnos para que Dios nos exalte (eso sería orgullo disfrazado), sino de confiar en que cuando vivimos humildemente, Dios se encarga del resto.',
  'Escribe tres compromisos concretos para cultivar la humildad en tu vida diaria. Ponlos donde puedas verlos cada mañana.',
  '¿Qué has aprendido esta semana sobre la soberbia y la humildad? ¿Qué cambio concreto quieres mantener?'
);

-- ============================================================================
-- PLAN 2: AVARICIA → GENEROSIDAD
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'a1000000-0000-0000-0000-000000000002',
  'Venciendo la Avaricia',
  'Un viaje de 7 días para examinar tu relación con el dinero y las posesiones. Aprenderás a soltar el apego material y descubrirás la libertad y alegría que vienen con la generosidad.',
  'Libérate del apego al dinero y las posesiones',
  7,
  '💰',
  'Todos los que luchan con el materialismo',
  false,
  true,
  2
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000002',
  1,
  ARRAY['1 Timoteo 6:10', 'Mateo 6:24'],
  'La avaricia no es solo querer ser millonario. Es cualquier apego desordenado al dinero o las posesiones. Puede manifestarse como ansiedad por el futuro financiero, incapacidad de dar, o poner nuestra seguridad en lo material en lugar de en Dios.

Pablo no dice que el dinero es malo, sino que "el amor al dinero es raíz de todos los males". El problema no es tener, sino amar el tener. Jesús fue aún más directo: "No podéis servir a Dios y a las riquezas". No dijo "no debéis", sino "no podéis". Son amos incompatibles.

¿Dónde está tu corazón respecto al dinero? ¿Te da seguridad o ansiedad? ¿Puedes dar con alegría o te cuesta soltar?',
  'Revisa tu estado de cuenta bancario de este mes. ¿Qué dice tu forma de gastar sobre tus verdaderas prioridades?',
  '¿En qué momento el dinero te ha causado más ansiedad o conflicto? ¿Qué crees que revela eso?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000002',
  2,
  ARRAY['Lucas 12:15-21', 'Eclesiastés 5:10'],
  'Jesús contó la parábola del rico insensato que acumuló y acumuló, pensando que así tendría seguridad para muchos años. Pero Dios le dijo: "Necio, esta noche vienen a pedirte tu alma; y lo que has provisto, ¿de quién será?" Murió rico en cosas, pero pobre hacia Dios.

Eclesiastés nos recuerda: "El que ama el dinero, no se saciará de dinero". La avaricia es un pozo sin fondo. Siempre necesitamos un poco más para sentirnos seguros. Nunca es suficiente. Es una esclavitud disfrazada de éxito.

La pregunta no es cuánto tienes, sino cuánto te tiene a ti. ¿Eres dueño de tus posesiones o ellas son dueñas de ti?',
  'Elige un objeto que valores mucho (ropa, electrónico, etc.) y regálalo hoy a alguien que lo necesite.',
  '¿Hay algo material que sientes que "no podrías vivir sin ello"? ¿Por qué crees que tiene ese poder sobre ti?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000002',
  3,
  ARRAY['Mateo 6:19-21', 'Colosenses 3:2'],
  '"Donde esté tu tesoro, allí estará también tu corazón". Jesús no dijo "donde esté tu corazón, estará tu tesoro", sino al revés. Nuestras decisiones financieras revelan y también forman nuestro corazón.

Si invertimos en lo temporal, nuestro corazón se apegará a lo temporal. Si invertimos en lo eterno (en personas, en el Reino, en generosidad), nuestro corazón se orientará hacia lo eterno. El dinero es una herramienta poderosa para reorientar nuestro corazón.

¿En qué estás "invirtiendo" realmente tu dinero y tu tiempo? ¿Qué tesoros estás acumulando?',
  'Haz una donación hoy a una causa que te importe. No tiene que ser grande, pero hazlo con intención y alegría.',
  '¿Si alguien viera en qué gastas tu dinero, qué diría que es lo más importante para ti?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000002',
  4,
  ARRAY['2 Corintios 9:6-7', 'Proverbios 11:24-25'],
  '"El que siembra escasamente, también segará escasamente". La generosidad funciona con una lógica diferente a la del mundo. El mundo dice "guarda para tener"; el Reino dice "da para vivir". Parece contradictorio, pero es una ley espiritual.

"Dios ama al dador alegre". No al que da por obligación, culpa o para impresionar, sino al que da con gozo porque ha entendido que todo es de Dios y que dar es un privilegio. La generosidad alegre es evidencia de un corazón libre de avaricia.

¿Cómo describes tu actitud al dar? ¿Es con alegría, con reluctancia, con cálculo?',
  'La próxima vez que pagues algo hoy (café, comida, cualquier cosa), deja una propina generosa o paga por la persona detrás de ti.',
  '¿Recuerdas algún momento en que diste generosamente y sentiste alegría? ¿Qué lo hizo diferente?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000002',
  5,
  ARRAY['Filipenses 4:11-13', 'Hebreos 13:5'],
  'Pablo escribió "he aprendido a contentarme, cualquiera que sea mi situación". Nota que dijo "he aprendido" - el contentamiento no es natural, se cultiva. Y el secreto no era tener más, sino "todo lo puedo en Cristo que me fortalece".

Hebreos nos exhorta: "Sean vuestras costumbres sin avaricia, contentos con lo que tenéis ahora". El contentamiento es el antídoto contra la avaricia. No es conformismo o falta de ambición; es paz interior independiente de las circunstancias externas.

¿Puedes decir que estás contento con lo que tienes ahora? ¿O siempre hay algo más que "necesitas" para estar bien?',
  'Haz una lista de 10 cosas que tienes y por las que estás genuinamente agradecido. Léela en voz alta como oración de gratitud.',
  '¿Qué es lo mínimo que necesitas para vivir contento? ¿Crees que es posible el contentamiento verdadero?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000002',
  6,
  ARRAY['Hechos 20:35', 'Lucas 6:38'],
  '"Más bienaventurado es dar que recibir". Estas palabras de Jesús, citadas por Pablo, resumen una verdad profunda: la generosidad nos hace más felices que la acumulación. La ciencia moderna lo confirma: dar activa los centros de placer del cerebro más que recibir.

"Dad, y se os dará; medida buena, apretada, remecida y rebosando". No damos para recibir, pero cuando damos, activamos un ciclo de bendición. No siempre vuelve en forma de dinero, pero siempre vuelve.

La generosidad no es para cuando "tengamos suficiente". Es una disciplina espiritual que practicamos independientemente de cuánto tengamos.',
  'Ofrece tu tiempo hoy: ayuda a alguien con algo sin esperar nada a cambio. El tiempo es nuestro recurso más valioso.',
  '¿En tu experiencia, es más fácil dar dinero o dar tiempo? ¿Por qué crees que es así?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000002',
  7,
  ARRAY['1 Timoteo 6:17-19', 'Mateo 25:35-40'],
  'Pablo instruye a los ricos que "hagan bien, que sean ricos en buenas obras, dadivosos, generosos". La riqueza no es mala, pero viene con responsabilidad. Es una herramienta que puede usarse para el bien o puede convertirse en un ídolo.

Jesús identificó el servicio a los necesitados con el servicio a Él mismo: "En cuanto lo hicisteis a uno de estos mis hermanos más pequeños, a mí lo hicisteis". Cada acto de generosidad hacia otros es un acto de amor hacia Cristo.

Esta semana has reflexionado sobre tu relación con el dinero. ¿Qué vas a hacer diferente de ahora en adelante?',
  'Establece un plan concreto de generosidad: decide un porcentaje fijo de tus ingresos para dar regularmente. Anótalo y comprométete.',
  '¿Qué has aprendido esta semana sobre ti mismo y tu relación con el dinero? ¿Qué cambio quieres implementar?'
);

-- ============================================================================
-- PLAN 3: LUJURIA → PUREZA
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'a1000000-0000-0000-0000-000000000003',
  'Venciendo la Lujuria',
  'Un viaje de 7 días para entender la sexualidad desde la perspectiva de Dios y cultivar la pureza de corazón. Aprenderás a ver a las personas con dignidad y a proteger tu mente y tu corazón.',
  'Cultiva pureza de corazón y mente',
  7,
  '🔥',
  'Todos los que luchan con pensamientos o acciones impuras',
  false,
  true,
  3
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000003',
  1,
  ARRAY['Mateo 5:27-28', '1 Tesalonicenses 4:3-5'],
  'Jesús elevó el estándar de la pureza del comportamiento al corazón: "Cualquiera que mira a una mujer para codiciarla, ya adulteró con ella en su corazón". La lujuria no es solo un acto; es una mirada, un pensamiento, una actitud del corazón.

La lujuria reduce a las personas a objetos de placer. Las despoja de su dignidad como hijos de Dios. Nos entrena para usar en lugar de amar, para consumir en lugar de valorar. Por eso es tan destructiva.

Pablo nos llama a "poseer cada uno su cuerpo en santidad y honor". Tu cuerpo y tu sexualidad son sagrados. La pureza no es represión; es protección de algo valioso.',
  'Identifica qué "puertas" permiten que la lujuria entre en tu vida (ciertas apps, sitios web, situaciones). Hoy, cierra una de esas puertas.',
  '¿Qué diferencia hay entre atracción natural y lujuria? ¿Cómo sabes cuándo cruzas la línea?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000003',
  2,
  ARRAY['Génesis 1:27', '1 Corintios 6:19-20'],
  'La lujuria prospera cuando olvidamos quiénes somos y quiénes son los demás. Cada persona está hecha "a imagen de Dios". Esa persona que la lujuria quiere reducir a un cuerpo es alguien por quien Cristo murió, alguien amado infinitamente por el Padre.

Y tú mismo eres "templo del Espíritu Santo". Tu cuerpo no es tuyo para usarlo como quieras; fue comprado por precio. Esto no es para hacerte sentir culpable, sino para recordarte tu dignidad. Eres demasiado valioso para la lujuria.

¿Cómo cambiaría tu forma de mirar a otros si realmente los vieras como portadores de la imagen de Dios?',
  'Cuando te encuentres mirando a alguien con lujuria hoy, inmediatamente ora por esa persona: "Dios, bendice a esta persona que amas".',
  '¿Crees que es posible ver a una persona atractiva sin lujuria? ¿Qué se necesitaría para eso?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000003',
  3,
  ARRAY['Job 31:1', 'Salmos 101:3'],
  'Job hizo "pacto con sus ojos" para no mirar con lujuria. El salmista decidió no poner "cosa indigna" delante de sus ojos. La pureza comienza con lo que permitimos entrar por nuestros ojos.

En la era digital, esto es más desafiante que nunca. Contenido que antes había que buscar activamente ahora aparece sin invitación. Por eso necesitamos ser más intencionales que nunca sobre lo que vemos.

No se trata de vivir con miedo, sino con sabiduría. ¿Qué pacto necesitas hacer con tus ojos?',
  'Revisa las apps en tu teléfono y las cuentas que sigues. Elimina o deja de seguir todo lo que alimenta la lujuria.',
  '¿Qué tan difícil es para ti controlar lo que miras? ¿Qué estrategias has intentado y cuáles han funcionado?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000003',
  4,
  ARRAY['Filipenses 4:8', '2 Corintios 10:5'],
  '"Todo lo que es verdadero, todo lo honesto, todo lo justo, todo lo puro... en esto pensad". Pablo sabía que la batalla de la pureza se gana o se pierde en la mente. No podemos evitar que un pensamiento llegue, pero sí podemos decidir si le damos hospedaje.

"Llevando cautivo todo pensamiento a la obediencia a Cristo". Esto requiere vigilancia y práctica. Cuando un pensamiento impuro llega, no lo alimentes; captúralo y entrégalo a Cristo.

La mente es como un jardín: crecerá lo que plantes y lo que riegues. ¿Qué estás plantando en tu mente?',
  'Memoriza Filipenses 4:8 hoy. Cada vez que un pensamiento impuro llegue, recita este versículo como reemplazo.',
  '¿Qué tan rápido sueles "capturar" un pensamiento impuro? ¿Qué lo hace difícil?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000003',
  5,
  ARRAY['1 Corintios 6:18', 'Proverbios 5:3-4'],
  '"Huid de la fornicación". Pablo no dice "resistan" o "luchen contra", sino "huyan". A veces la mejor estrategia contra la tentación sexual no es quedarse a pelear, sino salir corriendo.

Proverbios describe cómo el pecado sexual parece dulce al principio pero termina siendo "amargo como el ajenjo". Las consecuencias de la lujuria no son solo espirituales; afectan relaciones, autoestima, intimidad real con otros.

¿Conoces tus "zonas de peligro"? ¿Esos momentos, lugares o estados emocionales donde eres más vulnerable? La huida requiere conocerse bien.',
  'Identifica tu momento o situación de mayor vulnerabilidad. Crea un plan específico de qué harás cuando llegue ese momento.',
  '¿Cuáles son tus "zonas de peligro" respecto a la lujuria? ¿Qué hace esas situaciones difíciles?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000003',
  6,
  ARRAY['Santiago 5:16', 'Proverbios 27:17'],
  '"Confesaos vuestras ofensas unos a otros". La lujuria prospera en el secreto. Cuando sacamos nuestras luchas a la luz con alguien de confianza, pierden mucho de su poder.

Esto requiere humildad y valentía, pero es increíblemente liberador. No tienes que luchar solo. Dios nos dio comunidad precisamente para esto: "Hierro con hierro se aguza".

¿Tienes a alguien con quien puedas ser completamente honesto sobre esta lucha? Si no, ¿quién podría ser esa persona?',
  'Habla con alguien de confianza sobre tu lucha con la pureza. No tiene que ser una confesión detallada, pero rompe el secreto.',
  '¿Qué te impide hablar abiertamente sobre tus luchas con la pureza? ¿Vergüenza, miedo al juicio, orgullo?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000003',
  7,
  ARRAY['Mateo 5:8', 'Salmos 51:10'],
  '"Bienaventurados los de limpio corazón, porque ellos verán a Dios". La pureza no es solo evitar el pecado sexual; es tener un corazón limpio, íntegro, sin doble vida. Y la recompensa es extraordinaria: ver a Dios.

El Salmo 51 es la oración de David después de su pecado con Betsabé: "Crea en mí, oh Dios, un corazón limpio". La pureza no es algo que logramos solos; es algo que Dios crea en nosotros cuando nos rendimos a Él.

Esta semana has enfrentado una lucha difícil. El camino no termina aquí, pero has dado pasos importantes. ¿Qué prácticas vas a mantener?',
  'Escribe una carta a ti mismo del futuro, describiendo la persona pura que quieres ser. Guárdala donde puedas leerla cuando flaquees.',
  '¿Qué has aprendido esta semana sobre ti y tu lucha con la pureza? ¿Qué te da esperanza para seguir adelante?'
);

-- ============================================================================
-- PLAN 4: IRA → PACIENCIA
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'a1000000-0000-0000-0000-000000000004',
  'Venciendo la Ira',
  'Un viaje de 7 días para entender y manejar tu enojo. Aprenderás a responder en lugar de reaccionar, y cultivarás la paciencia y la paz interior.',
  'Transforma el enojo en paz y paciencia',
  7,
  '😤',
  'Todos los que luchan con el mal genio',
  false,
  true,
  4
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000004',
  1,
  ARRAY['Efesios 4:26-27', 'Santiago 1:19-20'],
  '"Airaos, pero no pequéis". Pablo reconoce que el enojo en sí no es pecado - es una emoción humana que incluso Jesús experimentó. El problema es cuando el enojo nos controla, cuando "se pone el sol" sobre él y se convierte en resentimiento.

Santiago nos da una fórmula práctica: "pronto para oír, tardo para hablar, tardo para airarse". ¿Cuántas veces hemos hecho lo opuesto? La ira del hombre "no obra la justicia de Dios".

¿Cómo manejas tu enojo? ¿Explotas? ¿Lo reprimes hasta que explota después? ¿Lo sacas con las personas equivocadas?',
  'Hoy, cada vez que sientas enojo, espera 10 segundos antes de hablar o actuar. Usa esos segundos para respirar profundamente.',
  '¿Cuáles son tus "detonadores" de enojo? ¿Qué situaciones o personas te hacen perder la calma más fácilmente?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000004',
  2,
  ARRAY['Proverbios 14:29', 'Proverbios 15:1'],
  '"El que tarda en airarse es grande de entendimiento". La sabiduría bíblica asocia la paciencia con la madurez y la inteligencia. El que explota fácilmente "engrandece la locura".

"La blanda respuesta quita la ira". Tenemos más poder del que pensamos para desescalar situaciones tensas. Nuestra respuesta puede alimentar el fuego o apagarlo. No controlamos cómo nos tratan, pero sí cómo respondemos.

¿Eres de los que escalan o de los que desescalan los conflictos?',
  'La próxima vez que alguien te hable con enojo o rudeza hoy, responde deliberadamente con suavidad y amabilidad.',
  '¿Cómo reaccionas normalmente cuando alguien te habla con enojo? ¿Qué pasaría si respondieras diferente?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000004',
  3,
  ARRAY['Mateo 5:21-22', 'Colosenses 3:8'],
  'Jesús conectó la ira con el asesinato: "Cualquiera que se enoje contra su hermano, será culpable de juicio". No porque sean lo mismo, sino porque la ira descontrolada es la semilla de la violencia. Todo asesinato comenzó con un enojo que creció sin control.

Pablo nos llama a "desechar" la ira, el enojo, la malicia. Son como ropa vieja que ya no nos queda. Cuando Cristo nos transforma, estas cosas ya no definen quiénes somos.

¿Has visto cómo el enojo pequeño, no tratado, puede crecer hasta convertirse en algo destructivo?',
  'Piensa en algún resentimiento o enojo que has guardado. Hoy, elige perdonar a esa persona, aunque no sientas ganas.',
  '¿Hay algún enojo "viejo" que has guardado por mucho tiempo? ¿Contra quién o contra qué?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000004',
  4,
  ARRAY['Romanos 12:17-21', 'Levítico 19:18'],
  '"No paguéis a nadie mal por mal". La venganza es una forma de ira que busca "emparejar" las cosas. Pero Dios dice que la venganza le pertenece a Él, no a nosotros. Nuestro trabajo es bendecir, no maldecir.

"No te dejes vencer del mal, sino vence el mal con el bien". Esta es una de las enseñanzas más radicales y contraculturales de la fe cristiana. No es pasividad; es una forma superior de victoria.

¿Has experimentado el deseo de venganza? ¿Cómo te fue cuando lo seguiste versus cuando lo soltaste?',
  'Piensa en alguien que te ha hecho daño. Haz algo bueno por esa persona hoy, aunque sea pequeño (un mensaje amable, una oración sincera).',
  '¿Cuál es la diferencia entre justicia y venganza? ¿Cómo sabes cuándo estás buscando una o la otra?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000004',
  5,
  ARRAY['Gálatas 5:22-23', '2 Pedro 1:6'],
  'La paciencia es fruto del Espíritu, no resultado de nuestro esfuerzo. No nos hacemos pacientes tratando más duro; nos hacemos pacientes al rendirnos más al Espíritu. Es Su obra en nosotros.

Pedro incluye la paciencia en la lista de virtudes a cultivar: "añadid a vuestro dominio propio, paciencia". El dominio propio nos ayuda a no explotar; la paciencia nos transforma para que ni siquiera queramos explotar.

¿Cómo es tu relación con el Espíritu Santo? ¿Le das espacio para producir Su fruto en ti?',
  'Dedica 10 minutos hoy a estar en silencio con Dios, sin pedir nada, solo estando presente. Practica la paciencia incluso en la oración.',
  '¿Cuál es la diferencia entre reprimir el enojo y realmente transformarlo? ¿Cómo se siente cada uno?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000004',
  6,
  ARRAY['Eclesiastés 7:9', 'Proverbios 19:11'],
  '"No te apresures en tu espíritu a enojarte; porque el enojo reposa en el seno de los necios". El enojo rápido y frecuente es señal de inmadurez espiritual. La persona sabia toma tiempo para procesar antes de reaccionar.

"La cordura del hombre detiene su furor, y su honra es pasar por alto la ofensa". A veces la respuesta más sabia al enojo es simplemente dejarlo ir. No todo merece una reacción. Elegir no ofenderse es una forma de fortaleza.

¿Cuántas de las cosas que te enojan realmente merecen tu energía emocional?',
  'Hoy, cuando algo te moleste, pregúntate: "¿Esto importará en una semana? ¿En un año?" Si no, déjalo pasar.',
  '¿Qué porcentaje de las cosas que te enojan realmente son importantes? ¿Qué pasaría si dejaras ir lo que no lo es?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000004',
  7,
  ARRAY['Salmos 37:8-9', 'Filipenses 4:6-7'],
  '"Deja la ira, y desecha el enojo; no te excites en manera alguna a hacer lo malo". El salmista nos invita a soltar activamente la ira, no solo a esperar que se pase. Es una decisión.

Pablo ofrece una alternativa al enojo ansioso: "Por nada estéis afanosos, sino sean conocidas vuestras peticiones delante de Dios... y la paz de Dios guardará vuestros corazones". La oración transforma la ira en paz.

Esta semana has trabajado en tu relación con el enojo. ¿Qué herramientas has descubierto que funcionan para ti?',
  'Escribe tres "reglas" personales para manejar tu enojo que implementarás de ahora en adelante.',
  '¿Qué has aprendido esta semana sobre tu enojo? ¿Qué cambio concreto has notado o quieres mantener?'
);

-- ============================================================================
-- PLAN 5: GULA → TEMPLANZA
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'a1000000-0000-0000-0000-000000000005',
  'Venciendo la Gula',
  'Un viaje de 7 días para examinar tu relación con la comida y los placeres. Aprenderás a practicar la templanza y a encontrar satisfacción en Dios más que en el consumo.',
  'Cultiva dominio propio y templanza',
  7,
  '🍽️',
  'Todos los que luchan con el autocontrol',
  false,
  true,
  5
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000005',
  1,
  ARRAY['Filipenses 3:19', 'Proverbios 23:20-21'],
  'La gula no es solo comer mucho. Es cualquier apetito desordenado por el placer físico - comida, bebida, entretenimiento, comodidad. Pablo describe a quienes tienen "el vientre por dios": cuando nuestros apetitos nos gobiernan en lugar de nosotros gobernarlos.

Proverbios advierte contra los que se dan a la glotonería, no por moralismo, sino porque la falta de control siempre tiene consecuencias: "el bebedor y el comilón empobrecerán".

¿En qué área de tu vida sientes que tus apetitos te controlan más de lo que tú los controlas?',
  'Hoy, identifica un "antojo" que normalmente satisfaces sin pensar (dulce, snack, scroll infinito). No lo hagas y observa cómo te sientes.',
  '¿Cuál es tu "debilidad" respecto a la gula? ¿Comida específica, bebida, entretenimiento, otra cosa?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000005',
  2,
  ARRAY['1 Corintios 6:12', '1 Corintios 9:27'],
  '"Todo me es lícito, pero no todo me conviene; todo me es lícito, pero yo no me dejaré dominar de nada". Pablo establece el principio: la libertad cristiana no es hacer lo que queramos, sino no ser esclavos de nada.

"Golpeo mi cuerpo, y lo pongo en servidumbre". Pablo no odiaba su cuerpo, pero sabía que necesitaba disciplinarlo. El cuerpo es un buen sirviente pero un mal amo. Cuando los apetitos mandan, perdemos libertad.

¿Te sientes libre respecto a tus apetitos, o sientes que ellos te tienen atado?',
  'Practica una pequeña disciplina corporal hoy: come una comida menos de lo que normalmente comerías, o sáltate un snack.',
  '¿Cuál es la diferencia entre disfrutar algo y ser esclavo de algo? ¿Cómo sabes en qué categoría estás?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000005',
  3,
  ARRAY['Mateo 4:4', 'Juan 6:35'],
  '"No sólo de pan vivirá el hombre, sino de toda palabra que sale de la boca de Dios". Jesús usó esta escritura para resistir la tentación del hambre. Hay un hambre más profunda que la física, y solo Dios puede satisfacerla.

"Yo soy el pan de vida; el que a mí viene, nunca tendrá hambre". A menudo usamos comida (u otros placeres) para llenar vacíos que no son físicos: soledad, aburrimiento, ansiedad, tristeza. Pero solo Cristo satisface verdaderamente.

¿Cuándo comes (o consumes) por hambre real y cuándo por otra cosa?',
  'Antes de cada comida hoy, pregúntate: "¿Tengo hambre física real o estoy buscando satisfacer otra necesidad?"',
  '¿Qué emociones o situaciones te llevan a comer (o consumir) de más? ¿Qué crees que realmente estás buscando?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000005',
  4,
  ARRAY['Gálatas 5:22-23', 'Proverbios 25:28'],
  'El dominio propio es fruto del Espíritu. No es fuerza de voluntad humana; es el Espíritu produciendo en nosotros la capacidad de decir no cuando es necesario y sí cuando es apropiado.

"Como ciudad derribada y sin muro es el hombre cuyo espíritu no tiene rienda". Sin dominio propio somos vulnerables, expuestos. La templanza es como un muro que protege lo valioso dentro de nosotros.

¿Cómo describirías tu nivel actual de dominio propio? ¿En qué áreas eres fuerte y en cuáles débil?',
  'Ayuna de algo hoy (una comida, redes sociales, entretenimiento). Usa el tiempo o el "espacio" para orar.',
  '¿Qué tan cómodo te sientes con el concepto del ayuno? ¿Lo has practicado antes? ¿Qué te detiene?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000005',
  5,
  ARRAY['Romanos 13:14', 'Eclesiastés 10:17'],
  '"Vestíos del Señor Jesucristo, y no proveáis para los deseos de la carne". Una estrategia práctica contra la gula: no te pongas en situaciones donde la tentación es inevitable. No compres lo que no debes comer. No navegues donde no debes ir.

"Bienaventurada la tierra cuyo rey come a su hora, para reponer sus fuerzas y no para beber". La comida (y el placer) tienen su propósito: nutrición, descanso, celebración legítima. El problema es cuando el medio se convierte en el fin.

¿Cómo puedes estructurar tu ambiente para hacer la templanza más fácil?',
  'Haz limpieza: identifica algo en tu casa o tu teléfono que te tienta regularmente y deshazte de ello o bloquéalo.',
  '¿Qué tan intencional eres sobre tu ambiente? ¿Lo diseñas para el éxito o para el fracaso?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000005',
  6,
  ARRAY['1 Corintios 10:31', '1 Timoteo 4:4-5'],
  '"Si coméis o bebéis, o hacéis otra cosa, hacedlo todo para la gloria de Dios". La templanza no es rechazo del placer; es placer santificado. Podemos comer, beber y disfrutar - pero con gratitud, con moderación, para la gloria de Dios.

"Todo lo que Dios creó es bueno, y nada es de desecharse, si se toma con acción de gracias". La comida es regalo de Dios. El placer es regalo de Dios. El problema no es el regalo, sino cuando lo adoramos más que al Dador.

¿Cómo sería para ti comer y disfrutar "para la gloria de Dios"?',
  'En tu próxima comida, come lentamente y con atención. Saborea cada bocado. Da gracias específicas por cada cosa que comes.',
  '¿Cuándo fue la última vez que realmente disfrutaste una comida con gratitud, sin culpa ni exceso?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000005',
  7,
  ARRAY['2 Pedro 1:5-6', 'Tito 2:11-12'],
  'Pedro nos dice que añadamos a nuestra fe virtud, conocimiento, dominio propio... Es un proceso de crecimiento. No llegas a la templanza de un día para otro; la cultivas paso a paso.

"La gracia de Dios nos enseña que, renunciando a la impiedad y a los deseos mundanos, vivamos en este siglo sobria, justa y piadosamente". La gracia no es permiso para el exceso; es poder para la templanza.

Esta semana has examinado tu relación con el placer y los apetitos. ¿Qué has aprendido?',
  'Escribe un plan de "templanza" personal: áreas específicas donde practicarás moderación y cómo lo harás.',
  '¿Qué cambio concreto has notado o quieres mantener respecto a tus apetitos? ¿Qué te ha ayudado más?'
);

-- ============================================================================
-- PLAN 6: ENVIDIA → GRATITUD
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'a1000000-0000-0000-0000-000000000006',
  'Venciendo la Envidia',
  'Un viaje de 7 días para liberarte del veneno de la envidia y cultivar un corazón agradecido. Descubrirás la alegría de celebrar a otros y estar contento con lo que Dios te ha dado.',
  'Transforma la envidia en gratitud genuina',
  7,
  '👀',
  'Todos los que luchan con compararse con otros',
  false,
  true,
  6
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000006',
  1,
  ARRAY['Proverbios 14:30', 'Santiago 3:16'],
  '"El corazón apacible es vida de la carne; mas la envidia es carcoma de los huesos". La envidia literalmente nos enferma. Es un veneno que tomamos esperando que le haga daño a otro, pero nos destruye a nosotros.

Santiago advierte: "donde hay celos y contención, allí hay perturbación y toda obra perversa". La envidia no solo nos afecta internamente; corrompe nuestras relaciones y acciones.

La envidia susurra: "no es justo que ellos tengan y yo no". Pero la envidia nunca te lleva a tener más; solo te hace miserable con lo que tienes.',
  'Identifica a alguien de quien sientes envidia. Hoy, en lugar de compararte, ora una bendición sincera sobre esa persona.',
  '¿De quién sientes más envidia actualmente? ¿Qué específicamente envidias de esa persona?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000006',
  2,
  ARRAY['1 Corintios 12:14-18', 'Romanos 12:15'],
  'Pablo usa la metáfora del cuerpo: "Si dijere el pie: Porque no soy mano, no soy del cuerpo, ¿por eso no será del cuerpo?" Cada parte tiene su función. Envidiar los dones de otro es como si el pie quisiera ser mano - absurdo y disfuncional.

"Gozaos con los que se gozan". Esto es difícil cuando envidiamos. La envidia hace que el éxito de otros nos duela. Pero somos un cuerpo: cuando a uno le va bien, a todos nos va bien.

¿Puedes genuinamente alegrarte cuando a otros les va bien, especialmente en áreas donde tú luchas?',
  'Cuando veas a alguien celebrando algo bueno hoy (en persona o en redes), celébra con ellos genuinamente. Comenta, felicita, alégrate.',
  '¿Qué tan fácil o difícil te resulta alegrarte por el éxito de otros? ¿De qué depende?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000006',
  3,
  ARRAY['Salmos 37:1-4', 'Gálatas 6:4'],
  '"No te impacientes a causa de los malignos, ni tengas envidia de los que hacen iniquidad". A veces envidiamos incluso a quienes obtienen cosas de manera injusta. Pero el salmista nos recuerda que su prosperidad es temporal.

"Cada uno examine su propia obra". En lugar de mirar lo que otros tienen, examina lo que tú estás haciendo con lo que tienes. Tu responsabilidad es ante Dios por lo tuyo, no por lo de otros.

¿Cuánta energía gastas mirando lo que otros tienen versus desarrollando lo que tú tienes?',
  'Hoy, no mires las redes sociales de otros. Usa ese tiempo para trabajar en algo que tú quieres desarrollar.',
  '¿Las redes sociales aumentan o disminuyen tu envidia? ¿Qué podrías hacer al respecto?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000006',
  4,
  ARRAY['1 Tesalonicenses 5:18', 'Filipenses 4:11-12'],
  '"Dad gracias en todo, porque esta es la voluntad de Dios". La gratitud es el antídoto directo a la envidia. Es imposible estar agradecido y envidioso al mismo tiempo. Son mutuamente excluyentes.

Pablo aprendió "a contentarse en cualquier situación". No nació sabiendo esto; lo aprendió. El contentamiento se cultiva a través de la práctica de la gratitud.

¿Cuándo fue la última vez que te detuviste a agradecer genuinamente por lo que tienes, sin compararlo con lo que otros tienen?',
  'Escribe 20 cosas específicas por las que estás agradecido hoy. No generalices ("mi familia"), sé específico ("la risa de mi hijo esta mañana").',
  '¿Qué tienes que otros no tienen y que a menudo das por sentado?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000006',
  5,
  ARRAY['Mateo 20:1-15', 'Romanos 9:20-21'],
  'En la parábola de los trabajadores de la viña, algunos reciben el mismo pago habiendo trabajado menos. Los que trabajaron más se quejan, pero el dueño responde: "¿No me es lícito hacer lo que quiero con lo mío? ¿O tienes tú envidia, porque yo soy bueno?"

La envidia cuestiona la bondad y justicia de Dios. Dice: "Dios, no me diste lo que merezco". Pero ¿quién de nosotros realmente quiere lo que merece? Todos vivimos de gracia, no de mérito.

¿Alguna vez has sentido que Dios ha sido injusto contigo al darle más a otros?',
  'Haz una lista de "bendiciones inmerecidas" - cosas buenas que tienes que no ganaste ni merecías.',
  '¿Confías en que Dios sabe lo que hace cuando distribuye dones, oportunidades y bendiciones de manera diferente?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000006',
  6,
  ARRAY['1 Pedro 2:1', 'Proverbios 23:17'],
  '"Desechando toda malicia, todo engaño, hipocresía, envidias...". Pedro pone la envidia junto a la malicia y el engaño. No es un pecado "menor" - es veneno para el alma y las relaciones.

"No tenga tu corazón envidia de los pecadores". A veces envidiamos precisamente a quienes viven de manera contraria a Dios y parecen prosperar. Pero no conocemos su historia completa ni su final.

¿Qué tan dispuesto estás a "desechar" la envidia de tu vida, sabiendo que eso requiere trabajo diario?',
  'Identifica a la persona que más envidias. Hoy, hazle un favor concreto o mándale un mensaje genuinamente celebrando algo de ella.',
  '¿Qué perderías si dejaras de envidiar? ¿Hay alguna "ganancia" que obtienes de la envidia?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000006',
  7,
  ARRAY['Hebreos 13:5', '1 Timoteo 6:6'],
  '"Sean vuestras costumbres sin avaricia, contentos con lo que tenéis". El contentamiento no es resignación pasiva; es confianza activa en que Dios provee lo que necesitas.

"Gran ganancia es la piedad acompañada de contentamiento". El mundo dice que la ganancia es tener más. Dios dice que la ganancia es estar contento con lo que tienes mientras buscas la piedad.

Esta semana has trabajado en tu envidia. El camino hacia el contentamiento es de toda la vida, pero ya has dado pasos importantes.',
  'Escribe una "declaración de contentamiento": tres frases que describan por qué puedes estar contento hoy, sin importar lo que otros tengan.',
  '¿Qué has aprendido esta semana sobre tu envidia? ¿Qué práctica vas a mantener para cultivar gratitud?'
);

-- ============================================================================
-- PLAN 7: PEREZA → DILIGENCIA
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'a1000000-0000-0000-0000-000000000007',
  'Venciendo la Pereza',
  'Un viaje de 7 días para despertar tu propósito y cultivar la diligencia. Aprenderás a vencer la procrastinación y a trabajar con excelencia para la gloria de Dios.',
  'Despierta tu propósito y cultiva la diligencia',
  7,
  '😴',
  'Todos los que luchan con la procrastinación',
  false,
  true,
  7
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000007',
  1,
  ARRAY['Proverbios 6:6-11', 'Proverbios 26:14'],
  '"Ve a la hormiga, oh perezoso, mira sus caminos, y sé sabio". Dios nos manda a aprender de un insecto. La hormiga trabaja sin supervisor, previendo el futuro, haciendo lo que debe aunque nadie la obligue.

"Como la puerta gira sobre sus quicios, así el perezoso se vuelve en su cama". La imagen es cómica pero triste: movimiento sin progreso, actividad sin avance. La pereza no es siempre inactividad; a veces es actividad sin propósito.

¿En qué área de tu vida estás "girando en tus quicios" - ocupado pero sin avanzar?',
  'Identifica una tarea que has pospuesto por más de una semana. Hoy, dedícale al menos 15 minutos.',
  '¿Qué es lo que más procrastinas en tu vida? ¿Por qué crees que lo evitas?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000007',
  2,
  ARRAY['Colosenses 3:23-24', 'Efesios 6:7'],
  '"Y todo lo que hagáis, hacedlo de corazón, como para el Señor y no para los hombres". Esto cambia todo. No trabajas para tu jefe, tus clientes o tu familia - trabajas para el Señor. Eso eleva cada tarea, por pequeña que sea.

La pereza a menudo viene de no ver el propósito en lo que hacemos. Pero cuando entendemos que todo trabajo honesto es servicio a Dios, cada tarea adquiere significado eterno.

¿Cómo cambiaría tu actitud hacia el trabajo si realmente creyeras que es para el Señor?',
  'Elige una tarea "mundana" de hoy (lavar platos, responder emails, cualquier cosa). Hazla con excelencia, como si Jesús fuera quien la recibirá.',
  '¿Qué tareas consideras "indignas" de tu mejor esfuerzo? ¿Por qué?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000007',
  3,
  ARRAY['2 Tesalonicenses 3:10-12', 'Proverbios 14:23'],
  '"Si alguno no quiere trabajar, tampoco coma". Pablo es contundente. La pereza no solo te afecta a ti; es una carga para otros. El que no trabaja está pidiendo que otros lo mantengan.

"En toda labor hay fruto; mas las vanas palabras de los labios empobrecen". Hablar de lo que vas a hacer no es lo mismo que hacerlo. Los planes sin acción son palabras vacías.

¿Cuánto tiempo pasas planeando, hablando o pensando versus realmente haciendo?',
  'Hoy, por cada hora que pases planeando o consumiendo contenido, pasa otra hora ejecutando algo productivo.',
  '¿Eres más de planear o de ejecutar? ¿Qué necesitas para equilibrar mejor ambos?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000007',
  4,
  ARRAY['Eclesiastés 9:10', 'Romanos 12:11'],
  '"Todo lo que te viniere a la mano para hacer, hazlo según tus fuerzas". No mañana, no cuando tengas ganas, no cuando sea perfecto - ahora, con lo que tienes. La diligencia no espera condiciones ideales.

"No perezosos en lo que requiere diligencia; fervientes en espíritu, sirviendo al Señor". La pereza espiritual es tan peligrosa como la física. Es posible ser activo en lo secular pero perezoso en lo espiritual.

¿Cómo está tu diligencia espiritual? ¿Oración, lectura, servicio - estás siendo ferviente?',
  'Establece un hábito espiritual que has descuidado (oración matutina, lectura bíblica, etc.). Practícalo hoy, aunque sea brevemente.',
  '¿En qué área eres más diligente: trabajo, relaciones, o vida espiritual? ¿Por qué crees que hay diferencia?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000007',
  5,
  ARRAY['Gálatas 6:9', 'Hebreos 6:10-12'],
  '"No nos cansemos, pues, de hacer bien; porque a su tiempo segaremos, si no desmayamos". La pereza a menudo viene del desánimo: sentimos que nuestro esfuerzo no da fruto. Pero la cosecha viene a su tiempo.

"No seáis perezosos, sino imitadores de aquellos que por la fe y la paciencia heredan las promesas". La fe y la paciencia van juntas. Confiamos en Dios y seguimos trabajando, aunque no veamos resultados inmediatos.

¿Has abandonado algo bueno porque los resultados no llegaban tan rápido como esperabas?',
  'Retoma algo bueno que dejaste por desánimo (ejercicio, proyecto, hábito). Hoy, da el primer paso para reiniciarlo.',
  '¿Qué te desanima más: no ver resultados, el esfuerzo requerido, o el miedo a fallar?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000007',
  6,
  ARRAY['Proverbios 12:24', 'Proverbios 22:29'],
  '"La mano de los diligentes señoreará; mas la negligencia será tributaria". Hay una correlación entre diligencia y libertad. El perezoso termina siendo esclavo; el diligente termina siendo líder.

"¿Has visto hombre solícito en su trabajo? Delante de los reyes estará". La excelencia abre puertas. No se trata de impresionar a otros, sino de que la diligencia tiene consecuencias naturales positivas.

¿Cómo describirías la calidad de tu trabajo actualmente? ¿Estás dando lo mejor de ti?',
  'En tu trabajo o responsabilidades de hoy, identifica un área donde puedes mejorar la calidad. Hazlo con excelencia.',
  '¿Qué te impide dar tu mejor esfuerzo consistentemente? ¿Falta de motivación, cansancio, no ver el punto?'
);

INSERT INTO plan_days (plan_id, day_number, verse_references, reflection, practical_exercise, question)
VALUES (
  'a1000000-0000-0000-0000-000000000007',
  7,
  ARRAY['Mateo 25:14-30', 'Juan 9:4'],
  'La parábola de los talentos nos muestra que Dios nos ha dado recursos (tiempo, habilidades, oportunidades) y espera que los multipliquemos. El siervo perezoso no hizo nada malo; simplemente no hizo nada. Y eso fue condenado.

"Me es necesario hacer las obras del que me envió, entre tanto que el día dura; la noche viene, cuando nadie puede trabajar". Jesús tenía urgencia. Sabía que el tiempo es limitado.

Esta semana has trabajado en tu pereza. El tiempo sigue pasando. ¿Qué vas a hacer diferente?',
  'Escribe tres metas específicas para las próximas 4 semanas. Ponles fecha límite y compártelas con alguien que te pueda pedir cuentas.',
  '¿Qué has aprendido esta semana sobre tu pereza? ¿Qué cambio concreto vas a mantener para ser más diligente?'
);
