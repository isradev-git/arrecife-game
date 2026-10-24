# Diseño vigente · El Arrecife 0.2.0

## Experiencia

Aventura 2D ilustrada en primera persona desde Sota. Vistas fijas, exploración por clic/toque, conversaciones y decisiones breves. La versión 0.2.0 contiene tres contratos y un desenlace con dos decisiones posibles. Su duración objetivo es unos 30 minutos; todavía requiere una partida cronometrada del autor.

Al arrancar: logo original «EL ARRECIFE PRODUCTS» suministrado por el autor → crédito del universo original de Israel Zamora → aviso de orientación → menú. Cada pantalla avanza sola tras una breve espera o al tocar la pantalla, hacer clic o pulsar Intro; no muestra un botón de salto. En Web se marca al empezar la apertura en `sessionStorage`: recargar la misma pestaña va directamente al menú, mientras que una pestaña nueva muestra la secuencia. La carga del motor usa fondo neutro, sin otro logo. En móvil, la tercera espera a que la pantalla esté horizontal; si se vuelve a vertical durante el juego, un aviso cubre la interfaz hasta recuperar la orientación. El ordenador muestra «disfruta» y no se bloquea por la forma de su ventana. Los textos de crédito y orientación están en `story.json`; la imagen original del logo se conserva sin modificar.

El menú usa una vista ilustrada de ciudad desde una ventana de una cota aún sin identificar, ajena al dormitorio de Sota. Los enlaces son líneas tipográficas sin cajas ni retrato de protagonista. Es una candidata visual del asistente, no arte final aprobado. Las vistas jugables dejan la ilustración a pantalla completa y sitúan los controles en bandas translúcidas sobre la propia escena.

La estructura sigue un cargo de reparación de agua, una orden duplicada y una verificación final de presión. El mundo aparece en recibos, lecturas, desplazamientos y conversaciones. No hay combate, avatar caminando ni cámara libre.

## Canon y propuesta

| Elemento | Situación |
| --- | --- |
| Cotas, Penumbra/Luz, ciudad acumulada y reparada | Canon: secciones 1–4 de `canon_el_arrecife.md` |
| La Fiebre (4), El Nudo (3), Los Puntales (2) | Denominación y temática canónicas; vistas concretas propuestas |
| Subida restringida, puertos físicos, decks externos | Canon; los permisos concretos de Sota son ficción de juego |
| Nómina, cuotas y fondo limitado | Canon, decisión D31. No autoridad universal ni refugio garantizado |
| Jefa como titular de Velvet | No se establece: su encuentro es en un pasaje adyacente |
| Sota protagonista del videojuego y retratos originales | Protagonismo y biografía fijados en el canon por el autor el 22 oct 2026; retratos originales aprobados |
| Sota, ex-Vesta del suelo, investigadora independiente y colaboradora ocasional de la policía | Canon, sección 8: cobra directamente por encargo, informa sólo en los trabajos policiales y vive en La Fiebre gracias a su oficio |
| Los tres contratos, personas afectadas, recibos, orden de visita y diálogos | **Ficción del videojuego pendiente de revisión final del autor** |
| Deck de Sota: memoria local, mensajes, contratos y notas | Interfaz propuesta compatible con tecnología canónica; no teléfono mágico ni transporte |

No se incorporan tramas ni revelaciones de los protagonistas de las novelas. El autor amplió el canon con Sota y la regla sobre la policía el 22 oct 2026, y delegó el desarrollo del juego; los contratos, diálogos y relaciones de los mensajes siguen pendientes de revisión final. `sources/`, `universo/` y los documentos literarios externos citados por el canon no existen en el checkout inspeccionado; esta entrega contrasta con el canon local disponible, no certifica revisión de fuentes ausentes.

## Mapa y alcance

| Zona | Vistas registradas | Construido |
| --- | --- | --- |
| Apartamento | Dormitorio, salón/cocina, baño | 3 navegables |
| La Fiebre | Pasaje, interior de Velvet, rincón, galería, suministros, control de descenso | 6 navegables |
| El Nudo | Acceso, taller, puesto de red, mercado, archivo, paso inferior | 6 navegables |
| Los Puntales | Acceso, taller, frente de trabajo, soportes, presión, verificación | 6 navegables |

Las cotas urbanas visitadas son **La Fiebre (4), El Nudo (3) y Los Puntales (2)**. El apartamento es la cuarta zona jugable y está en La Fiebre. El autor aprobó 3 vistas del apartamento y 6 por cota, con sus nombres y conexiones en [el diseño de 21 vistas](superpowers/specs/2026-10-21-21-vistas-zonas-design.md). Las vistas de calles y pasos públicos deben transmitir ciudades muy pobladas: en La Fiebre coinciden residentes, personal de servicio y visitantes de mayores recursos. La densidad ambiental no crea por sí sola nuevos personajes conversables ni altera las restricciones de acceso entre cotas.

El autor corrigió el antiguo umbral de Velvet: la vista `fiebre_entrada` muestra ahora un [interior de salón](superpowers/specs/2026-10-24-velvet-interior-design.md) y conserva su ID para las partidas previas. En el pasaje, pulsar la puerta entra; la fila lateral mantiene la observación exterior. La salida interior devuelve al pasaje. Esto no atribuye la propiedad de Velvet a la Jefa ni añade una misión.

Las puertas conectan habitaciones. La salida del apartamento se habilita al aceptar el contrato. Los trayectos entre cotas tienen rutas explícitas en `world.json`; bajar y subir se comprueban por separado. La residencia y la orden de visita justifican regresos concretos. El deck informa de los lugares y nunca permite saltarse estos accesos. Las 21 vistas forman un grafo alcanzable con camino de vuelta.

Al intentar cruzar un control sin permiso, el juego indica cuál falta en un aviso lateral compacto. Es información de orientación, sin cambiar las reglas de acceso ni añadir destinos.

## Contrato principal

ID `retorno_agua`. Mensaje recibido → AVAILABLE → aceptación → ACTIVE → copia de lectura → contraste con Jefa → ficha del equipo en El Nudo → verificación física en Los Puntales → READY_TO_COMPLETE → entrega explícita a la Jefa → COMPLETED.

Tras esa entrega, `orden_duplicada` llega por mensaje de un enlace policial. Sota coteja archivo, red y remesa; sólo este contrato exige un informe policial. Tras enviarlo, `prueba_presion` llega de la Jefa: Sota reúne cargos, marca del soporte y lectura actual, y entrega las copias. El jugador elige si las reciben primero las viviendas afectadas o la unidad policial. La misión se completa al cerrar el último parlamento; salir antes permite releerlo y cambiar la elección. Entonces se abre automáticamente el cierre, que permanece en el deck. El cobro sigue suspendido y se acuerda una verificación independiente; no se atribuye culpabilidad sin pruebas ni se resuelve toda la corrupción. La [especificación de 1.0](superpowers/specs/2026-10-22-version-1-design.md) detalla el arco.

## Interacciones

Hotspots con ID por pantalla, tipo, etiqueta, rectángulo normalizado, condición visible y disponible, y destino. Las rutas muestran una flecha ámbar; objetos, personas y demás interacciones conservan el punto circular de 10 unidades lógicas. Su área pulsable acotada mide 36×36 unidades en escritorio y 48×48 en horizontal bajo; el rectángulo normalizado completo no captura toques. No hay rótulos sobre la ilustración. «Pistas» abre, sólo a petición, un panel lateral compacto con acciones tipográficas y permite ocultar ambas marcas; las listas largas se desplazan dentro del panel. El deck y el terminal emplean el mismo lenguaje para sus entradas; las decisiones principales conservan mayor peso visual. La ilustración llena la ventana y puede recortarse por arriba/abajo en proporciones distintas de 16:9; las marcas se calculan sobre la imagen renderizada y permanecen dentro de la zona visible. Todas las vistas tienen salida y camino de vuelta; los controles entre cotas mantienen sus requisitos.

La experiencia móvil sólo está disponible en horizontal. La condición de candidata de los fondos se documenta fuera de la interfaz jugable.

La banda inferior aparece una vez como ayuda al terminar o saltar la introducción, y después cuando una acción aporta información, como observar, completar un diálogo o recorrer un trayecto con texto propio. Se puede cerrar con la X y también desaparece tras 14 segundos. Entrar en otra habitación o continuar una partida no repite el estado del contrato.

- OBJECT: observación breve, sin diálogo modal.
- PERSON: diálogo con temas, condiciones, efectos, elecciones y salida.
- TERMINAL: menú de registros locales con arranque breve.
- DOCUMENT: visor de papel, páginas y lectura persistente.
- DEVICE: interfaz del deck.
- NAVIGATION: ruta y cambio de vista.
- SPECIAL_EVENT: evento contextual; los descensos ya son NAVIGATION.

En conversaciones, Sota izquierda e interlocutora derecha, mirando al centro con sus PNG originales. Los torsos se apoyan en el borde inferior del diálogo para que el corte del retrato no flote a media pantalla. Sólo Sota en monólogos. Escena oscurecida, hablante iluminado y oyente atenuado. El texto central empieza junto a los retratos y se desplaza dentro de su columna. Las decisiones que avanzan el contrato se identifican en amarillo; las preguntas y salidas opcionales, en gris, con nombre accesible que explicita el papel de la opción. Los parlamentos, documentos y observaciones del primer tramo se ampliaron sin convertirlos en exposición enciclopédica. Texto completo inmediatamente: no se necesita ajuste de velocidad de escritura.

## Arquitectura

`Content` carga cuatro JSON: mundo, historia, diálogos y misiones. `State` conserva datos, evalúa condiciones, controla rutas/fases y escribe el guardado. Las interfaces sólo presentan esos datos y solicitan efectos.

`main.gd`: menú, intro, exploración y apertura de paneles. `startup.gd`: tres pantallas previas y aviso reutilizado al girar el móvil. `viewpoint.gd`: imagen e indicadores. `dialogue.gd`: secuencia de nodos y opciones. `device.gd`: secciones del deck. `ui.gd`: controles y tema compartidos. Una escena raíz; las vistas son datos y usan el mismo componente. Sin dependencias externas ni frameworks.

Guardado v1: vista/zona, misiones, flags, descubrimientos, documentos, mensajes, lugares y elecciones. Las acciones de juego se confirman sólo después de guardar; la lectura de un documento y sus efectos forman una sola transición. Se comprueba escritura temporal, se conserva copia anterior y se puede recuperar `.bak` o `.tmp` válido. Una partida anterior con sólo `retorno_agua` incorpora las dos misiones nuevas como bloqueadas al cargar, sin perder progreso. Los archivos incompatibles no se sobrescriben. El menú «Partidas» permite exportar e importar JSON con confirmación y recuperar las copias locales `.previa-*`. En Web, la descarga debe verificarse fuera del juego y borrar los datos del sitio elimina también esas copias internas. Opciones en archivo separado. No hay migración desde los prototipos retirados. [Detalles y límites](SAVE_SYSTEM_ARCHITECTURE.md).

## Estado de 0.2.0

El contenido completo se recorre por interfaz y el guardado v1 anterior sigue cargando. La versión interna del guardado sigue siendo 1; las respuestas a mensajes se conservan en las elecciones existentes. Los hilos de Madre, Hermana, Lía, Jefa y Enlace policial llegan por hitos y se abren en el deck. Hay un ambiente mecánico en bucle, con tono distinto por zona, y un sonido de toque; los controles «Ambiente» y «Acciones» ajustan sus buses. La ausencia de partitura musical es una decisión de esta versión centrada en la lectura.

La comprobación técnica se registra en [VALIDACION](VALIDACION.md). Quedan para revisión del autor la continuidad y aprobación de los fondos, la ficción del juego, la duración real y el texto legal. Falta probar dispositivos físicos y exportaciones de escritorio antes de publicar la versión final.
