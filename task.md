# EL ARRECIFE · Tareas del videojuego

Actualizado: **9 de octubre de 2026**. **Título definitivo pendiente**: el autor ha descartado «Pase pendiente» para la versión final. Ese nombre permanece en los archivos anteriores como referencia histórica hasta elegir el nuevo.

Objetivo: terminar un juego breve de investigación en Godot, con personajes y entornos cuidados, jugable en navegador y presentable como proyecto propio. Desarrollan y prueban el autor y el asistente.

**Nombre del local:** Velvet, elegido por el autor. El título del juego sigue pendiente.

**Tarea actual:** T02 · escala en escena, Entregada para revisión. T03 sigue Entregada; pendiente valoración y acabado fino de bordes. **Completadas:** T00 y T01.

El autor pide priorizar generación de recursos tras la limpieza. Se adelanta la referencia de T03; su cierre técnico seguirá necesitando T02. No se abre otra producción artística antes de revisar esta entrega.

## Cómo trabajar esta lista

1. Al retomar, leer [continuidad](proceso/ESTADO_DEL_PROYECTO.md) y comprobar los archivos de la siguiente tarea pendiente.
2. Marcar **una sola tarea** «En curso». Completarla y comprobarla antes de abrir la siguiente. Si resulta demasiado grande, dividir esa tarea en entregas menores manteniendo su orden.
3. Entregar algo revisable: escena ejecutable, recurso integrado, comparación visual o documento concreto. Resolver los defectos detectados dentro de esa tarea.
4. Registrar archivos, comprobación, límites y valoración del autor. Para arte nuevo, distinguir entrega y aprobación estética. La aprobación de una imagen no demuestra que funcione animada o en escena.
5. Marcar «Completada» solo al cumplir el criterio de cierre. Actualizar esta cabecera y la continuidad; conservar imágenes, prompts y versiones anteriores.

Estados: **Pendiente → En curso → Entregada → Completada**. «Entregada» significa que existe un resultado revisable y quedan comprobaciones o valoración pendientes. Una prueba técnica terminada puede cerrarse directamente. Las decisiones nuevas del autor pueden cambiar el orden; registrar el motivo.

Este archivo es la fuente del orden y estado de las tareas. [PLAN_GODOT.md](proceso/PLAN_GODOT.md) conserva el diagnóstico y la estrategia; la continuidad conserva decisiones e historial. Las fases siguientes orientan la cola, no autorizan ejecutarla entera en una sesión.

## Calidad que debe cumplir cada entrega

| Área | Criterio de revisión |
| --- | --- |
| Personajes | Identidad, anatomía, ropa y equipo coherentes entre vistas y fotogramas; silueta legible; escala y presencia propias. Sota conserva la identidad aprobada en v8 y el deck en la cadera derecha. |
| Animación | Apoyos y peso creíbles, pies acordes al avance, pivote estable, cambios de dirección y velocidad continuos. Revisar a velocidad normal y fotograma a fotograma. |
| Entornos | Espacio transitable comprensible, perspectiva y escala consistentes, arquitectura vertical, materiales usados y reparados, luz con jerarquía y profundidad por capas. Rótulos, tecnología y vestuario sostienen el universo. |
| Integración | Personajes apoyados en el suelo, sin halos o recortes visibles; sombras y elementos delante/detrás coherentes. Revisar con la cámara, los controles y la iluminación reales del juego. |
| Actividad de ciudad | Secundarios e infraestructura con acciones y ritmos propios; vapor, lluvia, luces y sonido ayudan a leer el lugar. La atmósfera deja visibles personajes, accesos y pistas. |
| Investigación | Se entiende qué observar, preguntar y contrastar. Los documentos conservan sus datos; el consentimiento y la autonomía de Iria sostienen el cierre. |
| Uso | Texto legible, teclado y ratón, foco visible, alternativas a buscar puntos pequeños, movimiento reducido y guardado comprobado. |
| Web | Exportar durante la producción y comprobar el resultado en navegador. Un recurso importado o una exportación sin errores no equivalen a una escena validada. |

La ambición de calidad se concreta en estos criterios y en revisiones sobre resultados. El alcance actual sigue siendo tres localizaciones y cuatro pantallas; una escena terminada fija el estándar del resto.

## Base y primera escena

### T00 · Instalar Godot y comprobar salida Web — Completada

**Resultado existente:** editor y plantillas Web 4.7.2, proyecto independiente y escena técnica. Importación y comprobación automática superadas; exportación y respuesta al clic y teclado observadas en Safari.

**Evidencia:** [godot/README.md](godot/README.md). Todavía no acredita movimiento ni caso migrados.

### T01 · Guardar una base recuperable — Completada

**Entrega:** control de versiones local, exclusión de cachés/exportaciones y una copia de respaldo fuera de la carpeta de trabajo. Conservar prototipo, recursos y prompts.

**Cierre:** identificar la versión de partida y comprobar que un archivo puede recuperarse desde una copia temporal, sin alterar los originales. Registrar ubicación del respaldo. La publicación de un repositorio será una decisión posterior.

**Resultado T01:** Git local, base `740bbb3`, respaldo externo al proyecto y recuperación de un archivo comprobada. [Registro](proceso/RESPALDO_Y_LIMPIEZA.md).

### T02 · Fijar escala, encuadre y acabado en escena — Entregada

**Entrega:** comparación en Godot de Sota, suelo, mobiliario y personajes de Velvet, tomando [Fiebre v8](trabajo/arte/conceptos/fiebre_v8/fiebre_escena_v8.png) como referencia. Elegir resolución de trabajo, filtrado y encuadre con esa comparación visible.

**Cierre:** Sota tiene proporciones creíbles junto a puertas y personas; el recorrido se entiende y la ciudad mantiene su escala. Registrar la opción elegida y la valoración del autor. Los 1280 × 720 de la prueba técnica no constituyen una decisión artística.

**Entrega T02:** [escena, capturas y propuesta](trabajo/arte/revisiones/escala_v1/README.md). Composición 1672 × 941, propuesta Sota 252, cuatro vistas con apoyo normalizado y filtro suave/nítido. Prueba automática y render nativo correctos; exportación Web correcta. Pendientes valoración del autor y comprobación visual en navegador.

### T03 · Preparar a Sota para producción — Entregada

**Entrega:** referencia coherente de frente, tres cuartos y ambos perfiles, con medidas de suelo/pivote y detalles de ropa, pelo, manos, correa y deck. Mantener el diseño aprobado.

**Cierre:** las vistas representan al mismo personaje, coinciden en proporciones y mantienen el lado del equipo; funcionan a la escala elegida. Guardar recurso, prompt y revisión.

**Entrega T03:** [referencia de cuatro vistas](trabajo/arte/personajes/sota/README.md), PNG importado en Godot, regiones y apoyos medidos. Perfil izquierdo propio, deck en el lado físico correcto. Pendientes valoración del autor, bordes de alfa y escala/apoyos en T02; no se da por terminada la producción del personaje.

### T04 · Construir el desplazamiento en Godot — Pendiente

**Entrega:** Sota provisional en Velvet con teclado, clic, correr, aceleración, frenada, límites/colisiones y puntos de llegada propios para cada interacción.

**Cierre:** llegar sin sobrepasar el destino, detenerse, invertir dirección y perder/recuperar el foco sin movimiento atascado. Comprobar entradas y límites con una prueba pequeña; verificar también la exportación Web. El recurso provisional permite evaluar el control, no cerrar el arte.

### T05 · Terminar el ciclo de caminar — Pendiente

**Entrega:** ciclo consistente en ambos sentidos, integrado en el controlador y sincronizado con la distancia recorrida.

**Cierre:** revisar apoyos, transferencia de peso, articulaciones, manos, ropa y deck; sin saltos de tamaño, pivote o postura al cerrar el ciclo. Ajustar zancada y velocidad viendo el resultado en escena.

### T06 · Terminar carrera, giros y reposo — Pendiente

**Entrega:** carrera propia, cambios caminar/correr, parada, vuelta y reposo con respiración sutil.

**Cierre:** ambas direcciones y todas las transiciones son continuas, conservan identidad y equipo y mantienen los apoyos. Movimiento reducido funciona. Registrar revisión visual del autor.

### T07 · Construir Velvet por capas — Pendiente

**Entrega:** fondo distante, arquitectura, suelo, recepción y elementos de primer plano separados donde haga falta. Reconstruir zonas ocultas al extraer personajes u objetos del fondo existente.

**Cierre:** Sota recorre la escena con perspectiva, suelo y oclusiones correctos; las capas mantienen el acabado aprobado y no revelan huecos. El movimiento de cámara, si lo hay, conserva la composición y permite comprobar profundidad.

### T08 · Producir la jefa de la Nómina — Pendiente

**Entrega:** personaje independiente, con identidad, equipo de trabajo, reposo y acción breve relacionada con el libro o la recepción. Su presencia no la convierte en recepcionista permanente del local.

**Cierre:** se integra en escala, luz y postura con Sota; rostro, ropa, manos y objetos son consistentes. Su acción se entiende a tamaño real y su diseño queda revisado con el autor.

### T09 · Dar actividad a la Fiebre — Pendiente

**Entrega:** figuración necesaria y actividad de infraestructura: personas con acciones diferenciadas, luces, ventilación, humedad y vapor. Separar del fondo los secundarios que deban animarse.

**Cierre:** observar la escena durante un minuto: los ciclos no distraen ni se sincronizan de forma evidente, la ciudad parece habitada y los puntos del caso siguen legibles. Comprobar movimiento reducido y coste de renderizado en Web.

### T10 · Integrar encargo y primer documento — Pendiente

**Entrega:** acercamiento a la jefa, conversación inicial y lectura de E0 con controles de Godot; recibir también P2 conforme al encargo existente. Preparar únicamente el estado necesario para este tramo.

**Cierre:** iniciar y terminar la conversación, guardar las copias en la libreta y volver al movimiento con foco correcto. Texto legible y controles utilizables con ratón y teclado; contenido cotejado con el guion.

### T11 · Revisar Velvet como escena completa — Pendiente

**Entrega:** versión Web del primer tramo con personaje, entorno, actividad, encargo y documento funcionando juntos.

**Cierre:** el autor prueba caminar, correr, giros, interacción y lectura. Registrar problemas concretos y corregir los que afecten al estándar visual o de control. Cerrar con valoración del conjunto antes de extenderlo a las otras pantallas.

## Completar personajes, entornos y caso

### T12 · Migrar las reglas y consolidar textos — Pendiente

**Entrega:** estado de caso en Godot y fuente única de datos de ejecución, cotejada con guion y tarjetas v2. Conservar identificadores y condiciones existentes; incorporar lo ya usado en el primer tramo.

**Cierre:** pruebas de progresión, deducción tardía, respuesta incorrecta sin pérdida, documentos al salir de Sanz, lectura y consentimiento, y cantidades/cierre. Los textos de ejecución coinciden con las fuentes revisadas; el movimiento queda independiente del estado narrativo.

### T13 · Terminar las dependencias de Iria — Pendiente

**Entrega:** casillero integrado, suelo y profundidad, objetos de trabajo, ropa y sobre; interacciones y documentos P1/P3.

**Cierre:** escala y recorrido coherentes con Velvet; objetos legibles y accesibles mediante teclado/lista de exploración. Entrada, regreso y recogida de copias comprobados; revisión visual de la pantalla completa.

### T14 · Producir a Sanz — Pendiente

**Entrega:** personaje independiente con referencia consistente, postura de trabajo y acciones necesarias para hablar y mostrar el expediente.

**Cierre:** rostro, ropa, puerto/cable, manos y objetos coherentes; integrado a escala y con animaciones revisadas. La caracterización procede del guion y de su oficio.

### T15 · Terminar la oficina del Nudo — Pendiente

**Entrega:** entorno por capas, mobiliario reparado, Sanz integrado, luz y actividad; conversaciones, expediente P4 y carpeta P5.

**Cierre:** perspectiva, acceso y oclusiones correctos; el terminal y los documentos se identifican. Entrar, conversar y salir conservando las copias funciona también con deducciones pendientes. Revisión visual y Web.

### T16 · Producir a Berta — Pendiente

**Entrega:** personaje independiente con referencia, reposo y acción de reparación, y transición necesaria para consultar a Iria.

**Cierre:** trabajo manual, herramientas, manos y postura coherentes, con identidad y proporciones constantes. Integración revisada en la zona de trabajo del taller.

### T17 · Producir a Iria — Pendiente

**Entrega:** personaje independiente, referencia consistente y acciones de conversación y entrega de documentos, con taza y prenda según el guion cuando corresponda.

**Cierre:** silueta propia, ropa y objetos estables, escala coherente junto a Berta y Sota. Su aparición respeta la consulta previa de Berta y su voluntad de hablar. Revisión visual del autor.

### T18 · Terminar el taller de la cota 0 — Pendiente

**Entrega:** taller por capas y mercado visible, zona de trabajo, trastienda, Berta e Iria integradas, infraestructura activa y conversaciones/documentos P6/P7.

**Cierre:** recorrido y profundidad legibles; personajes presentes en el momento correcto; herramientas y reparación sostienen el oficio del lugar. Contacto, explicación del silencio y consentimiento comprobados. Revisión visual y Web.

### T19 · Terminar libreta, recorrido y deducciones — Pendiente

**Entrega:** documentos completos, comparación, conclusiones, mapa, ayudas graduales y alternativa «Explorar», integrados con las cuatro pantallas.

**Cierre:** leer tablas y fechas, comparar pruebas, equivocarse, pedir ayuda y resolver D2 más tarde sin perder progreso. Viajes se habilitan al leer direcciones. Comprobar foco, tamaño de texto y lectura asistida; registrar los límites reales de accesibilidad.

### T20 · Integrar informe, coda y cierre — Pendiente

**Entrega:** informe, regreso a la Fiebre y desenlace sobre la recepción preparada; incluir la puesta en escena de la vuelta de Iria que necesite el cierre.

**Cierre:** faltas del informe señaladas con claridad, consentimiento obligatorio y devolución de 200 con 100 pendientes, comisión separada y regreso voluntario. El recorrido completo termina sin contradicciones entre texto y escena.

### T21 · Terminar guardado y reanudación — Pendiente

**Entrega:** guardado versionado y validado en Godot, continuar partida y recuperación comprensible ante datos incompatibles o almacenamiento indisponible.

**Cierre:** guardar y recargar en varios tramos, durante la lectura y tras el cierre; comprobar datos inválidos y reinicio voluntario. Probar persistencia en navegador y definir qué ocurre al interrumpir un diálogo. Conservar la partida del prototipo anterior.

## Pulido y entrega pública

### T22 · Producir sonido y mezcla — Pendiente

**Entrega:** ambientes propios por cota, pasos y sonidos de interacción necesarios. Decidir voces selectivas con el guion revisado y comprobar acceso a ElevenLabs antes de generarlas.

**Cierre:** mezcla legible, bucles sin cortes molestos, controles de volumen y silencio; los textos permiten jugar sin audio. Probar inicio del sonido mediante entrada del jugador y cambio de pestaña en Web. Guardar procedencia de recursos.

### T23 · Pulir interfaz, transiciones y opciones — Pendiente

**Entrega:** menú, entradas/salidas de escena, lectura, foco, opciones de texto/movimiento y retroalimentación coherentes con el acabado del juego.

**Cierre:** completar todas las acciones con teclado y ratón, revisar pérdida de foco, ventanas de lectura y tamaños habituales de pantalla. Ninguna transición tapa una prueba o deja controles bloqueados. Resolver los límites de accesibilidad detectados o documentar el soporte que realmente se ofrece.

### T24 · Probar ritmo y claridad con el autor — Pendiente

**Entrega:** partida completa con lectura natural y registro de duración, dudas y observaciones; revisar la espera de Iria y las explicaciones de las deducciones.

**Cierre:** corregir y volver a probar los tramos problemáticos. Registrar duración observada sin presentarla como prueba a ciegas: el autor conoce la solución. Las ayudas son opcionales y el juego tiene sentido sin alargarlo para cumplir un minutaje.

### T25 · Verificar rendimiento y navegadores — Pendiente

**Entrega:** comprobación del paquete Web en Safari, Chromium y Firefox, con carga inicial, escenas exigentes, recorrido, lectura, sonido y guardado.

**Cierre:** registrar equipos/navegadores, tiempos de carga y rendimiento observado; corregir bloqueos, pérdidas de progreso y caídas que afecten al control. Definir requisitos según resultados. Móvil tendrá su propia tarea si se decide incluirlo.

### T26 · Elegir y aplicar el título definitivo — Pendiente

**Entrega:** propuesta breve de nombres basada en el juego ya definido, elección del autor e incorporación del elegido al menú, metadatos y materiales actuales.

**Cierre:** título elegido expresamente y usado de forma consistente. Conservar nombres anteriores en historial, prompts y versiones archivadas; revisar identificadores técnicos antes de cambiar rutas o claves de guardado. Esta tarea puede adelantarse si surge una propuesta que convenza al autor.

### T27 · Preparar el paquete y la presentación — Pendiente

**Entrega:** exportación candidata, créditos, controles, duración medida, portada, capturas y ficha de portfolio con proceso y responsabilidades. Alojamiento propuesto: itch.io, pendiente de elección del autor.

**Cierre:** paquete autónomo con los recursos necesarios, sin fuentes de la novela ni soluciones de moderación; probar desde una carpeta limpia. Materiales describen el juego entregado y sus requisitos reales. Añadir enlace a la novela solo si existe y está verificado.

### T28 · Publicar y comprobar la versión alojada — Pendiente

**Entrega:** página y paquete revisables antes de publicar; tras la decisión del autor sobre la publicación, enlace público para jugar.

**Cierre:** probar carga, recorrido, sonido, recarga y guardado desde la URL final; conservar versión y paquete publicados y documentar problemas restantes. La ficha de portfolio enlaza esa versión.

## Registro de cierre

Al completar una tarea, añadir una fila breve y actualizar su estado arriba. Los detalles y comprobaciones extensas viven en los archivos del trabajo correspondiente.

| Tarea | Fecha | Entrega y archivos | Resultado comprobado | Valoración del autor / pendiente |
| --- | --- | --- | --- | --- |
| T00 | 9 oct 2026 | Base Godot y exportación Web; `godot/README.md` | Instalación, importación, prueba automática y escena técnica en Safari | Elección de Godot por el autor; sin aprobación de un acabado nuevo |
| T01 | 9 oct 2026 | Git local y [respaldo/limpieza](proceso/RESPALDO_Y_LIMPIEZA.md) | Recuperación idéntica desde respaldo y Git; retirados 47 MiB regenerables/duplicados | Respaldo en el mismo equipo; conserva fuentes y versiones |
| T03 · entrega | 9 oct 2026 | [Sota: cuatro vistas y prompts](trabajo/arte/personajes/sota/README.md) | Transparencia y siluetas medidas, importación Godot correcta | Pendientes valoración, escala/apoyos T02 y bordes; sin animación nueva |
| T02 · entrega | 9 oct 2026 | [Revisión de escala y capturas](trabajo/arte/revisiones/escala_v1/README.md) | Cuatro vistas y tres alturas, apoyos y filtros; render nativo, importación, pruebas y exportación Web correctos | Propuesta 252; pendientes valoración y prueba visual en navegador |
