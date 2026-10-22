# Diseño vigente · aventura ilustrada

## Experiencia

Primera persona desde Sota. Vistas fijas, exploración por clic/toque, conversaciones y decisiones breves. Objetivo de la primera entrega completa: unos 30 minutos, ampliables con nuevos contratos y localizaciones. El hito actual es una base jugable más corta; su duración no se ha medido con una sesión del autor.

Al arrancar: logo original «EL ARRECIFE PRODUCTS» suministrado por el autor → crédito del universo original de Israel Zamora → aviso de orientación → menú. Cada pantalla avanza sola tras una breve espera o al tocar la pantalla, hacer clic o pulsar Intro; no muestra un botón de salto. En Web se marca al empezar la apertura en `sessionStorage`: recargar la misma pestaña va directamente al menú, mientras que una pestaña nueva muestra la secuencia. La carga del motor usa fondo neutro, sin otro logo. En móvil, la tercera espera a que la pantalla esté horizontal; si se vuelve a vertical durante el juego, un aviso cubre la interfaz hasta recuperar la orientación. El ordenador muestra «disfruta» y no se bloquea por la forma de su ventana. Los textos de crédito y orientación están en `story.json`; la imagen original del logo se conserva sin modificar.

El menú usa una vista ilustrada de ciudad desde una ventana de una cota aún sin identificar, ajena al dormitorio de Sota. Los enlaces son líneas tipográficas sin cajas ni retrato de protagonista. Es una candidata visual del asistente, no arte final aprobado. Las vistas jugables dejan la ilustración a pantalla completa y sitúan los controles en bandas translúcidas sobre la propia escena.

La estructura propone una actividad concreta: comprobar un cargo de reparación de agua. El mundo aparece en recibos, lecturas, desplazamientos y conversaciones. No hay combate, avatar caminando ni cámara libre.

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
| Contrato «El parte del agua», afectada, recibo, orden de visita y diálogos | **Ficción nueva pendiente de aprobación** |
| Deck de Sota: memoria local, mensajes, contratos y notas | Interfaz propuesta compatible con tecnología canónica; no teléfono mágico ni transporte |

No se incorporan tramas ni revelaciones de los protagonistas de las novelas. El autor amplió el canon con Sota y la regla sobre la policía el 22 oct 2026; los contratos y diálogos actuales del juego siguen pendientes de aprobación. `sources/`, `universo/` y los documentos literarios externos citados por el canon no existen en el checkout inspeccionado; esta entrega contrasta con el canon local disponible, no certifica revisión de fuentes ausentes.

## Mapa y alcance

| Zona | Vistas registradas | Construido |
| --- | --- | --- |
| Apartamento | Dormitorio, salón/cocina, baño | 3 navegables |
| La Fiebre | Pasaje, umbral, rincón, galería, suministros, control de descenso | 6 navegables |
| El Nudo | Acceso, taller, puesto de red, mercado, archivo, paso inferior | 6 navegables |
| Los Puntales | Acceso, taller, frente de trabajo, soportes, presión, verificación | 6 navegables |

Las cotas urbanas visitadas son **La Fiebre (4), El Nudo (3) y Los Puntales (2)**. El apartamento es la cuarta zona jugable y está en La Fiebre. El autor aprobó 3 vistas del apartamento y 6 por cota, con sus nombres y conexiones en [el diseño de 21 vistas](superpowers/specs/2026-10-21-21-vistas-zonas-design.md). Las vistas de calles y pasos públicos deben transmitir ciudades muy pobladas: en La Fiebre coinciden residentes, personal de servicio y visitantes de mayores recursos. La densidad ambiental no crea por sí sola nuevos personajes conversables ni altera las restricciones de acceso entre cotas.

Las puertas conectan habitaciones. La salida del apartamento se habilita al aceptar el contrato. Los trayectos entre cotas tienen rutas explícitas en `world.json`; bajar y subir se comprueban por separado. La residencia y la orden de visita justifican regresos concretos. El deck informa de los lugares y nunca permite saltarse estos accesos. Las 21 vistas forman un grafo alcanzable con camino de vuelta.

## Contrato principal

ID `retorno_agua`. Mensaje recibido → AVAILABLE → aceptación → ACTIVE → copia de lectura → contraste con Jefa → equipo en El Nudo (pendiente) → comprobación física en Puntales (pendiente) → READY_TO_COMPLETE → entrega explícita → COMPLETED.

Las fases futuras se prueban con datos sintéticos, pero **no se completan en el juego actual**. El hito termina mostrando el siguiente paso y conserva el contrato activo. El cierre narrativo, los honorarios concretos y una decisión con consecuencias finales se escribirán en otro hito.

## Interacciones

Hotspots con ID por pantalla, tipo, etiqueta, rectángulo normalizado, condición visible y disponible, y destino. El centro del rectángulo sitúa un punto circular de 10 unidades lógicas. Su área pulsable acotada mide 36×36 unidades en escritorio y 48×48 en horizontal bajo; el rectángulo normalizado completo no captura toques. No hay rótulos sobre la ilustración. «Pistas» abre, sólo a petición, un panel lateral compacto con acciones tipográficas y permite ocultar los puntos; las listas largas se desplazan dentro del panel. El deck y el terminal emplean el mismo lenguaje para sus entradas; las decisiones principales conservan mayor peso visual. La ilustración llena la ventana y puede recortarse por arriba/abajo en proporciones distintas de 16:9; los puntos se calculan sobre la imagen renderizada y permanecen dentro de la zona visible.

La experiencia móvil sólo está disponible en horizontal. La condición de candidata de los fondos se documenta fuera de la interfaz jugable.

La banda inferior aparece una vez como ayuda al terminar o saltar la introducción, y después cuando una acción aporta información, como observar, completar un diálogo o recorrer un trayecto con texto propio. Se puede cerrar con la X y también desaparece tras 14 segundos. Entrar en otra habitación o continuar una partida no repite el estado del contrato.

- OBJECT: observación breve, sin diálogo modal.
- PERSON: diálogo con temas, condiciones, efectos, elecciones y salida.
- TERMINAL: menú de registros locales con arranque breve.
- DOCUMENT: visor de papel, páginas y lectura persistente.
- DEVICE: interfaz del deck.
- NAVIGATION: ruta y cambio de vista.
- SPECIAL_EVENT: evento contextual; los descensos ya son NAVIGATION.

En conversaciones, Sota izquierda e interlocutora derecha, mirando al centro con sus PNG originales. Sólo Sota en monólogos. Escena oscurecida, hablante iluminado y oyente atenuado. Texto central, desplazable. Las decisiones que avanzan el contrato se identifican en amarillo; las preguntas y salidas opcionales, en gris, con nombre accesible que explicita el papel de la opción. Los parlamentos, documentos y observaciones del primer tramo se ampliaron sin convertirlos en exposición enciclopédica. Texto completo inmediatamente: no se necesita ajuste de velocidad de escritura.

## Arquitectura

`Content` carga cuatro JSON: mundo, historia, diálogos y misiones. `State` conserva datos, evalúa condiciones, controla rutas/fases y escribe el guardado. Las interfaces sólo presentan esos datos y solicitan efectos.

`main.gd`: menú, intro, exploración y apertura de paneles. `startup.gd`: tres pantallas previas y aviso reutilizado al girar el móvil. `viewpoint.gd`: imagen e indicadores. `dialogue.gd`: secuencia de nodos y opciones. `device.gd`: secciones del deck. `ui.gd`: controles y tema compartidos. Una escena raíz; las vistas son datos y usan el mismo componente. Sin dependencias externas ni frameworks.

Guardado v1: vista/zona, misiones, flags, descubrimientos, documentos, mensajes, lugares y elecciones. Validación de tipos e IDs, escritura temporal verificada, copia anterior, rechazo de versiones desconocidas y recuperación de `.bak`. Nueva partida pide confirmación y conserva copia fechada. Opciones en archivo separado. No hay migración desde los prototipos retirados.

## Próximos hitos

1. **H1 técnico:** fundación y primer tramo comprobados; revisión narrativa/artística del autor pendiente.
2. **H2 técnico:** 21 vistas, navegación y fondos candidatos implementados y comprobados; producir fuentes por capas tras la aprobación artística.
3. **H3:** diseñar las misiones 2 y 3, resolver el contrato y el final, y editar el ritmo hasta la duración objetivo.
4. **H4:** sonido, arte definitivo, accesibilidad, dispositivos reales y exportaciones de escritorio.
