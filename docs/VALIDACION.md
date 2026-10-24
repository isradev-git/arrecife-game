# Validación del juego y las 21 vistas

Actualizado el 24 de octubre de 2026. Godot 4.7.2 oficial, Mac mini M4, Compatibility. Estas pruebas certifican el alcance descrito; no aprueban el arte ni la ficción.

## Movimiento ambiental del pasaje · 24 oct 2026

El piloto aprobado se implementó sólo en `fiebre_calle`. La capa vectorial sigue las coordenadas del PNG completo y se sitúa bajo hotspots, bandas y paneles. `tests/ambient_fiebre.gd` pasó **17/17 headless** y **23/23 nativas con GPU** en la captura habitual; comprobó avance y parada del reloj, cambio inmediato de `reduced_motion`, recorte 844×390, reentrada sin duplicar efectos, ausencia en el dormitorio y clic real sobre un hotspot bajo la capa. La ejecución opcional de 48 fotogramas pasó **71/71**. [GIF real a 844×390](evidence/ambient_fiebre_844x390.gif), [activo](evidence/ambient_fiebre_activo_844x390.png) y [reducido](evidence/ambient_fiebre_reducido_844x390.png). Las capturas sin publicar de 1280×720 y 844×390, en dos momentos y con movimiento reducido, se regeneran con `ARRECIFE_AMBIENT_CAPTURE=1`; añadir `ARRECIFE_AMBIENT_CLIP=1` genera los 48 fotogramas.

Importación correcta, suite principal **831/831 headless** y **905/905 nativas con GPU**, `preservation.py` correcto y exportación Web completada. En Chromium se recorrió menú → mensaje de la Jefa → contrato → cocina → pasaje, se observaron dos momentos del efecto a 1280×720 y la vista a 844×390, y se volvió desde el menú con «Reducir movimiento» activado. `agent-browser errors` no registró errores. Esto no prueba rendimiento en teléfono físico, Safari ni continuidad artística de las otras vistas. El pulso, el vapor y la bruma son discretos para conservar la lectura; el autor aún debe valorar si su intensidad resulta adecuada.

## Línea base al retomar el trabajo del juego · 23 oct 2026

### Paquete Web para primera prueba privada

Se añadió `tools/build_playtest.py`, que exige Godot 4.7.2, importa y exporta en `game/build/playtest-web/`, exige los siete archivos Web, incorpora una hoja de juego sin soluciones y genera ZIP con `MANIFEST.json` y checksum SHA-256 externo. La comprobación `game/tests/playtest_package.py` falló contra el ZIP antiguo sin manifiesto y pasó con la nueva exportación: contenido exacto, versión, motor y hashes internos. `python3 -m zipfile -t` no detectó daños. El navegador abrió el menú con «Partidas» desde HTTP local y `agent-browser errors` no registró errores de página; se inspeccionó una captura de 1280×720. La primera ejecución llevaba sufijo `-dirty` porque script y documentación aún no estaban confirmados; el paquete identificable por commit limpio debe regenerarse después del commit. No se ha publicado una Release ni se ha probado en el dominio oficial.

En la rama `feat/save-integrity-021`, antes de nuevos cambios jugables: importación `--editor --import --quit` correcta; `tests/run.gd` pasó **827/827 headless** y **899/899 nativas con GPU**; `preservation.py` confirmó originales, canon y único proyecto 2D activo. El recorrido automatizado cubre las 21 vistas, los tres contratos y ambos finales. La ejecución nativa regeneró capturas que se restauraron a la evidencia versionada: este pase no incluye una nueva valoración visual de las 21 vistas. La partida humana completa, su duración, el uso real de «Pistas», el sonido escuchado por el autor y los teléfonos físicos siguen pendientes.

### Bloqueos entre cotas

La prueba desde la interfaz falló primero en dos casos: bajar a El Nudo sin orden de visita y subir a La Fiebre sin acreditación mostraban un aviso genérico. Otra comprobación reprodujo que ese aviso ocupaba casi toda la escena. Ahora cada ruta restringida declara el permiso necesario y el aviso breve usa un panel lateral. `tests/run.gd` pasó **831/831 headless** y **905/905 nativas con GPU**; importación, `preservation.py`, integridad **73/73**, archivos **13/13** y sincronización simulada **7/7** también pasaron como regresión. Se regeneró la exportación Web local, sin volver a recorrer este bloqueo en navegador. Se inspeccionaron [bloqueo a 1280×720](evidence/bloqueo_nudo_1280x720.png) y [bloqueo a 844×390](evidence/bloqueo_nudo_844x390.png): texto completo, cierre accesible y escena visible. No equivale a prueba con teléfono físico ni valida la claridad para un jugador nuevo.

## Guardado y subruta Web · 23 oct 2026

**Segunda tanda, controles de archivo:** `tests/save_file_ui.gd` pasó **13/13 headless** y **16/16 nativas con GPU** después de añadir la recuperación de copias locales. Comprueba exportación a archivo nuevo, rechazo de sobrescritura, archivo inválido, espera de confirmación, cancelación, persistencia tras importar y deshacer una importación mediante respaldo interno. Tras el último ajuste, el recorrido principal pasó **827/827 headless** y **899/899 nativas**, integridad **73/73**, sincronización simulada **7/7**, preservación e importación Godot. Se inspeccionó el [panel a 1280×720](evidence/partidas_1280x720.png) y [844×390](evidence/partidas_844x390.png); el aviso de privacidad queda visible sin desplazar en horizontal móvil. La suite principal headless emitió ocasionalmente avisos de objetos/recursos al salir, con código 0; no son fallos de aserción.

En Chromium, Godot se ejecutó desde `http://127.0.0.1:8765/ensayo-022/`. Se inició una partida, se descargó un JSON real (278 bytes; versión 1, tres contratos), se importó con confirmación y se volvió a «Continuar». Un perfil nuevo abrió sin partida, rechazó `{"version":999}` sin activar «Continuar» e importó la copia válida. En el perfil original se navegó fuera del juego, se borró IndexedDB `/userfs`, se recargó el juego (sin «Continuar») y se restauró el mismo archivo; «Continuar» recuperó el dormitorio. Después se viajó al salón/cocina, se comenzó otra partida y **Copias anteriores** recuperó la partida desde la cocina con confirmación. La [captura Web de copias anteriores](evidence/copias_anteriores_1280x720.png) muestra las ubicaciones y fechas de ambos respaldos. `agent-browser errors` no mostró errores de página en estos recorridos. Son pruebas locales HTTP y Chromium: **no** comprueban HTTPS/cPanel, cuota de almacenamiento, Safari, teléfonos físicos, sincronización cloud ni que una descarga futura no sea bloqueada por otro navegador. El selector nativo de archivos de macOS está configurado, pero no se abrió manualmente en esta tanda; su escritura y lectura se ejercitaron por pruebas de integración con rutas temporales.

Antes de modificar el código: importación correcta; **827/827** comprobaciones headless, **899/899** nativas con GPU y preservación correcta. Después: `tests/save_integrity.gd` **73/73**; `tests/save_sync.gd` **7/7** con repositorio simulado; suite principal **827/827** headless y **899/899** nativas; `preservation.py` correcto. Se forzaron fallo de escritura, reinicio fallido, documento con varios efectos, aceptación y trayecto fallidos, primario/backup corruptos (JSON roto e incompleto), recuperación desde único temporal seguida de guardado/reinicio/importación, temporal enorme junto a primario sano, versión futura incluso en `.tmp`, renombrado/promoción fallidos, misión desconocida e importación inválida. La migración cargó el fixture v1 anterior a las misiones 2 y 3. La suite principal recorre los tres contratos y ambos desenlaces; conserva mensajes y decisiones tras recarga.

La exportación Web final se generó con Godot 4.7.2 en una carpeta limpia `game/build/staging/ensayo-021/`. `index.html`, `.js`, `.pck`, `.wasm` y `.png` respondieron **HTTP 200** desde `/ensayo-021/` en servidor local; el tipo de `.wasm` fue `application/wasm`. La exportación usa rutas relativas y el PCK ya no empaqueta `build/` ni `tests/`. Se inspeccionó el aviso de partida local en la [captura nativa actualizada del menú](evidence/01_menu.png): es legible y cabe en la columna.

**Pendiente de la primera tanda y aún no ejecutado:** cuota Web agotada, interrupción física, cuenta real, RLS, dos usuarios reales, sincronización cloud entre dispositivos, HTTPS/cPanel en el dominio del autor y publicación FTP. La sesión de navegador y la importación manual mediante UI sí se ejecutaron en la segunda tanda descrita arriba. El mock separa identificadores, pero **no demuestra aislamiento del servidor**. La aplicación no tiene nube activa. [Arquitectura](SAVE_SYSTEM_ARCHITECTURE.md).

## Versión 0.2.0 · primera prueba · 22 oct 2026

La importación terminó sin errores. El recorrido automatizado pasó **827/827 comprobaciones headless** y **899/899 nativas con GPU**, sin errores de script; incluye las 21 vistas, los tres contratos, ambos desenlaces, una partida v1 anterior, aparición de chats por hitos, respuestas guardadas y una oferta recuperada tras simular una interrupción del guardado. `preservation.py` confirmó canon, cinco originales, las copias de los dos retratos, logo intacto y un único proyecto activo. La exportación Web 4.7.2 se generó sin errores.

Se inspeccionaron capturas nativas de [conversación a 1280×720](evidence/v0_2_dialogo_1280x720.png) y [844×390](evidence/v0_2_dialogo_844x390.png): el texto comienza junto a los retratos y los torsos terminan en el borde inferior. Los [hilos a 1280×720](evidence/v0_2_chat_1280x720.png) y [844×390](evidence/v0_2_chat_844x390.png) muestran burbujas diferenciadas y respuesta completa. En horizontal pequeño, la prueba abrió el seguimiento de la madre, desplazó al mensaje nuevo y respondió. Se corrigieron dos símbolos que la exportación Web mostraba como glifos rotos.

La Web final se abrió desde HTTP local en Chromium a **844×390**. Se vieron [dormitorio](evidence/v0_2_web_dormitorio.png), [listado del deck](evidence/v0_2_web_deck.png) y [chat con respuestas](evidence/v0_2_web_chat.png). Se eligió una respuesta, se recargó la página, se pulsó «Continuar» y [la réplica seguía guardada](evidence/v0_2_web_respuesta_recarga.png). `agent-browser errors` no registró errores de página. La prueba Web llegó al inicio del contrato, sin repetir allí el recorrido completo de las tres misiones; éste sí pasó en Godot nativo. Quedan por probar teléfonos físicos, Safari/iOS, Android, Windows/Linux y la duración de una partida humana. Los fondos y la ficción del juego aún requieren valoración del autor.

[Log headless 0.2.0](evidence/v0_2_pruebas_headless.log) · [Log nativo 0.2.0](evidence/v0_2_pruebas_nativas.log) · [Preservación 0.2.0](evidence/v0_2_preservacion.log).

## Retratos de diálogo · 22 oct 2026

La prueba nueva reprodujo el fallo de ambos retratos en escritorio y horizontal móvil: cuatro comprobaciones fallaron porque el torso terminaba lejos del borde inferior. Se ajustó el control de imagen sin modificar los PNG originales. La importación, **797/797 comprobaciones headless**, **867/867 nativas con GPU**, preservación y exportación Web pasaron después del cambio. Se inspeccionaron las capturas nuevas de [1280×720](evidence/v1_retratos_1280x720.png) y [844×390](evidence/v1_retratos_844x390.png): ambos torsos descansan en el borde inferior del diálogo. Falta probar el render en un teléfono físico.

## Versión 1.0 candidata · 22 oct 2026

El recorrido automatizado abrió una partida nueva y completó **los tres contratos por la interfaz**, incluidos el informe policial y las dos decisiones del desenlace. Comprobó que los mensajes posteriores no se muestran antes de tiempo, que cada misión llega a `READY_TO_COMPLETE` y sólo se marca `COMPLETED` tras la entrega, y que `Continuar` recupera el final. Salir del último parlamento antes de cerrarlo permite volver a la Jefa; el cierre se abre automáticamente sólo después de «Cerrar la historia». Una partida v1 anterior con sólo `retorno_agua` conserva ubicación, permisos, documentos y elecciones; los dos contratos nuevos entran bloqueados. Un guardado sin la misión original se rechaza.

La importación terminó sin errores. La suite obtuvo **793/793 comprobaciones headless** y **861/861 en ejecución nativa con GPU** en el cierre original de 1.0; `preservation.py` confirmó canon, originales, retratos y proyecto único. La exportación Web se generó y abrió en Chrome local mediante HTTP: se vieron apertura, menú, dormitorio y deck con sólo el primer mensaje; `agent-browser errors` quedó vacío. El recorrido completo de las tres misiones **no se repitió en Web**; sí pasó en Godot nativo. Los dos WAV de ambiente/toque están empaquetados en la exportación. El audio se comprobó por carga, bucle y cambio de tono, no mediante una sesión de escucha del autor.

Se inspeccionaron capturas reales de [contratos en 844×390](evidence/v1_contratos_844x390.png), [cierre a 1280×720](evidence/v1_cierre_1280x720.png) y [cierre a 844×390](evidence/v1_cierre_844x390.png). El contrato activo aparece primero; el panel de cierre encaja en horizontal pequeño y su texto se desplaza. Las 21 vistas conservan fondo y puntos dentro de la ilustración. El objetivo de 30 minutos, la comodidad en teléfonos físicos, Safari/iOS, Android, Windows/Linux, la continuidad artística y la aprobación del guion siguen sin comprobarse. La versión es candidata técnica, pendiente de revisión del autor antes de publicarla.

## Mapa completo · 21 oct 2026

Las 21 vistas están registradas e implementadas con 21 fondos propios: apartamento 3; La Fiebre, El Nudo y Los Puntales 6 cada una. Se comprobó que todas son alcanzables desde el dormitorio y tienen camino de vuelta. Las parejas de salidas aprobadas funcionan en ambos sentidos. La bajada a Los Puntales se bloquea sin `orden_visita` y la subida a La Fiebre se bloquea sin `acreditacion_residencia`; con sus condiciones se recorren. La regresión carga [un fixture representativo del guardado v1 de H1](../game/tests/fixtures/partida_h1_v1.json), sigue cada salida física hasta El Nudo y Los Puntales, regresa y confirma que misiones, permisos, documentos y elecciones no cambian por explorar.

Se ejecutaron los cuatro comandos de «Comprobar» del README con Godot 4.7.2: importación correcta, **633/633 comprobaciones headless**, **698/698 nativas con GPU** y preservación de canon/originales correcta. La exportación Web se generó sin error. En Helium/Chromium con servidor local se abrió una partida, se aceptó el contrato, se salió a La Fiebre y se probó [recarga al menú](evidence/zonas_web_recarga.png) y [«Continuar» en el pasaje](evidence/zonas_web_continuar.png), sin repetir el aviso del parte; `errors` no mostró errores de página. Ese recorrido Web no llegó a El Nudo ni a Los Puntales; los fondos de esas cotas se probaron y capturaron en ejecución nativa.

La prueba nativa de H2 capturó cada vista nueva a 1280×720 y 844×390. Se inspeccionaron las salidas, puntos y bandas en ambos tamaños; muestras: [control de La Fiebre](evidence/zona_fiebre_descenso_1280x720.png), [El Nudo en horizontal móvil](evidence/zona_nudo_acceso_844x390.png), [Los Puntales en escritorio](evidence/zona_puntales_acceso_1280x720.png) y [Los Puntales en horizontal móvil](evidence/zona_puntales_acceso_844x390.png). Se abrieron además [«Pistas» en El Nudo](evidence/zona_nudo_acceso_pistas_844x390.png) y [«Pistas» en Los Puntales](evidence/zona_puntales_acceso_pistas_844x390.png), ambas dentro del área móvil. Los fondos son candidatos aplanados: hay que revisar continuidad visual entre vistas, pequeños detalles de las figuras y coherencia del acabado de Los Puntales con los retratos antes de aprobarlos. En la fecha de H2 todavía estaban pendientes las misiones 2 y 3; se completaron en la candidata 1.0 descrita arriba.

Las secciones siguientes conservan resultados históricos de las iteraciones de H1 y H2. Los conteos vigentes son los de «Versión 0.2.0» arriba.

## Aviso repetido al navegar · 21 oct 2026

Se reprodujo el defecto tras contrastar el parte con la Jefa: entrar en otra habitación y pulsar «Continuar» volvían a mostrar el mismo estado del contrato porque cada reconstrucción de la vista abría la banda inferior. La prueba falló en ambos casos antes del cambio. Ahora la primera entrada conserva la ayuda para explorar y, después, la banda se abre cuando una acción aporta información; al reconstruir la escena empieza oculta. La prueba confirma que el diálogo informa una vez, el regreso desde La Fiebre muestra su texto de trayecto y el paso al baño y «Continuar» no repiten el aviso.

Importación, **239/239 comprobaciones headless**, **268/268 nativas con GPU**, integridad de originales y exportación Web correctas. Se inspeccionó [la navegación sin aviso](evidence/navegacion_sin_aviso.png) y, en la Web final, «Continuar» y el cambio de la cocina al baño sin banda inferior. La comodidad táctil sigue pendiente de teléfono físico.

## Corrección de paneles · 21 oct 2026

Tras la captura enviada por el autor, «Pistas» pasó a un panel lateral compacto: las acciones son filas de texto sin recuadros, la escena permanece visible y el control de puntos queda separado de los destinos. El terminal y las listas del deck siguen el mismo tratamiento; la aceptación del contrato mantiene su botón destacado. Se revisaron visualmente [Pistas a 1280×720](evidence/pistas_1280x720.png), [Pistas a 844×390](evidence/pistas_844x390.png), [contrato](evidence/04_contrato.png), [documento](evidence/06_documento.png) y [terminal](evidence/07_terminal.png). En el apartamento, cuya lista es más larga, el panel permite desplazarse.

La versión corregida obtuvo **234/234 comprobaciones headless** y **262/262 nativas con GPU**. Las nuevas aserciones cubren anchura del panel, ausencia de desplazamiento innecesario en la lista corta, acciones sin recuadro, separación de pestañas y encaje del panel en horizontal móvil. Se generó de nuevo la exportación Web y se abrió «Pistas» en Helium/Chromium: conserva el panel y el desplazamiento de la lista larga. No se ha repetido en Web el recorrido completo del contrato tras esta corrección; las capturas de contrato, documento y terminal son nativas.

## Comprobación de cierre técnico · 21 oct 2026

Se repitieron los cuatro comandos de «Comprobar» del README con Godot 4.7.2: importación correcta, **228/228 comprobaciones headless**, **254/254 nativas con GPU** e integridad de canon y originales correcta. La prueba nativa regeneró capturas; se restauraron las evidencias versionadas, que ya documentaban el mismo recorrido, para no introducir cambios binarios ajenos al cierre.

Se exportó de nuevo la versión Web actual y se recorrió en Helium/Chromium desde un origen local aislado, sin tocar la partida que ya existía en el puerto habitual: apertura, menú, nueva partida, dormitorio, observación de la cama con cierre por X, mensaje, aceptación del contrato, cocina, lectura del terminal, La Fiebre, conversación con la Jefa y límite de El Nudo. Al recargar apareció directamente el menú; «Continuar» recuperó La Fiebre y el avance del parte. La revisión visual confirmó en escritorio los puntos circulares y el texto de la observación actual. No se inspeccionó la consola ni se repitió el recorrido Web en tamaño móvil, Safari o teléfono físico.

## Observaciones temporales · 21 oct 2026

La banda de información aparece al tocar un objeto y se oculta tras **14 segundos** o al pulsar la X. Un nuevo clic o toque sobre el mismo objeto la reabre con el tiempo completo. La prueba automatizada ejercita la cama con ratón y toque, el cierre manual, el vencimiento automático y una nueva apertura; también toca la observación de Velvet y su X a 844×390. En esa resolución se amplió temporalmente la banda para mostrar el texto entero sin desplazarlo. [Dormitorio con observación](evidence/03_observacion.png) · [La Fiebre en móvil horizontal](evidence/observacion_844x390.png). Son capturas nativas reales; en la revisión Web posterior de escritorio se comprobó la X de la cama. El texto de Velvet sigue sin revisión Web en móvil ni en teléfono físico.

## Revisión de menú, escala y textos · 21 oct 2026

El menú muestra el nuevo fondo de ventana con ciudad, sin Sota; cuatro enlaces tipográficos sustituyen las cajas. Las tres pantallas previas se adelantan con clic, toque o Intro y carecen de botón visible. La exploración usa imagen a pantalla completa con controles superpuestos. La elección que avanza el contrato aparece en amarillo y las preguntas/salidas en gris; el nombre accesible también explica su función. Se ampliaron introducción, observaciones, mensaje, documentos, noticia y conversación con la Jefa.

**Corrección tras captura del autor:** los cuadrados resultaban demasiado visibles. Cada hotspot vuelve a tener un punto circular de 10 unidades dentro de un área pulsable acotada de 36 o 48 unidades; el área completa no se dibuja. En ventanas horizontales bajas, los textos y botones aumentan de tamaño sin alterar la escala de escritorio. El menú se reconstruye a 844×390 en la prueba para mostrar su tamaño móvil real. [Pasaje horizontal](evidence/viewport_844x390.png) y [diálogo horizontal](evidence/dialogo_844x390.png) inspeccionados; los puntos y la letra se distinguen mejor sin tapar la ilustración. La comodidad del toque aún requiere un teléfono físico.

Importación y exportación Web sin errores. El recorrido automatizado de esa revisión obtuvo **228/228 comprobaciones headless** y **254/254 nativas**, incluidas **26 capturas**. Se inspeccionaron [menú de escritorio](evidence/01_menu.png), [menú a 844×390](evidence/menu_844x390.png), [dormitorio](evidence/03_dormitorio.png) y [diálogo horizontal](evidence/dialogo_844x390.png): el paisaje ocupa la pantalla, el menú deja visible la ciudad y la jerarquía amarillo/gris se distingue. La revisión Web de la interfaz corregida se completó después, en el recorrido de cierre descrito arriba. Falta verificarla en Safari y teléfonos físicos.

## Revisión del pasaje poblado · 21 oct 2026

Se sustituyó sólo la referencia artística del pasaje por `fiebre_multitud_v2.png`; `fiebre.png` y la primera variante se conservan. Importación Godot sin error; recorrido headless **193/193** y recorrido nativo GPU **216/216**; preservación de canon y originales correcta. El recorrido llegó a La Fiebre, activó el punto de la Jefa y continuó el diálogo. Las capturas reales actualizadas son [pasaje a 1280×720](evidence/10_fiebre.png) y [vista a 844×390](evidence/viewport_844x390.png).

Inspección visual del asistente: las dos entradas y el paso central se leen, la multitud ocupa calle, interiores y pasarelas, y los indicadores siguen sobre la ilustración. En 844×390 las figuras pequeñas pierden detalle, por lo que la variedad de implantes, anatomía, reflejos y legibilidad en teléfono físico siguen pendientes de revisión. La puerta cálida de la derecha parece un local con botellas; hay que decidir si sirve para el encuentro propuesto con la Jefa. Se regeneró la exportación Web y se comprobó que empaqueta la nueva imagen; no se ha repetido la navegación en navegador ni una prueba en móvil físico para esta revisión artística. La variante no está aprobada por el autor.

## Automatización

| Comprobación | Resultado |
| --- | --- |
| Importación del proyecto y arranque | Sin errores de script/importación registrados |
| `tests/run.gd`, headless | **827 comprobaciones, 0 fallos** |
| Mismo recorrido nativo con GPU Apple M4 | **899 comprobaciones, 0 fallos**; incluye los tres contratos y capturas de 0.2.0 |
| `tests/preservation.py` | Canon, cinco originales, dos copias de diálogo y logo original idénticos; un proyecto activo; ninguna dependencia 3D |
| Exportación Web, sin hilos | Generada correctamente con las plantillas 4.7.2 |

Los conteos difieren porque la ejecución GPU incluye comprobaciones de escritura de capturas. Se comprueba logo → autoría → aviso → menú, avance por clic/toque sin botón, espera en móvil vertical, cobertura del menú hasta volver a horizontal y configuración nativa por sensor para que el aviso pueda verse con el teléfono erguido. En las cuatro proporciones se comprueba que cada área táctil sea de 36 o 48 unidades lógicas, contenga un punto de 10 unidades centrado, permanezca sobre la ilustración y no tenga rótulos superpuestos. Un clic cercano a la puerta, fuera del área acotada, no navega; el clic central sí. La prueba vertical de interacción de la escena se ejecuta en modo ordenador dentro de Godot para conservar la regresión de layout; en un móvil la escena queda cubierta. No sumar las cifras como si fuesen casos independientes.

Las pruebas cubren: IDs/destinos y condiciones, cuatro zonas y 21 vistas, partida nueva, bloqueo previo al contrato, menú/opciones/créditos/continuar, intro saltable, deck y mensajes condicionados, aceptación y entrega de los tres contratos, documentos y paginación, terminal e informe, conversaciones y ambas decisiones finales, persistencia, migración desde H1, rechazo de formatos inválidos, recuperación de `.bak` y limpieza de nueva partida. `READY_TO_COMPLETE` y `COMPLETED` se alcanzan con acciones reales de la partida.

Entrada: eventos `InputEventMouseButton` y `InputEventScreenTouch` entregados al viewport. Se pulsa también la opción de diálogo mediante su botón. No son pruebas con un dedo físico.

Resoluciones nativas capturadas: 1280×720, 844×390, 1024×768 y 390×844. Ilustración a pantalla completa con recorte vertical cuando procede, controles dentro del encuadre; diálogo desplazable. En móvil, horizontal es obligatorio. La prueba de layout vertical corresponde al modo ordenador. La lista de acciones sólo aparece al abrir «Pistas».

[Log headless](evidence/pruebas_headless.log) · [Log GPU](evidence/pruebas_nativas.log) · [Integridad](evidence/preservacion.log).

## Navegador

Helium/Chromium, WebGL 2, servidor HTTP local. Comprobados visualmente menú, introducción, dormitorio, deck/mensaje, contrato disponible/aceptado y cambio a cocina. Recargar la página habilita Continuar y restaura la cocina con el contrato activo.

Se ajusta el viewport a 844×390. Un `TouchEvent` de inicio/fin enviado al canvas sobre Deck abre su interfaz. Es una comprobación del recorrido táctil del navegador de escritorio, no una certificación de Safari ni de un teléfono real.

Consola sin errores de ejecución registrados en la revisión del hito 1. En la corrección móvil posterior, se reemplazaron los indicadores con letras y rótulos por puntos de luz y áreas táctiles transparentes. A 844×390 se comprobó visualmente el dormitorio, un `TouchEvent` sobre la puerta que lleva a la cocina, una observación sobre el suministro y la apertura del terminal desde «Pistas». Tras acotar las áreas, se repitió en la nueva exportación Web: toque próximo al punto sin navegar; toque central con navegación correcta.

Antes de la nueva decisión horizontal se probó la exploración Web a 390×844: escena y observación juntas, texto legible y toques dentro/fuera del punto. Esa captura es evidencia histórica del diseño anterior. Con la nueva exportación se emuló iPhone 12 en Helium: en 390×844 aparece «Gira el móvil» y no el menú; al pasar a 844×390 aparece el menú; de vuelta a vertical reaparece el aviso encima del menú. El icono de giro se vio en movimiento. Emulación de navegador, no hardware iOS/Safari.

Con el logo original integrado se repitió la exportación Web. En una sesión de pestaña vacía apareció el logo; se recargó durante la apertura y apareció directamente el menú. Se cerró esa pestaña y se abrió otra en la misma dirección: el logo volvió a aparecer. Una recarga adicional con iPhone emulado en vertical mostró únicamente el aviso de giro, sin repetir logo ni crédito. Se inspeccionó el valor de sesión `el_arrecife_apertura_v1`. Si el navegador impide usar `sessionStorage`, la apertura se muestra de nuevo como degradación segura; aún no se ha probado ese caso en hardware.

La exportación final usa `boot_splash/show_image=false`: se inspeccionó el HTML generado y su clase `show-image--false` oculta la imagen azul de Godot durante la descarga. Queda el fondo neutro `#0c171d`, seguido del logo original sólo en la primera apertura de la pestaña.

[Consola](evidence/web_consola.log) · [Errores](evidence/web_errores.log) · [Antes de recargar](evidence/web_cocina_antes_recarga.png) · [Después](evidence/web_cocina_tras_recarga.png) · [Toque sobre Deck](evidence/web_toque_deck.png).

La persistencia observada es entre recargas del mismo origen y perfil. Borrar almacenamiento, modo privado, restricciones del navegador o cambiar de host/puerto pueden impedir recuperar la partida. No se ha probado persistencia prolongada, cuotas agotadas ni cierres abruptos del dispositivo.

## Evidencia visual real

- [Logo](evidence/00_logo.png), [autoría](evidence/00_autoria.png), [aviso PC](evidence/00_aviso_pc.png), [aviso móvil](evidence/00_girar_movil.png).
- [Web primera visita con el logo original](evidence/web_apertura_primera_visita.png), [recarga directa al menú](evidence/web_apertura_recarga.png), [pestaña nueva con logo](evidence/web_apertura_pestana_nueva.png), [recarga móvil vertical con aviso](evidence/web_apertura_recarga_movil_vertical.png).
- [Web iPhone emulado vertical inicial](evidence/web_iphone_vertical.png), [horizontal con menú](evidence/web_iphone_horizontal.png), [vertical tras menú](evidence/web_iphone_giro_en_menu.png).
- [Menú](evidence/01_menu.png), [menú horizontal pequeño](evidence/menu_844x390.png), [introducción](evidence/02_introduccion.png), [dormitorio](evidence/03_dormitorio.png).
- [Contrato](evidence/04_contrato.png), [cocina](evidence/05_cocina.png), [documento](evidence/06_documento.png), [terminal](evidence/07_terminal.png).
- [Pistas en escritorio](evidence/pistas_1280x720.png) y [Pistas en horizontal pequeño](evidence/pistas_844x390.png).
- [Habitación tras navegar, sin aviso repetido](evidence/navegacion_sin_aviso.png).
- [Baño](evidence/08_bano.png), [Sota sola](evidence/09_monologo.png), [La Fiebre](evidence/10_fiebre.png), [diálogo](evidence/11_dialogo.png).
- [Horizontal móvil](evidence/dialogo_844x390.png), [vertical](evidence/viewport_390x844.png).
- [Dormitorio Web con puntos discretos](evidence/web_movil_sutil_dormitorio.png), [cocina tras toque directo](evidence/web_movil_sutil_toque.png), [acciones a petición](evidence/web_movil_sutil_pistas.png).
- [Escena vertical Web histórica, anterior al bloqueo](evidence/web_movil_vertical_escena.png), [cocina tras toque vertical histórico](evidence/web_movil_vertical_toque.png).

Son capturas del juego ejecutándose, no maquetas. Los PNG fuente de fondos no se utilizan como prueba de interfaz. Se revisaron composición, retratos, etiquetas, desplazamiento y transiciones. Se corrigieron botones superpuestos, referencias a pantallas liberadas al redimensionar y opciones de diálogo recortadas en vertical.

## Límites pendientes

No se han probado Windows/Linux, Safari/iOS, Android real ni teléfonos físicos. La detección móvil Web usa los indicadores `web_android`/`web_ios` de Godot, comprobada con iPhone emulado en H1; queda por validar en Safari y Android físicos. El logo original fue suministrado por el autor para esta pantalla; el texto de derechos requiere revisión editorial. El arco y el sonido básico existen, pero no hay medición de duración ni prueba de escucha del autor. Los fondos son candidatos aplanados sin capas ambientales animadas aprobadas. La ventana y la continuidad de las habitaciones requieren revisión artística. La Jefa aparece en el retrato de conversación; falta su figura ambiental. No se declara ninguna aprobación del autor sobre la ficción o los fondos de esta entrega.
