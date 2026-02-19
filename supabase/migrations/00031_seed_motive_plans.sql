-- =============================================================================
-- MIGRACION 00031: Seed Motive-Based Study Plans (12 plans, 84 days)
-- =============================================================================
-- Descripcion: Adds title column to plan_days, 4 new chat topic keys,
--              and 12 study plans based on onboarding motive + motive_detail
-- =============================================================================

-- 1. Add title column to plan_days
ALTER TABLE plan_days ADD COLUMN IF NOT EXISTS title TEXT;

-- 2. Add 4 topic keys for motive-based plans
INSERT INTO chat_topics (key, title, description, sort_order) VALUES
('plan_momento_dificil', 'Plan: Momento Dificil', 'Plan personalizado para superar momentos dificiles', 20),
('plan_crecimiento', 'Plan: Crecimiento Espiritual', 'Plan personalizado para crecer espiritualmente', 21),
('plan_reconexion', 'Plan: Reconexion con Dios', 'Plan personalizado para reconectarse con Dios', 22),
('plan_entender_biblia', 'Plan: Entender la Biblia', 'Plan personalizado para entender la Biblia', 23)
ON CONFLICT (key) DO NOTHING;

-- ============================================================================
-- PLAN 1: Sanando relaciones familiares (difficult_moment / family_issues)
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'b1000000-0000-0000-0000-000000000001',
  'Sanando relaciones familiares',
  'Un viaje de 7 dias para llevar ante Dios el dolor de las relaciones familiares rotas. Exploraras como el perdon, la comunicacion con amor y la paciencia pueden transformar tu familia. No importa si la herida es reciente o de hace anos: Dios quiere sanar tu corazon y restaurar lo que parece perdido. Cada dia te acercara un paso mas a la paz que necesitas, con ejercicios practicos y reflexiones basadas en la Palabra.',
  'Lleva ante Dios el dolor familiar y encuentra sanacion',
  7,
  '👨‍👩‍👧',
  'Personas que atraviesan conflictos familiares, separaciones o relaciones rotas',
  false,
  true,
  11
) ON CONFLICT (id) DO NOTHING;

-- Plan 1, Dia 1: Reconociendo tu dolor
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000001',
  1,
  'Reconociendo tu dolor',
  ARRAY['Salmo 34:18', 'Isaias 41:10', 'Mateo 11:28'],
  'Antes de sanar, necesitas reconocer que hay una herida. Muchas veces cargamos el dolor familiar en silencio, fingiendo que no nos afecta, que ya lo superamos, que no importa. Pero a Dios no le puedes mentir, y tampoco necesitas hacerlo.

El Salmo 34:18 dice: "Cercano esta Jehova a los quebrantados de corazon; y salva a los contritos de espiritu." Dios no se aleja cuando sufres; se acerca. Tu dolor no lo incomoda ni lo sorprende. El ya lo conoce, pero quiere que tu se lo entregues.

Tal vez la relacion con tu padre, tu madre, un hermano o tu pareja esta rota. Tal vez hay palabras que se dijeron y que todavia duelen. Tal vez hay un silencio que pesa mas que cualquier grito. Hoy no tienes que resolver nada. Solo necesitas ser honesto contigo mismo y con Dios sobre lo que sientes. Jesus dijo: "Venid a mi todos los que estais trabajados y cargados, y yo os hare descansar." Ese descanso empieza cuando dejas de cargar solo.',
  'Busca un lugar tranquilo, cierra los ojos y dile a Dios exactamente como te sientes respecto a esa relacion familiar. No filtres nada. Luego escribelo en un papel.',
  '¿Que relacion familiar te causa mas dolor en este momento? ¿Que sientes cuando piensas en esa persona?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 1, Dia 2: El perdon que libera
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000001',
  2,
  'El perdon que libera',
  ARRAY['Efesios 4:31-32', 'Mateo 6:14-15', 'Colosenses 3:13'],
  'Perdonar no significa que lo que te hicieron estuvo bien. No significa olvidar ni fingir que no paso. Perdonar es soltar la carga que cargas para que deje de envenenarte por dentro. Es un acto de libertad, no de debilidad.

Pablo escribe: "Sed benignos unos con otros, misericordiosos, perdonandoos unos a otros, como Dios tambien os perdono a vosotros en Cristo." El modelo de perdon no es humano; es divino. Dios te perdono cuando no lo merecías, y te pide que hagas lo mismo con otros.

Esto no pasa de la noche a la manana. El perdon es un proceso, y a veces tienes que elegir perdonar cada dia hasta que tu corazon se alinee con tu decision. No esperes sentirlo para hacerlo; hazlo y los sentimientos llegaran. Jesus no dijo "perdona cuando te sientas listo"; dijo "perdona" porque sabe que es el camino hacia tu propia sanacion.',
  'Escribe una carta de perdon a esa persona que te ha herido. No tienes que enviarla. El acto de escribir sana tu corazon y libera lo que llevas dentro.',
  '¿Hay alguien en tu familia a quien necesitas perdonar? ¿Que te impide dar ese paso hoy?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 1, Dia 3: Comunicacion con amor
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000001',
  3,
  'Comunicacion con amor',
  ARRAY['Proverbios 15:1', 'Efesios 4:15', 'Santiago 1:19'],
  'Muchos conflictos familiares no empezaron por un gran problema, sino por una mala comunicacion. Palabras dichas con rabia, silencios que castigaban, conversaciones que nunca se tuvieron. La forma en que hablamos puede construir puentes o levantar muros.

"La blanda respuesta quita la ira; mas la palabra aspera hace subir el furor." Proverbios 15:1 nos da una herramienta practica: tu tono puede cambiar el rumbo de una conversacion entera. No se trata de ser falso o de callarte lo que sientes, sino de decir la verdad con amor, como dice Pablo en Efesios 4:15.

Santiago nos da la formula perfecta: "pronto para oir, tardo para hablar, tardo para airarse." ¿Cuantas discusiones familiares se evitarían si escucharamos primero y hablaramos despues? Hoy te invito a practicar una comunicacion que honre a Dios: honesta pero amable, clara pero respetuosa.',
  'La proxima vez que hables con esa persona dificil, practica la regla de Santiago: escucha el doble de lo que hablas. Antes de responder, cuenta hasta cinco en silencio.',
  '¿Como describirias tu forma de comunicarte cuando hay conflicto? ¿Explotas, te callas, o buscas resolver?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 1, Dia 4: Limites saludables
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000001',
  4,
  'Limites saludables',
  ARRAY['Proverbios 4:23', 'Mateo 5:37', 'Galatas 6:5'],
  'Amar a tu familia no significa permitir todo. "Sobre toda cosa guardada, guarda tu corazon; porque de el mana la vida." Poner limites no es egoismo; es sabiduria. Es proteger lo que Dios te ha dado para que puedas seguir amando sin destruirte en el proceso.

Jesus mismo ponia limites. Se retiraba a orar cuando las multitudes lo agotaban. Decia "no" cuando era necesario. Confrontaba comportamientos daninos con amor pero con firmeza. Si Jesus necesitaba limites, tu tambien.

Un limite saludable suena asi: "Te amo, pero no puedo permitir que me hables de esa manera." O: "Quiero ayudarte, pero necesito cuidar mi propia salud primero." No es rechazo; es amor maduro. Pablo dice en Galatas que cada uno llevara su propia carga. No eres responsable de cargar lo que le corresponde a otro, y eso esta bien.',
  'Identifica una situacion familiar donde necesitas poner un limite. Escribe exactamente que dirias, usando un tono firme pero amoroso. Practica decirlo en voz alta.',
  '¿En que area de tu vida familiar sientes que necesitas poner limites? ¿Que te ha impedido hacerlo hasta ahora?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 1, Dia 5: Paciencia en el proceso
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000001',
  5,
  'Paciencia en el proceso',
  ARRAY['Eclesiastes 3:1', 'Romanos 8:28', 'Salmo 27:14'],
  'Quisieras que todo se arreglara hoy. Que esa persona cambiara, que la relacion se restaurara, que el dolor desapareciera. Pero la sanacion familiar tiene su propio ritmo, y no siempre es el que tu quieres.

"Todo tiene su tiempo, y todo lo que se quiere debajo del cielo tiene su hora." Eclesiastes nos recuerda que hay un tiempo para cada cosa. Hay un tiempo para hablar y un tiempo para callar. Un tiempo para acercarse y un tiempo para dar espacio. La sabiduria esta en discernir que tiempo es este.

"Aguarda a Jehova; esfuerzate, y aliéntese tu corazon; si, espera a Jehova." La espera no es pasividad; es confianza activa. Es seguir orando, seguir amando, seguir haciendo tu parte, mientras confias en que Dios esta trabajando en lo que tu no puedes ver. Romanos 8:28 promete que Dios hace que todas las cosas cooperen para bien. Incluso esto.',
  'Hoy, en lugar de intentar resolver la situacion familiar, simplemente ora por ella. Dedica 10 minutos a poner la relacion en las manos de Dios sin pedirle un resultado especifico.',
  '¿Te cuesta ser paciente con el proceso de sanacion familiar? ¿Que es lo mas dificil de esperar?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 1, Dia 6: Oracion por tu familia
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000001',
  6,
  'Oracion por tu familia',
  ARRAY['1 Tesalonicenses 5:17', 'Filipenses 4:6-7', 'Jeremias 29:12'],
  'La oracion es el arma mas poderosa que tienes para tu familia. Cuando ya no sabes que decir, cuando las palabras humanas no alcanzan, cuando sientes que no puedes hacer nada mas... puedes orar. Y eso no es poco; es todo.

Pablo dice: "Por nada esteis afanosos, sino sean conocidas vuestras peticiones delante de Dios en toda oracion y ruego, con accion de gracias. Y la paz de Dios, que sobrepasa todo entendimiento, guardara vuestros corazones." La oracion no siempre cambia la situacion, pero siempre te cambia a ti. Te da la paz que necesitas para seguir adelante.

No necesitas palabras elaboradas. Dios escucha el gemido del corazon tanto como la oracion mas elocuente. "Me buscareis y me hallareis, porque me buscareis de todo vuestro corazon." El esta esperando que le busques, especialmente por tu familia.',
  'Escribe los nombres de cada miembro de tu familia en un papel. Ora especificamente por cada uno, pidiendo a Dios algo concreto para esa persona. Hazlo cada dia esta semana.',
  '¿Con que frecuencia oras por tu familia? ¿Que te gustaria pedirle a Dios especificamente por ellos?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 1, Dia 7: Un nuevo comienzo
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000001',
  7,
  'Un nuevo comienzo',
  ARRAY['Isaias 43:18-19', '2 Corintios 5:17', 'Lamentaciones 3:22-23'],
  'Dios es el Dios de los nuevos comienzos. "No os acordeis de las cosas pasadas, ni traigais a memoria las cosas antiguas. He aqui que yo hago cosa nueva." No importa cuanto tiempo llevas cargando este dolor familiar, Dios puede hacer algo nuevo en tu historia.

Cada manana sus misericordias son nuevas, dice Lamentaciones. Eso significa que hoy es un nuevo dia para tu familia tambien. Tal vez la restauracion no se vea como tu imaginabas. Tal vez no sea una reconciliacion perfecta sino una paz interior que te permite seguir adelante. Tal vez sea un primer paso pequeno despues de anos de silencio.

Esta semana has trabajado en tu corazon: reconociste el dolor, exploraste el perdon, aprendiste sobre comunicacion y limites, practicaste la paciencia y la oracion. No desperdicies ese trabajo. Da un paso concreto hoy. Un mensaje, una llamada, una oracion mas profunda. Dios va contigo.',
  'Elige una accion concreta hacia la restauracion familiar: un mensaje de paz, una llamada, una invitacion a conversar. No tiene que resolver todo; solo tiene que ser un primer paso.',
  '¿Que paso concreto puedes dar hoy hacia la sanacion de tu relacion familiar? ¿Que aprendiste esta semana que te da esperanza?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- ============================================================================
-- PLAN 2: Fe en medio de la enfermedad (difficult_moment / health_issues)
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'b1000000-0000-0000-0000-000000000002',
  'Fe en medio de la enfermedad',
  'Un viaje de 7 dias para encontrar a Dios en medio del dolor fisico y la incertidumbre de la enfermedad. Ya sea que tu o un ser querido este pasando por esto, descubriras que Dios no te ha abandonado. Cada dia exploraras como mantener la fe cuando el cuerpo falla, encontrando paz, esperanza y fortaleza en las Escrituras y en la presencia de Dios que nunca se aparta.',
  'Encuentra fortaleza y paz cuando la salud falla',
  7,
  '🏥',
  'Personas enfrentando enfermedad propia o de un ser querido',
  false,
  true,
  12
) ON CONFLICT (id) DO NOTHING;

-- Plan 2, Dia 1: Dios conoce tu dolor
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000002',
  1,
  'Dios conoce tu dolor',
  ARRAY['Salmo 56:8', 'Isaias 53:3-4', '1 Pedro 5:7'],
  'Cuando la enfermedad toca tu puerta, todo cambia. Las prioridades se reordenan, el futuro se vuelve incierto, y preguntas que nunca te habias hecho empiezan a surgir. Es normal sentir miedo, frustracion, incluso enojo. Dios no te juzga por eso.

El Salmo 56:8 dice algo hermoso: "Pon mis lagrimas en tu redoma; ¿no estan ellas en tu libro?" Dios guarda cada una de tus lagrimas. Ninguna se pierde, ninguna pasa desapercibida. Tu dolor le importa profundamente.

Isaias describe a Jesus como "varon de dolores, experimentado en quebranto." El Dios que adoramos no es ajeno al sufrimiento; lo conoce de primera mano. Pedro te invita: "Echando toda vuestra ansiedad sobre el, porque el tiene cuidado de vosotros." No tienes que cargar esto solo. Hoy, simplemente entrégale tu preocupacion. No necesitas entender por que; solo necesitas saber que El esta contigo.',
  'Encuentra un momento de silencio. Pon tu mano sobre tu corazon y dile a Dios: "Senor, me duele. Tengo miedo. Pero confio en que estas aqui." Repitelo las veces que necesites.',
  '¿Como te sientes respecto a tu situacion de salud o la de tu ser querido? ¿Que es lo que mas te preocupa?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 2, Dia 2: Paz en la incertidumbre
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000002',
  2,
  'Paz en la incertidumbre',
  ARRAY['Filipenses 4:6-7', 'Juan 14:27', 'Isaias 26:3'],
  'Lo mas dificil de la enfermedad no siempre es el dolor fisico; es la incertidumbre. No saber que va a pasar, esperar resultados, vivir entre citas medicas y preguntas sin respuesta. Esa espera puede ser agotadora.

Jesus dijo: "La paz os dejo, mi paz os doy; yo no os la doy como el mundo la da." La paz de Cristo no depende de que todo salga bien. Es una paz que existe en medio de la tormenta, no despues de ella. No es la ausencia de problemas, sino la presencia de Dios en ellos.

Isaias promete: "Tu guardaras en completa paz a aquel cuyo pensamiento en ti persevera; porque en ti ha confiado." La clave no es pensar en la enfermedad todo el dia, sino redirigir tus pensamientos hacia Dios cuando la ansiedad te invada. No se trata de negar la realidad, sino de mirarla desde la perspectiva de quien te sostiene.',
  'Cada vez que la ansiedad por la salud te invada hoy, repite en silencio: "Dios tiene el control, y yo estoy en sus manos." Hazlo consciente al menos cinco veces durante el dia.',
  '¿En que momentos del dia la incertidumbre te golpea mas fuerte? ¿Que te ayuda a encontrar algo de calma?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 2, Dia 3: Tu cuerpo, templo de Dios
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000002',
  3,
  'Tu cuerpo, templo de Dios',
  ARRAY['1 Corintios 6:19-20', 'Salmo 139:13-14', 'Romanos 12:1'],
  'La enfermedad puede hacerte sentir traicionado por tu propio cuerpo. Ese cuerpo que antes funcionaba sin que lo pensaras, ahora te recuerda a cada momento que algo no esta bien. Es facil empezar a resentirlo o a sentirte definido por tu condicion.

Pero el salmista declara: "Formidables, maravillosas son tus obras." Tu cuerpo es obra de Dios, incluso ahora. Tu valor no disminuye porque tu cuerpo este debil. Pablo dice que tu cuerpo es "templo del Espiritu Santo." Un templo no deja de ser sagrado porque tenga grietas en las paredes.

Dios te ve completo cuando el mundo te ve enfermo. Te ve amado cuando te sientes fragil. Te ve con proposito cuando te sientes inutil. Tu identidad no esta en tu diagnostico; esta en quien te creo y en como te mira. Hoy, trata tu cuerpo con la misma ternura con la que Dios lo mira.',
  'Haz algo bueno por tu cuerpo hoy, no como obligacion medica sino como acto de amor: una caminata corta, una comida que disfrutes, descanso sin culpa. Agradece a Dios por lo que tu cuerpo si puede hacer.',
  '¿Como ha cambiado tu relacion con tu cuerpo desde la enfermedad? ¿Que le dirias a tu cuerpo si pudiera escucharte?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 2, Dia 4: Compania en la soledad
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000002',
  4,
  'Compania en la soledad',
  ARRAY['Salmo 23:4', 'Deuteronomio 31:6', 'Mateo 28:20'],
  'La enfermedad puede ser muy solitaria. Aunque estes rodeado de personas que te quieren, hay un aspecto del sufrimiento que solo tu conoces. Hay noches largas, pensamientos que no compartes, un cansancio que nadie mas siente exactamente como tu.

David escribio: "Aunque ande en valle de sombra de muerte, no temerée mal alguno, porque tu estas conmigo." No dice "porque tu me sacaste del valle", sino "porque tu estas conmigo EN el valle." A veces Dios no nos saca de la dificultad; nos acompana en ella. Y esa compania lo cambia todo.

Jesus prometio: "Yo estoy con vosotros todos los dias, hasta el fin del mundo." No dijo "los dias buenos" o "cuando se sientan fuertes." Todos los dias. Los dias de esperanza y los dias de miedo. Los dias de buenas noticias y los de malas. El esta.',
  'Antes de dormir, imagina que Jesus esta sentado junto a ti. No tienes que decir nada. Solo siente su presencia. Si te salen lagrimas, dejalas fluir. El esta ahi.',
  '¿En que momentos te sientes mas solo en tu proceso de enfermedad? ¿Sientes la presencia de Dios o te cuesta percibirla?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 2, Dia 5: Testimonios de sanacion
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000002',
  5,
  'Testimonios de sanacion',
  ARRAY['Marcos 5:34', 'Santiago 5:15', 'Salmo 103:2-3'],
  'La Biblia esta llena de historias de sanacion. La mujer que toco el manto de Jesus llevaba doce anos enferma. Doce anos de doctores, de gastos, de esperanzas rotas. Y Jesus le dijo: "Hija, tu fe te ha hecho salva; ve en paz." No fue la medicina ni la suerte; fue la fe puesta en el lugar correcto.

Santiago escribe: "La oracion de fe salvara al enfermo, y el Senor lo levantara." Dios sigue sanando hoy. No siempre como esperamos ni cuando esperamos, pero su poder no ha disminuido. El Salmo 103 nos recuerda: "El es quien perdona todas tus iniquidades, el que sana todas tus dolencias."

Estas historias no son para presionarte a "tener mas fe" como si la sanacion dependiera solo de ti. Son para recordarte que sirves a un Dios que puede. Y que tu historia no ha terminado. Mientras haya vida, hay esperanza, y el Dios de la Biblia sigue siendo el mismo.',
  'Lee Marcos 5:25-34 completo, la historia de la mujer con flujo de sangre. Ponte en su lugar. Luego, acercate a Jesus con tu propia necesidad de sanacion, en oracion sincera.',
  '¿Crees que Dios puede sanarte o sanar a tu ser querido? ¿Como te sientes al pedirle algo tan grande?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 2, Dia 6: Gratitud en la prueba
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000002',
  6,
  'Gratitud en la prueba',
  ARRAY['1 Tesalonicenses 5:18', 'Habacuc 3:17-18', 'Job 1:21'],
  'Dar gracias cuando estas enfermo suena casi ofensivo. ¿Como puedes agradecer en medio del dolor? Pablo no dice "dad gracias POR todo", sino "dad gracias EN todo." No agradeces la enfermedad; agradeces en medio de ella. Es diferente.

Habacuc escribio una de las declaraciones de fe mas poderosas: "Aunque la higuera no florezca... con todo, yo me alegrare en Jehova." Eso es gratitud radical. No porque todo este bien, sino porque Dios sigue siendo bueno independientemente de las circunstancias.

La gratitud no niega el dolor; lo pone en perspectiva. Cuando empiezas a buscar razones para agradecer, descubres que incluso en los momentos mas oscuros hay destellos de luz: una persona que te cuida, un dia sin dolor, una palabra de aliento. La gratitud no cambia tu diagnostico, pero cambia como lo vives.',
  'Escribe cinco cosas por las que puedes dar gracias HOY, a pesar de la enfermedad. Se especifico: no "mi familia" sino "la llamada de mi hermana esta manana."',
  '¿Que cosas buenas siguen existiendo en tu vida a pesar de la enfermedad? ¿Te cuesta verlas o las reconoces?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 2, Dia 7: Esperanza inquebrantable
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000002',
  7,
  'Esperanza inquebrantable',
  ARRAY['Romanos 8:18', 'Apocalipsis 21:4', 'Jeremias 29:11'],
  'Pablo escribio algo atrevido: "Tengo por cierto que las aflicciones del tiempo presente no son comparables con la gloria venidera que en nosotros ha de manifestarse." No minimizaba el sufrimiento; lo ponia en perspectiva eterna. Hay algo mas grande que esto esperandote.

Apocalipsis promete un dia en que "Dios enjugara toda lagrima de los ojos de ellos; y ya no habra muerte, ni habra mas llanto, ni clamor, ni dolor." Esta no es una fantasia; es una promesa del Dios que no miente. Tu dolor tiene fecha de vencimiento, aunque ahora no lo parezca.

Jeremias 29:11 te recuerda: "Porque yo se los pensamientos que tengo acerca de vosotros, pensamientos de paz, y no de mal, para daros el fin que esperais." Dios tiene planes para ti. Buenos planes. Planes de esperanza. Esta semana has caminado por el valle, pero no te quedas ahi. Mira hacia adelante con la fuerza que solo Dios puede dar.',
  'Escribe una carta a ti mismo desde el futuro, describiendo como te gustaria mirar hacia atras a este momento. Incluye lo que aprendiste y como creciste. Guardala para leerla cuando necesites esperanza.',
  '¿Que esperanza tienes para tu futuro? ¿Que le pedirias a Dios si supieras que te va a escuchar?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- ============================================================================
-- PLAN 3: Confianza en la provision de Dios (difficult_moment / financial_issues)
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'b1000000-0000-0000-0000-000000000003',
  'Confianza en la provision de Dios',
  'Un viaje de 7 dias para quienes enfrentan presion economica. Ya sea desempleo, deudas o la incertidumbre de no saber como llegar a fin de mes, descubriras que Dios ve tu necesidad y tiene un plan para ti. Exploraras principios biblicos de administracion, generosidad y confianza que transformaran tu relacion con el dinero y con quien provee verdaderamente.',
  'Encuentra paz financiera confiando en quien provee',
  7,
  '💼',
  'Personas enfrentando dificultades economicas, desempleo o deudas',
  false,
  true,
  13
) ON CONFLICT (id) DO NOTHING;

-- Plan 3, Dia 1: Dios ve tu necesidad
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000003',
  1,
  'Dios ve tu necesidad',
  ARRAY['Mateo 6:31-33', 'Filipenses 4:19', 'Salmo 37:25'],
  'La presion economica tiene una forma unica de robarte la paz. Te despierta a las tres de la manana pensando en facturas. Te hace sentir que no eres suficiente, que fallaste, que Dios se olvido de ti. Pero nada de eso es verdad.

Jesus dijo: "No os afaneis diciendo: ¿Que comeremos? ¿Que beberemos? ¿Con que nos vestiremos? Porque vuestro Padre celestial sabe que teneis necesidad de todas estas cosas." Dios no necesita que le informes de tu situacion; ya la conoce. Lo que necesita es que confies en El en medio de ella.

Pablo, que conocio la abundancia y la escasez, escribio: "Mi Dios suplira todo lo que os falta conforme a sus riquezas en gloria en Cristo Jesus." No dice "parte" de lo que te falta; dice "todo." Y no conforme a tu economia, sino conforme a SUS riquezas. El recurso de Dios no tiene limite. Hoy, el primer paso es dejar de mirar el problema y empezar a mirar al Proveedor.',
  'Haz una lista honesta de tus preocupaciones financieras. Luego, al lado de cada una, escribe: "Mi Dios suplira esto." Ora sobre cada punto de la lista.',
  '¿Cual es tu mayor preocupacion financiera en este momento? ¿Como te hace sentir?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 3, Dia 2: Libertad de la ansiedad
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000003',
  2,
  'Libertad de la ansiedad',
  ARRAY['Mateo 6:25-27', '1 Pedro 5:7', 'Salmo 55:22'],
  'Jesus hizo una pregunta que deberia detenernos: "¿Quien de vosotros podra, por mucho que se afane, anadir a su estatura un codo?" La ansiedad no resuelve nada. No paga facturas, no genera empleo, no multiplica el dinero. Solo te roba la paz que necesitas para pensar con claridad y actuar con sabiduria.

"Echa sobre Jehova tu carga, y el te sustentara." El salmista no dice que Dios eliminara la carga, sino que te sostendra mientras la llevas. A veces la provision de Dios no es que desaparezca el problema, sino que te da la fuerza para atravesarlo.

La ansiedad financiera es un ciclo: no tienes dinero, te angustias, la angustia te paraliza, la paralisis empeora la situacion. Romper ese ciclo empieza con soltar. No soltar la responsabilidad de actuar, sino soltar la ilusion de que tu solo puedes controlarlo todo. Dios quiere ser tu socio en esto.',
  'Cuando la ansiedad economica te ataque hoy, sal a caminar 10 minutos y habla con Dios como si fuera tu amigo. Dile exactamente que necesitas y como te sientes.',
  '¿La ansiedad por el dinero afecta tu sueno, tus relaciones o tu salud? ¿En que se nota mas?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 3, Dia 3: Mayordomia fiel
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000003',
  3,
  'Mayordomia fiel',
  ARRAY['Lucas 16:10', 'Proverbios 21:5', 'Mateo 25:21'],
  'Dios promete proveer, pero tambien espera que administres con sabiduria lo que ya tienes. "El que es fiel en lo muy poco, tambien en lo mas es fiel." No se trata de cuanto tienes, sino de como lo manejas. La mayordomia fiel en lo poco abre la puerta a mas.

Proverbios dice: "Los pensamientos del diligente ciertamente tienden a la abundancia." La diligencia y la planificacion no son falta de fe; son fe en accion. Confiar en Dios no significa no hacer presupuesto; significa hacer presupuesto confiando en que El bendecira tu esfuerzo.

Jesus conto la parabola del siervo fiel al que le dijo: "Bien, buen siervo y fiel; sobre poco has sido fiel, sobre mucho te pondre." Dios observa como manejas lo que tienes ahora. La fidelidad en la escasez es la semilla de la abundancia futura.',
  'Siéntate hoy 15 minutos y haz un presupuesto simple: ingresos vs gastos del mes. Identifica un gasto que puedes reducir y un area donde puedes ser mas intencional.',
  '¿Como describirias tu relacion con el dinero? ¿Eres ordenado o impulsivo? ¿Planificas o improvisas?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 3, Dia 4: Generosidad en la escasez
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000003',
  4,
  'Generosidad en la escasez',
  ARRAY['2 Corintios 9:6-7', 'Marcos 12:41-44', 'Proverbios 11:24-25'],
  'Esto va a sonar contradictorio: una de las claves para superar la escasez es dar. No por magia ni por formula, sino porque la generosidad rompe el espiritu de escasez que te dice que nunca hay suficiente.

Jesus senalo a la viuda que echo dos monedas al tesoro del templo y dijo que habia dado mas que todos los ricos. No porque la cantidad fuera mayor, sino porque dio de su pobreza, no de su sobrante. Eso requiere una fe que dice: "Dios, confio en ti lo suficiente como para soltar lo poco que tengo."

"El que siembra escasamente, tambien segara escasamente; y el que siembra generosamente, generosamente tambien segara." No se trata de dar para recibir como si fuera un negocio. Se trata de que la generosidad abre tu corazon y tu perspectiva. Te saca del modo supervivencia y te conecta con la economia del Reino, que funciona con reglas diferentes.',
  'Hoy, da algo a alguien que lo necesite. No tiene que ser dinero: puede ser tiempo, comida, ayuda practica. Da con alegria, sin esperar nada a cambio.',
  '¿Te cuesta dar cuando no tienes mucho? ¿Por que crees que es asi? ¿Que sientes cuando das a pesar de la escasez?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 3, Dia 5: Trabajo con proposito
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000003',
  5,
  'Trabajo con proposito',
  ARRAY['Colosenses 3:23-24', 'Proverbios 14:23', '2 Tesalonicenses 3:10'],
  'El trabajo no es un castigo; es un regalo de Dios. Antes de la caida, Adan ya tenia trabajo en el jardin. El proposito del trabajo va mas alla de ganar dinero: es contribuir, servir, usar los talentos que Dios te dio y glorificarlo con tu esfuerzo.

"Todo lo que hagais, hacedlo de corazon, como para el Senor y no para los hombres." Esto cambia la perspectiva de cualquier trabajo, por humilde que parezca. No trabajas solo para un jefe o por un sueldo; trabajas para Dios. Y eso dignifica cada tarea.

Si estas desempleado, no pierdas la esperanza. Proverbios dice: "En toda labor hay fruto." Sigue buscando, sigue tocando puertas, sigue preparandote. Dios honra la diligencia. Mientras esperas, trabaja en lo que puedas: tu hogar, tu comunidad, tus habilidades. Ningun esfuerzo honesto se pierde.',
  'Si tienes trabajo, haz tu tarea de hoy con excelencia, como ofrenda a Dios. Si estas buscando empleo, dedica una hora enfocada a buscar oportunidades y ora antes de empezar.',
  '¿Como ves tu trabajo o tu busqueda de empleo? ¿Es solo un medio para ganar dinero o le encuentras un proposito mas profundo?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 3, Dia 6: Contentamiento verdadero
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000003',
  6,
  'Contentamiento verdadero',
  ARRAY['Filipenses 4:11-13', 'Hebreos 13:5', '1 Timoteo 6:6-8'],
  'Pablo escribio desde la carcel: "He aprendido a contentarme, cualquiera que sea mi situacion." Nota que dijo "he aprendido." El contentamiento no es natural; se cultiva. No es resignacion ni falta de ambicion; es paz interior independiente de tu cuenta bancaria.

"Sean vuestras costumbres sin avaricia, contentos con lo que teneis ahora; porque el dijo: No te desamparare, ni te dejare." El fundamento del contentamiento no es "tengo suficiente," sino "Dios no me dejara." Tu seguridad no esta en lo que tienes, sino en quien te tiene a ti.

"Gran ganancia es la piedad acompañada de contentamiento." El mundo te dice que la ganancia es tener mas. Dios dice que la ganancia es estar en paz con lo que tienes mientras confias en El para lo que necesitas. Eso no significa que no trabajes por mejorar; significa que no permites que la falta te robe el gozo del presente.',
  'Hoy, cada vez que desees algo que no puedes comprar, agradece por tres cosas que ya tienes. Escribe al final del dia cuantas veces lo hiciste.',
  '¿Que necesitas realmente vs que quieres? ¿Puedes distinguir entre necesidad y deseo en tu vida financiera?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 3, Dia 7: Futuro con esperanza
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000003',
  7,
  'Futuro con esperanza',
  ARRAY['Jeremias 29:11', 'Romanos 8:28', 'Deuteronomio 8:18'],
  'Dios tiene planes para ti, y son buenos. "Pensamientos de paz, y no de mal, para daros el fin que esperais." Tu situacion economica actual no es tu destino. Es un capitulo, no toda la historia. Y Dios es el autor que escribe finales que superan lo que puedes imaginar.

Deuteronomio nos recuerda algo crucial: "Acuerdate de Jehova tu Dios, porque el te da el poder para hacer las riquezas." La capacidad que tienes para trabajar, crear, producir, resolver problemas... todo viene de Dios. El que te dio la capacidad tambien te dara la oportunidad.

Esta semana has recorrido un camino de confianza: reconociste tu necesidad, soltaste la ansiedad, aprendiste sobre mayordomia y generosidad, encontraste proposito en el trabajo y contentamiento en lo que tienes. Ahora mira hacia adelante. Romanos 8:28 promete que todas las cosas cooperan para bien. Incluso esta temporada dificil esta produciendo algo bueno en ti.',
  'Escribe tres metas financieras realistas para los proximos tres meses. Al lado de cada una, escribe un paso concreto que puedes dar esta semana. Comprométete a orar por ellas cada dia.',
  '¿Que aprendiste esta semana sobre tu relacion con el dinero y con Dios? ¿Que habito quieres mantener?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- ============================================================================
-- PLAN 4: Fortaleciendo tu vida de oracion (spiritual_growth / prayer_life)
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'b1000000-0000-0000-0000-000000000004',
  'Fortaleciendo tu vida de oracion',
  'Un viaje de 7 dias para redescubrir la oracion como conversacion viva con Dios. Si sientes que tus oraciones son repetitivas, que Dios no escucha, o simplemente no sabes como orar, este plan es para ti. Aprenderas modelos biblicos de oracion, como escuchar la voz de Dios, y como construir un habito de oracion que transforme tu relacion con El y cada area de tu vida.',
  'Redescubre la oracion como conversacion viva con Dios',
  7,
  '🙏',
  'Personas que quieren profundizar su vida de oracion',
  false,
  true,
  14
) ON CONFLICT (id) DO NOTHING;

-- Plan 4, Dia 1: ¿Por que orar?
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000004',
  1,
  '¿Por que orar?',
  ARRAY['Jeremias 33:3', '1 Tesalonicenses 5:17', 'Mateo 7:7-8'],
  '¿Para que orar si Dios ya sabe lo que necesitas? Es una pregunta honesta que muchos se hacen. La respuesta es que la oracion no es para informar a Dios; es para conectar con El. Es como hablar con alguien que amas: no lo haces porque necesites transmitir datos, sino porque la relacion vive en la comunicacion.

Dios dice: "Clamame, y yo te respondere, y te ensenaré cosas grandes y ocultas que tu no conoces." La oracion abre puertas que nada mas puede abrir. No porque Dios necesite que le pidamos para actuar, sino porque al orar nos alineamos con Su voluntad y nos hacemos receptivos a lo que quiere hacer.

Jesus dijo: "Pedid, y se os dara; buscad, y hallareis; llamad, y se os abrira." La oracion es pedir, buscar y llamar. Es accion, no pasividad. Y la promesa es clara: el que pide, recibe. No siempre lo que esperas, pero siempre lo que necesitas.',
  'Hoy, en lugar de orar con una lista de peticiones, simplemente habla con Dios como hablas con tu mejor amigo. Cuentale como te fue el dia, que te preocupa, que te alegra. Sin formulas.',
  '¿Como describirias tu vida de oracion actual? ¿Es una rutina, una obligacion, un placer, o algo que casi no practicas?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 4, Dia 2: Modelos de oracion
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000004',
  2,
  'Modelos de oracion',
  ARRAY['Mateo 6:9-13', 'Salmo 51:1-4', 'Daniel 9:4-5'],
  'Cuando los discipulos le pidieron a Jesus que les ensenara a orar, El les dio el Padrenuestro. No como una formula para repetir mecanicamente, sino como un modelo de lo que la oracion debe incluir: adoracion ("santificado sea tu nombre"), sometimiento ("hagase tu voluntad"), peticion ("danos hoy nuestro pan"), confesion ("perdonanos nuestras deudas") e intercesion ("libranos del mal").

Pero la Biblia tiene muchos mas modelos. El Salmo 51 es un modelo de oracion de arrepentimiento: David, despues de su pecado, clama: "Ten piedad de mi, oh Dios... lavame mas y mas de mi maldad." Es crudo, honesto, sin adornos. Daniel oraba con confesion corporativa, identificandose con el pecado de su pueblo.

No hay una sola forma correcta de orar. Hay oraciones gritadas y susurradas, largas y cortas, con palabras y sin ellas. Lo que importa es que sea autentica. Dios prefiere una oracion torpe pero sincera a una elocuente pero vacia.',
  'Usa el Padrenuestro como guia, pero personalizalo. En cada parte, anade tus propias palabras. Por ejemplo: "Danos hoy nuestro pan" → "Senor, dame hoy la fuerza para enfrentar..." Hazlo lentamente.',
  '¿Que tipo de oracion te resulta mas natural: alabanza, peticion, confesion o gratitud? ¿Cual te cuesta mas?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 4, Dia 3: Escuchar a Dios
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000004',
  3,
  'Escuchar a Dios',
  ARRAY['1 Reyes 19:11-13', 'Juan 10:27', 'Salmo 46:10'],
  'La oracion no es un monologo; es un dialogo. Hablamos mucho CON Dios, pero ¿cuanto tiempo dedicamos a escucharlo? Elias descubrio que Dios no estaba en el terremoto, ni en el fuego, ni en el viento fuerte, sino en "un silbo apacible y delicado." La voz de Dios a menudo es suave, y para escucharla necesitas hacer silencio.

Jesus dijo: "Mis ovejas oyen mi voz, y yo las conozco, y me siguen." Dios habla. El problema no es que El este callado, sino que vivimos en un mundo tan ruidoso que nos cuesta escucharlo. Habla a traves de Su Palabra, a traves de otras personas, a traves de circunstancias, y a traves de ese susurro interior que reconoces cuando te detienes.

"Estad quietos, y conoced que yo soy Dios." La quietud es una disciplina espiritual casi perdida. Estamos tan acostumbrados al ruido constante que el silencio nos incomoda. Pero es en el silencio donde Dios mas claramente se revela.',
  'Busca 10 minutos de silencio absoluto hoy. Sin telefono, sin musica, sin distracciones. Siéntate, respira profundo, y simplemente escucha. Si un pensamiento o una impresion llega, anotalo.',
  '¿Alguna vez has sentido que Dios te hablaba? ¿Como fue? Si no, ¿que crees que te impide escucharlo?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 4, Dia 4: Oracion persistente
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000004',
  4,
  'Oracion persistente',
  ARRAY['Lucas 18:1-8', 'Colosenses 4:2', 'Romanos 12:12'],
  'Jesus conto la parabola de la viuda insistente para ensenar que "es necesario orar siempre, y no desmayar." La viuda no tenia poder, influencia ni conexiones. Solo tenia persistencia. Y gano.

¿Por que Dios quiere que seamos persistentes? No porque necesite que le roguemos para convencerlo, sino porque la persistencia en la oracion nos transforma. Cada vez que vuelves a orar por algo, renuevas tu confianza en Dios, clarificas lo que realmente quieres, y te mantienes conectado con El.

Pablo dice: "Perseverad en la oracion, velando en ella con accion de gracias." Perseverar es seguir cuando no ves resultados. Es orar el dia 30 con la misma fe del dia 1. Es creer que Dios escucho la primera vez y que Su silencio no es indiferencia sino que esta trabajando en lo que no ves.',
  'Elige una peticion especifica que llevas tiempo orando. Hoy, ofrécela a Dios tres veces durante el dia: manana, tarde y noche. No con ansiedad, sino con confianza renovada.',
  '¿Hay algo por lo que has dejado de orar porque sientes que Dios no responde? ¿Que pasaria si retomas esa oracion hoy?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 4, Dia 5: Orando por otros
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000004',
  5,
  'Orando por otros',
  ARRAY['1 Timoteo 2:1', 'Santiago 5:16', 'Efesios 6:18'],
  'La oracion no es solo sobre ti. Una de las formas mas poderosas de orar es interceder por otros. Pablo pide: "Exhorto ante todo, a que se hagan rogativas, oraciones, peticiones y acciones de gracias, por todos los hombres." Orar por otros te saca de tu propio mundo y te conecta con el corazon de Dios por la humanidad.

Santiago escribe algo radical: "La oracion eficaz del justo puede mucho." Tu oracion por otra persona tiene poder real. No es un gesto simbolico ni un pensamiento bonito; es una fuerza espiritual que mueve cosas en el mundo invisible. Cuando oras por alguien, estas colaborando con Dios en su plan para esa persona.

La intercesion tambien te transforma a ti. Es dificil guardar resentimiento contra alguien por quien oras sinceramente. Es dificil ser indiferente al sufrimiento de alguien que llevas ante Dios cada dia. La oracion por otros agranda tu corazon.',
  'Hoy, ora por cinco personas: un familiar, un amigo, alguien que te cae mal, un lider de tu comunidad y alguien que no conoces pero que sabes que esta sufriendo. Dedica al menos un minuto a cada uno.',
  '¿Por quien oras regularmente ademas de ti mismo? ¿Hay alguien que necesita tus oraciones y que has estado ignorando?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 4, Dia 6: Obstaculos en la oracion
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000004',
  6,
  'Obstaculos en la oracion',
  ARRAY['Isaias 59:1-2', 'Santiago 4:3', 'Marcos 11:25'],
  'A veces sentimos que nuestras oraciones rebotan en el techo. Que Dios esta lejos o que no escucha. Isaias explica: "No se ha acortado la mano de Jehova para salvar, ni se ha agravado su oido para oir; pero vuestras iniquidades han hecho division entre vosotros y vuestro Dios." El pecado no confesado es un obstaculo real.

Santiago anade otro: "Pedis, y no recibis, porque pedis mal, para gastar en vuestros deleites." A veces nuestras oraciones no son respondidas porque estamos pidiendo cosas que no nos convienen, motivados por egoismo disfrazado de espiritualidad.

Jesus menciona otro obstaculo: la falta de perdon. "Cuando esteis orando, perdonad, si teneis algo contra alguno." La oracion efectiva requiere un corazon limpio: sin pecado escondido, con motivaciones honestas y sin resentimiento guardado. No significa ser perfecto, sino ser sincero y estar dispuesto a que Dios trabaje en ti.',
  'Haz un examen de conciencia honesto: ¿hay pecado sin confesar, motivaciones egoistas o falta de perdon que puedan estar bloqueando tus oraciones? Confiesa lo que encuentres y pide a Dios que limpie el camino.',
  '¿Sientes que tus oraciones son escuchadas? Si no, ¿que crees que podria estar interfiriendo?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 4, Dia 7: Una vida de oracion
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000004',
  7,
  'Una vida de oracion',
  ARRAY['1 Tesalonicenses 5:17', 'Salmo 5:3', 'Lucas 5:16'],
  '"Orad sin cesar." ¿Como se ora sin parar? No significa estar de rodillas todo el dia, sino vivir en una actitud constante de conexion con Dios. Es como tener una conversacion abierta que nunca termina: le hablas mientras manejas, mientras cocinas, mientras trabajas. Le consultas decisiones, le agradeces momentos, le pides ayuda al instante.

"Oh Jehova, de manana oiras mi voz; de manana me presentare delante de ti." El salmista comenzaba cada dia con oracion. Lucas nos dice que Jesus, a pesar de las multitudes y las demandas, "se apartaba a lugares desiertos, y oraba." Si Jesus necesitaba retirarse a orar, cuanto mas nosotros.

Esta semana has explorado diferentes aspectos de la oracion. Ahora viene lo mas importante: convertirlo en habito. Un habito no se forma con inspiracion sino con consistencia. No necesitas oraciones largas ni perfectas; necesitas oraciones frecuentes y honestas. Cada dia, un poco mas. Asi se construye una vida de oracion.',
  'Establece un horario fijo de oracion: un momento especifico del dia que sera tu "cita con Dios." Ponlo como alarma en tu telefono. Empieza con 5 minutos y ve aumentando cada semana.',
  '¿Que aprendiste esta semana sobre la oracion que no sabias o habias olvidado? ¿Que habito concreto vas a mantener?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- ============================================================================
-- PLAN 5: Conociendo la Palabra de Dios (spiritual_growth / bible_knowledge)
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'b1000000-0000-0000-0000-000000000005',
  'Conociendo la Palabra de Dios',
  'Un viaje de 7 dias para descubrir la Biblia como lo que realmente es: una carta de amor de Dios para ti. Si la Biblia te parece complicada, aburrida o lejana, este plan es para ti. Recorreras el Antiguo y Nuevo Testamento, aprenderas herramientas practicas para leer con comprension, y descubriras versiculos que pueden cambiar tu perspectiva de la vida. Al final, tendras un plan claro para hacer de la lectura biblica un habito diario.',
  'Descubre la Biblia como carta de amor de Dios para ti',
  7,
  '📖',
  'Personas que quieren conocer mejor la Biblia',
  false,
  true,
  15
) ON CONFLICT (id) DO NOTHING;

-- Plan 5, Dia 1: ¿Que es la Biblia?
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000005',
  1,
  '¿Que es la Biblia?',
  ARRAY['2 Timoteo 3:16-17', 'Hebreos 4:12', 'Salmo 119:105'],
  'La Biblia no es solo un libro; es una biblioteca. 66 libros escritos por mas de 40 autores durante 1,500 anos, y sin embargo, cuentan una sola historia: el amor de Dios por la humanidad. Desde Genesis hasta Apocalipsis, el hilo es el mismo: Dios creando, buscando, rescatando y restaurando.

Pablo escribio: "Toda la Escritura es inspirada por Dios, y util para ensenar, para redargüir, para corregir, para instruir en justicia." No es un libro mas. Es la Palabra de Dios: viva, activa, capaz de transformarte. Hebreos la describe como "mas cortante que toda espada de dos filos," capaz de llegar a donde nada mas llega.

El salmista la llama "lampara a mis pies y lumbrera a mi camino." En un mundo lleno de confusion, la Biblia es la guia que no falla. No porque sea un manual de reglas, sino porque revela el corazon de Dios y el camino que El diseño para ti.',
  'Lee el Salmo 119:97-112 lentamente. Subraya o anota las frases que mas te llamen la atencion. Observa como el salmista describe su relacion con la Palabra de Dios.',
  '¿Que es la Biblia para ti ahora mismo? ¿Un libro polvoriento, un misterio, una obligacion, o algo vivo que te habla?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 5, Dia 2: Antiguo Testamento
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000005',
  2,
  'Antiguo Testamento',
  ARRAY['Genesis 1:1', 'Exodo 3:14', 'Isaias 53:5'],
  'El Antiguo Testamento cuenta la historia desde la creacion hasta 400 anos antes de Jesus. Tiene de todo: poesia, historia, leyes, profecia, sabiduria. Puede parecer lejano, pero sus lecciones son eternas.

"En el principio creo Dios los cielos y la tierra." Todo empieza aqui. Dios crea, el ser humano cae, y Dios comienza un plan de rescate que atraviesa toda la Biblia. Elige a Abraham, forma un pueblo, lo libera de Egipto, le da leyes, lo acompana al exilio y le promete un Salvador.

Isaias, 700 anos antes de Cristo, profetizo: "Mas el herido fue por nuestras rebeliones, molido por nuestros pecados." El Antiguo Testamento no es una coleccion de historias antiguas; es la preparacion para lo que vendria. Cada pagina apunta hacia Jesus, aunque no siempre sea obvio. Cuando lo lees sabiendo eso, cobra una dimension completamente nueva.',
  'Lee Genesis 1-3 (la creacion y la caida). Son solo tres capitulos. Anota: ¿que te dice sobre Dios? ¿Que te dice sobre el ser humano? ¿Que te dice sobre el mal?',
  '¿Que parte del Antiguo Testamento te resulta mas interesante o mas confusa? ¿Que te gustaria entender mejor?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 5, Dia 3: Nuevo Testamento
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000005',
  3,
  'Nuevo Testamento',
  ARRAY['Juan 1:14', 'Hechos 2:42', 'Romanos 8:1'],
  'El Nuevo Testamento es donde todo llega a su climax. "Aquel Verbo fue hecho carne, y habito entre nosotros." Dios se hace humano. El Creador entra en su creacion. Es la noticia mas asombrosa de la historia.

Los cuatro Evangelios (Mateo, Marcos, Lucas y Juan) cuentan la vida de Jesus desde diferentes perspectivas. Hechos narra como la iglesia primitiva se expandio: "Perseveraban en la doctrina de los apostoles, en la comunion unos con otros, en el partimiento del pan y en las oraciones." Las cartas de Pablo, Pedro, Juan y otros explican lo que significa vivir a la luz de Jesus.

"Ahora, pues, ninguna condenacion hay para los que estan en Cristo Jesus." El Nuevo Testamento no es un libro de reglas nuevas; es la declaracion de libertad mas grande jamas escrita. Eres libre del pecado, libre de la culpa, libre para vivir como Dios diseno.',
  'Lee el Evangelio de Marcos, capitulo 1. Es el mas corto y directo de los Evangelios. Nota la urgencia con la que Marcos cuenta la historia de Jesus. ¿Que te impresiona?',
  '¿Que sabes de Jesus? Si tuvieras que describir quien es a alguien que nunca oyo de El, ¿que dirias?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 5, Dia 4: Como leer la Biblia
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000005',
  4,
  'Como leer la Biblia',
  ARRAY['Josue 1:8', 'Salmo 1:2-3', '2 Timoteo 2:15'],
  'Muchos empiezan a leer la Biblia con entusiasmo, llegan a Levitico y abandonan. Es normal. La Biblia no se lee como una novela de principio a fin. Necesitas herramientas y estrategia.

"Medita en el de dia y de noche," dice Josue. Meditar no es solo leer; es detenerte, pensar, masticar las palabras. Lee un pasaje corto y preguntate: ¿que dice? ¿Que significaba para los lectores originales? ¿Que me dice a mi hoy? ¿Que voy a hacer al respecto?

Pablo le dice a Timoteo: "Procura con diligencia presentarte a Dios aprobado, como obrero que no tiene de que avergonzarse, que usa bien la palabra de verdad." Usar BIEN la Palabra requiere esfuerzo. Algunos consejos practicos: empieza por los Evangelios si eres nuevo, lee un Salmo al dia para cultivar adoracion, usa una version en espanol que entiendas bien, y no tengas miedo de las preguntas. Las preguntas honestas son el inicio de la comprension.',
  'Elige un pasaje corto (5-10 versiculos). Leelo tres veces: la primera para entender que dice, la segunda para descubrir que significa, y la tercera para decidir que vas a hacer con lo que aprendiste.',
  '¿Que te ha impedido leer la Biblia con mas frecuencia? ¿Falta de tiempo, de comprension, de motivacion, o algo mas?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 5, Dia 5: Versiculos que cambian vidas
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000005',
  5,
  'Versiculos que cambian vidas',
  ARRAY['Jeremias 29:11', 'Romanos 8:28', 'Filipenses 4:13'],
  'Hay versiculos que son como anclas para el alma. En los momentos de tormenta, tener la Palabra de Dios memorizada te sostiene cuando nada mas puede.

"Porque yo se los pensamientos que tengo acerca de vosotros, dice Jehova, pensamientos de paz, y no de mal, para daros el fin que esperais." Jeremias 29:11 no es un cheque en blanco para tener todo lo que quieres; es una promesa de que Dios tiene un plan bueno para ti, incluso cuando las circunstancias dicen lo contrario.

"Y sabemos que a los que aman a Dios, todas las cosas les ayudan a bien." Romanos 8:28 no dice que todo lo que pasa es bueno, sino que Dios toma incluso lo malo y lo transforma en bien. Y "Todo lo puedo en Cristo que me fortalece" no significa que puedas hacer cualquier cosa que se te antoje, sino que con Cristo tienes la fuerza para enfrentar cualquier situacion que la vida te ponga delante.',
  'Elige uno de los tres versiculos de hoy y memorizalo. Escríbelo en un papel y ponlo donde lo veas varias veces al dia. Repitelo hasta que lo sepas de memoria.',
  '¿Hay algun versiculo que ya sea especial para ti? ¿Cual es y por que te marca?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 5, Dia 6: Aplicando la Palabra
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000005',
  6,
  'Aplicando la Palabra',
  ARRAY['Santiago 1:22-25', 'Mateo 7:24-27', 'Lucas 11:28'],
  'Leer la Biblia sin aplicarla es como mirar una receta sin cocinar. Santiago lo dice claro: "Sed hacedores de la palabra, y no tan solamente oidores, engañandoos a vosotros mismos." Conocer la Biblia de memoria pero no vivirla es autoengano espiritual.

Jesus conto la parabola de dos constructores: uno edifico sobre roca (escucho y obedecio) y el otro sobre arena (escucho y no obedecio). Cuando vino la tormenta, solo la casa sobre roca se mantuvo. La diferencia no fue cuanto sabian, sino cuanto obedecieron.

"Bienaventurados los que oyen la palabra de Dios, y la guardan." La bendicion no esta en el conocimiento, sino en la obediencia. Cada vez que lees algo en la Biblia, la pregunta clave es: ¿que voy a hacer con esto HOY? No manana, no algun dia. Hoy.',
  'Piensa en algo que leiste en la Biblia esta semana. Identifica una accion concreta que puedes tomar hoy basada en esa lectura. Hazla antes de que termine el dia.',
  '¿Que es mas facil para ti: leer la Biblia o aplicar lo que lees? ¿Que te impide poner en practica lo que aprendes?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 5, Dia 7: Un habito para siempre
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000005',
  7,
  'Un habito para siempre',
  ARRAY['Salmo 119:11', 'Deuteronomio 6:6-9', 'Proverbios 2:1-5'],
  '"En mi corazon he guardado tus dichos, para no pecar contra ti." La Palabra de Dios guardada en el corazon es proteccion, guia y consuelo disponible en todo momento. No necesitas tener la Biblia en la mano si la tienes en el corazon.

Dios le dijo a Israel: "Estas palabras que yo te mando hoy, estaran sobre tu corazon; y las repetiras a tus hijos, y hablaras de ellas estando en tu casa, y andando por el camino." La Palabra no es para los domingos; es para cada momento de la vida.

Esta semana has descubierto que es la Biblia, recorrido sus dos partes, aprendido a leerla, encontrado versiculos clave y practicado aplicarla. Ahora viene lo mas importante: no dejar que esto se quede en una semana. Proverbios dice que si buscas la sabiduria como la plata, "entonces entenderas el temor de Jehova, y hallaras el conocimiento de Dios." El tesoro esta ahi. Solo necesitas buscarlo cada dia.',
  'Establece un plan de lectura biblica sencillo: un capitulo al dia, empezando por el Evangelio de Juan. Pon un recordatorio en tu telefono a la misma hora cada dia. Marca cada dia que leas.',
  '¿Que aprendiste esta semana sobre la Biblia que no sabias? ¿Que plan de lectura te comprometes a seguir?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- ============================================================================
-- PLAN 6: Fe en lo cotidiano (spiritual_growth / daily_faith)
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'b1000000-0000-0000-0000-000000000006',
  'Fe en lo cotidiano',
  'Un viaje de 7 dias para descubrir que la fe no se vive solo en la iglesia o en momentos de crisis, sino en cada instante del dia. Aprenderas a ver la mano de Dios en lo ordinario: en tu trabajo, en tus relaciones, en tus decisiones diarias. Este plan te ayudara a integrar tu fe con tu vida real, de una forma practica y autentica, sin ser falso ni rigido.',
  'Descubre a Dios en cada momento de tu dia a dia',
  7,
  '☀️',
  'Personas que quieren vivir su fe de manera practica y cotidiana',
  false,
  true,
  16
) ON CONFLICT (id) DO NOTHING;

-- Plan 6, Dia 1: Fe en lo ordinario
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000006',
  1,
  'Fe en lo ordinario',
  ARRAY['1 Corintios 10:31', 'Colosenses 3:17', 'Salmo 118:24'],
  'Tendemos a pensar que la fe es para los momentos grandes: la iglesia, la oracion, la crisis. Pero la mayoria de tu vida ocurre en lo ordinario: preparar el desayuno, ir al trabajo, hacer mandados, conversar con vecinos. ¿Donde esta Dios en todo eso?

Pablo responde: "Si comeis o bebeis, o haceis otra cosa, hacedlo todo para la gloria de Dios." Todo. No solo lo espiritual. Comer es espiritual si lo haces con gratitud. Trabajar es espiritual si lo haces con excelencia. Descansar es espiritual si lo haces confiando en que Dios se encarga mientras tu paras.

"Este es el dia que hizo Jehova; nos gozaremos y alegraremos en el." Cada dia, no solo los domingos o los dias especiales. Hoy, mientras lees esto, es un dia que Dios hizo para ti. La pregunta no es si Dios esta presente en tu rutina; la pregunta es si tu estas presente para notarlo.',
  'Hoy, intenta ser consciente de la presencia de Dios en tres momentos ordinarios: al despertarte, durante una comida y antes de dormir. En cada momento, di: "Gracias Dios, estas aqui."',
  '¿En que momentos de tu dia a dia sientes mas la presencia de Dios? ¿En cuales te cuesta mas percibirla?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 6, Dia 2: Amor al projimo
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000006',
  2,
  'Amor al projimo',
  ARRAY['Mateo 22:37-39', '1 Juan 4:20', 'Galatas 5:13-14'],
  'Jesus dijo que el segundo mandamiento mas importante es: "Amaras a tu projimo como a ti mismo." No dijo "ama a la humanidad en abstracto," sino a tu projimo: el vecino, el companero de trabajo, la persona en la fila del supermercado, el familiar que te cae mal.

Juan lo pone crudamente: "Si alguno dice: Yo amo a Dios, y aborrece a su hermano, es mentiroso." No puedes amar a un Dios invisible y despreciar al hermano visible. Tu fe se mide, mas que por tus oraciones, por como tratas a las personas que te rodean cada dia.

Pablo resume toda la ley en una frase: "Por amor servios unos a otros." La fe cotidiana se expresa en actos de amor concretos. Un saludo amable, una escucha atenta, una ayuda inesperada, un perdon silencioso. Cada interaccion humana es una oportunidad de reflejar a Cristo.',
  'Elige a una persona que veras hoy y hazle un favor inesperado: un cafe, una nota de animo, ayudarle con algo. Hazlo sin esperar nada a cambio y sin contarle a nadie.',
  '¿A quien te cuesta mas amar en tu vida diaria? ¿Que crees que Jesus te diria sobre esa persona?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 6, Dia 3: Trabajo como adoracion
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000006',
  3,
  'Trabajo como adoracion',
  ARRAY['Colosenses 3:23-24', 'Genesis 2:15', 'Proverbios 22:29'],
  'Antes de la caida, antes del pecado, Dios ya le habia dado trabajo a Adan: "Tomo, pues, Jehova Dios al hombre, y lo puso en el huerto de Eden, para que lo labrara y lo guardase." El trabajo no es castigo; es parte del diseno original de Dios para ti.

"Todo lo que hagais, hacedlo de corazon, como para el Senor." Cuando cambias la perspectiva de "trabajo para mi jefe" a "trabajo para Dios," todo se transforma. La tarea aburrida se vuelve ofrenda. El esfuerzo invisible se vuelve adoracion. La excelencia se vuelve testimonio.

Proverbios dice: "¿Has visto hombre solicito en su trabajo? Delante de los reyes estara." Tu trabajo bien hecho es un testimonio mas poderoso que mil sermones. La gente nota la diferencia cuando alguien trabaja con un proposito que va mas alla del sueldo.',
  'Hoy, elige la tarea que menos te gusta de tu trabajo o tus responsabilidades. Antes de empezarla, ora: "Senor, hago esto para ti." Nota si cambia tu actitud.',
  '¿Ves tu trabajo como parte de tu fe o como algo separado? ¿Como cambiaria tu dia si trabajaras conscientemente para Dios?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 6, Dia 4: Tentaciones cotidianas
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000006',
  4,
  'Tentaciones cotidianas',
  ARRAY['1 Corintios 10:13', 'Efesios 6:11', 'Santiago 4:7'],
  'Las grandes caidas rara vez empiezan con grandes tentaciones. Empiezan con las pequenas: la mentira piadosa, el chisme casual, la pereza tolerada, el mal humor justificado. La fe cotidiana se prueba en lo cotidiano.

Pablo promete: "No os ha sobrevenido ninguna tentacion que no sea humana; pero fiel es Dios, que no os dejara ser tentados mas de lo que podeis resistir." Toda tentacion tiene una salida. El problema es que a menudo no buscamos la salida porque la tentacion se siente comoda.

Santiago da la estrategia: "Someteos a Dios; resistid al diablo, y huira de vosotros." Dos pasos: primero someterte (rendirte a la voluntad de Dios), luego resistir. No al reves. No puedes resistir la tentacion con tu propia fuerza; necesitas estar conectado a Dios primero. La sumision precede a la victoria.',
  'Identifica tu tentacion cotidiana mas frecuente (la que te gana casi todos los dias). Hoy, cuando aparezca, di en voz alta: "Me someto a Dios y resisto esto." Nota que pasa.',
  '¿Cual es la tentacion cotidiana que mas te cuesta vencer? ¿Que has intentado y que ha funcionado?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 6, Dia 5: Gratitud como estilo de vida
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000006',
  5,
  'Gratitud como estilo de vida',
  ARRAY['1 Tesalonicenses 5:18', 'Salmo 100:4', 'Efesios 5:20'],
  '"Dad gracias en todo, porque esta es la voluntad de Dios." La gratitud no es un sentimiento que esperas tener; es una decision que tomas. Decides agradecer antes de sentir ganas de hacerlo. Y algo magico pasa: al dar gracias, empiezas a sentir gratitud genuina.

"Entrad por sus puertas con accion de gracias." La gratitud es la puerta de entrada a la presencia de Dios. Cuando te quejas, te alejas. Cuando agradeces, te acercas. No porque Dios necesite tus gracias, sino porque la gratitud reorienta tu corazon hacia El.

La gratitud como estilo de vida significa ver la bendicion incluso en lo imperfecto. Tu trabajo no es perfecto, pero tienes trabajo. Tu familia no es perfecta, pero tienes familia. Tu salud no es perfecta, pero estas vivo. La perspectiva agradecida no niega los problemas; los ve desde un lugar diferente.',
  'Empieza un diario de gratitud hoy. Cada noche, antes de dormir, escribe tres cosas especificas por las que das gracias. Se concreto: no "mi salud" sino "pude caminar hasta la tienda sin cansarme."',
  '¿Eres naturalmente agradecido o tiendes a quejarte? ¿Que efecto tiene la queja o la gratitud en tu estado de animo?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 6, Dia 6: Influencia positiva
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000006',
  6,
  'Influencia positiva',
  ARRAY['Mateo 5:14-16', '2 Corintios 2:15', '1 Pedro 3:15'],
  'Jesus dijo: "Vosotros sois la luz del mundo." No dijo "traten de ser luz" o "deberian ser luz." Dijo "sois." Ya lo eres. La pregunta es si tu luz esta brillando o la tienes escondida.

"Asi alumbre vuestra luz delante de los hombres, para que vean vuestras buenas obras, y glorifiquen a vuestro Padre." Tu fe se ve. No en lo que predicas, sino en lo que haces. La gente a tu alrededor esta observando como manejas los problemas, como tratas a los demas, como reaccionas bajo presion.

Pedro dice: "Estad siempre preparados para presentar defensa ante todo el que os demande razon de la esperanza que hay en vosotros; pero hacedlo con mansedumbre y reverencia." No necesitas ser predicador. Solo necesitas vivir de una manera que haga que la gente se pregunte por que eres diferente. Y cuando pregunten, tener una respuesta.',
  'Hoy, busca una oportunidad natural para compartir algo positivo sobre tu fe. No predicando, sino simplemente contando lo que Dios ha hecho en tu vida. Si no surge la oportunidad, simplemente se amable de una forma que sorprenda.',
  '¿Las personas a tu alrededor saben que eres cristiano? ¿Lo notan por como vives o solo si se los dices?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 6, Dia 7: Crecimiento continuo
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000006',
  7,
  'Crecimiento continuo',
  ARRAY['Filipenses 3:12-14', '2 Pedro 3:18', 'Proverbios 4:18'],
  'Pablo, el apostol que escribio gran parte del Nuevo Testamento, dijo: "No que lo haya alcanzado ya, ni que ya sea perfecto." Si Pablo no era perfecto, tu tampoco necesitas serlo. La fe no es un destino al que llegas; es un camino que recorres.

"Creced en la gracia y el conocimiento de nuestro Senor Jesucristo." Crecer es el verbo clave. No "llegar," no "ser perfecto," sino crecer. Y crecer toma tiempo, tiene tropiezos, y nunca se termina. Eso no es una mala noticia; es liberador. No tienes que tenerlo todo resuelto hoy.

"Mas la senda de los justos es como la luz de la aurora, que va en aumento hasta que el dia es perfecto." Tu camino de fe va en aumento. Cada dia un poco mas de luz. Esta semana has aprendido a ver a Dios en lo cotidiano, a amar al projimo, a trabajar con proposito, a enfrentar tentaciones, a vivir agradecido y a ser influencia. No lo dejes aqui. Cada dia es una oportunidad de crecer un poco mas.',
  'Escribe tres areas de tu vida donde quieres crecer espiritualmente en los proximos tres meses. Para cada una, identifica un habito sencillo que te ayude. Compartelo con alguien de confianza.',
  '¿Que aprendiste esta semana que quieres mantener? ¿En que area de tu fe cotidiana quieres seguir creciendo?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- ============================================================================
-- PLAN 7: Retomando tu camino de fe (feeling_distant / stopped_practicing)
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'b1000000-0000-0000-0000-000000000007',
  'Retomando tu camino de fe',
  'Un viaje de 7 dias para quienes se alejaron de la fe y quieren volver. Sin juicio, sin culpa, sin presion. Solo un Dios que te recibe con brazos abiertos. Este plan te acompanara en ese regreso: reflexionaras sobre que te alejo, descubriras que Dios nunca se fue, y encontraras formas simples y sostenibles de reconectar con tu fe, tu comunidad y tu proposito espiritual.',
  'Regresa a la fe sin juicio, a tu propio ritmo',
  7,
  '🚶',
  'Personas que dejaron de practicar su fe y quieren volver',
  false,
  true,
  17
) ON CONFLICT (id) DO NOTHING;

-- Plan 7, Dia 1: Sin juicio, sin culpa
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000007',
  1,
  'Sin juicio, sin culpa',
  ARRAY['Romanos 8:1', 'Juan 3:17', 'Isaias 1:18'],
  'Lo primero que necesitas saber es esto: no hay condenacion para ti. "Ninguna condenacion hay para los que estan en Cristo Jesus." No importa cuanto tiempo te alejaste, que hiciste durante ese tiempo, o por que te fuiste. Dios no te recibe con un reclamo; te recibe con un abrazo.

Jesus dijo: "Porque no envio Dios a su Hijo al mundo para condenar al mundo, sino para que el mundo sea salvo por el." Si Jesus no vino a condenar, ¿por que tu te condenas? La culpa que sientes no viene de Dios; viene de la voz interior que te dice que no mereces volver. Esa voz miente.

Dios dice a traves de Isaias: "Venid luego, dice Jehova, y estemos a cuenta: si vuestros pecados fueren como la grana, como la nieve seran emblanquecidos." El quiere limpiar, no castigar. Quiere restaurar, no recriminar. Hoy es un nuevo comienzo, y El esta mas emocionado de verte que tu de volver.',
  'Siéntate en un lugar tranquilo y dile a Dios: "Aqui estoy. He vuelto." No necesitas decir nada mas. Si sientes culpa, dile: "Acepto que no me condenas." Repitelo hasta que lo creas.',
  '¿Que sentimientos te acompanan al pensar en volver a la fe? ¿Culpa, verguenza, miedo, esperanza, alivio?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 7, Dia 2: ¿Que te alejo?
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000007',
  2,
  '¿Que te alejo?',
  ARRAY['Salmo 139:7-10', 'Mateo 11:28', 'Oseas 2:14'],
  'Hay muchas razones por las que la gente se aleja de la fe. A veces es una experiencia dolorosa con la iglesia o con personas que decian ser cristianos. A veces es la vida misma: te mudaste, cambiaron tus rutinas, y poco a poco la fe se fue quedando atras. A veces son dudas que nadie supo responder. Cualquiera que sea tu razon, es valida.

El salmista escribe: "¿A donde me ire de tu Espiritu? ¿Y a donde huire de tu presencia?" Aunque te alejaste, Dios nunca se alejo de ti. Estuvo contigo en cada momento, incluso en los que no lo buscabas.

Oseas describe como Dios corte a su pueblo errante: "Yo la atraeré y la llevare al desierto, y hablare a su corazon." Dios no te arrastra de vuelta con culpa; te atrae con amor. Este momento, esta lectura, este deseo de volver... es El hablando a tu corazon.',
  'Escribe honestamente que te alejo de la fe. Sin justificarte ni juzgarte. Solo la verdad. Luego dile a Dios: "Esto es lo que paso. Ayudame a entenderlo y a sanar."',
  '¿Que fue lo que te alejo de la fe? ¿Fue un evento especifico, un proceso gradual, o algo que todavia no tienes claro?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 7, Dia 3: El hijo prodigo
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000007',
  3,
  'El hijo prodigo',
  ARRAY['Lucas 15:11-24', 'Salmo 103:12', 'Miqueas 7:18-19'],
  'La parabola del hijo prodigo es tu historia. Un hijo que se fue lejos, gasto todo, toco fondo y decidio volver. Pero lo que mas importa no es la ida del hijo, sino la reaccion del padre: "Cuando aun estaba lejos, lo vio su padre, y fue movido a misericordia, y corrio, y se echo sobre su cuello, y le beso."

El padre no esperó a que el hijo llegara a la puerta. Corrio a encontrarlo. No le dio un sermon; le dio un abrazo. No lo puso en periodo de prueba; le puso un anillo, una tunica y organizo una fiesta. Esa es la respuesta de Dios cuando vuelves.

"Cuanto esta lejos el oriente del occidente, hizo alejar de nosotros nuestras rebeliones." Dios no guarda un expediente de tus errores. Miqueas dice que El "echara en lo profundo del mar todos nuestros pecados." No los guarda para sacartelos en cara. Los elimina. Tu pasado no define tu regreso.',
  'Lee Lucas 15:11-24 completo. Ponte en el lugar del hijo. Luego ponte en el lugar del padre. ¿Que sientes en cada perspectiva? Escribe lo que descubras.',
  '¿Te identificas mas con el hijo que se fue o con el hermano mayor que se quedo? ¿Por que?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 7, Dia 4: Primeros pasos de vuelta
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000007',
  4,
  'Primeros pasos de vuelta',
  ARRAY['Apocalipsis 3:20', 'Santiago 4:8', 'Salmo 37:23-24'],
  'No necesitas dar un salto enorme para volver a Dios. Solo necesitas dar un paso. Jesus dice: "He aqui, yo estoy a la puerta y llamo; si alguno oye mi voz y abre la puerta, entrare a el." El ya esta tocando. Tu solo necesitas abrir.

Santiago promete: "Acercaos a Dios, y el se acercara a vosotros." No dice "cuando esteis listos" o "cuando sean dignos." Dice acércate, y El se acerca. Es asi de simple. No necesitas arreglar tu vida antes de volver; vuelves para que El te ayude a arreglarla.

"Por Jehova son ordenados los pasos del hombre... aunque caiga, no quedara postrado, porque Jehova sostiene su mano." Vas a tropezar en el camino de regreso. Vas a tener dias malos, dudas, momentos en los que sientas que no avanzas. Eso es normal. Lo importante no es no caer; es no quedarte en el suelo.',
  'Hoy, da un paso concreto hacia tu fe: puede ser orar cinco minutos, leer un Salmo, o simplemente decirle a alguien de confianza que estas buscando reconectar con Dios. Un paso. Solo uno.',
  '¿Cual es el paso mas pequeno que puedes dar hoy hacia Dios? ¿Que te detiene de darlo?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 7, Dia 5: Una nueva comunidad
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000007',
  5,
  'Una nueva comunidad',
  ARRAY['Hebreos 10:24-25', 'Eclesiastes 4:9-10', 'Hechos 2:42-47'],
  'La fe no se vive en solitario. "No dejando de congregarnos, como algunos tienen por costumbre, sino exhortandonos." La comunidad es parte esencial del diseno de Dios. Necesitas personas que te acompanen, te animen y te pidan cuentas.

Eclesiastes dice: "Mejor son dos que uno; porque si cayeren, el uno levantara a su companero." Tal vez tu experiencia anterior con la iglesia no fue buena. Tal vez las personas que debieron cuidarte te hirieron. Eso duele, y es valido. Pero una mala experiencia con una comunidad no significa que todas las comunidades sean malas.

La iglesia primitiva descrita en Hechos era imperfecta pero autentica: "Perseveraban en la doctrina de los apostoles, en la comunion unos con otros, en el partimiento del pan y en las oraciones." Busca personas asi. No una iglesia perfecta, sino personas reales que amen a Dios y te acepten como eres.',
  'Piensa en una persona cristiana que te inspire confianza. Contactala hoy y dile que estas retomando tu fe. No necesitas un discurso; solo compartir donde estas. Si no conoces a nadie, busca un grupo o comunidad en linea.',
  '¿Que experiencia has tenido con la comunidad cristiana? ¿Que buscarias en una nueva comunidad de fe?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 7, Dia 6: Habitos de fe simples
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000007',
  6,
  'Habitos de fe simples',
  ARRAY['Mateo 6:6', 'Salmo 1:2-3', 'Marcos 1:35'],
  'No necesitas hacer cosas complicadas para mantener tu fe viva. Los habitos mas simples son los mas sostenibles. Jesus mismo tenia habitos simples: "Levantandose muy de manana, salio y se fue a un lugar desierto, y alli oraba." Se levantaba temprano. Buscaba un lugar. Oraba. Simple.

"En tu ley medito de dia y de noche." El salmista describe a la persona bienaventurada como alguien que medita en la Palabra regularmente. No dice "estudia teologia 8 horas al dia," sino que piensa en las cosas de Dios como parte natural de su rutina.

Jesus dijo: "Tu, cuando ores, entra en tu aposento, y cerrada la puerta, ora a tu Padre que esta en secreto." Un lugar, un momento, una conversacion con Dios. Eso es todo. No necesitas un altar elaborado ni una hora entera. Necesitas constancia. Cinco minutos cada dia son mejores que una hora una vez al mes.',
  'Elige un habito de fe que puedas mantener: 5 minutos de oracion al despertar, un versiculo al dia, o una oracion antes de dormir. Hazlo hoy y comprometete a hacerlo manana tambien.',
  '¿Que habito de fe es mas realista para ti en esta etapa? ¿Que horario y lugar funcionarian mejor?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 7, Dia 7: Tu nuevo comienzo
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000007',
  7,
  'Tu nuevo comienzo',
  ARRAY['2 Corintios 5:17', 'Lamentaciones 3:22-23', 'Filipenses 3:13-14'],
  '"Si alguno esta en Cristo, nueva criatura es; las cosas viejas pasaron; he aqui todas son hechas nuevas." Hoy es el primer dia del resto de tu vida de fe. No cargas el pasado. No te define lo que hiciste ni lo que dejaste de hacer. Eres nuevo.

"Por la misericordia de Jehova no hemos sido consumidos, porque nunca decayeron sus misericordias; nuevas son cada manana." Cada manana es una oportunidad fresca. Ayer pudiste haber fallado; hoy empiezas de nuevo. La gracia de Dios no tiene limite de renovaciones.

Pablo escribio: "Olvidando ciertamente lo que queda atras, y extendiéndome a lo que esta delante, prosigo a la meta." No mires atras. No te castigues por los anos perdidos. Mira hacia adelante. Esta semana has dado pasos valientes: reconociste donde estabas, reflexionaste sobre que te alejo, descubriste que Dios te recibe sin juicio, y empezaste a construir habitos nuevos. No pares. El camino acaba de empezar, y es bueno.',
  'Escribe una oracion personal que sea tu "declaracion de regreso." Algo como: "Dios, hoy decido volver a ti. No soy perfecto, pero soy tuyo." Ponla donde la veas cada dia.',
  '¿Como te sientes al final de esta semana comparado con el inicio? ¿Que has descubierto sobre ti y sobre Dios?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- ============================================================================
-- PLAN 8: Respondiendo tus dudas de fe (feeling_distant / faith_doubts)
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'b1000000-0000-0000-0000-000000000008',
  'Respondiendo tus dudas de fe',
  'Un viaje de 7 dias para explorar tus dudas sin miedo. Dudar no es pecado; los heroes de la fe tambien dudaron. Este plan te acompanara a traves de las preguntas dificiles: el sufrimiento, la ciencia, las contradicciones aparentes. No te daremos respuestas prefabricadas, sino herramientas para pensar, historias de personas que superaron sus dudas, y una perspectiva de la fe que abraza la honestidad intelectual.',
  'Explora tus dudas de fe sin miedo y con honestidad',
  7,
  '❓',
  'Personas con dudas sobre la fe que buscan respuestas honestas',
  false,
  true,
  18
) ON CONFLICT (id) DO NOTHING;

-- Plan 8, Dia 1: Dudar no es pecado
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000008',
  1,
  'Dudar no es pecado',
  ARRAY['Marcos 9:24', 'Salmo 13:1-2', 'Judas 1:22'],
  'Si crees que dudar es pecado, hay algo que debes saber: los mas grandes heroes de la fe dudaron. Abraham pregunto. Moises cuestiono. David grito "¿Hasta cuando, Jehova? ¿Me olvidaras para siempre?" Elias quiso morirse. Y Pedro se hundio despues de caminar sobre el agua.

En Marcos 9:24, un padre desesperado le dice a Jesus las palabras mas honestas de toda la Biblia: "Creo; ayuda mi incredulidad." Y Jesus no lo rechazo. Lo ayudo. La fe y la duda coexisten. Puedes creer y dudar al mismo tiempo, y eso no te descalifica ante Dios.

Judas escribe: "A algunos que dudan, convencedlos." Dios no rechaza a los que dudan; los invita a seguir buscando. La duda puede ser el inicio de una fe mas profunda si la usas como puerta para investigar en lugar de como excusa para huir. Tus preguntas no asustan a Dios.',
  'Escribe tus tres mayores dudas sobre la fe. Se completamente honesto. No las censures. Luego dile a Dios: "Estas son mis dudas. Ayudame a encontrar respuestas."',
  '¿Cual es tu duda mas grande sobre Dios o la fe? ¿Desde cuando la tienes?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 8, Dia 2: Tomas, el apostol
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000008',
  2,
  'Tomas, el apostol',
  ARRAY['Juan 20:24-29', 'Juan 11:16', 'Juan 14:5'],
  'Tomas tiene mala fama. Lo llamamos "el incredulo." Pero la realidad es mas matizada. Este mismo Tomas, cuando Jesus iba camino a una zona peligrosa, dijo a los demas discipulos: "Vamos tambien nosotros, para que muramos con el." Era valiente y leal.

Cuando no creyo que Jesus habia resucitado, dijo: "Si no viere en sus manos la senal de los clavos, y metiere mi dedo en el lugar de los clavos, no creere." ¿Que hizo Jesus? ¿Lo condeno? No. Se le aparecio y le dijo: "Pon aqui tu dedo, y mira mis manos." Jesus respondio a sus dudas. No lo castigo por tener preguntas.

Y Tomas respondio con una de las confesiones de fe mas poderosas de la Biblia: "¡Senor mio, y Dios mio!" Su duda no destruyo su fe; la llevo a una fe mas profunda. Tus dudas, si las llevas ante Dios con honestidad, pueden hacer lo mismo.',
  'Piensa en algo que antes dudabas y ahora crees (puede ser de cualquier area de la vida, no solo fe). ¿Que te convencio? Aplica ese mismo principio a tus dudas de fe: busca, investiga, no te quedes en la superficie.',
  '¿Te identificas con Tomas? ¿Necesitas "ver para creer" o puedes creer sin evidencia completa?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 8, Dia 3: Preguntas dificiles
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000008',
  3,
  'Preguntas dificiles',
  ARRAY['Habacuc 1:2-3', 'Romanos 9:20', 'Job 38:4'],
  'La pregunta mas dificil de la fe es probablemente: "Si Dios es bueno y todopoderoso, ¿por que hay sufrimiento?" Es una pregunta honesta y antigua. Habacuc la hizo: "¿Hasta cuando, oh Jehova, clamare, y no oiras? ¿Hasta cuando dare voces a ti a causa de la violencia, y no salvaras?"

No hay una respuesta facil, y desconfia de quien te la ofrezca. Lo que sabemos es esto: Dios creo un mundo con libre albedrio, y el libre albedrio implica la posibilidad del mal. Dios no causa el sufrimiento, pero lo permite como consecuencia de la libertad humana. Y en medio de el, promete estar presente.

Job, despues de perderlo todo, cuestiono a Dios. Y Dios respondio, no con explicaciones sino con perspectiva: "¿Donde estabas tu cuando yo fundaba la tierra?" A veces la respuesta a nuestras preguntas no es informacion; es confianza. No entendemos todo, pero podemos confiar en quien si entiende.',
  'Elige la pregunta de fe que mas te inquieta. Dedica 15 minutos a investigarla: lee un articulo, un capitulo de libro, o preguntale a alguien que respetes. No busques una respuesta definitiva; busca una perspectiva nueva.',
  '¿Que pregunta sobre el sufrimiento o la injusticia te resulta mas dificil de reconciliar con tu fe?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 8, Dia 4: Fe y ciencia
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000008',
  4,
  'Fe y ciencia',
  ARRAY['Salmo 19:1-2', 'Romanos 1:20', 'Proverbios 25:2'],
  '"Los cielos cuentan la gloria de Dios, y el firmamento anuncia la obra de sus manos." La ciencia y la fe no son enemigas; son dos formas de mirar la misma realidad. La ciencia responde al "como"; la fe responde al "por que" y al "para que."

Pablo escribe: "Porque las cosas invisibles de el, su eterno poder y deidad, se hacen claramente visibles desde la creacion del mundo." La creacion misma apunta a un Creador. Cuanto mas aprendemos sobre la complejidad del universo, mas asombroso es que exista algo en lugar de nada.

Proverbios dice algo fascinante: "Gloria de Dios es encubrir un asunto; pero honra del rey es escudrinarlo." Dios quiere que investiguemos, que preguntemos, que descubramos. La curiosidad cientifica no contradice la fe; la complementa. Muchos de los cientificos mas importantes de la historia fueron personas de fe profunda. No tuvieron que elegir entre razón y fe.',
  'Busca la historia de un cientifico creyente (Galileo, Newton, Lemaitre, Collins). Lee brevemente sobre como reconcilio su fe con su ciencia. ¿Que puedes aprender de su perspectiva?',
  '¿Sientes que la ciencia y la fe estan en conflicto? ¿En que areas especificas? ¿Que necesitarias para reconciliarlas?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 8, Dia 5: Testimonios de fe
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000008',
  5,
  'Testimonios de fe',
  ARRAY['Hebreos 11:1', 'Hebreos 12:1-2', '2 Corintios 4:18'],
  '"Es, pues, la fe la certeza de lo que se espera, la conviccion de lo que no se ve." La fe no es creer sin evidencia; es confiar mas alla de lo que puedes verificar. Como confiar en un amigo aunque no puedas leer su mente, o como un nino salta a los brazos de su padre sin calcular la fisica del asalto.

Hebreos 11 es el "salon de la fama" de la fe. Abraham salio sin saber a donde iba. Moises eligio sufrir con su pueblo en lugar de disfrutar los placeres de Egipto. No eran personas sin dudas; eran personas que eligieron confiar a pesar de sus dudas.

"Teniendo en derredor nuestro tan grande nube de testigos, despojémonos de todo peso y del pecado que nos asedia, y corramos con paciencia la carrera." No estas solo en esto. Millones de personas antes que tu enfrentaron las mismas dudas y encontraron razones para creer. Su testimonio te respalda.',
  'Habla con alguien cuya fe admires. Preguntale: "¿Alguna vez dudaste? ¿Como lo superaste?" Escucha su historia. Si no conoces a alguien asi, busca un testimonio en linea de alguien que supero dudas de fe.',
  '¿Conoces a alguien cuya fe te inspira? ¿Que es lo que admiras de como esa persona vive su fe?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 8, Dia 6: Fe como confianza
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000008',
  6,
  'Fe como confianza',
  ARRAY['Proverbios 3:5-6', 'Salmo 62:8', '2 Timoteo 1:12'],
  '"Fiate de Jehova de todo tu corazon, y no te apoyes en tu propia prudencia." La fe no es entenderlo todo; es confiar en Alguien aunque no entiendas todo. Es como un nino que no entiende por que su padre le dice que no toque el fuego, pero confia en que su padre sabe lo que dice.

"Esperad en el en todo tiempo, oh pueblos; derramad delante de el vuestro corazon." Confiar es derramar tu corazon. Es ser vulnerable. Es decir: "No entiendo, pero confio en ti." Eso no es debilidad intelectual; es madurez relacional.

Pablo escribio: "Yo se a quien he creido, y estoy seguro de que es poderoso para guardar mi deposito." Pablo no dijo "se todo lo que hay que saber." Dijo "se a QUIEN he creido." La fe se basa en la persona de Dios, no en tener todas las respuestas. Puedes no entender el plan, pero puedes confiar en el Planificador.',
  'Hoy, identifica un area de tu vida donde necesitas confiar sin entender. Puede ser una situacion, una relacion, o una pregunta sin respuesta. Dile a Dios: "No entiendo esto, pero elijo confiar en ti."',
  '¿Que te cuesta mas: confiar sin entender, o buscar respuestas y no encontrarlas? ¿Por que?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 8, Dia 7: Avanzar con preguntas
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000008',
  7,
  'Avanzar con preguntas',
  ARRAY['1 Corintios 13:12', 'Deuteronomio 29:29', 'Santiago 1:5'],
  '"Ahora vemos por espejo, oscuramente; mas entonces veremos cara a cara. Ahora conozco en parte; pero entonces conoceré como fui conocido." Pablo admite que en esta vida solo vemos en parte. No tenemos todas las respuestas, y esta bien. La fe madura no es la que no tiene preguntas, sino la que avanza con preguntas.

"Las cosas secretas pertenecen a Jehova nuestro Dios; mas las reveladas son para nosotros." Hay cosas que no sabremos en esta vida. Y hay cosas que si podemos saber. La sabiduria esta en distinguir entre ambas y no dejar que lo que no sabes destruya lo que si sabes.

Santiago ofrece una promesa hermosa: "Si alguno de vosotros tiene falta de sabiduria, pidala a Dios, el cual da a todos abundantemente y sin reproche." Dios no te reprende por preguntar. Te invita a seguir preguntando. Esta semana has explorado tus dudas con honestidad. No todas se resolvieron, y eso esta bien. Una fe que necesita tener todas las respuestas es fragil. Una fe que avanza con preguntas abiertas es fuerte.',
  'Escribe dos columnas: "Lo que creo" y "Lo que todavia no entiendo." Mira ambas listas. ¿Hay suficiente en la primera para sostener lo que esta en la segunda? Comprometete a seguir buscando.',
  '¿Te sientes mas libre para vivir tu fe con preguntas abiertas? ¿Que cambiaria si aceptas que no necesitas todas las respuestas?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- ============================================================================
-- PLAN 9: Sanando heridas del alma (feeling_distant / painful_experience)
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'b1000000-0000-0000-0000-000000000009',
  'Sanando heridas del alma',
  'Un viaje de 7 dias para quienes cargan heridas profundas que los alejaron de Dios. Tal vez fue una experiencia traumatica en la iglesia, una perdida devastadora, o un dolor que hizo que cuestionaras todo. Este plan no te dara respuestas faciles. Te acompanara en tu dolor con honestidad, te mostrara que Dios no minimiza lo que sientes, y te guiara hacia una esperanza que no ignora las cicatrices sino que las transforma.',
  'Encuentra sanacion para el dolor que te alejo de Dios',
  7,
  '💔',
  'Personas con heridas emocionales o espirituales profundas',
  false,
  true,
  19
) ON CONFLICT (id) DO NOTHING;

-- Plan 9, Dia 1: Tu dolor es valido
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000009',
  1,
  'Tu dolor es valido',
  ARRAY['Salmo 34:18', 'Isaias 63:9', 'Mateo 5:4'],
  'Lo primero que necesitas escuchar hoy es esto: tu dolor es real y es valido. No necesitas minimizarlo, justificarlo ni compararlo con el de nadie. Lo que te paso, importa. Y a Dios le importa.

"Cercano esta Jehova a los quebrantados de corazon." Dios no te dice "superalo" ni "todo pasa por algo." Se acerca. Se sienta a tu lado en el dolor. Isaias dice: "En toda angustia de ellos el fue angustiado." Tu dolor no te aleja de Dios; lo acerca a ti.

Jesus dijo: "Bienaventurados los que lloran, porque ellos recibiran consolacion." No dijo "bienaventurados los que no lloran" ni "los que ya superaron su dolor." Bienaventurados los que lloran. Tal como estan. Llorar no es debilidad; es humanidad. Y Dios promete consuelo, no un consejo para que dejes de sentir.',
  'Hoy, permite te sentir tu dolor sin juzgarte. Si necesitas llorar, llora. Si necesitas gritar, grita. Si necesitas escribir, escribe. Dale espacio a lo que sientes y dile a Dios: "Esto es lo que cargo."',
  '¿Que experiencia dolorosa es la que mas pesa en tu corazon? ¿Has podido hablar de ella o la llevas en silencio?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 9, Dia 2: Job y el sufrimiento
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000009',
  2,
  'Job y el sufrimiento',
  ARRAY['Job 3:1-3', 'Job 23:3-4', 'Job 42:5'],
  'Job perdio todo: hijos, salud, posesiones. Y su respuesta fue cruda: "Maldijo su dia... ¿Por que no mori yo en la matriz?" No fingió estar bien. No puso cara de "Dios es bueno todo el tiempo." Dijo lo que sentia, y la Biblia lo incluyo sin censura.

Lo mas interesante de Job es que sus amigos, los que le decian que algo habria hecho mal para merecer ese sufrimiento, fueron reprendidos por Dios al final. Las respuestas faciles al dolor ajeno son ofensivas, no consoladoras. "Seguramente es por algo" es una frase cruel, no biblica.

Al final, Job no recibio una explicacion de por que sufrio. Recibio algo mejor: un encuentro con Dios. "De oidas te habia oido; mas ahora mis ojos te ven." A veces la respuesta al sufrimiento no es informacion; es presencia. No un "por que," sino un "aqui estoy contigo."',
  'Lee Job 38:1-11, la respuesta de Dios a Job. No es la respuesta que esperarias. ¿Que te dice sobre como Dios responde al dolor? Anota tus reflexiones.',
  '¿Alguna vez alguien te dio una respuesta facil a tu sufrimiento que te dolio mas que ayudarte? ¿Que habrias necesitado escuchar en ese momento?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 9, Dia 3: Lamento sagrado
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000009',
  3,
  'Lamento sagrado',
  ARRAY['Salmo 22:1-2', 'Salmo 88:1-3', 'Lamentaciones 3:1-3'],
  'La Biblia tiene un genero literario que la cultura moderna ha perdido: el lamento. No es queja; es dolor expresado ante Dios. Los Salmos estan llenos de lamentos. "Dios mio, Dios mio, ¿por que me has desamparado?" Estas palabras no las dijo un ateo; las dijo David, el hombre conforme al corazon de Dios. Y Jesus mismo las cito en la cruz.

El Salmo 88 es el salmo mas oscuro de la Biblia. No tiene final feliz. Termina en oscuridad. Y aun asi, esta en las Escrituras. Dios incluyo un salmo sin resolucion porque a veces la vida no tiene resolucion inmediata. A veces estas en la oscuridad y no ves la salida. Y eso es parte de la experiencia humana.

El lamento es oracion. Gritar a Dios es orar. Cuestionar a Dios es orar. Llorar ante Dios es orar. El lamento dice: "Dios, me duele, y confio en ti lo suficiente como para decirtelo sin filtro."',
  'Escribe tu propio salmo de lamento. Empieza con "Dios, me duele..." y sigue escribiendo lo que sientes. No lo censures, no lo hagas bonito. Solo dejalo salir. Eso es oracion.',
  '¿Te sientes comodo expresando dolor ante Dios, o sientes que debes estar "bien" delante de El?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 9, Dia 4: El Dios que llora contigo
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000009',
  4,
  'El Dios que llora contigo',
  ARRAY['Juan 11:33-35', 'Isaias 53:3', 'Hebreos 4:15'],
  'El versiculo mas corto de la Biblia es tambien uno de los mas profundos: "Jesus lloro." Estaba frente a la tumba de su amigo Lazaro, y aunque sabia que iba a resucitarlo, lloro. ¿Por que? Porque el dolor de las personas que amaba le dolia a El tambien.

Isaias describe a Jesus como "varon de dolores, experimentado en quebranto." El Dios que adoramos no observa tu dolor desde lejos con indiferencia divina. Lo siente. Hebreos dice que tenemos "un sumo sacerdote que puede compadecerse de nuestras debilidades, pues fue tentado en todo segun nuestra semejanza."

Esto cambia todo. No oras a un Dios que no entiende. Oras a un Dios que ha llorado, que ha sufrido, que ha sido traicionado, abandonado y torturado. Y que eligio pasar por todo eso para estar contigo en tu dolor. No te pide que entiendas; te pide que le dejes acompanarte.',
  'Cierra los ojos e imagina a Jesus sentado frente a ti. No dice nada. Solo te mira con compasion. Si pudieras decirle una sola cosa sobre tu dolor, ¿que seria? Dilo en voz alta.',
  '¿Sientes que Dios entiende tu dolor o sientes que esta lejos? ¿Que necesitarias para sentir su presencia?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 9, Dia 5: Soltar el por que
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000009',
  5,
  'Soltar el por que',
  ARRAY['Isaias 55:8-9', 'Deuteronomio 29:29', 'Romanos 11:33'],
  '"Porque mis pensamientos no son vuestros pensamientos, ni vuestros caminos mis caminos, dijo Jehova." Hay un momento en el proceso de sanacion donde necesitas soltar la necesidad de entender el "por que." No porque la pregunta sea mala, sino porque la respuesta tal vez no existe en terminos humanos.

Pablo exclama: "¡Oh profundidad de las riquezas de la sabiduria y de la ciencia de Dios! ¡Cuan insondables son sus juicios, e inescrutables sus caminos!" Hay cosas que no entenderemos en esta vida. Y la paz no viene de encontrar la explicacion, sino de confiar en el Explicador.

Soltar el "por que" no es resignacion. Es elegir dejar de buscar una respuesta que tal vez no tiene y empezar a buscar consuelo, sanacion y un camino hacia adelante. No significa que lo que paso estuvo bien. Significa que no vas a dejar que el "por que" te mantenga atrapado para siempre.',
  'Si llevas tiempo preguntandote "¿por que me paso esto?", hoy intenta cambiar la pregunta: "¿Que puedo hacer con este dolor? ¿Como puedo crecer a traves de el?" Escribe lo que surja.',
  '¿Puedes vivir sin saber el "por que" de tu dolor? ¿Que necesitarias para encontrar paz sin esa respuesta?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 9, Dia 6: Cicatrices que cuentan historias
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000009',
  6,
  'Cicatrices que cuentan historias',
  ARRAY['2 Corintios 1:3-4', 'Romanos 8:28', 'Juan 20:27'],
  'Despues de resucitar, Jesus todavia tenia sus cicatrices. Las heridas sanaron, pero las marcas quedaron. E invito a Tomas a tocarlas. Las cicatrices de Jesus no son senal de derrota; son testimonio de victoria. Demuestran que paso por el dolor y lo supero.

Pablo escribe: "El Dios de toda consolacion, el cual nos consuela en todas nuestras tribulaciones, para que podamos tambien nosotros consolar a los que estan en cualquier tribulacion." Tu dolor, una vez sanado, se convierte en tu capacidad unica para consolar a otros. Nadie puede entender a alguien que sufre como alguien que ha sufrido lo mismo.

"Todas las cosas cooperan para bien." Esto no significa que lo malo fue bueno. Significa que Dios puede tomar incluso lo peor y producir algo redentor. Tus cicatrices no te definen, pero si cuentan una historia. Y esa historia puede ser el puente que alguien mas necesita para cruzar su propio valle.',
  'Piensa en alguien que este pasando por algo similar a lo que tu viviste. Si puedes, acercate y dile: "Se lo que se siente. Estoy aqui." Tu experiencia de dolor puede ser el regalo mas grande para esa persona.',
  '¿Puedes ver como tu dolor podria ayudar a otros algun dia? ¿O todavia se siente demasiado fresco para eso?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 9, Dia 7: Esperanza despues del dolor
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000009',
  7,
  'Esperanza despues del dolor',
  ARRAY['Salmo 30:5', 'Apocalipsis 21:4', 'Isaias 61:1-3'],
  '"Por la noche durara el lloro, y a la manana vendra la alegria." No dice "puede que venga" ni "si tienes suerte." Dice "vendra." El amanecer siempre llega despues de la noche mas oscura. Siempre. Es una ley espiritual tan segura como una ley fisica.

Isaias profetizo sobre Jesus: "Me ha enviado a sanar a los quebrantados de corazon... a ordenar que a los afligidos se les de gloria en lugar de ceniza, oleo de gozo en lugar de luto." Dios no te deja en cenizas; te da gloria. No te deja en luto; te da gozo. No cuando tu decides; cuando El sabe que es tiempo.

Apocalipsis promete el final de la historia: "Enjugara Dios toda lagrima de los ojos de ellos; y ya no habra muerte, ni habra mas llanto, ni clamor, ni dolor." Tu dolor tiene fecha de vencimiento. Esta semana has caminado por lugares oscuros de tu corazon. Has llorado, cuestionado, lamentado. Y sigues aqui. Eso no es debilidad; es fortaleza. El amanecer esta mas cerca de lo que piensas.',
  'Escribe una declaracion de esperanza personal: "A pesar de lo que vivi, creo que..." Completala con lo que genuinamente crees. No tiene que ser grande. Solo tiene que ser tuyo. Guárdala y leela cada manana.',
  '¿Como te sientes al final de esta semana comparado con el principio? ¿Que cambiaria en tu vida si de verdad creyeras que el amanecer viene?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- ============================================================================
-- PLAN 10: La Biblia en tu vida diaria (understand_bible / apply_teachings)
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'b1000000-0000-0000-0000-000000000010',
  'La Biblia en tu vida diaria',
  'Un viaje de 7 dias para descubrir que la Biblia no es un libro antiguo e irrelevante, sino una guia practica para tu vida hoy. Aprenderas a aplicar principios eternos a tus relaciones, decisiones, emociones y trabajo. Cada dia conecta una ensenanza biblica con un aspecto concreto de tu rutina, ayudandote a ver que la Palabra de Dios tiene algo que decir sobre todo lo que enfrentas.',
  'Aprende a aplicar la Biblia a tu vida real de cada dia',
  7,
  '📚',
  'Personas que quieren hacer practica la lectura biblica',
  false,
  true,
  20
) ON CONFLICT (id) DO NOTHING;

-- Plan 10, Dia 1: Mas que un libro antiguo
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000010',
  1,
  'Mas que un libro antiguo',
  ARRAY['Hebreos 4:12', 'Isaias 40:8', '2 Timoteo 3:16-17'],
  'Muchos ven la Biblia como un libro antiguo, lleno de historias lejanas que no tienen nada que ver con su vida de hoy. Si alguna vez has pensado eso, te entiendo. Pero hay algo que quiero que consideres: ningun otro libro de la historia ha transformado mas vidas, culturas y civilizaciones que este.

"La palabra de Dios es viva y eficaz, y mas cortante que toda espada de dos filos." Viva. No fue viva hace 2,000 anos y ahora esta muerta. Es viva AHORA. Tiene la capacidad de hablarte hoy con la misma fuerza con la que le hablo a David, a Pablo o a Maria.

"La hierba se seca, y la flor se marchita, pero la palabra del Senor permanece para siempre." Las tendencias cambian, las filosofias van y vienen, pero los principios de la Biblia han sobrevivido siglos porque tocan algo universal en la experiencia humana. Hoy vas a empezar a descubrirlo por ti mismo.',
  'Abre la Biblia en Proverbios y lee los primeros 10 versiculos del capitulo que corresponda al dia de hoy (si es dia 15, lee Proverbios 15:1-10). Anota un proverbio que puedas aplicar hoy.',
  '¿Que te viene a la mente cuando piensas en la Biblia? ¿Algo aburrido, algo confuso, algo inspirador, o algo que aun no has explorado?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 10, Dia 2: Principios eternos
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000010',
  2,
  'Principios eternos',
  ARRAY['Mateo 7:12', 'Galatas 6:7', 'Proverbios 3:5-6'],
  'La Biblia contiene principios que funcionan independientemente de si crees en ellos o no, como la gravedad. "Todas las cosas que querais que los hombres hagan con vosotros, asi tambien haced vosotros con ellos." La regla de oro funciona en cualquier cultura, epoca o situacion. Trata a otros como quieres ser tratado, y tu vida mejora.

"Todo lo que el hombre sembrare, eso tambien segara." Este no es un concepto exclusivamente cristiano; es una ley de la vida. Lo que inviertes en tus relaciones, tu trabajo, tu salud y tu fe, lo cosechas. No hay atajos.

"Fiate de Jehova de todo tu corazon, y no te apoyes en tu propia prudencia." En una cultura que glorifica la autosuficiencia, este principio es radical: no lo tienes que resolver todo solo. Hay una sabiduria mas grande que la tuya disponible. La Biblia no te da reglas arbitrarias; te da principios que funcionan porque vienen de quien diseno la vida.',
  'Elige uno de los tres principios de hoy (regla de oro, siembra y cosecha, o confianza en Dios). Aplícalo conscientemente durante todo el dia. Al final, evalua: ¿funciono?',
  '¿Que principio biblico ya aplicas en tu vida sin darte cuenta? ¿Hay alguno que te gustaria empezar a aplicar?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 10, Dia 3: Relaciones biblicas
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000010',
  3,
  'Relaciones biblicas',
  ARRAY['1 Corintios 13:4-7', 'Efesios 4:2-3', 'Colosenses 3:12-14'],
  'La Biblia tiene mucho que decir sobre las relaciones, y no solo las romanticas. Pablo describe el amor de una forma que es un espejo implacable: "El amor es sufrido, es benigno; el amor no tiene envidia, el amor no es jactancioso, no se envanece." Lee esas palabras pensando en como tratas a las personas mas cercanas a ti. ¿Cuantas puedes tachar como "esa si la cumplo"?

"Con toda humildad y mansedumbre, soportandoos con paciencia los unos a los otros en amor." Las relaciones saludables requieren humildad (no creerme mas importante), mansedumbre (no reaccionar con fuerza bruta) y paciencia (dar tiempo y espacio). Esto aplica a tu pareja, tus padres, tus hijos, tus amigos y tus companeros de trabajo.

"Sobre todas estas cosas vestios de amor, que es el vinculo perfecto." El amor es lo que mantiene todo unido. Sin amor, la paciencia se agota, la humildad se finge y la mansedumbre se rompe. Con amor, todo lo demas fluye.',
  'Piensa en la relacion que mas te cuesta. Lee 1 Corintios 13:4-7 reemplazando "el amor" por tu nombre. Por ejemplo: "[Tu nombre] es sufrido, es benigno..." ¿Que descubres?',
  '¿En que relacion de tu vida te cuesta mas aplicar el amor biblico? ¿Que aspecto especifico necesitas trabajar?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 10, Dia 4: Decisiones con sabiduria
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000010',
  4,
  'Decisiones con sabiduria',
  ARRAY['Santiago 1:5', 'Proverbios 16:3', 'Salmo 32:8'],
  'Cada dia tomas decenas de decisiones: algunas pequenas, otras que cambian tu vida. ¿Como decides? ¿Por impulso, por logica, por presion social, o por principios? La Biblia ofrece un recurso invaluable: sabiduria.

Santiago promete: "Si alguno de vosotros tiene falta de sabiduria, pidala a Dios, el cual da a todos abundantemente y sin reproche." Dios no se burla de ti por no saber que hacer; te ofrece su sabiduria generosamente. Solo tienes que pedirla.

"Encomienda a Jehova tus obras, y tus pensamientos seran afirmados." Esto no significa que Dios tomara las decisiones por ti. Significa que cuando le presentas tus planes, El clarifica tu pensamiento. El Salmo 32 dice: "Te hare entender, y te ensenaré el camino en que debes andar." Dios no te deja en la oscuridad. Ilumina el paso siguiente. A veces no ves el camino entero, pero siempre puedes ver el proximo paso.',
  'Si tienes una decision pendiente (grande o pequena), aplica estos tres pasos hoy: 1) Pidele sabiduria a Dios. 2) Busca un principio biblico relevante. 3) Consulta con alguien de confianza. Luego decide.',
  '¿Que decision tienes pendiente en este momento? ¿Has considerado lo que la Biblia dice al respecto?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 10, Dia 5: Emociones y la Biblia
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000010',
  5,
  'Emociones y la Biblia',
  ARRAY['Salmo 42:5', 'Filipenses 4:6-7', 'Salmo 139:23-24'],
  'Los Salmos son el libro mas emocional de la Biblia. David pasa de la euforia a la depresion, del gozo al terror, de la alabanza al lamento, a veces en el mismo salmo. "¿Por que te abates, oh alma mia, y por que te turbas dentro de mi? Espera en Dios." David hablaba con sus propias emociones. Las reconocia, las nombraba y luego las redirigía hacia Dios.

La Biblia nunca dice que las emociones son malas. Jesus sintio tristeza, ira, compasion, angustia. Lo que la Biblia ensena es que las emociones no deben gobernarte. Son indicadores, no directores. Te dicen algo, pero no deben tomar las decisiones por ti.

"Por nada esteis afanosos... y la paz de Dios, que sobrepasa todo entendimiento, guardara vuestros corazones." La alternativa a la ansiedad no es no sentir; es llevar lo que sientes ante Dios. Y la promesa es paz. No paz que entiendas, sino paz que te sobrepasa.',
  'Identifica la emocion dominante que sientes hoy (ansiedad, tristeza, frustracion, alegria). Busca un Salmo que exprese esa misma emocion. Leelo como si fuera tu propia oracion.',
  '¿Como manejas tus emociones dificiles? ¿Las reprimes, las explotas, o les das un espacio saludable?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 10, Dia 6: Fe en el trabajo
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000010',
  6,
  'Fe en el trabajo',
  ARRAY['Colosenses 3:23-24', 'Proverbios 10:4', 'Eclesiastes 9:10'],
  '"Todo lo que hagais, hacedlo de corazon, como para el Senor." Si pasas 8 horas al dia trabajando, eso es un tercio de tu vida. ¿Puede un tercio de tu vida ser espiritual, o solo lo es la hora que dedicas a la oracion? La Biblia dice que TODO tu tiempo puede ser ofrenda a Dios, incluido tu trabajo.

"La mano negligente empobrece; mas la mano de los diligentes enriquece." Proverbios no condena la ambicion ni la prosperidad. Lo que condena es la pereza y la deshonestidad. Trabajar con excelencia, ser integro en los negocios, tratar bien a los colegas: eso es fe practica.

"Todo lo que te viniere a la mano para hacer, hazlo segun tus fuerzas." No a medias, no "lo suficiente para que no me despidan," sino con todo tu corazon. Cuando tu trabajo refleja tus valores, tu fe deja de ser algo que haces los domingos y se convierte en algo que vives todos los dias.',
  'Mañana en tu trabajo o responsabilidades, antes de empezar cada tarea, di mentalmente: "Esto lo hago para Dios." Al final del dia, evalua: ¿cambio tu actitud?',
  '¿Ves tu trabajo como algo separado de tu fe o como parte de ella? ¿Como cambiaria tu dia si integraras ambos?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 10, Dia 7: Una brujula para la vida
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000010',
  7,
  'Una brujula para la vida',
  ARRAY['Salmo 119:105', 'Josue 1:8', 'Mateo 7:24-25'],
  '"Lampara es a mis pies tu palabra, y lumbrera a mi camino." La Biblia no es un mapa que muestra todo el camino de una vez. Es una lampara que ilumina el proximo paso. No necesitas ver todo el futuro; necesitas ver lo suficiente para el paso siguiente.

Dios le dijo a Josue: "Nunca se apartara de tu boca este libro de la ley, sino que de dia y de noche meditaras en el." No "leelo una vez al ano," sino meditalo constantemente. La Palabra de Dios funciona mejor cuando la llevas siempre contigo: en tus pensamientos, en tus decisiones, en tus conversaciones.

Esta semana has visto la Biblia aplicada a tu vida real: principios eternos, relaciones, decisiones, emociones y trabajo. Jesus dijo que quien escucha estas palabras y las pone en practica es como quien construye su casa sobre roca. Las tormentas vienen igual, pero la casa se mantiene. La diferencia no es la tormenta; es el fundamento. Tu fundamento es la Palabra.',
  'Elige un versiculo de esta semana que te haya impactado especialmente. Escríbelo en tu telefono como fondo de pantalla o en un papel que lleves contigo. Cada vez que lo veas, recuerda aplicarlo.',
  '¿Que aprendiste esta semana sobre aplicar la Biblia a tu vida? ¿Que area de tu vida necesita mas de la Palabra de Dios?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- ============================================================================
-- PLAN 11: Viajando por la historia biblica (understand_bible / historical_context)
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'b1000000-0000-0000-0000-000000000011',
  'Viajando por la historia biblica',
  'Un viaje de 7 dias por el contexto historico de la Biblia. Desde la creacion hasta la iglesia primitiva, exploraras las epocas, culturas y eventos que dieron forma a las Escrituras. Entender el mundo de la Biblia te ayudara a leerla con ojos nuevos, a comprender pasajes que antes te confundian, y a apreciar la profundidad de un libro que cruza milenios manteniendo un mensaje coherente.',
  'Entiende el contexto historico que dio vida a la Biblia',
  7,
  '🗺️',
  'Personas curiosas sobre el trasfondo historico de las Escrituras',
  false,
  true,
  21
) ON CONFLICT (id) DO NOTHING;

-- Plan 11, Dia 1: El mundo de la Biblia
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000011',
  1,
  'El mundo de la Biblia',
  ARRAY['Galatas 4:4', 'Hechos 17:26', 'Hebreos 1:1-2'],
  'La Biblia no cayo del cielo como un libro terminado. Fue escrita por personas reales, en lugares reales, durante eventos reales. Moises escribio en el desierto del Sinai. David escribio como rey de Israel. Pablo escribio desde carceles romanas. Cada autor vivia en un mundo especifico que influyo en como escribio.

Pablo dice que Dios envio a Jesus "cuando vino el cumplimiento del tiempo." No fue casualidad que Jesus naciera cuando lo hizo: el Imperio Romano habia construido caminos que conectaban todo el mundo conocido, el griego era idioma universal, y habia una pax romana que permitia viajar libremente. Dios preparo el escenario durante siglos.

"Dios, habiendo hablado muchas veces y de muchas maneras en otro tiempo a los padres por los profetas, en estos postreros dias nos ha hablado por el Hijo." La Biblia es un dialogo continuo entre Dios y la humanidad. Conocer el contexto de ese dialogo lo hace mas rico, mas profundo y mas comprensible.',
  'Busca un mapa del mundo biblico (hay muchos gratuitos en internet). Ubica Israel, Egipto, Babilonia, Roma y Grecia. Imagina las distancias que recorrian los personajes biblicos a pie. Eso te dara perspectiva.',
  '¿Cuanto sabes sobre el contexto historico de la Biblia? ¿Que te gustaria entender mejor sobre las epocas y culturas biblicas?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 11, Dia 2: De Adan a Abraham
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000011',
  2,
  'De Adan a Abraham',
  ARRAY['Genesis 12:1-3', 'Genesis 3:15', 'Hebreos 11:8-10'],
  'La Biblia abre con una declaracion cosmica: Dios crea todo. Luego, la humanidad cae. El pecado entra al mundo y las consecuencias se multiplican: Cain mata a Abel, el mundo se corrompe, Dios envia el diluvio, la torre de Babel dispersa a las naciones. Los primeros 11 capitulos de Genesis son el prologo de la historia.

Pero en Genesis 12, todo cambia. Dios elige a un hombre, Abraham, y le hace una promesa: "Hare de ti una nacion grande, y te bendecire... y seran benditas en ti todas las familias de la tierra." De una persona, Dios va a bendecir al mundo entero. Toda la historia biblica fluye desde esta promesa.

Abraham no era especial por sus meritos. Era un hombre comun de Ur de los Caldeos (actual Irak). Pero "creyo Abraham a Dios, y le fue contado por justicia." La fe no empezo con la iglesia ni con Jesus; empezo con un hombre que confio en una promesa que no podia ver cumplida en su vida.',
  'Lee Genesis 12:1-9. Abraham lo dejo todo para ir a un lugar que no conocia. ¿Que te pide Dios que dejes para seguirlo? No tiene que ser fisico; puede ser una actitud, un miedo o una comodidad.',
  '¿Que te impresiona mas de Abraham: su fe para dejar todo, o su humanidad para cometer errores a lo largo del camino?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 11, Dia 3: El pueblo de Israel
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000011',
  3,
  'El pueblo de Israel',
  ARRAY['Exodo 3:7-8', '1 Samuel 8:6-7', 'Isaias 1:18'],
  'De Abraham nacio Isaac, de Isaac Jacob, y de Jacob las doce tribus de Israel. El pueblo termino esclavizado en Egipto durante 400 anos. Pero Dios dijo: "Bien he visto la afliccion de mi pueblo que esta en Egipto, y he oido su clamor... y he descendido para librarlos." El Exodo es la historia central del Antiguo Testamento: Dios liberando a su pueblo.

Despues vino la ley en el Sinai, la conquista de Canaan, los jueces, y finalmente los reyes. Israel pidio un rey humano, y Dios se lo dio, aunque advirtio que un rey humano les fallaria. Saul, David, Salomon... cada uno con grandezas y miserias. El reino se dividio, vino el exilio a Babilonia, y los profetas gritaron arrepentimiento.

La historia de Israel es un patron que se repite: Dios rescata, el pueblo se aleja, Dios llama, el pueblo regresa, Dios rescata de nuevo. ¿Te suena familiar? Es tu propia historia tambien. Dios no se cansa de buscarte, sin importar cuantas veces te alejes.',
  'Lee Exodo 14:13-14, el cruce del Mar Rojo. Moises le dice al pueblo: "Jehova peleara por vosotros." ¿Hay una "esclavitud" en tu vida de la que Dios quiere liberarte? Nombrala.',
  '¿Con que periodo de la historia de Israel te identificas mas: la esclavitud, la liberacion, el tiempo en el desierto, o el exilio?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 11, Dia 4: Entre los Testamentos
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000011',
  4,
  'Entre los Testamentos',
  ARRAY['Daniel 2:44', 'Miqueas 5:2', 'Malaquias 3:1'],
  'Entre Malaquias (el ultimo libro del Antiguo Testamento) y Mateo (el primero del Nuevo) hay unos 400 anos de silencio biblico. Pero no de silencio historico. En esos 400 anos, el mundo cambio drasticamente, preparando el escenario para Jesus.

Alejandro Magno conquisto el mundo y difundio la cultura griega. Por eso el Nuevo Testamento se escribio en griego: era el idioma universal. Los Macabeos lucharon por la independencia judia y purificaron el templo (la fiesta de Januca). Roma conquisto todo y construyo caminos, leyes y paz que facilitaron la expansion del cristianismo.

Daniel habia profetizado siglos antes: "En los dias de estos reyes el Dios del cielo levantara un reino que no sera jamas destruido." Miqueas predijo que el Mesias naceria en Belen. Malaquias anuncio un mensajero que prepararia el camino. Todo estaba listo. 400 anos de silencio no fueron desperdicio; fueron preparacion.',
  'Piensa en un periodo de "silencio" en tu vida: un tiempo donde sentiste que Dios no hablaba. ¿Es posible que estuviera preparando algo que no podias ver? Reflexiona y escribe lo que descubras.',
  '¿Has vivido un periodo de "silencio de Dios"? ¿Que aprendiste de ese tiempo al mirarlo en retrospectiva?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 11, Dia 5: El mundo de Jesus
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000011',
  5,
  'El mundo de Jesus',
  ARRAY['Lucas 2:1-7', 'Juan 1:46', 'Marcos 1:14-15'],
  'Jesus nacio en un rincon insignificante del Imperio Romano. Belen era un pueblo pequeno. Nazaret era aun peor: "¿De Nazaret puede salir algo de bueno?" pregunto Natanael. Palestina era una provincia ocupada, los judios vivian bajo opresion romana, y habia tension religiosa y politica constante.

Jesus nacio pobre. Trabajo como carpintero. No fue a las escuelas teologicas de Jerusalen. No tenia conexiones politicas. Y desde esa posicion, cambio la historia del mundo. Su mensaje era simple: "El tiempo se ha cumplido, y el reino de Dios se ha acercado; arrepentios, y creed en el evangelio."

Conocer el contexto de Jesus te ayuda a entender sus ensenanzas. Cuando hablaba de semillas y cosechas, sus oyentes eran agricultores. Cuando confrontaba a los fariseos, desafiaba un sistema religioso corrupto que oprimia al pueblo. Cuando tocaba a leprosos, rompia barreras sociales de pureza que marginaban a los enfermos. Cada acto de Jesus era revolucionario en su contexto.',
  'Lee Marcos 2:13-17, donde Jesus come con "pecadores." En el contexto de la epoca, esto era escandaloso. ¿Con quien comerias tu que la sociedad desaprobaria? Reflexiona sobre el ejemplo de Jesus.',
  '¿Que aspecto de la vida de Jesus te sorprende mas cuando lo pones en su contexto historico?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 11, Dia 6: La iglesia primitiva
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000011',
  6,
  'La iglesia primitiva',
  ARRAY['Hechos 2:42-47', 'Hechos 8:4', 'Hechos 17:6'],
  'Despues de la resurreccion y la ascension de Jesus, 120 personas se reunieron en un cuarto en Jerusalen. Vino el Espiritu Santo y nacio la iglesia. En un solo dia, 3,000 personas creyeron. Y desde ahi, el movimiento se expandio como fuego.

"Perseveraban en la doctrina de los apostoles, en la comunion unos con otros, en el partimiento del pan y en las oraciones." La iglesia primitiva no tenia edificios, presupuestos, ni organizacion formal. Tenia comunidad, ensenanza, oracion y mision. Compartian sus posesiones, cuidaban de los necesitados y se reunian en casas.

Cuando los opositores describieron a los primeros cristianos, dijeron: "Estos que trastornan el mundo entero tambien han venido aca." Un punado de pescadores, recaudadores de impuestos y gente comun trastornaron el mundo. No por poder militar o politico, sino por el poder del mensaje y la autenticidad de sus vidas. ¿Que pasaria si la iglesia de hoy viviera con esa misma intensidad?',
  'Lee Hechos 2:42-47 y compara esa descripcion de la iglesia con tu experiencia actual de comunidad cristiana. ¿Que se parece? ¿Que falta? ¿Que puedes hacer para acercarte a ese modelo?',
  '¿Que te inspira de la iglesia primitiva? ¿Que aspecto te gustaria ver en tu propia experiencia de comunidad?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 11, Dia 7: De entonces a hoy
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000011',
  7,
  'De entonces a hoy',
  ARRAY['Mateo 28:19-20', '2 Corintios 3:18', 'Salmo 78:1-4'],
  'La Biblia abarca miles de anos de historia, pero su mensaje cruza el tiempo: Dios ama a la humanidad, la humanidad se aleja, Dios la busca, y quien confía en El es transformado. Esa historia no termino con el ultimo capitulo de Apocalipsis; sigue escribiendose. En ti.

Jesus dijo: "Id, y haced discipulos a todas las naciones." El mensaje que empezo en un rincon de Medio Oriente ha llegado a todos los continentes, a todos los idiomas, a todas las culturas. Y sigue llegando. Hoy, a traves de tu telefono, ese mismo mensaje milenario te alcanza.

El Salmo 78 dice: "Las contaremos a la generacion venidera." Conocer la historia biblica no es un ejercicio academico; es entender de donde vienes para saber a donde vas. La Biblia es tu herencia espiritual. Cuanto mejor la conozcas, mas rica sera tu fe. Esta semana has viajado desde la creacion hasta la iglesia primitiva. Ahora, el siguiente capitulo de esta historia eres tu.',
  'Comparte algo que aprendiste esta semana sobre la historia biblica con alguien. Puede ser un familiar, un amigo o incluso una publicacion en redes. Al ensenarlo, lo fijaras en tu memoria.',
  '¿Como cambia tu lectura de la Biblia ahora que conoces mejor su contexto historico? ¿Que pasaje quieres releer con estos nuevos ojos?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- ============================================================================
-- PLAN 12: Entendiendo las tradiciones cristianas (understand_bible / denomination_differences)
-- ============================================================================
INSERT INTO plans (id, name, description, short_description, days_total, icon, target_audience, is_premium, is_active, sort_order)
VALUES (
  'b1000000-0000-0000-0000-000000000012',
  'Entendiendo las tradiciones cristianas',
  'Un viaje de 7 dias para entender por que hay tantas iglesias cristianas diferentes y que las une. Sin favorecer ninguna denominacion, exploraras la historia de las divisiones, los puntos en comun que comparten todos los cristianos, y como cada tradicion aporta algo valioso a la fe. El objetivo no es que cambies de iglesia, sino que ames la tuya con mas fundamento y respetes las otras con mas comprension.',
  'Entiende las diferentes tradiciones cristianas con respeto',
  7,
  '⛪',
  'Personas curiosas sobre las diferencias entre iglesias cristianas',
  false,
  true,
  22
) ON CONFLICT (id) DO NOTHING;

-- Plan 12, Dia 1: Una fe, muchas expresiones
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000012',
  1,
  'Una fe, muchas expresiones',
  ARRAY['1 Corintios 12:12-14', 'Juan 17:20-21', 'Efesios 4:4-6'],
  '¿Por que hay tantas iglesias diferentes si todos creen en el mismo Dios? Es una pregunta valida que merece una respuesta honesta. La respuesta corta: porque los humanos somos diversos, y nuestra forma de expresar la fe tambien lo es.

Pablo usa la metafora del cuerpo: "Porque asi como el cuerpo es uno, y tiene muchos miembros... asi tambien Cristo." Un cuerpo necesita ojos, manos, pies y oidos. Todos diferentes, todos necesarios. De la misma forma, las diferentes tradiciones cristianas aportan riqueza a la fe comun.

Jesus oro por la unidad: "Que todos sean uno; como tu, oh Padre, en mi, y yo en ti." La unidad que Jesus pide no es uniformidad. No pide que todos hagan lo mismo, sino que se amen. Pablo anade: "Un Senor, una fe, un bautismo, un Dios y Padre de todos." Lo que nos une es mucho mas grande que lo que nos separa. Este plan te ayudara a verlo.',
  'Si perteneces a una tradicion cristiana, escribe tres cosas que valoras de ella. Luego piensa en una tradicion diferente y escribe algo que admires o que te genere curiosidad.',
  '¿Que sabes sobre las tradiciones cristianas diferentes a la tuya? ¿Que te gustaria entender mejor?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 12, Dia 2: Catolicos y protestantes
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000012',
  2,
  'Catolicos y protestantes',
  ARRAY['Romanos 3:23-24', 'Santiago 2:17', 'Efesios 2:8-9'],
  'En 1517, Martin Lutero clavo 95 tesis en una puerta de iglesia en Alemania. No queria dividir la iglesia; queria reformarla. Pero las diferencias eran profundas, y la Reforma Protestante cambio el cristianismo para siempre.

Las diferencias principales giran en torno a preguntas fundamentales. ¿Como se es salvo? Los protestantes enfatizan "por gracia, por medio de la fe" (Efesios 2:8-9). Los catolicos enfatizan que "la fe, si no tiene obras, es muerta" (Santiago 2:17). ¿La Biblia sola o la Biblia mas la tradicion? ¿Quien tiene autoridad: el Papa, los concilios, o la Escritura? ¿Que papel juegan los santos y Maria?

Pero los puntos en comun son enormes: Dios es Creador, Jesus es Salvador, el Espiritu Santo es real, la Biblia es Palabra de Dios, el amor al projimo es mandamiento central. Romanos dice: "Todos pecaron, y estan destituidos de la gloria de Dios, siendo justificados gratuitamente por su gracia." Catolicos y protestantes confiesan esto juntos.',
  'Si eres catolico, lee un articulo breve sobre lo que valoran los protestantes. Si eres protestante, haz lo mismo con el catolicismo. Busca entender, no criticar. Anota algo que te sorprenda positivamente.',
  '¿Que crees que es lo mas importante que catolicos y protestantes comparten? ¿Y la diferencia que mas te cuesta entender?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 12, Dia 3: Evangelicos y pentecostales
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000012',
  3,
  'Evangelicos y pentecostales',
  ARRAY['Hechos 2:1-4', 'Romanos 10:9', '1 Corintios 12:4-7'],
  'Dentro del protestantismo hay una enorme diversidad. Los evangelicos enfatizan la conversion personal: "Si confesares con tu boca que Jesus es el Senor, y creyeres en tu corazon que Dios le levanto de los muertos, seras salvo." La relacion individual con Cristo es central.

Los pentecostales anaden el enfasis en el Espiritu Santo y los dones espirituales. Hechos 2 narra como el Espiritu vino con poder, y los pentecostales creen que esa experiencia sigue disponible hoy: hablar en lenguas, sanaciones, profecia. Pablo afirma: "Hay diversidad de dones, pero el Espiritu es el mismo."

En America Latina, el crecimiento evangelico y pentecostal ha sido explosivo. Millones de hispanos han encontrado en estas iglesias una fe vibrante, comunidad solida y esperanza tangible. Si vienes de esta tradicion, valora su energia y pasion. Si no, reconoce que el Espiritu de Dios sopla donde quiere, y a veces sopla con mas fuerza de la que esperamos.',
  'Si tu tradicion es mas formal, visita un culto evangelico o pentecostal en linea y observa con mente abierta. Si la tuya es mas expresiva, haz lo mismo con una liturgia catolica u ortodoxa. Busca a Dios en una expresion diferente.',
  '¿Que valoras de tu forma de adorar? ¿Hay algun aspecto de otra tradicion que te atraiga o te genere curiosidad?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 12, Dia 4: Lo que nos une
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000012',
  4,
  'Lo que nos une',
  ARRAY['1 Corintios 15:3-5', 'Juan 3:16', 'Mateo 28:19'],
  'A pesar de las diferencias, hay un nucleo de fe que practicamente todos los cristianos comparten. Se resume en lo que se llama el "kerygma," el mensaje central: Cristo murio por nuestros pecados, fue sepultado, resucito al tercer dia y fue visto por muchos testigos.

"Porque de tal manera amo Dios al mundo, que ha dado a su Hijo unigenito, para que todo aquel que en el cree, no se pierda, mas tenga vida eterna." Juan 3:16 es el versiculo mas conocido del mundo, y ningun cristiano lo rechaza, sin importar su denominacion.

El bautismo en el nombre del Padre, del Hijo y del Espiritu Santo. La oracion como comunicacion con Dios. El amor como mandamiento central. La Biblia como Palabra de Dios. La esperanza de la vida eterna. Estos pilares son comunes a católicos, protestantes, evangelicos, pentecostales, ortodoxos y mas. Lo que nos une es infinitamente mas importante que lo que nos separa.',
  'Escribe lo que crees sobre Dios, Jesus, el Espiritu Santo y la salvacion. Luego, compara lo que escribiste con lo que sabes de otras tradiciones. ¿Cuanto tienen en comun? Te sorprenderas.',
  '¿Alguna vez has sentido que las diferencias entre iglesias son mas importantes que lo que comparten? ¿Ha cambiado esa perspectiva?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 12, Dia 5: Tradiciones y Escritura
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000012',
  5,
  'Tradiciones y Escritura',
  ARRAY['2 Timoteo 3:16-17', '2 Tesalonicenses 2:15', 'Hechos 17:11'],
  'Una de las diferencias mas profundas entre tradiciones es como interpretan la Biblia. Los protestantes enfatizan "Sola Scriptura": la Biblia como autoridad final. Pablo escribio: "Toda la Escritura es inspirada por Dios." Los catolicos y ortodoxos aceptan tambien la tradicion apostolica: Pablo mismo escribio "retened las tradiciones que habeis aprendido, sea por palabra, o por carta nuestra."

¿Quien tiene razon? Ambos tienen un punto valido. La Biblia es fundamental, pero no se interpreto sola: la iglesia primitiva la interpreto en comunidad, guiada por los apostoles. Al mismo tiempo, toda tradicion debe ser evaluada a la luz de la Escritura, como los bereanos que "escudrinaban cada dia las Escrituras para ver si estas cosas eran asi."

Lo mas sabio es conocer bien tu Biblia Y respetar la sabiduria acumulada de siglos de reflexion cristiana. No son enemigos; son companeros. Tu Biblia te protege de tradiciones erroneas, y la tradicion te protege de interpretaciones aisladas y excentricas.',
  'Elige un tema donde tu tradicion y otra difieran. Busca que dice la Biblia directamente sobre ese tema. ¿Es tan claro como pensabas? ¿Puedes ver por que diferentes tradiciones llegan a conclusiones distintas?',
  '¿Como decides lo que crees: por lo que dice la Biblia, por lo que dice tu iglesia, o por una combinacion? ¿Te sientes comodo con esa forma de decidir?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 12, Dia 6: Respeto en la diversidad
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000012',
  6,
  'Respeto en la diversidad',
  ARRAY['Romanos 14:1-4', 'Filipenses 2:3-4', '1 Pedro 3:15'],
  'Pablo abordó las diferencias entre cristianos con sabiduria: "Recibid al debil en la fe, pero no para contender sobre opiniones." En su epoca, los debates eran sobre comer carne sacrificada a idolos y guardar ciertos dias. En la nuestra, son sobre liturgia, dones, sacramentos y mas. El principio es el mismo: en lo esencial, unidad; en lo no esencial, libertad; en todo, amor.

"Nada hagais por contienda o por vanagloria; antes bien con humildad, estimando cada uno a los demas como superiores a el mismo." ¿Puedes respetar a un cristiano que piensa diferente a ti en cosas no esenciales? ¿Puedes aprender de alguien cuya tradicion no es la tuya?

Pedro aconseja defender tu fe "con mansedumbre y reverencia." No con agresion, no con superioridad moral, no con memes burlones sobre otras iglesias. Con mansedumbre. La confianza en lo que crees no necesita despreciar lo que otros creen.',
  'Hoy, si escuchas a alguien hablar negativamente de otra tradicion cristiana (o si tu mismo lo haces), para y piensa: "¿Que diria Jesus?" Intenta encontrar algo valioso en esa tradicion que critican.',
  '¿Te cuesta respetar tradiciones cristianas diferentes a la tuya? ¿Por que? ¿Que podrias aprender de ellas?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;

-- Plan 12, Dia 7: Tu fe personal
INSERT INTO plan_days (plan_id, day_number, title, verse_references, reflection, practical_exercise, question)
VALUES (
  'b1000000-0000-0000-0000-000000000012',
  7,
  'Tu fe personal',
  ARRAY['Filipenses 2:12-13', '2 Timoteo 1:5', 'Josue 24:15'],
  'Pablo le dijo a los filipenses: "Ocupaos en vuestra salvacion con temor y temblor, porque Dios es el que en vosotros produce asi el querer como el hacer." Tu fe es personal. Nadie puede creer por ti. La tradicion en la que creciste o en la que estas es valiosa, pero al final, tu relacion con Dios es tuya.

Timoteo tenia una fe heredada de su abuela Loida y su madre Eunice. Pero Pablo le anima a hacerla propia: "Aviva el fuego del don de Dios que esta en ti." Una fe heredada que no se hace personal se apaga. Una fe investigada, cuestionada y elegida es una fe fuerte.

Josue desafio al pueblo: "Escogeos hoy a quien sirvais... pero yo y mi casa serviremos a Jehova." Es una decision. No la de tus padres, no la de tu pastor, no la de tu cultura. La tuya. Esta semana has explorado las tradiciones cristianas con mente abierta. Ahora, con todo lo que sabes, ¿que eliges creer? ¿En que fundamento construyes? La respuesta es tuya, y es sagrada.',
  'Escribe tu propia declaracion de fe personal. No lo que dice tu iglesia, sino lo que TU crees. Incluye: quien es Dios para ti, quien es Jesus, que papel juega la Biblia en tu vida, y como quieres vivir tu fe. Guardala como tu brujula espiritual.',
  '¿Tu fe es heredada, elegida, o una mezcla de ambas? ¿Que necesitas para que sea verdaderamente tuya?'
) ON CONFLICT (plan_id, day_number) DO NOTHING;
