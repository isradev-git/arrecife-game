# EL ARRECIFE · continuidad vigente

Actualizado: **21 de octubre de 2026**.

## Dirección del autor

**Reinicio completo** como aventura narrativa **2D ilustrada en primera persona**, desde los ojos de Sota. Clic/toque, vistas fijas, exploración, diálogo, deck, contratos y progresión. Duración objetivo de la primera aventura completa: unos 30 minutos. Los retratos originales marcan el estilo.

**Decisión posterior del autor:** en móvil sólo se juega en horizontal. Antes del menú aparecen el logo original «EL ARRECIFE PRODUCTS» que ha facilitado el autor, el crédito del universo original de Israel Zamora y el aviso de giro (en ordenador: «disfruta»). En vertical móvil el aviso cubre el juego y conserva la partida debajo. Se puede adelantar cada pantalla; también avanza sola cuando corresponde. En Web, la apertura aparece una vez por pestaña: recargar lleva al menú; cerrar la pestaña y abrir otra repite la secuencia.

**Dirección de interfaz del autor, 21 oct:** menú con paisaje cyberpunk visto desde una ventana, sin Sota, inspirado en la composición del menú de *The Last of Us* pero con ilustración original del Arrecife. Enlaces de texto sin cajas; apertura sin botón de salto, sólo indicación discreta de tocar, hacer clic o pulsar Intro. Reducir botones y letra, hacer que el paisaje ocupe más pantalla, igualar marca y área de cada hotspot, distinguir amarillo para progreso principal y gris para información opcional, y dar más cuerpo a los textos. Tratar el juego como base ampliable del universo.

La orden actual sustituye las decisiones jugables anteriores. El único proyecto activo es **`game/project.godot`**, Godot 4.7.2. [Diseño vigente](../docs/GAME_DESIGN.md) y [dirección artística](../docs/ART_DIRECTION.md).

## Respaldo y preservación

Inspección inicial limpia en `main`, checkpoint previo ya publicado **433e099**. Se creó `backup/pre-reboot-20261020` y se trabajó en **`feat/interactive-arrecife-reboot`**. Las carpetas retiradas se trasladaron completas a `../el-arrecife-respaldos/pre-reboot-20261020-433e099/`. [Recuperación exacta](../docs/RECUPERACION.md), [manifiesto SHA256](../docs/PRESERVACION.json).

Canon intacto. Dos retratos originales ilustrados (Sota/Jefa) migrados sin alterar bytes; guardia, figurante y acompañante del acceso conservados como originales históricos pixel, no confundidos con retratos. Licencias/atribución conservadas. No existen `sources/` ni `universo/` en este checkout; no se ha certificado lectura de fuentes ausentes. Todo el historial y los prompts anteriores permanecen recuperables.

**El reinicio no se ha enviado al remoto.** Requiere autorización explícita para publicar esta limpieza.

## Entrega del asistente: hito 1

Menú, opciones, créditos, intro saltable, tres habitaciones y primer pasaje de La Fiebre. Hotspots por datos, observaciones, terminal, documentos paginados y leídos, diálogo con temas/elecciones/revisita, Sota izquierda/Jefa derecha y hablante iluminado. Deck con mensajes, contrato, archivo, noticias, contactos y lugares. Guardado v1, copia anterior, recuperación y nueva partida confirmada con respaldo fechado. Interacción de ratón y toque sobre la ilustración, puntos de luz discretos y lista de acciones a petición dentro de «Pistas».

Apertura previa al menú implementada con textos editables en `story.json`, el logo original suministrado por el autor y un icono de móvil que gira. El original y la copia del juego son idénticos por SHA256 y constan en `docs/PRESERVACION.json`. El crédito legal es una entrega de texto del asistente pendiente de revisión editorial. `sessionStorage` guarda únicamente la marca de apertura durante la pestaña; no altera el guardado de partidas.

Contrato **`retorno_agua`**: mensaje → aceptar → copiar lectura doméstica → contrastar con Jefa. El contrato permanece ACTIVE al terminar el contenido del hito. El Nudo y Los Puntales tienen IDs, rutas y condiciones, pero sus vistas no están construidas. Doce vistas registradas, cuatro construidas. No hay desenlace ni duración final comprobada.

Cuatro fondos candidatos generados con imagegen desde referencia de retrato, en `game/assets/backgrounds/candidates/`. PNG originales y prompts conservados; ninguna regeneración de retratos. Son imágenes aplanadas, sin aprobación artística ni fuentes por capas. Revisar luz exterior del dormitorio, continuidad arquitectónica y representación ambiental de la Jefa.

**Revisión visual del autor, 21 oct:** le gusta mucho el estilo de los entornos a primera vista; pide revisar sus detalles y mostrar calles densamente pobladas. En La Fiebre deben coexistir visitantes de mayores recursos y personas que viven y trabajan allí, incluido el servicio sexual. El asistente ha creado `fiebre_multitud_v2.png` como variante del pasaje visible en el juego, con las dos entradas despejadas. `fiebre.png` y la primera variante poblada permanecen intactos. Prompts y límites documentados en `art/prompts/fiebre_multitud_v2.md`. Esta impresión positiva **no equivale a aprobación final** del nuevo fondo, de cada detalle ni del guion.

**Entrega de interfaz del asistente, 21 oct:** nuevo fondo candidato de menú `menu_nudo_ventana_v3.png`, con dos versiones previas conservadas y generación documentada; la cota exacta de la vista no queda fijada. Sota desaparece del menú y las cuatro acciones son enlaces tipográficos. Apertura con clic/toque/Intro y sin botón. Exploración con ilustración a pantalla completa, bandas translúcidas, letra y controles menores. Opciones de diálogo amarillas para el avance del contrato y grises para preguntas/salida, más etiqueta accesible. Textos de inicio, objetos, documentos, mensaje y Jefa ampliados en JSON. El fondo y la ficción nueva siguen **pendientes de revisión/aprobación del autor**.

**Corrección solicitada por el autor, 21 oct:** la captura móvil mostró que los indicadores cuadrados eran demasiado grandes y que la letra era pequeña. El asistente devolvió puntos circulares de 10 unidades, centrados en áreas pulsables acotadas de 36/48 unidades, y amplió texto y botones sólo en ventanas horizontales bajas. El menú móvil se reconstruyó en la prueba a 844×390 para obtener evidencia del tamaño real. La presentación queda pendiente de valoración del autor y toque en teléfono físico.

## Canon frente a propuesta

Cotas, jerarquía, tecnología física y límites de la Nómina proceden del canon. La residencia de Sota cerca de La Fiebre, su acreditación, el parte del agua, el encuentro y todos los diálogos nuevos son **propuestas de juego pendientes de aprobación**. La Jefa no se convierte en dueña ni recepcionista de Velvet. No se incluyen revelaciones principales de las novelas ni se modifica el canon literario.

## Resultados probados

Importación y arranque correctos. **219 comprobaciones headless y 243 nativas con GPU, cero fallos**, incluidas 24 capturas reales. Integridad de canon, cinco originales y dos copias; una única implementación sin dependencia 3D. Web exportada y comprobada en Helium/WebGL 2 antes de la última corrección de indicadores y letra. Las pruebas previas de clic, toque sintético, contrato y recarga se mantienen; la orientación nueva se probó además con emulación iPhone 12 en Web: aviso en vertical inicial, menú al girar a horizontal y aviso de nuevo al devolver el navegador a vertical. También se comprobó por código que la apertura no puede terminar en móvil vertical, el aviso desaparece al volver a horizontal y la aplicación nativa usa orientación por sensor para mostrarlo. Las pruebas verticales de la exploración pertenecen a la etapa previa a esta decisión; hoy la tapa el aviso en móvil.

Tras incorporar el logo original, la prueba Web confirmó **primera visita con logo → recarga directa al menú → cierre y pestaña nueva con logo**. En iPhone emulado, recargar en vertical muestra el bloqueo de orientación sin repetir la apertura. El logo original y su copia pasan comprobación de hash. Los 193/216 resultados automáticos permanecen sin fallos en la última ejecución nativa; estas verificaciones Web son manuales y adicionales.

La carga previa del motor Web se dejó con fondo neutro: el HTML exportado oculta el logo por defecto de Godot para que una recarga no muestre ningún segundo logo. La imagen aportada por el autor sólo aparece en la secuencia controlada por pestaña.

**Variante poblada del pasaje, 21 oct:** importación correcta; 193 comprobaciones headless y 216 nativas sin fallos, incluida conversación con la Jefa. Capturas reales a 1280×720 y 844×390 inspeccionadas; las entradas se mantienen visibles. Exportación Web regenerada e imagen nueva empaquetada; no se ha repetido recorrido de navegador ni probado teléfono físico. [Detalle](../docs/VALIDACION.md).

**Interfaz actual, 21 oct:** importación y exportación Web correctas; 219/219 pruebas headless y 243/243 nativas. Capturas reales del menú, exploración y diálogo a 1280×720 y 844×390 inspeccionadas. La exportación anterior a la corrección de puntos y letra abrió y mostró menú y dormitorio en Helium/Chromium; la versión corregida se exportó, sin nueva inspección en navegador. No se ha probado esta versión en Safari ni en móvil físico. [Evidencia](../docs/VALIDACION.md).

[Resultados, evidencias y límites](../docs/VALIDACION.md). No se han probado móviles físicos, Safari/iOS, Windows ni Linux. El navegador depende de su almacenamiento local. No hay música ni efectos finales; los buses están preparados. Las pruebas técnicas no constituyen aprobación artística.

## Siguiente trabajo

Revisión del autor sobre la propuesta narrativa y los detalles de los fondos, incluido el menú desde la ventana y la multitud de La Fiebre a tamaño de juego. En los futuros pasos públicos de El Nudo y Los Puntales, representar la densidad humana propia de cada cota. Completar La Fiebre y El Nudo con una comprobación técnica y consecuencias, después Puntales y el final. Producir capas y sonido, revisar ritmo y validar dispositivos reales. [Tareas completas](../task.md).

## Historial breve

- **20 oct 2026 · decisión del autor:** abandonar la implementación anterior y construir una aventura ilustrada en primera persona, con misiones, contratos y progresión.
- **20 oct 2026 · entrega del asistente:** retiro recuperable, proyecto único, hito 1 jugable y pruebas descritas arriba. **Pendiente de revisión narrativa y artística por el autor.**
- **20 oct 2026 · corrección solicitada por el autor:** retirar los rótulos y botones grandes sobre los objetos, con prioridad móvil. **Entrega del asistente:** puntos pequeños, toque directo sobre la imagen y acciones nombradas sólo al abrir «Pistas». Verificación técnica y visual realizada; el autor aún no ha aprobado esta presentación.
- **20 oct 2026 · segunda corrección solicitada por el autor:** reducir el tamaño de las áreas pulsables. **Entrega del asistente:** 56×56 unidades alrededor de cada punto, con pruebas dentro y fuera del área en Godot y Web. Pendiente de valorar la comodidad en teléfono físico.
- **20 oct 2026 · continuación del asistente:** comprobación visual de los puntos del apartamento; agrupación de escena y observación en vertical y retirada del aviso técnico durante la exploración. Pruebas nativas y Web realizadas; diseño móvil pendiente de revisión del autor y de un teléfono físico.
- **20 oct 2026 · decisión del autor:** juego móvil exclusivamente horizontal; apertura con logo, autoría de Israel Zamora y aviso de giro antes del menú. **Entrega del asistente:** secuencia y bloqueo visual persistente, capturas Godot y Web iPhone emulado, 193/216 comprobaciones sin fallos. Logo tipográfico, crédito y experiencia en teléfono físico pendientes de aprobación/comprobación.
- **20 oct 2026 · decisión del autor:** apertura una sola vez por pestaña Web; una recarga debe ir al menú y una pestaña nueva debe repetirla. El autor facilitó el logo original «EL ARRECIFE PRODUCTS». **Entrega del asistente:** logo intacto integrado y preservado, marca por `sessionStorage`, prueba visual de las tres situaciones y aviso móvil al recargar. Redacción legal y teléfono físico pendientes.
- **21 oct 2026 · observación del autor:** el estilo de los entornos gusta a primera vista; pide revisar detalles y calles concurridas con mezcla social en La Fiebre. **Entrega del asistente:** nueva variante poblada del pasaje, original preservado y dirección de población registrada para las tres cotas. **Comprobado:** importación, pruebas y capturas nativas. Pendiente aprobación artística del autor y dispositivo físico.
- **21 oct 2026 · dirección del autor:** menú de ventana cyberpunk sin Sota ni cajas, apertura con indicación discreta; controles/textos menores, paisaje mayor, opciones de diálogo jerarquizadas y narrativa más extensa. **Entrega del asistente:** candidato de menú, interfaz y textos ajustados, versiones y prompts conservados. **Comprobado:** 201/225 pruebas, 24 capturas, importación/exportación y revisión Web de menú/dormitorio. Pendiente aprobación visual y narrativa y prueba en teléfonos físicos.
- **21 oct 2026 · nueva observación del autor:** los puntos se habían convertido en cuadrados y el texto móvil era pequeño. **Entrega del asistente:** puntos redondos discretos y letra móvil mayor; área táctil acotada y pruebas de menú móvil real. **Comprobado:** 219/243 pruebas y capturas nativas a 844×390. Pendiente prueba táctil física y valoración visual del autor.

El historial de las etapas anteriores está íntegro en la rama de respaldo y la copia local; no describe la producción actual.
