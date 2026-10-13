# EL ARRECIFE · Tareas del videojuego

Actualizado: **13 de octubre de 2026**. **Título definitivo pendiente**: el autor ha descartado «Pase pendiente» para la versión final. Ese nombre permanece en los archivos anteriores como referencia histórica hasta elegir el nuevo.

Objetivo: terminar un juego breve de investigación en Godot, con personajes y entornos cuidados, jugable en navegador y presentable como proyecto propio. Desarrollan y prueban el autor y el asistente.

**Nombre del local:** Velvet, elegido por el autor. El título del juego sigue pendiente.

**Sota:** solo perfil derecho e izquierdo, decisión del autor del 10 de octubre. Reposo, respiración, conversación y cambios de dirección no muestran frontal ni tres cuartos. La escala de la entrega aprobada sirve de base; se revisará con los recursos nuevos.

**Dirección artística vigente:** renovar sprites, modelos, personajes, objetos, animaciones y entornos por capas para un acabado más pixel art, más cercano a REPLACED. Los recursos actuales son una iteración previa; conservar identidad, universo, versiones y prompts. El 11 de octubre el autor fija las [dos imágenes de estilo aprobadas](trabajo/arte/referencias/pixel_art_v1/README.md) como referencia principal para todo el juego: entorno y personajes. Criterios en [dirección artística](trabajo/direccion_artistica.md). La renovación se incorpora a las tareas existentes, una cada vez.

**Última tarea entregada:** T04 · Desplazamiento provisional en Godot. [Pruebas y capturas](trabajo/arte/revisiones/recorrido_jugable_v1/README.md). Teclado/clic, caminar, aceleración/frenada, colisiones, límites y puntos de acercamiento comprobados; valoración del control por el autor pendiente. El autor aprueba **Sota a 252 de altura** el 13 de octubre, con v7 como dibujo vigente. Esa aprobación no cierra toda T02: retícula artística e iluminación siguen abiertas. **Actual:** T05 · ciclo de caminar, T05.1 rechazada por diferencia de dibujo/oscuridad; corrección de continuidad con v7 y primeros intermedios solicitados después por el autor. T07/T08 conservan sus pendientes por capas y actividad. **Completadas:** T00 y T01.

**Preferencia de Sota · 12 de octubre:** el autor compara en navegador y prefiere **Referencia aprobada (v7)** frente a Base e iluminación. [V7 predeterminada y comprobada](trabajo/arte/revisiones/preferencia_sota_v1/README.md); PNG intactos y alternativa conservada. Próximas revisiones de luz deben conservar ese dibujo; T02/T03 siguen abiertas técnicamente para retícula, iluminación y animación.

El autor pide priorizar generación de recursos tras la limpieza. Se adelanta la referencia de T03; su cierre técnico seguirá necesitando T02. El primer pase fue rechazado; el autor aprueba el estilo de la propuesta v7 con ojos sutiles. Resolver iluminación y escala/retícula antes de producir el resto en serie.

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
| Pixel art | Todas las personas con píxel intenso y rostros reducidos a manchas, con ojos apenas insinuados y sin rasgos detallados de retrato, según la corrección del autor del 11 de octubre. Píxeles y formas trabajados en el recurso original, legibles a tamaño de juego, con retícula y tratamiento coherentes entre sprites, objetos y capas; acabado cercano a REPLACED según la dirección vigente. Un filtro sobre la imagen anterior no cierra la renovación. |
| Personajes | Identidad, anatomía, ropa y equipo coherentes entre vistas y fotogramas; silueta legible; escala y presencia propias. Sota conserva la identidad aprobada en v8 y el deck en la cadera derecha. |
| Animación | Apoyos y peso creíbles, pies acordes al avance, pivote estable, cambios de dirección y velocidad continuos. Revisar a velocidad normal y fotograma a fotograma. |
| Entornos | Recorrido lateral horizontal; la pasarela conserva profundidad entre bordes paralelos. Personajes en el centro transitable, barandilla trasera detrás y delantera más abajo y delante; apoyos comunes solo para recursos del mismo plano. Escala consistente, arquitectura vertical, materiales usados y reparados, luz con jerarquía y profundidad por capas. Rótulos, tecnología y vestuario sostienen el universo. |
| Integración | Contraluz de color del personaje acorde con las fuentes de luz del entorno, criterio aprobado por el autor. Luz de escenario separada del color propio del personaje; evitar neón fijo entre localizaciones. Personajes apoyados en el suelo, sin halos o recortes visibles; sombras y elementos delante/detrás coherentes. Revisar con la cámara, los controles y la iluminación reales del juego. |
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

**Cierre:** identificar la versión de partida y comprobar que un archivo puede recuperarse desde una copia temporal, sin alterar los originales. Registrar ubicación del respaldo. El autor ha autorizado subir el proyecto completo a GitHub el 10 de octubre; subida verificada en `main`. La publicación del juego para jugadores sigue siendo posterior.

**Resultado T01:** Git local, base `740bbb3`, respaldo externo al proyecto y recuperación de un archivo comprobada. [Registro](proceso/RESPALDO_Y_LIMPIEZA.md).

### T02 · Fijar escala, encuadre y acabado en escena — Entregada

**Entrega:** comparación en Godot de Sota, suelo, mobiliario y personajes de Velvet, tomando [Fiebre v8](trabajo/arte/conceptos/fiebre_v8/fiebre_escena_v8.png) como referencia de identidad y composición, y REPLACED como orientación del nuevo acabado pixel art. Elegir resolución de trabajo, retícula, filtrado y encuadre con recursos nuevos a tamaño real.

**Cierre:** Sota tiene proporciones creíbles junto a puertas y personas; el recorrido se entiende y la ciudad mantiene su escala. Revisar el nuevo acabado pixel art integrado, registrar la opción elegida y la valoración del autor. La aprobación de la iteración anterior no cierra esta renovación; los 1280 × 720 de la prueba técnica no constituyen una decisión artística.

**Entrega T02 vigente · T02.1, 12 de octubre:** [comparación de escala y raster](trabajo/arte/revisiones/escala_produccion_v1/README.md), [lámina](trabajo/arte/revisiones/escala_produccion_v1/comparacion.png). Sota v7 aprobada a 232/252/272 junto a Jefa/cabina, ambos perfiles; Jefa aprobada de 244 intacta. Render 1672 × 941 frente a 836 × 471 ampliado 2×. Propuesta: conservar 252/244 y nearest actual; sin aplicar el raster alternativo a la escena. Control Comparar Jefa (x = 1260). Pasan pruebas de escala/renders, exportación y clic Web; el autor aprueba 252 el 13 de octubre, sin cerrar el resto de T02. La retícula común de render no implica que los PNG generativos compartan una retícula artística ni que el escalado a toda ventana esté resuelto. [Comparación anterior de luz conservada](trabajo/arte/revisiones/luz_v2/README.md); fuentes espaciales/reflejos/sombra siguen pendientes.

### T03 · Preparar a Sota para producción — Entregada

**Entrega:** nueva referencia pixel art coherente de ambos perfiles, con medidas de suelo/pivote y detalles de ropa, pelo, manos, correa y deck. Redibujar el recurso manteniendo la identidad aprobada y el nuevo criterio de acabado.

**Cierre:** las vistas representan al mismo personaje, coinciden en proporciones y mantienen el lado del equipo; funcionan a la escala elegida y siguen el acabado de las referencias aprobadas del 11 de octubre. Guardar recurso, prompt y comparación en escena.

**Entrega T03 vigente:** [v7 preferida por el autor](trabajo/arte/revisiones/preferencia_sota_v1/README.md), dos perfiles propios, píxel intenso y ojos mínimos; atlas/JSON intactos. [Base sin neón y prompt](trabajo/arte/personajes/sota/base_v1/README.md) conservados como alternativa. Próxima separación de luz debe mantener el dibujo aprobado. T02.1 compara escala/píxel para fijar referencia; altura 252 aprobada, retícula y escalado final pendientes. Sin respiración ni locomoción nueva.

### T04 · Construir el desplazamiento en Godot — Entregada

**Entrega:** Sota provisional en Velvet con teclado, clic, aceleración, frenada, límites/colisiones y puntos de llegada propios para cada interacción.

**Resultado · 13 de octubre:** `recorrido.tscn` es el arranque; reutiliza el montaje aprobado de `revision_escala.gd`. V7 a 252, pies y = 705 y planos conservados. Acercamientos: guardia x = 300, Jefa 1260, mochila 1480 y acompañante 1580. Límites físicos x = 128–1632. `tests/movimiento.gd` comprueba control y un obstáculo real añadido solo en la prueba; en Velvet los muebles del fondo no bloquean el centro transitable. Exportación y entradas/foco probados en Helium. Sprite estático provisional, sin animación de pasos ni conversaciones. [Registro](trabajo/arte/revisiones/recorrido_jugable_v1/README.md); falta valoración del autor sobre velocidades/frenada.

**Cierre:** llegar sin sobrepasar el destino, detenerse, invertir dirección y perder/recuperar el foco sin movimiento atascado. Comprobar entradas y límites con una prueba pequeña; verificar también la exportación Web. El recurso provisional permite evaluar el control, no cerrar el arte.

### T05 · Terminar el ciclo de caminar — En curso

**T05.1 · Rechazada por el autor:** la marcha propuesta es más clara y no se parece al reposo aprobado. [Archivo de dieciséis poses](trabajo/arte/revisiones/marcha_poses_v1/README.md), PNG/prompts conservados. Se retira Pasos en prueba del recorrido; v7 es de nuevo el único sprite jugable. **T05.1 corrección en curso:** [un contacto editado desde v7 y comparación](trabajo/arte/revisiones/marcha_identidad_v2/README.md). Conservar oscuridad, paleta, masas de sombra, densidad de píxel, proporciones y equipo; reposo original intacto. Propuesta nueva pendiente de valoración. **T05.2:** exploración de intermedios autorizada por petición posterior del autor; integración/calibración del ciclo después de resolver continuidad.

**Continuación · 13 de octubre:** el autor autoriza seguir; no implica aprobación artística nueva. Se entregan [apoyo, cruce e impulso junto al contacto y v7 real](trabajo/arte/revisiones/marcha_poses_oscuras_v1/README.md): cuatro fases de un medio paso derecho, con imagegen integrado y prompts conservados. Alfa/márgenes/altura/rango tonal y dos láminas GPU comprobados; misma escala 252/871 y CUTOUT, sin oscurecimiento por código. Propuesta nueva pendiente de valoración. No se incorpora al recorrido; faltan pierna contraria, perfil izquierdo propio, coherencia de dibujo/proporciones, pivotes y pruebas del bucle con apoyos sincronizados. T05.1 sigue en curso.

**Más posturas · petición posterior del autor:** se adelanta una exploración T05.2 con [tres intermedios y siete posturas en total del primer medio paso derecho](trabajo/arte/revisiones/marcha_intermedios_v1/README.md). Carga, despegue y extensión enlazan las cuatro fases; intentos/prompts de imagegen conservados. Variantes de articulación y color corregidas antes de entregar. Alfa/márgenes/altura/rango tonal, prueba anterior y dos láminas GPU pasan. Objetivo inicial del asistente: **16 dibujos por ciclo completo y perfil**, ajustable al revisar; no cifra ni arte aprobados por el autor. La solicitud de más posturas permite esta exploración sin cerrar T05.1. Falta completar el paso contrario, su transición y el perfil izquierdo propio; luego revisar bucle, tiempo por fase, pivotes, pie plantado y cuerpo/ropa. Recorrido/Web conservan v7. T05 sigue en curso.

**Entrega:** ciclo completo de dos pasos, consistente en ambos sentidos, con sprites propios por fotograma, integrado en el controlador y sincronizado con la distancia recorrida.

**Decisión del autor · 13 de octubre:** solo caminar. La carrera no se necesita por el tamaño de los escenarios y se elimina de T04/T06 y de los criterios de revisión. El autor exige un andar natural y completo, con dibujos de las fases del movimiento.

**Producción T05:** primero ocho poses clave por perfil: contacto, amortiguación/apoyo, cruce y elevación/impulso, repetidas con la pierna contraria. Después añadir intermedios según la revisión del ciclo; ocho poses no fijan el número final de fotogramas. Cada perfil tiene dibujos propios: no reflejar el atlas ni animar solo desplazando/deformando la pose estática. Conservar pelo, mecha, chaqueta, correa y lado físico del deck. Brazos en oposición a las piernas, peso y flexión de articulaciones coherentes, ropa/equipo con movimiento contenido. Celdas iguales y pivote común; una escala basada en los 252 de reposo, sin normalizar por separado la altura de cada fotograma ni eliminar la oscilación natural. El pie apoyado debe mantenerse en el suelo mientras el cuerpo avanza; ajustar distancia del ciclo y velocidad al probarlo en Velvet. Revisar poses y bucle antes de darlo por aprobado.

**Cierre:** revisar apoyos, transferencia de peso, articulaciones, manos, ropa y deck; sin saltos de tamaño, pivote o postura al cerrar el ciclo. Ajustar zancada y velocidad viendo el resultado en escena.

### T06 · Terminar arranque, parada, cambios de dirección y reposo — Pendiente

**Entrega:** inicio de marcha, transición caminar/parar, cambio entre perfiles y reposo con respiración y gestos sutiles. Carrera descartada por el autor el 13 de octubre. No mostrar frontal ni tres cuartos, tampoco durante conversaciones o transiciones.

**Cierre:** ambas direcciones y todas las transiciones son continuas, conservan identidad y equipo y mantienen los apoyos. Movimiento reducido funciona. Registrar revisión visual del autor.

### T07 · Construir Velvet por capas — En curso

**Entrega:** fondo distante, arquitectura, suelo, recepción y elementos de primer plano separados donde haga falta. Reconstruir zonas ocultas al extraer personajes u objetos del fondo existente.

**Prioridad del autor · 11 de octubre:** barandillas y objetos deben quedar delante o detrás del personaje según el espacio; elementos móviles del fondo, humo y luz necesitan planos propios. Se adelanta T07 sin abrir varias tareas a la vez.

**T07.1 — Entregada:** tramo central separado y parche reconstruido, comparación de profundidad en ambos perfiles. PNG originales y prompts conservados; recorte de alfa hace opaco el metal. Prueba GPU de oclusión, escala, escena técnica, importación y exportación Web correctas. [Entrega y límites](trabajo/arte/entornos/velvet/capas_v1/README.md). Pendientes valoración, resto del recorrido y visual Web.

**T07.2 — Entregada; colocación corregida después en T07.3:** el autor exige suelo horizontal en todas las escenas laterales. Fondo nuevo sin barandillas pintadas, bordes de pasarela paralelos y apoyo de Sota/barandilla constante. Pruebas de suela en seis posiciones, oclusión en ambos perfiles, importación y exportación Web correctas. [Entrega](trabajo/arte/entornos/velvet/suelo_v1/README.md). La versión anterior queda conservada; objetos/figurantes aún aplanados y valoración pendiente. [Comprobación posterior en navegador](trabajo/arte/revisiones/suelo_web_v1/README.md): carga, recarga, dos perfiles y cambio de profundidad por clic correctos en Helium/Chromium; Safari/Firefox pendientes.

**T07.3 — Entregada:** el autor detecta apoyo en el borde trasero y falta de barandilla delantera. Se conserva el fondo y se reutiliza la barandilla en dos instancias: bases y = 675/735, pies de Sota en y = 705, capas z = −5/0/+5. Pruebas de centro/apoyos, oclusión GPU en ambos perfiles, importación, escena técnica y exportación correctas; clic y render Web comprobados en Helium. [Cuatro capturas nativas y tres Web](trabajo/arte/revisiones/profundidad_v1/README.md). Sustituye la colocación de T07.2; sin arte nuevo. El autor valora positivamente la mejora y destaca la perspectiva como IMPORTANTÍSIMA. Solo tramo central independiente; T07 sigue en curso.

**T07.4 — Entregada:** barandilla delantera por todo el ancho visible, cinco extensiones del módulo central unidas por postes con solape de remates. Se mantiene trasera sobre el hueco central y se añaden posiciones de revisión Personal/Extremo. [Cuatro capturas nativas y cinco Web](trabajo/arte/revisiones/recorrido_v1/README.md). Apoyos, cobertura, ocultación conjunta, continuidad de largueros y oclusión GPU en ocho combinaciones correctos; importación, escena técnica, exportación y clic en Helium correctos. Sin arte nuevo; aprobación visual posterior del autor, incluida trasera junto a la gente. Repetición de acabado/luz provisional.

**T07.5 — Entregada:** mostrador transparente, interior reconstruido y prompts de imagegen conservados. Solo se integra parche de 278 × 143; objeto independiente en z = −3, base y = 675, Sota en centro y = 705. Controles de visibilidad y ubicación frente al mostrador. [Ocho capturas](trabajo/arte/revisiones/mostrador_v1/README.md); alfa/apoyo/orden, GPU en ambos perfiles y conservación fuera del parche, pruebas previas, exportación y clic Web correctos. Generación cambia detalles; recurso nuevo pendiente de valoración.

**T07.6 — Entregada:** figurante completa de perfil izquierdo, equipo de superficie e interior vacío generados con imagegen; [recursos y prompts](trabajo/arte/entornos/velvet/recepcion_v1/README.md). Parche ampliado a 278 × 235, figurante en z = −4 con pies y = 675, equipo en z = −2 con base y = 538. Controles de visibilidad independientes. [Doce capturas](trabajo/arte/revisiones/recepcion_v1/README.md); alfa, apoyos, cuerpo oculto por mostrador y Sota delante en ambos perfiles comprobados en GPU; pruebas previas y clic Web correctos. Arte nuevo pendiente de valoración. Contraluz manual acorde a recepción; sin animación ni cambio de historia.

**T07.7 — Entregada:** persona con mochila junto a escalera separada, perfil derecho y pelo corto corregido con imagegen; primer intento y tres prompts conservados. [Recursos](trabajo/arte/entornos/velvet/acceso_v1/README.md). Parche de 96 × 245, figura z = −4, altura 236 y apoyo y = 675; controles Acceso/Junto al acceso. [Diez capturas](trabajo/arte/revisiones/acceso_v1/README.md); alfa, apoyo, contraluz separado, parche fuera idéntico, barandilla delante y Sota delante en ambos perfiles comprobados en GPU. Pasan pruebas previas, importación/exportación y clic Web. Nueva entrega pendiente de valoración; contraluz manual, sin animación ni cambio de historia.

**T07.8 — Entregada:** acompañante de abrigo oscuro de perfil izquierdo, altura 248 y apoyo y = 675, z = −4; [PNG, fondo sin ambas personas y prompts](trabajo/arte/entornos/velvet/acompanante_v1/README.md). Parche común ampliado a 154 × 261, materiales/visibilidad independientes y posición de Sota x = 1625. [Catorce capturas](trabajo/arte/revisiones/acompanante_v1/README.md). Prueba de acceso reutilizada para ambas figuras: pasan alfa, apoyo, contraluz propio, parche fuera idéntico, barandilla delante y Sota delante en ambos perfiles; pruebas previas y Web correctos. Arte nuevo pendiente de valoración; diálogos todavía sin implementar.

**T07.9 — Entregada:** guardia de perfil derecho con deck azul, frontal transparente e interior reconstruido; [tres PNG y prompts](trabajo/arte/entornos/velvet/cabina_v1/README.md). Parche limitado a 129 × 286; guardia de 260 y apoyo y = 675 detrás del frontal, ambos detrás de Sota. Controles Guardia/Cabina y Frente al guardia; panel se aparta al revisar el extremo izquierdo. [Catorce capturas](trabajo/arte/revisiones/cabina_v1/README.md). Pasan alfa/apoyos, GPU de ventanilla/frontal/Sota, parche fuera idéntico, pruebas anteriores, importación/exportación y clic Web. Arte nuevo pendiente de valoración; personajes estáticos y contraluz manual. Funciones de conversación y cambio de cota decididas por el autor, anotadas en T11/T19.

**Criterio de separación · 12 de octubre:** aprobado por el autor para personas que tendrán actividad, interacción o necesiten un plano propio. No separar por sistema toda la figuración distante decorativa. El autor propone posibles diálogos con personas de Velvet; selección/textos al integrar T11.

**Siguientes entregas de T07:** priorizar restantes objetos/personas según actividad o interacción, después arquitectura/ciudad; reservar humo de cada profundidad y piezas móviles para su producción en T09. Cada extracción debe incluir fondo reconstruido y revisión integrada antes de seguir.

**Cierre:** Sota recorre la escena con perspectiva, suelo y oclusiones correctos; todas las capas siguen el nuevo acabado pixel art cercano a REPLACED, coherente con los personajes, y no revelan huecos. El movimiento de cámara, si lo hay, conserva la composición y permite comprobar profundidad.

### T08 · Producir la jefa de la Nómina — En curso

**Entrega:** personaje independiente, con identidad, equipo de trabajo, reposo y acción breve relacionada con el libro o la recepción. Su presencia no la convierte en recepcionista permanente del local.

**T08.1 — Entregada, 12 de octubre:** el autor aporta retratos de Sota y de la Jefa, identifica a esta última con la figura del mostrador y pide adaptar su sprite. Ambos PNG originales guardados sin editar; [referencias y diseño de diálogo](trabajo/arte/personajes/retratos_v1/README.md). [Sprite de perfil izquierdo y prompt](trabajo/arte/personajes/jefa/pixel_v1/README.md): pelo recogido, abrigo burdeos, negro/dorado y hardware de mandíbula/cuello; mantiene píxel intenso y ojo mínimo. Altura 244, apoyo y = 675 y planos de recepción conservados. [Doce capturas](trabajo/arte/revisiones/jefa_v1/README.md); pasan GPU de mostrador/Sota, alfa/apoyos, regresiones relevantes, importación/exportación y clic Web. El autor aprueba el sprite pixel art el 12 de octubre; sin animación ni diálogo.

**T08.2 — Entregada:** [libro abierto independiente](trabajo/arte/personajes/jefa/libro_v1/README.md) con original y prompt de imagegen; tapas burdeos, páginas con marcas abstractas, sin cifras ni pistas. El libro de la Nómina ya está establecido en canon/guion; aspecto propuesto por el asistente. Montaje 56 × 18, x = 1318, tapa apoyada y = 538 y z = −5, manos de Jefa delante z = −4. Control Libro. [Catorce capturas](trabajo/arte/revisiones/libro_v1/README.md); pasan alfa/apoyo, GPU de manos/páginas/Sota, escala, capas, mostrador, importación/exportación y clic Web. PNG de Jefa aprobado intacto; libro nuevo pendiente de valoración. Sin animación, anotación ni diálogo.

**Siguiente cierre de T08:** reposo/respiración y acción breve con el libro propio; conservar identidad, manos, apoyo y oclusión al animar. No convertir el equipo de recepción en el libro de la Nómina.

**Cierre:** se integra en escala, luz y postura con Sota; rostro, ropa, manos y objetos son consistentes. Su acción se entiende a tamaño real y su diseño queda revisado con el autor.

### T09 · Dar actividad a la Fiebre — Pendiente

**Entrega:** figuración necesaria y actividad de infraestructura: personas con acciones diferenciadas, luces, ventilación, humedad y vapor. Separar del fondo los secundarios que deban animarse o interactuar; conservar aplanada la figuración distante puramente decorativa. Elementos móviles de ciudad en su plano de profundidad; emisores de humo detrás/delante separados, sin teñir globalmente la escena. Luz y reflejos ligados a fuentes del entorno y a sus oclusiones. Reparar la imagen subyacente antes de animar cada elemento extraído.

**Cierre:** observar la escena durante un minuto: los ciclos no distraen ni se sincronizan de forma evidente, la ciudad parece habitada y los puntos del caso siguen legibles. Comprobar movimiento reducido y coste de renderizado en Web.

### T10 · Integrar encargo y primer documento — Pendiente

**Entrega:** acercamiento a la jefa, conversación inicial y lectura de E0 con controles de Godot; recibir también P2 conforme al encargo existente. Preparar únicamente el estado necesario para este tramo.

**Presentación decidida por el autor, 12 de octubre:** oscurecer la escena, retrato de Sota a la izquierda, retrato del interlocutor a la derecha y diálogo entre ambos. [Originales guardados](trabajo/arte/personajes/retratos_v1/README.md). Retratos ilustrados con detalle facial; sprites en escena siguen solo de perfil y rostro apenas definido. Resolver tamaños, opciones, tipografía y foco al implementar, sin construir ahora la interfaz.

**Cierre:** iniciar y terminar la conversación, guardar las copias en la libreta y volver al movimiento con foco correcto. Texto legible y controles utilizables con ratón y teclado; contenido cotejado con el guion.

### T11 · Revisar Velvet como escena completa — Pendiente

**Entrega:** versión Web del primer tramo con personaje, entorno, actividad, encargo y documento funcionando juntos.

**Posibilidad autorizada · 12 de octubre:** conversar con algunas personas de esta escena. Seleccionar cuáles y preparar diálogos breves compatibles con canon/guion; no convertir a toda la figuración en conversaciones obligatorias ni añadir automáticamente pruebas del caso. Textos e interacción pendientes.

**Cabina y guardia · decisión del autor, 12 de octubre:** incorporar «Hablar con el guardia» como interacción propia, además de la función de viajar de T19. Consultar canon y guion antes de redactar; sin inventar pruebas, identidad o un bloqueo de acreditación para Sota. Revisar la antigua puesta en escena de vigilancia/salida de personal para que comunique también el nuevo acceso entre cotas. Arte preparado en T07.9, conversación pendiente.

**Cierre:** el autor prueba caminar, arrancar/parar, cambios entre perfiles, interacción y lectura. Registrar problemas concretos y corregir los que afecten al estándar visual o de control. Cerrar con valoración del conjunto antes de extenderlo a las otras pantallas.

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

**Cambio de cota · decisión del autor, 12 de octubre:** la cabina del guardia de Velvet será un punto de viaje. Ofrecer «Cambiar de cota» separado de «Hablar»; conectar destinos descubiertos con permisos y retorno coherentes con canon/guion. Bajar es fácil y subir exige autorización; el encargo ya acredita a Sota, sin añadir un trámite artificial. Preparar señalización legible y transición al integrar las otras pantallas. T07.9 solo aporta las capas visuales; viaje pendiente.

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
| Dirección de Sota | 10 oct 2026 | Solo perfiles en la revisión Godot; frontal y tres cuartos conservados como historial | Comprobación adaptada a dos vistas | Autor aprueba el aspecto en escena y descarta frontal; respiración y animaciones todavía pendientes |
| GitHub | 10 oct 2026 | Proyecto e historial en isradev-git/arrecife-game, main | Clonación desde GitHub: 129 archivos idénticos y 7 commits hasta 5e8a2d7; cierre posterior adicional | Autor autoriza incluir canon y documentos; él lo hará privado |
| Dirección pixel art | 10 oct 2026 | Dirección y criterios de T02/T03/T07 actualizados; cambio aplicable a toda la cola de recursos | Revisión documental; no se generan ni sustituyen recursos en esta entrega | Autor pide sprites/modelos y entornos más pixel art, cercanos a REPLACED; nuevas versiones y revisión en escena pendientes |
| Referencias pixel art | 11 oct 2026 | [Dos PNG aportados por el autor](trabajo/arte/referencias/pixel_art_v1/README.md), guardados sin editar | Copias idénticas a los adjuntos y enlaces comprobados | Autor aprueba este acabado para todo el juego; sprites, capas y animaciones aún pendientes |
| T03/T02 · pase pixel art | 11 oct 2026 | [Atlas, prompts](trabajo/arte/personajes/sota/pixel_v1/README.md) y [cuatro capturas nativas](trabajo/arte/revisiones/escala_v3/README.md); comparación anterior/nuevo en Godot | Importación, prueba de ambas versiones/transparencia/apoyos, escena técnica y exportación Web correctas | Asistente revisa el render; pendientes valoración del autor, retícula/luz y visual Web (control Safari falla) |
| T03 · corrección de acabado | 11 oct 2026 | [Atlas v3 y prompt](trabajo/arte/personajes/sota/pixel_v2/README.md), [comparación nativa](trabajo/arte/revisiones/escala_v4/README.md) | Importación, perfiles/alturas/apoyos/alfa/filtros, escena técnica y exportación correctas | Autor rechaza v2 y exige píxel intenso y caras sin definición para todas las personas; v3 pendiente de valoración |
| T03 · ojos sutiles | 11 oct 2026 | [Atlas v7 y prompts](trabajo/arte/personajes/sota/pixel_v3/README.md), [comparación nativa](trabajo/arte/revisiones/escala_v5/README.md) | Importación, perfiles/alturas/apoyos/alfa/filtros, escena técnica y exportación Web correctas | Autor precisa ojos muy poco visibles, sin cara vacía; propuesta pendiente de valoración, retícula, luz y visual Web |
| T02 · color de luz | 11 oct 2026 | [Shader y ocho capturas](trabajo/arte/revisiones/luz_v1/README.md), PNG v7 conservado | Neón recoloreable, alfa invariante, muestras de cara/ojos/ropa/equipo conservadas y restauración idéntica del render original; pruebas, importación y exportación correctas | Autor aprueba el estilo y pide resolver rosa fijo; prueba de color pendiente de valoración, sin iluminación espacial terminada ni visual Web |
| Criterio de iluminación | 11 oct 2026 | Dirección y revisión de luz actualizadas | Revisión documental; sin cambios de código ni recursos | Autor aprueba conservar el contraluz de color coincidiendo con el entorno; integración automática y luz espacial todavía pendientes |
| T03 · base sin neón | 11 oct 2026 | [Base, prompt](trabajo/arte/personajes/sota/base_v1/README.md) y [diez capturas](trabajo/arte/revisiones/luz_v2/README.md), v7 conservada | Importación, perfiles/alturas/apoyos/alfa/filtros, material y render GPU correctos; color/dirección separados e intensidad cero restaura la base; exportación Web correcta | Autor autoriza continuar; variante entregada, pendiente de valoración, retícula, luz de escenario, visual Web y animación |
| T07.1 · primera capa | 11 oct 2026 | [Barandilla, fondo y prompts](trabajo/arte/entornos/velvet/capas_v1/README.md), [seis capturas](trabajo/arte/revisiones/capas_v1/README.md) | GPU: metal opaco delante, Sota visible entre barrotes y orden inverso correcto en ambos perfiles; escala, escena técnica, importación y exportación Web correctas | Autor prioriza profundidad y elementos móviles/humo/luz; entrega parcial pendiente de valoración. Resto de capas, movimiento y visual Web pendientes |
| T07.2 · suelo horizontal | 11 oct 2026 | [Fondo, variantes y prompts](trabajo/arte/entornos/velvet/suelo_v1/README.md), [seis capturas](trabajo/arte/revisiones/suelo_v1/README.md) | Apoyo constante en seis x, base de barandilla, render GPU de oclusión en ambos perfiles; importación y exportación Web correctas | Autor valora T07.1 y exige suelo recto; T07.2 pendiente de valoración. Figuración/objetos aún aplanados; movimiento y visual Web pendientes |
| T07.2 · visual Web | 11 oct 2026 | [Tres capturas de navegador](trabajo/arte/revisiones/suelo_web_v1/README.md) | Helium/Chromium 154, WebGL 2.0: carga, recarga, dos perfiles y delante/detrás por clic correctos; sin errores registrados | Sin aprobación estética nueva; Safari/Firefox, teclado, rendimiento y juego completo pendientes |
| T07.3 · centro y dos bordes | 11 oct 2026 | [Montaje y siete capturas](trabajo/arte/revisiones/profundidad_v1/README.md) | Centro equidistante, seis apoyos, orden fijo y oclusión GPU en ambos perfiles; importación, escena técnica, exportación y clic Web correctos | Autor corrige profundidad y orden anteriores y después valora positivamente la mejora; perspectiva destacada como IMPORTANTÍSIMA. Solo tramo central; resto de capas y movimiento pendientes |
| T07.4 · barandillas del recorrido | 11 oct 2026 | [Montaje y nueve capturas](trabajo/arte/revisiones/recorrido_v1/README.md) | Bases, cobertura y visibilidad conjunta, dos largueros sin huecos, render GPU de ocho posiciones/perfiles; importación, escena técnica, exportación y clic Web correctos | Autor aprueba visualmente el montaje y la trasera junto a la gente; repetición de acabado/luz, resto de capas y movimiento pendientes |
| T07.5 · mostrador independiente | 11 oct 2026 | [Recursos y prompts](trabajo/arte/entornos/velvet/mostrador_v1/README.md), [ocho capturas](trabajo/arte/revisiones/mostrador_v1/README.md) | Alfa/base/orden, GPU de Sota en ambos perfiles y render intacto fuera del parche; barandillas, escala, escena técnica, importación, exportación y clic Web correctos | Mostrador nuevo pendiente de valoración; equipo/figurantes, arquitectura/ciudad y movimiento pendientes |
| T07.6 · figurante y equipo | 11 oct 2026 | [Tres recursos y prompts](trabajo/arte/entornos/velvet/recepcion_v1/README.md), [doce capturas](trabajo/arte/revisiones/recepcion_v1/README.md) | Alfa/apoyos/orden, GPU de mostrador y Sota, parche sin cambios fuera, barandillas, escala, escena técnica, importación, exportación y clic Web correctos | Autor autoriza continuar; entrega nueva pendiente de valoración. Resto de figurantes/objetos, arquitectura/ciudad, luces espaciales y movimiento pendientes |
| T07.7 · figurante del acceso | 12 oct 2026 | [Figura, fondo, variantes y prompts](trabajo/arte/entornos/velvet/acceso_v1/README.md), [diez capturas](trabajo/arte/revisiones/acceso_v1/README.md) | Alfa/apoyo/orden, contraluz GPU, parche fuera idéntico, oclusión de figura y Sota, pruebas anteriores, importación/exportación y clic Web correctos | Autor valora progreso y pide continuar con calma; nueva entrega pendiente de valoración. Persona contigua, resto de capas, luces espaciales y movimiento pendientes |
| T07.8 · acompañante y criterio de interacción | 12 oct 2026 | [Dos recursos y prompts](trabajo/arte/entornos/velvet/acompanante_v1/README.md), [catorce capturas](trabajo/arte/revisiones/acompanante_v1/README.md) | Dos modos de prueba de acceso, alfa/apoyos/materiales, parche fuera idéntico, GPU de figura/Sota, pruebas previas, importación/exportación y clic Web correctos | Autor aprueba criterio de separación y propone diálogos; recursos nuevos pendientes de valoración. Ambas figuras estáticas, fuentes espaciales, conversaciones y resto de capas pendientes |
| T07.9 · guardia y cabina | 12 oct 2026 | [Recursos/prompts](trabajo/arte/entornos/velvet/cabina_v1/README.md), [catorce capturas](trabajo/arte/revisiones/cabina_v1/README.md) | GPU de ventanilla/frontal/Sota, alfa/apoyos/panel, parche fuera idéntico, regresiones y Godot/Web correctos | Autor establece conversación y viaje; funciones pendientes, arte nuevo pendiente de valoración |
| T08.1 · Jefa y retratos de diálogo | 12 oct 2026 | [Originales](trabajo/arte/personajes/retratos_v1/README.md), [sprite y prompt](trabajo/arte/personajes/jefa/pixel_v1/README.md), [doce capturas](trabajo/arte/revisiones/jefa_v1/README.md) | Copias SHA-256, alfa/apoyos/planos, GPU de mostrador/Sota, regresiones relevantes, importación/exportación y clic Web correctos | Autor fija identidad de Jefa y composición de diálogos; adaptación nueva pendiente de valoración. T08 sigue abierta para animación/acción; diálogo posterior |
| T08.2 · aprobación de Jefa y libro | 12 oct 2026 | [Libro y prompt](trabajo/arte/personajes/jefa/libro_v1/README.md), [catorce capturas](trabajo/arte/revisiones/libro_v1/README.md) | Alfa/apoyo/orden, GPU de páginas/manos/Sota, escala/capas/mostrador, importación/exportación y clic Web correctos | Autor aprueba sprite pixel art de Jefa; PNG intacto. Libro nuevo pendiente de valoración; reposo/acción e interfaz pendientes |
| Preferencia de Sota v7 | 12 oct 2026 | [Registro y tres capturas Web](trabajo/arte/revisiones/preferencia_sota_v1/README.md) | Atlas/shader inicial, ambas variantes, perfiles/alturas/luz, GPU de capas/recepción, exportación y clic Web correctos | Autor prefiere v7 tras comparar en navegador; queda predeterminada. Luz adaptable debe conservar el dibujo; PNG anteriores intactos |
| T02.1 · escala junto a Jefa y cabina | 12 oct 2026 | [Lámina y capturas](trabajo/arte/revisiones/escala_produccion_v1/README.md) | Tres alturas/dos perfiles/dos posiciones, Jefa invariable, apoyos y nearest, GPU de comparación, exportación/clic Web y lámina HTML correctos | Autor autoriza comparar; propuesta del asistente 252/244 y raster actual, valoración pendiente. T02 no completada; movimiento después |

| T04 · altura aprobada y recorrido provisional | 13 oct 2026 | [Código, capturas y comprobaciones](trabajo/arte/revisiones/recorrido_jugable_v1/README.md) | Control, 14 llegadas sin sobrepasar, límites, colisión física, foco, perfiles/planos, Godot nativo y Web | Autor aprueba 252; controlador entregado para valorar. Sin animación ni diálogos; siguiente T05 |

| T04 · retirada de carrera y criterio de T05 | 13 oct 2026 | [Solo caminar](trabajo/arte/revisiones/solo_caminar_v1/README.md) | Controlador/pruebas/panel sin carrera; exportación y Web comprobadas | Autor descarta correr y exige sprites por fase de marcha. T05 pendiente de producción/revisión del ciclo |

| T05.1 · poses clave de marcha | 13 oct 2026 | [Originales/prompts](trabajo/arte/personajes/sota/caminar_v1/README.md), [láminas y prueba](trabajo/arte/revisiones/marcha_poses_v1/README.md) | Marco/pivote/escala/alfa, fases por distancia, ambos perfiles, retorno v7, controlador y Godot/Web comprobados | Propuesta nueva pendiente de valoración; intermedios y calibración T05.2, T05 en curso |

| T05.1 · rechazo y corrección de continuidad | 13 oct 2026 | [Contacto v2 y comparación](trabajo/arte/revisiones/marcha_identidad_v2/README.md) | Retirada del juego, controlador v7 probado, una pose nueva comparada con shader/escala comunes | Autor rechaza diferencia de dibujo/oscuridad; nueva pose pendiente de valoración, ciclo por rehacer |

| T05.1 · primer medio paso oscuro | 13 oct 2026 | [Tres poses, prompts y dos láminas](trabajo/arte/revisiones/marcha_poses_oscuras_v1/README.md) | Alfa/márgenes/altura/rango tonal y render Godot con v7 original, escala/shader comunes | Autor autoriza continuar; serie nueva pendiente de valoración. Sin ciclo ni integración Web; pierna contraria/perfil izquierdo y pivotes pendientes |

| T05 · más posturas e intermedios | 13 oct 2026 | [Siete posturas, intentos/prompts y dos láminas](trabajo/arte/revisiones/marcha_intermedios_v1/README.md) | Alfa/márgenes/altura/rango tonal, modo anterior y GPU comprobados; variantes demasiado claras corregidas | Autor pide más posturas; objetivo inicial del asistente 16 por ciclo/perfil, ajustable. Sin aprobación artística ni bucle; otro paso/perfil y apoyos pendientes |
