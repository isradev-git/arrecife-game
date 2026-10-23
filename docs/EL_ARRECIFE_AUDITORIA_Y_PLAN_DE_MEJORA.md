# EL ARRECIFE — Auditoría y plan de mejora

**Versión analizada:** 0.2.0  
**Fecha del documento:** 22 de octubre de 2026  
**Revisión:** 1.2 · añade protección prioritaria de partidas, cuentas y despliegue en la web de autor  
**Repositorio:** https://github.com/isradev-git/arrecife-game  
**Rama:** `main`  
**Commit de referencia:** `b8aa8b5400a353c5ba739bb806a4cb5b5c4754f7`  
**Estado del documento:** auditoría técnica y hoja de ruta. El rumbo episódico, la importancia de recuperar partidas y el destino web han sido establecidos por el autor; la solución técnica de cuentas/nube, el slug final y los detalles editoriales quedan pendientes de diseño y ejecución.

> **Regla de partida:** conservar la aventura actual de Godot, sus datos, escenas, retratos originales y canon. Mejorar por etapas pequeñas con pruebas. No iniciar otro reinicio ni convertir propuestas narrativas o artísticas en canon sin autorización expresa. **Visión de largo recorrido:** casos episódicos y expansiones que llegan mediante mensajes o llamadas, crecen sobre una ciudad persistente y respetan las partidas anteriores (secciones 19–27). **Nueva decisión crítica:** proteger las partidas antes de la publicación pública mediante guardado local verificable, cuenta recuperable y copia en la nube (secciones 28–32), con el juego alojado dentro de `universo.israelzamora.es`.

---

## 0. Alcance y grado de certeza

Esta auditoría parte de la lectura de la estructura, archivos de datos, scripts principales, pruebas, documentación y logs publicados en el commit indicado. **No se ha ejecutado una nueva sesión de Godot ni una partida humana para redactarla**, ni se han inspeccionado directamente todos los PNG binarios. Por tanto:

- **Confirmado en el código:** estructura del juego, número y tipos de hotspots, organización de datos, funcionamiento declarado de guardado y navegación, dependencias y puntos de mejora localizados.
- **Documentado por las pruebas existentes:** 827/827 comprobaciones headless y 899/899 con GPU en la entrega 0.2.0; exportación Web local; pruebas de persistencia parciales en Chromium.
- **Pendiente de comprobar:** duración real, sensación de juego, aprobación de cada fondo, coherencia espacial, rendimiento en hardware real, recorrido Web completo en varios navegadores y todos los casos de error de guardado.
- **Hipótesis de diseño:** propuestas sobre ritmo, decisiones, interacción y carácter de Sota. Deben contrastarse jugando, no darse por defectos demostrados.

Referencias principales:

- [`README.md`](https://github.com/isradev-git/arrecife-game/blob/main/README.md)
- [`proceso/ESTADO_DEL_PROYECTO.md`](https://github.com/isradev-git/arrecife-game/blob/main/proceso/ESTADO_DEL_PROYECTO.md)
- [`docs/GAME_DESIGN.md`](https://github.com/isradev-git/arrecife-game/blob/main/docs/GAME_DESIGN.md)
- [`docs/ART_DIRECTION.md`](https://github.com/isradev-git/arrecife-game/blob/main/docs/ART_DIRECTION.md)
- [`docs/VALIDACION.md`](https://github.com/isradev-git/arrecife-game/blob/main/docs/VALIDACION.md)
- [`canon_el_arrecife.md`](https://github.com/isradev-git/arrecife-game/blob/main/canon_el_arrecife.md)

## 1. Fotografía del proyecto

| Elemento | Estado del commit analizado | Observación |
|---|---|---|
| Motor | Godot 4.7.2, GDScript, render Compatibility | Un único proyecto activo: `game/project.godot` |
| Tipo de juego | Aventura narrativa 2D ilustrada, primera persona, clic/toque | Decisión vigente documentada; sin avatar caminando |
| Escenarios | 21 vistas: apartamento (3), La Fiebre (6), El Nudo (6), Los Puntales (6) | Conectadas; el grafo se prueba automáticamente |
| Hotspots | 82: 46 navegación, 23 observaciones, 8 documentos, 2 personajes, 2 terminales, 1 deck | Nueve vistas tienen únicamente navegación y una observación |
| Contratos | `retorno_agua`, `orden_duplicada`, `prueba_presion` | Progresión implementada con dos variantes finales |
| Conversaciones | Retratos Sota/Jefa, diálogos y chats del deck | Relaciones y textos creados para el juego pendientes de aprobación |
| Persistencia | JSON local v1, copia `.bak`, respaldo al iniciar nueva partida | **No existe hoy login ni copia en la nube**; es prioridad de producto antes de lanzamiento público |
| Acceso móvil | Horizontal obligatorio | Comprobado sobre todo con emulación, no con dispositivos físicos |
| Fondos | 21 imágenes jugables aplanadas, más menú y variantes | Arte candidato, sin fuentes editables por capas |
| Audio | Ambiente en bucle y toque de interfaz | Escucha y balance finales pendientes |
| Publicación | Exportación Web local documentada | Destino previsto: web del autor `universo.israelzamora.es` y juego bajo una ruta propia aún por fijar |

### 1.1 Qué conviene conservar

1. **Arquitectura basada en datos.** `world.json`, `missions.json`, `story.json` y `dialogues.json` evitan acoplar el contenido narrativo a cada escena.
2. **Separación `Content` / `State` / interfaz.** Para la escala actual es suficiente. La evolución debe ser progresiva.
3. **Canon protegido.** Sota y las reglas de las cotas están fijadas; los contratos y vínculos de la demo no pasan automáticamente a las novelas.
4. **Conservación de originales.** Los retratos, logo, prompts, variantes y material antiguo tienen procedencia documentada.
5. **Pruebas existentes.** No sustituir la batería de regresión: dividirla con cuidado cuando empiece a ser difícil mantenerla.
6. **Recorrido cerrado.** Mantener los tres contratos y las 21 vistas como límite de la próxima entrega.

### 1.2 Decisión artística y de género que no debe quedar ambigua

La idea histórica estaba inspirada por *REPLACED*, con movimiento lateral y estética 2.5D/pixel art. **El juego activo ya no sigue ese formato**: es una aventura de vistas fijas, ilustradas y en primera persona, aprobada como dirección de producción. La comparación con el concepto anterior sirve para reconocer la experiencia que hemos dejado atrás, no para reabrir una migración sin decisión del autor. Si se desea otra vez movimiento lateral, haría falta un documento de decisión separado con coste, riesgos y prueba corta; no debe mezclarse con el pulido de la 0.2.0.

---

## 2. Criterios para elegir trabajo

**Prioridades**

- **P0 — Bloqueante de integridad:** riesgo de perder progreso, errores que impiden terminar el recorrido, fallos graves de lectura o controles. **Nuevo requisito:** la cuenta recuperable y la copia en la nube son P0 para el *lanzamiento público*; se admiten pruebas privadas con guardado local siempre que se informe con claridad del riesgo y no se prometa sincronización.
- **P1 — Necesario para una demo convincente:** ritmo, comprensión de objetivos, identidad visual y de Sota, coherencia narrativa, audio y accesibilidad básica.
- **P2 — Mejora de calidad:** interacción investigadora más participativa, capas/animación ambiental, automatización de tareas repetidas, rendimiento avanzado.
- **P3 — Posterior a la demo:** contenido adicional, más contratos/cotas, sistemas que amplían mucho el alcance.

**Orden general actualizado:** corregir guardado local y diseñar migraciones → definir la arquitectura de identidad/nube y el despliegue en la web de autor → implementar sincronización y probar recuperación → avanzar paralelamente con playtest, narrativa y arte → cerrar la publicación pública sólo con pruebas de continuidad superadas. **No esperar a terminar el arte para abordar cuentas y nube.**

**Tamaños orientativos:** S (cambio localizado), M (varios archivos o pruebas), L (cambio transversal o producción artística). Son etiquetas de esfuerzo, no plazos prometidos.

---

## 3. P0 — Persistencia e integridad del progreso

### P0-01. Nueva partida: no dar éxito si no se pudo guardar

- **Archivo:** `game/scripts/core/state.gd` (`new_game()`, `persist()`, `save_game()`).
- **Hallazgo confirmado:** `new_game()` llama a `persist()` y devuelve `true`. `persist()` no devuelve un resultado y sólo emite `save_failed` si falla el guardado. Por tanto, `new_game()` no conoce el error.
- **Riesgo:** la interfaz puede continuar a la introducción con una partida que no quedó escrita.
- **Cómo abordarlo:**
  1. Definir un resultado comprobable para la operación de guardado; separar notificación visual y resultado de escritura.
  2. Mantener una copia del estado anterior en memoria durante el inicio de partida.
  3. Confirmar el cambio de partida únicamente después de escribir y verificar el archivo nuevo. Si falla, restaurar el estado de memoria y conservar las copias anteriores.
  4. Mostrar un aviso accionable (reintentar, volver al menú) sin presentar la partida como creada.
- **Pruebas de aceptación:** simular falta de permisos, directorio no disponible y guardado inválido; `new_game()` debe indicar fallo, no sobrescribir el respaldo y no entrar a la partida. Verificar también el caso normal.
- **Prioridad / tamaño:** P0 / M.

### P0-02. Unificar escrituras de un mismo evento

- **Archivos:** `game/scripts/ui/main.gd` (`show_document()`), `game/scripts/core/state.gd` (`apply()`).
- **Hallazgo confirmado:** abrir un documento llama a `State.apply({"document": id})` y después a `State.apply(document.get("effects", {}))`; cada llamada guarda por separado.
- **Riesgo:** estados intermedios si la segunda escritura falla; trabajo de disco innecesario.
- **Cómo abordarlo:** combinar documento y efectos en una sola operación lógica. La capa de presentación debe pedir una acción; el estado la aplica y guarda una sola vez.
- **Aceptación:** leer un documento produce un estado completo tras una única escritura; forzar error no deja el documento como leído sin sus efectos ni viceversa.
- **Prioridad / tamaño:** P0 / S.

### P0-03. Recuperación ante interrupciones y copias dañadas

- **Archivo:** `game/scripts/core/state.gd` (`read_save()`, `valid()`, `save_game()`, `load_game()`).
- **Situación:** existe `.tmp`, `.bak` y recuperación cuando el principal está corrupto. Hay pruebas, pero no una matriz completa de interrupciones.
- **Cómo abordarlo:** ensayar fallos justo antes/después de escribir `.tmp`, validar, renombrar el archivo principal y sustituirlo. Revisar la política cuando ya existe `.bak`, cuando un guardado es de versión futura y cuando se llena la cuota Web. Evitar que una recuperación exitosa borre la única copia sana.
- **Aceptación:** ante cada interrupción se recupera el último guardado íntegro o se explica claramente por qué no puede recuperarse; nunca se anuncia éxito sin archivo verificable.
- **Prioridad / tamaño:** P0 / M.

### P0-04. Validación estricta y compatibilidad de estados

- **Archivo:** `game/scripts/core/state.gd`; fixture en `game/tests/fixtures/partida_h1_v1.json`.
- **Cómo abordarlo:** documentar el esquema esperado (tipos, claves necesarias, enumeraciones, referencias y valores permitidos). Crear casos de datos incompletos, IDs desconocidos, campos mal tipados, misiones futuras y estados imposibles. Preservar la migración de partidas v1 existentes.
- **Aceptación:** una partida válida anterior se carga sin pérdida; un archivo incompatible se rechaza sin borrarlo; no se generan transiciones imposibles.
- **Prioridad / tamaño:** P0 / M.

### P0-05. Web: persistencia real en distintos navegadores

- **Archivos:** lógica `user://` y `sessionStorage` de `game/scripts/ui/main.gd`; documentación de entrega.
- **Cómo abordarlo:** validar guardado tras recarga, nueva pestaña, cierre y reapertura, modo privado y borrado de datos. Comparar Chrome/Chromium, Firefox y Safari; repetir en Android e iOS físicos. No prometer continuidad entre dominios, perfiles o dispositivos.
- **Aceptación:** documentar el comportamiento de cada navegador con resultado y versión; aviso claro cuando el almacenamiento del sitio impide guardar. Las pruebas deben repetirse en el dominio y subruta finales, no sólo en `localhost`.
- **Prioridad / tamaño:** P0 / M.
- **Ampliación prioritaria:** apartados 28–32: cuentas, guardado en nube, migraciones, pruebas cruzadas y despliegue en `universo.israelzamora.es`.

---

## 4. P0 — Flujo del juego y regresiones críticas

### P0-06. Recorrido completo de los tres contratos, sin atajos

- **Archivos:** `game/data/missions.json`, `world.json`, `dialogues.json`, `story.json`, `game/tests/run.gd`.
- **Qué revisar:** ofertas y aceptación, condiciones de visibilidad, bloqueo de rutas, documentos obligatorios, regreso entre cotas, entrega explícita y los dos finales. Comprobar que no haya un camino válido para cerrar un contrato sin pruebas esenciales.
- **Cómo abordarlo:** ejecutar el recorrido por interfaz y registrar cada paso; contrastar con los flags reales y las reglas de cada cota. Preparar una partida limpia y otra migrada.
- **Aceptación:** los tres contratos se completan por medios normales; cada bloqueo explica qué falta; ninguna transición provoca pérdida de progreso o repetición de una recompensa.
- **Prioridad / tamaño:** P0 / M.

### P0-07. Acciones repetidas, efectos y decisiones

- **Archivos:** `game/scripts/ui/dialogue.gd`, `device.gd`, `state.gd`.
- **Qué revisar:** abrir varias veces un diálogo, volver a un nodo con `effects`, cerrar durante una elección, releer un mensaje y responder dos veces. Los efectos actuales basados en flags suelen ser repetibles, pero eso no garantiza que cualquier efecto futuro lo sea.
- **Cómo abordarlo:** especificar qué acciones son de una sola vez y cuáles pueden repetirse; guardar esa condición en estado cuando sea necesario. Probar salida en cada paso sensible.
- **Aceptación:** ningún evento ofrece dos veces una misión, duplica un cobro o contradice una elección guardada. La opción de cambiar la elección final antes de cerrar conserva su comportamiento acordado.
- **Prioridad / tamaño:** P0 / M.

### P0-08. Distribución reproducible de una build de prueba

- **Archivos:** `game/export_presets.cfg`, `README.md`, `docs/GUIA_PRIMERA_PARTIDA.md`.
- **Situación:** la exportación Web se documenta, pero `game/build/` está excluido de Git y no hay Release pública.
- **Cómo abordarlo:** script de empaquetado con la versión del motor fijada, comprobación de archivos exportados, guía incluida y nombre de paquete con versión/commit. Servir el HTML por HTTP(S). Publicar una Release o un enlace de pruebas sólo cuando esté autorizada.
- **Aceptación:** otra persona puede generar la misma entrega desde un checkout limpio y abrirla sin instrucciones verbales. Registrar checksum, versión de Godot y commit.
- **Prioridad / tamaño:** P0 / M.

### P0-09. Auditoría de experiencia en móvil horizontal

- **Archivos:** `game/scripts/ui/startup.gd`, `main.gd`, `viewpoint.gd`, `ui.gd`.
- **Cómo abordarlo:** probar controles táctiles, orientación vertical/horizontal, paneles, desplazamiento de chat, diálogo largo, cierre de modales, zonas pulsables cercanas y reapertura de partida. Usar hardware físico además de la emulación de 844×390.
- **Aceptación:** no hay controles inaccesibles ni texto cortado; el aviso de giro tapa la interacción en vertical y al volver a horizontal conserva el punto exacto de la partida. La prueba tiene evidencia visual por dispositivo.
- **Prioridad / tamaño:** P0 / M.

---

## 5. P1 — Primera partida humana y diseño de experiencia

### P1-01. Prueba sin guía: comprobar qué entiende una persona

**Esta tarea debe preceder a añadir mecánicas grandes.** Una prueba automatizada demuestra que un camino funciona; no demuestra que alguien sepa encontrarlo.

- **Preparación:** entregar la 0.2.1 sin explicar el recorrido. Indicar sólo controles básicos y registrar consentimiento para tomar notas/capturas.
- **Personas:** idealmente 2–4 perfiles con diferente experiencia en aventuras narrativas. Empezar incluso con una sola partida completa aporta datos reales.
- **Mediciones:** duración total y por contrato, pasos de bloqueo, uso de «Pistas», veces que se vuelve al deck sin saber qué hacer, errores de toque, partes de texto que se saltan, momentos memorables y abandonos.
- **Registro:** marca temporal → lugar/contrato → acción → expectativa del jugador → resultado → gravedad → propuesta.
- **Aceptación:** existe al menos una partida cronometrada hasta los créditos, una lista priorizada de problemas observados y una decisión fundada sobre si se mantiene el objetivo de 30 minutos.
- **Prioridad / tamaño:** P1 / M.

### P1-02. Comprobar el arranque y los primeros minutos

- **Qué revisar:** tres pantallas de apertura, intro, primer deck, oferta del contrato y salida del apartamento. El jugador debe entender quién es Sota, cuál es su encargo y cómo interactuar.
- **Cómo abordarlo:** observar si el jugador descubre por sí mismo el mensaje de la Jefa y acepta el trabajo. Acortar o mover texto si la introducción interrumpe el interés. Mantener el salto de intro y que la ayuda inicial no reaparezca en cada vista.
- **Aceptación:** un jugador nuevo puede realizar la primera acción útil sin intervención externa; el texto introductorio no duplica información que la escena cuenta mejor.
- **Prioridad / tamaño:** P1 / S–M.

### P1-03. Revisar navegación y carga cognitiva de las 21 vistas

- **Hallazgo confirmado:** nueve vistas presentan únicamente observación y desplazamientos. No es un fallo automático: algunas deben existir para situar al jugador.
- **Qué revisar:** vistas difíciles de diferenciar, pasos sin referencia espacial, puntos de luz mal alineados con puertas, idas y vueltas repetitivas y fondos que no comunican la función del lugar.
- **Cómo abordarlo:** construir un mapa de ruta por misión y marcar cada trayecto como descubrimiento, búsqueda de prueba, transición o regreso. Reducir los regresos sin valor; añadir señalización ambiental antes que más texto de ayuda.
- **Aceptación:** cada vista tiene una función reconocible (ambiental o jugable); el jugador puede explicar de dónde viene y hacia dónde debe ir al completar una prueba.
- **Prioridad / tamaño:** P1 / M.

### P1-04. Deck, Pistas y estados de interfaz

- **Archivos:** `game/scripts/ui/device.gd`, `main.gd`, `ui.gd`.
- **Qué revisar:** mensajes no leídos, orden de contratos, pestañas, respuesta guardada, retorno desde documentos, foco de teclado, contraste entre opción principal y opcional, presentación de bloqueos y paneles en resoluciones bajas.
- **Cómo abordarlo:** una matriz por estado (sin contrato, disponible, activo, listo, completado). Evitar etiquetas que den por hecho que el jugador ya sabe algo. Si «Pistas» se consulta constantemente, investigar por qué la escena no comunica la ruta.
- **Aceptación:** los estados se distinguen, la acción principal es evidente y ninguna entrada accesible rompe la navegación de regreso.
- **Prioridad / tamaño:** P1 / M.

### P1-05. Tiempo de lectura y observaciones

- **Archivo:** `game/scripts/ui/main.gd` (`OBSERVATION_SECONDS := 14.0`).
- **Qué revisar:** 14 segundos quizá basten para textos breves, pero no para todos los jugadores ni en pantalla pequeña.
- **Cómo abordarlo:** medir durante la prueba humana. Valorar mantener la X y permitir ampliar tiempo o desactivar autocierre en ajustes. No modificar el temporizador por intuición sin conocer la longitud real de los textos.
- **Aceptación:** los textos pueden terminar de leerse sin prisas; el jugador puede reabrir la información y elegir un modo de lectura cómodo.
- **Prioridad / tamaño:** P1 / S.

---

## 6. P1 — Narrativa, personajes y canon

### P1-06. Auditoría narrativa contrato por contrato

- **Archivos:** `game/data/missions.json`, `story.json`, `dialogues.json`; contraste con `canon_el_arrecife.md`.
- **Preguntas clave:** ¿qué investiga realmente Sota?, ¿qué descubre el jugador y qué le cuentan?, ¿qué motivo tiene la Jefa para encargarlo?, ¿cómo se encadenan las misiones?, ¿qué cambia al final?
- **Cómo abordarlo:** crear una ficha por contrato con premisa, pista inicial, giro, prueba decisiva, entrega y consecuencia. Identificar diálogos que explican una acción que el jugador podría deducir por sí mismo. Mantener una trama contenida, sin revelar secretos principales de las novelas.
- **Aceptación:** cada contrato tiene una pregunta dramática clara y un hallazgo propio, sin contradicciones con permisos, economía, tecnología o jerarquía del Arrecife.
- **Prioridad / tamaño:** P1 / M.

### P1-07. Voz y carácter de Sota

- **Canon fijo:** ex-Vesta, origen en la cota 0, contrabando entre cotas 0–4, investigadora independiente, residente de La Fiebre, encargos pagados y colaboración policial puntual. No actúa como policía permanente ni acepta asesinatos por encargo.
- **Situación:** los textos son funcionales, pero hay margen para que el pasado y criterio de Sota se sientan en sus observaciones y decisiones.
- **Cómo abordarlo:** redactar una guía corta de voz: frases, actitud ante autoridad, oficio, qué calla, qué pregunta, qué señales físicas reconoce por su pasado. Reescribir una escena piloto antes de abordar todos los diálogos.
- **Aceptación:** las líneas de Sota se distinguen de las de la Jefa sin necesidad del rótulo; su experiencia aporta valor investigativo y no se convierte en exposición de biografía.
- **Prioridad / tamaño:** P1 / M.

### P1-08. Relaciones personales en los mensajes

- **Elementos:** Madre, Hermana, Lía, Jefa y Enlace policial.
- **Riesgo:** que los mensajes parezcan simples pausas mecánicas o construyan biografías aún no aprobadas.
- **Cómo abordarlo:** revisar voz de cada contacto, momento de llegada, tono emocional y repetición de respuestas. Establecer explícitamente qué detalles son canon y cuáles sólo pertenecen a esta entrega. No fijar edades, residencias u oficios por comodidad narrativa.
- **Aceptación:** cada hilo deja una impresión diferente, no interfiere con un punto crítico del contrato y ninguna novedad literaria pasa al canon por accidente.
- **Prioridad / tamaño:** P1 / S–M.

### P1-09. Consecuencias del final

- **Situación confirmada:** elegir si las copias llegan primero a residentes o policía cambia flags y texto de cierre; la repercusión jugable es limitada.
- **Cómo abordarlo:** mantener el alcance del desenlace, pero preparar una reacción breve y concreta según cada opción: mensaje final distinto, comentario posterior de la Jefa o constancia de quién ha recibido antes la información. No añadir una nueva misión completa.
- **Aceptación:** ambas opciones tienen un efecto perceptible y coherente; no crean una solución milagrosa a la desigualdad o corrupción de la ciudad.
- **Prioridad / tamaño:** P1 / M.

### P1-10. Aprobación editorial y límites del universo

- **Cómo abordarlo:** una tabla de decisiones del autor para la biografía, relaciones, textos de autoría, cargos/contratos, uso de corporaciones, topónimos y desenlace. Marcar `APROBADO`, `PENDIENTE` o `RECHAZADO` con fecha y versión revisada.
- **Revisiones concretas:** subida y bajada entre cotas, Penumbra sin sol directo, valor del agua, tecnologías físicas de red, Nómina según canon, policía subordinada a autorizaciones, distancia con las tramas de las novelas.
- **Aceptación:** ningún elemento pendiente aparece rotulado como parte firme del canon. Los cambios editoriales se hacen en los JSON pertinentes y pasan las pruebas de referencias.
- **Prioridad / tamaño:** P1 / M.

---

## 7. P1/P2 — Dirección artística, continuidad y animación

### P1-11. Auditoría visual de los 21 fondos y menú

- **Archivos:** `game/assets/backgrounds/candidates/`, `docs/ART_DIRECTION.md`, `art/prompts/`, `art/iterations/`.
- **Cómo abordarlo:** comparar cada imagen a 1280×720 y 844×390; registrar composición, escala humana, puertas/salidas, posición de hotspots, materiales, iluminación, implantes, anatomía de figurantes y relación espacial con las escenas vecinas.
- **Especial atención:** dormitorio (luz exterior sin sol directo), pasaje de La Fiebre (multitud y accesos), transiciones a El Nudo y Los Puntales, diferencia de acabado de Los Puntales frente a los retratos.
- **Aceptación:** ficha de los 21 fondos con decisión `APROBAR`, `CORREGIR` o `REHACER`, evidencia a tamaño de juego y lista cerrada de cambios. **No aprobar en bloque por haber aprobado un retrato o una zona.**
- **Prioridad / tamaño:** P1 / L.

### P1-12. Elegir una escena de referencia antes de producir capas

- **Propuesta:** pasaje de La Fiebre junto a Velvet, por densidad humana, contraste de recursos y relevancia narrativa.
- **Cómo abordarlo:** preparar fuente editable con fondo/arquitectura, plano medio, elementos interactivos, luces, atmósfera y primer plano. Cada grupo debe poder revisarse sin perder la composición. Conservar el original aplanado y su procedencia.
- **Aceptación:** una sola escena aprobada en escritorio y horizontal móvil, con composición estable y capas exportables por separado. La escala, contraste y lenguaje visual quedan documentados.
- **Prioridad / tamaño:** P1 / L.

### P2-01. Añadir movimiento ambiental contenido

- **Archivos futuros:** recursos por capas en `game/assets/` y un componente visual separado del controlador principal; adaptar `viewpoint.gd` sólo después de cerrar la escena piloto.
- **Propuesta:** alternancia de letreros, humo contenido, alguna luz de trabajo y actividad mínima de maquinaria. Movimiento discreto, sin convertir una escena fija en otro género.
- **Cómo abordarlo:** primero una demostración técnica aislada; estudiar orden de capas, recortes, transparencia y ubicación de hotspots con la misma referencia de coordenadas. Respetar `reduced_motion`.
- **Aceptación:** la escena funciona y se entiende también inmóvil; el movimiento no tapa pruebas, puertas ni textos, y su coste se mide en dispositivo de prueba.
- **Prioridad / tamaño:** P2 / M–L.

### P1-13. Personajes en contexto, retratos y escala

- **Qué revisar:** la Jefa existe como retrato y diálogo, pero falta resolver su presencia en el fondo del entorno. Comprobar tamaño de figuras y continuidad de vestuario.
- **Cómo abordarlo:** decidir si debe estar representada en la vista de encuentro o si el diálogo se introduce de otro modo. Cualquier figura nueva debe partir del estilo aprobado, sin alterar los retratos originales.
- **Aceptación:** la ubicación de cada personaje conversable resulta creíble; los PNG protegidos siguen intactos.
- **Prioridad / tamaño:** P1 / M.

---

## 8. P2 — Hacer que investigar sea una acción del jugador

### P2-02. Prototipo de interpretación de pruebas

**Hipótesis:** el bucle actual de aceptar → leer → desplazarse → entregar puede resultar demasiado pasivo. Se debe comprobar primero en una partida humana.

- **Intervención mínima propuesta:** en el contrato del agua, mostrar dos registros en el deck (hora de caída de presión y hora de intervención). El jugador marca la discrepancia que justifica cuestionar el cierre.
- **Reglas:** sin temporizador, sin castigo irreversible por error, con pista opcional y resultado accesible. No exigir conocimientos técnicos externos.
- **Implementación:** nuevos datos declarativos de prueba; controlador de comparación aislado; flag de resolución persistente; conservar la lectura simple en una rama de prueba hasta validar la mecánica.
- **Aceptación:** alguien entiende qué compara, por qué importa y qué ha descubierto. La mecánica añade decisión real sin convertirse en un minijuego ajeno a la historia.
- **Prioridad / tamaño:** P2 / M–L.

### P2-03. Interacciones ambientales con propósito

- **Cómo abordarlo:** para cada una de las nueve vistas limitadas a observación/desplazamiento, decidir si basta como transición o si merece un detalle que anticipe información, cuente un conflicto local o ayude a situarse. No llenar todas las vistas por obligación.
- **Aceptación:** ningún añadido existe únicamente para incrementar la cantidad de hotspots; cada intervención aporta orientación, carácter o contexto.
- **Prioridad / tamaño:** P2 / M.

### P2-04. Reacción del mundo al avance

- **Propuesta:** variaciones muy pequeñas según flags: un aviso en un terminal, una nueva nota junto a una reparación o una respuesta breve al volver a La Fiebre.
- **Cómo abordarlo:** escoger dos puntos de retorno existentes y condicionar su texto/visual al avance. Reaprovechar la infraestructura `visible_if`/`available_if` cuando encaje.
- **Aceptación:** el mundo reconoce al menos algunos resultados sin obligar a ampliar el mapa ni generar nuevas cadenas de misiones.
- **Prioridad / tamaño:** P2 / M.

---

## 9. P1/P2 — Audio, lectura y accesibilidad

### P1-14. Escucha crítica del sonido

- **Archivos:** `game/assets/audio/`, buses y reproductores en `main.gd`.
- **Situación:** un WAV de ambiente en bucle con distinto `pitch_scale` por zona y un efecto de toque; no hay partitura musical en esta versión.
- **Cómo abordarlo:** escuchar cada cota con auriculares y altavoces sencillos; comprobar monotonía, cortes de bucle, volumen de interfaz, sonido tras cambiar de zona y ajustes persistentes. No introducir música porque sí.
- **Aceptación:** el ambiente acompaña a los diálogos sin distraer; silencio, volumen y reducción de sonido funcionan después de cargar.
- **Prioridad / tamaño:** P1 / S–M.

### P1-15. Legibilidad y acceso por teclado

- **Archivos:** `ui.gd`, `dialogue.gd`, `device.gd`, `viewpoint.gd`.
- **Cómo abordarlo:** revisar tamaños reales de fuente, contraste, estados de foco, orden de Tab, navegación con teclado, descripciones accesibles de puntos, diálogos extensos, control de scroll y texto grande en todos los paneles (no sólo algunos).
- **Aceptación:** tareas principales accesibles con ratón y toque; se registra qué puede hacerse con teclado y se corrigen los bloqueos detectados. Los colores no son el único indicador de decisión.
- **Prioridad / tamaño:** P1 / M.

### P1-16. Preferencias de movimiento y orientación

- **Cómo abordarlo:** verificar que `reduced_motion` cubre las transiciones actuales y cualquier animación nueva. Comprobar que la exigencia de horizontal móvil no provoque pérdida de datos o un bloqueo permanente tras girar.
- **Aceptación:** el juego puede completarse sin animaciones; rotación y regreso dejan todos los paneles operativos.
- **Prioridad / tamaño:** P1 / S–M.

---

## 10. P1/P2 — Rendimiento, recursos y calidad de código

### P1-17. Perfil real de memoria, carga y FPS

- **Situación:** el árbol `game/` contiene aproximadamente 67,5 MB en archivos; los PNG suelen rondar varios MB por fondo. El tamaño comprimido en repositorio **no equivale a RAM ocupada** cuando se cargan texturas.
- **Qué medir:** peso Web descargado, tiempo de inicio, memoria antes/después de cambiar repetidamente de cota, FPS en escenas estáticas y animadas, y comportamiento al recargar.
- **Cómo abordarlo:** tomar primero una línea base en ordenador y móvil de gama media; después comparar formatos/importación, resolución efectiva y vida de las texturas. Probar en Compatibility, que es el render vigente.
- **Aceptación:** resultados medidos por dispositivo, sin crecimiento continuo de memoria al recorrer el mapa ni pausas que impidan interactuar. Fijar presupuestos finales a partir de esas medidas, no de suposiciones.
- **Prioridad / tamaño:** P1 / M.

### P2-05. Separar responsabilidades de `main.gd`

- **Situación:** `game/scripts/ui/main.gd` concentra menú, paneles, exploración, navegación, audio y parte del flujo narrativo.
- **Cómo abordarlo:** extraer primero componentes con frontera clara (controlador de paneles, acciones de exploración, audio), sin reescribir `State` ni cambiar la forma de los JSON. Mantener una PR por extracción.
- **Aceptación:** tests anteriores verdes y ausencia de cambios visibles no previstos; cada nuevo módulo tiene una responsabilidad entendible.
- **Prioridad / tamaño:** P2 / M.

### P2-06. Validación automática de datos antes de ejecutar

- **Archivos:** cuatro JSON y prueba de integridad en `game/tests/`.
- **Cómo abordarlo:** comprobar IDs únicos, enlaces a pantallas/diálogos/documentos existentes, targets, condiciones, flags esperados y opciones que terminan en nodos válidos. Fallar con nombre de archivo e ID concretos.
- **Aceptación:** un typo en un destino o condición rompe el chequeo antes de que llegue a un jugador.
- **Prioridad / tamaño:** P2 / M.

### P2-07. Hacer mantenible la batería de pruebas

- **Situación:** `game/tests/run.gd` contiene un recorrido grande y numerosas comprobaciones; los contadores actuales son valiosos, pero difíciles de aislar ante un error.
- **Cómo abordarlo:** dividir por áreas sin perder cobertura: integridad de contenido, guardado, misiones, navegación, interfaz y capturas. Separar pruebas rápidas de comprobaciones que necesitan render.
- **Aceptación:** cada fallo informa módulo, caso y causa; la misma regresión histórica sigue cubierta.
- **Prioridad / tamaño:** P2 / M.

### P2-08. Integración continua y control de cambios

- **Situación:** no hay una configuración de GitHub Actions en el árbol consultado.
- **Cómo abordarlo:** montar un flujo que prepare Godot con versión fija, importe recursos, ejecute pruebas headless y preservación, y guarde logs como artefactos. La prueba nativa con GPU y las revisiones visuales seguirán siendo comprobaciones separadas donde CI no disponga de ese entorno.
- **Aceptación:** una PR que rompa una referencia o una misión falla automáticamente antes de integrar en `main`.
- **Prioridad / tamaño:** P2 / M.

### P2-09. Higiene de repositorio y archivos grandes

- **Qué revisar:** diferencias entre originales, variantes, imágenes de evidencia, recursos necesarios para ejecutar y builds excluidas. El árbol total consultado ronda 124 MB antes de considerar otras capas de Git.
- **Cómo abordarlo:** inventario de archivos realmente necesarios para build y cuáles son material histórico. No borrar originales ni reescribir el historial; estudiar Git LFS o almacenamiento de evidencias si el crecimiento comienza a dificultar clones/CI.
- **Aceptación:** cualquier desarrollador sabe qué archivos son fuente, cuáles son derivados y cuáles deben preservarse sin edición.
- **Prioridad / tamaño:** P2 / S–M.

---

## 11. P1 — Preparación editorial y publicación

### P1-18. Créditos, autoría, licencias y textos legales

- **Archivos:** `game/data/story.json` (créditos), `docs/attribution/`, originales y manifiesto de preservación.
- **Cómo abordarlo:** revisar nombres, autoría del universo, atribución de recursos, motor MIT, texto definitivo del logo y el uso de imágenes generadas. Confirmar que cualquier recurso de terceros que se incorpore tenga permiso aplicable y atribución documentada.
- **Aceptación:** texto de créditos aprobado por el autor y recursos distribuibles con su documentación correspondiente.
- **Prioridad / tamaño:** P1 / M.

### P1-19. Matriz mínima de plataformas

| Plataforma / contexto | Prueba imprescindible | Situación actual |
|---|---|---|
| macOS, Godot nativo | Partida completa, guardado, sonido y cierre | Existen pruebas técnicas registradas; falta sesión humana |
| Chromium escritorio | Web, recarga, mensajes, tres contratos y final | Recorrido Web parcial registrado |
| Firefox escritorio | Web, scroll, guardado y foco | Pendiente |
| Safari macOS/iOS | WebGL, audio, almacenamiento, orientación y toque | Pendiente |
| Android físico, horizontal | Arranque, toques, cambio de orientación, chats y guardado | Pendiente |
| Windows | Exportación y recorrido de control | Pendiente |
| Linux | Exportación y recorrido de control | Pendiente |

La prioridad real depende de dónde vayamos a distribuir la demo. No declarar una plataforma compatible hasta probarla.

### P1-20. Paquete de release y material para testers

- **Cómo abordarlo:** incluir versión y commit, controles, requisitos, modo de ejecutar, advertencia del guardado local, canal de incidencias y formulario corto de comentarios. Si se publica en Web, usar un origen estable con HTTPS y comprobar su comportamiento tras actualizar la versión.
- **Aceptación:** una persona ajena al desarrollo puede abrir la demo, terminarla y comunicar un fallo indicando plataforma, pantalla y paso.
- **Prioridad / tamaño:** P1 / M.

### P0-WEB. Destino oficial de publicación: web literaria del autor

- **Web de autor definida:** `https://universo.israelzamora.es/`. Será el centro de información literaria, con un espacio para **EL DIOS EN LA PLACA** (primer libro) y otro para el nuevo universo **EL ARRECIFE** y la novela **CARGA ADMISIBLE** (segundo libro).
- **Ubicación prevista del juego:** `https://universo.israelzamora.es/titulodeljuego/`, donde `titulodeljuego` es un **marcador de posición**, no un slug confirmado. `https://universo.israelzamora.es/el-arrecife/` es una *propuesta* legible que deberá aprobar el autor antes de fijarse.
- **Integración editorial:** acceso al juego desde la sección del universo, apartado con requisitos/controles y enlaces de regreso a libros y mundo; mantener diferenciadas las páginas de la novela y la experiencia interactiva para evitar confusiones y spoilers.
- **Integración técnica:** desplegar la exportación Godot Web en una subruta estable del mismo sitio mediante HTTPS; probar rutas relativas, archivos `.wasm`/`.pck`, caché y futuras actualizaciones. No dar por hecho que mover el juego de ruta conserve las partidas locales aunque el dominio no cambie.
- **Más detalle y pruebas:** secciones 28 y 31.

---

## 12. Plan de trabajo por hitos

### Hito A — `0.2.1`: fiabilidad y entrega controlada

**Objetivo:** disponer de una build reproducible que preserve el progreso y permita una primera prueba completa.

- [x] P0-01 — Corregir el resultado del guardado al crear una partida. Verificación local: `tests/save_integrity.gd`, 23 oct 2026.
- [x] P0-02 — Unificar guardado de apertura de documentos y efectos. Verificación local: `tests/save_integrity.gd`, 23 oct 2026.
- [ ] P0-03 — Probar recuperación ante interrupciones y copias dañadas.
- [ ] P0-04 — Reforzar validación de archivos y migración v1.
- [ ] SAVE-01 / SAVE-02 — Definir esquema versionado, copias de seguridad y recuperación sin sobrescribir (sección 30).
- [ ] WEB-01 — Decidir subruta canónica y entorno de pruebas de la web de autor (sección 30).
- [ ] P0-06 — Repetir los tres contratos y ambos finales desde la UI.
- [ ] P0-07 — Cubrir acciones repetidas, salidas y respuestas.
- [ ] P0-08 — Generar paquete Web reproducible con instrucciones.
- [ ] Ejecutar importación, headless, GPU nativa y preservación.

**Puerta de salida de la prueba privada:** cero fallos P0 locales conocidos, logs disponibles, paquete identificado por versión/commit y partida recuperable tras recarga. **Esta puerta NO autoriza la publicación pública sin copia remota y recuperación de cuenta.**

### Hito B — `0.2.2`: validación con jugadores

**Objetivo:** saber qué debe mejorar la experiencia antes de producir mucho más contenido o arte.

- [ ] P1-01 — Primera partida humana completa cronometrada.
- [ ] P1-02 — Revisar arranque y primeros minutos.
- [ ] P1-03 — Estudiar rutas, regresos y función de las 21 vistas.
- [ ] P1-04 / P1-05 — Corregir fricciones observadas en deck, Pistas y lectura.
- [ ] P0-05 / P0-09 — Probar Web y móvil horizontal en hardware real.
- [ ] P1-17 — Obtener primera medida de carga, memoria y FPS.
- [ ] SAVE-03 / SAVE-04 / SAVE-05 — Implementar identidad recuperable, guardado remoto y sincronización con protección de conflictos; probar desde el prototipo Web.
- [ ] SAVE-06 / SAVE-07 — Probar vinculación de partidas invitadas, restauración real y recuperación entre dispositivos.
- [ ] Repetir partida tras las correcciones y anotar diferencias.

**Puerta de salida:** existe informe de playtest con duración, fricciones clasificadas y decisiones fundamentadas. La sincronización avanza con sus propias pruebas, en paralelo al playtest; si necesita una iteración adicional, **no se publica al público antes de completarla**. No ampliar contenido por mera intuición.

### Hito C — `0.3.0`: escena artística de referencia e investigación

**Objetivo:** elevar la identidad del juego sin rediseñar su arquitectura.

- [ ] P1-11 — Revisar las 21 vistas y clasificar cambios visuales.
- [ ] P1-12 — Aprobar una escena piloto con fuentes por capas.
- [ ] P1-06 / P1-07 — Revisar un contrato y una escena de voz de Sota.
- [ ] P1-09 — Dar consecuencia reconocible a las dos opciones finales.
- [ ] P2-02 — Prototipar una comparación de pruebas si el playtest lo justifica.
- [ ] P2-01 — Añadir movimiento ambiental contenido a la escena piloto.
- [ ] P1-14 / P1-15 — Pulir sonido y lectura en esa escena.

**Puerta de salida:** escena piloto aprobada, mecánica validada con jugador y rendimiento medido. Si la comparación de pruebas no funciona, descartarla sin extenderla.

### Hito D — Pulido del conjunto / candidata a publicación

**Objetivo:** trasladar lo que funciona al resto de la experiencia y cerrar aspectos editoriales.

- [ ] Aprobar/corregir fondos restantes, especialmente iluminación de Penumbra y Los Puntales.
- [ ] P1-08 / P1-10 — Revisar relaciones, textos y límites del canon.
- [ ] P1-13 — Resolver la presencia visual de personajes en escenarios.
- [ ] P2-03 / P2-04 — Introducir sólo interacciones con propósito.
- [ ] P2-05 / P2-06 / P2-07 / P2-08 — Mejoras de mantenimiento sin alterar el juego.
- [ ] P1-18 / P1-19 / P1-20 — Créditos aprobados, plataformas probadas y paquete final.
- [ ] SAVE-08 / SAVE-09 — Verificar seguridad, privacidad, respaldo y restauración cloud antes de abrir el acceso general.
- [ ] WEB-02 / WEB-03 / WEB-04 — Desplegar en la ruta canónica y superar la matriz de actualización y recuperación.

**Puerta de salida pública:** aprobación narrativa y artística, pruebas técnicas y humanas en plataformas objetivo, **login recuperable, guardado local y en nube, recuperación entre dispositivos y compatibilidad de migraciones probadas**, versión candidata identificable y lista de problemas sin bloqueantes.

### Fuera de alcance por ahora (para el pulido 0.2.x)

- [ ] Añadir otra cota o un cuarto contrato.
- [ ] Incorporar combate, salto, movimiento lateral o cámara libre.
- [ ] Implementar infraestructura online compleja que no sea necesaria para **cuentas y protección del guardado** (estadísticas, comunidad, multijugador, chat en vivo). El guardado en nube y la autenticación **sí son prioridades inmediatas** antes de publicar.
- [ ] Introducir sistemas complejos de economía/inventario sin un problema demostrado.
- [ ] Rehacer todos los fondos antes de validar una escena piloto.

**La expansión por casos y nuevas cotas ya es una decisión de producto a largo plazo**, desarrollada en las secciones 19–27. **La protección de partidas NO es una expansión futura**: su diseño empieza con 0.2.1 y debe quedar implementado y probado antes del primer lanzamiento público (secciones 28–32).

---

## 13. Matriz de riesgos y decisiones

| Riesgo | Probabilidad por verificar | Impacto | Respuesta |
|---|---|---|---|
| Nueva partida anunciada sin guardado íntegro | Caso permitido por flujo actual | Alto | Corregir P0-01 y añadir fallo inyectado |
| Progreso parcial al abrir documento | Hay dos escrituras separadas | Medio/alto | Unificar P0-02 |
| Pérdida de progreso por limpieza/cambio de navegador o equipo | Riesgo inherente al guardado Web exclusivamente local | **Crítico** | SAVE-03–SAVE-09: cuenta recuperable y nube, sin falsos éxitos |
| Sobrescritura de partida entre dispositivos o versiones | Riesgo de diseño si se sincroniza sin revisión | **Crítico** | Versionado, conflictos explícitos, backup y migraciones |
| Cambio del dominio o ruta del juego | Puede alterar el acceso a datos locales | **Alto** | Fijar URL canónica antes del público; ensayar migración |
| Problemas en teléfonos reales | Sin datos suficientes | Alto para distribución móvil | P0-09 + P1-19 |
| Recorrido largo o repetitivo | Hipótesis plausible | Alto para experiencia | P1-01 y P1-03 antes de ampliar |
| Los fondos no parecen pertenecer al mismo mundo | Señalado en dirección artística | Alto para presentación | Auditoría vista por vista y escena piloto |
| Fuentes aplanadas impiden animación selectiva | Confirmado | Medio/alto para arte futuro | P1-12 y P2-01 |
| Sota queda reducida a vehículo de exposición | Riesgo narrativo | Alto para personalidad | P1-07, revisión de escenas |
| Regresiones en un script central grande | Riesgo de mantenimiento | Medio | P2-05, P2-07 y CI |
| Crecimiento del peso y memoria | Pendiente de medida | Medio/alto según móvil | P1-17 |
| Ficción de juego confundida con canon | Riesgo editorial | Alto | P1-10 con aprobación explícita |

---

## 14. Protocolo de trabajo para cada cambio

1. **Abrir incidencia pequeña:** problema observado, evidencia, versión, pasos para reproducir y criterio de cierre.
2. **Clasificar:** bug confirmado, hipótesis de UX, tarea de arte o aprobación narrativa. Nunca mezclarlos en una misma PR sin motivo.
3. **Añadir prueba antes de corregir cuando sea posible:** especialmente para persistencia, misiones, condiciones y navegación.
4. **Cambiar lo mínimo:** evitar refactorizar `main.gd` a la vez que se modifica el arco narrativo.
5. **Verificar:** importación, suite relevante, preservación, captura si afecta al aspecto y prueba manual corta si afecta al jugador.
6. **Solicitar aprobación cuando corresponda:** los cambios de canon, textos principales y fondos finales requieren visto bueno del autor.
7. **Actualizar documentación:** `task.md`, `docs/VALIDACION.md` y `proceso/ESTADO_DEL_PROYECTO.md` con implementado, comprobado y aprobado por separado.
8. **Integrar y etiquetar:** PR pequeña, revisión de diff, versión cuando haya una entrega, sin mezclar builds regenerables con fuentes.

**Plantilla de incidencia**

```md
## [ID] Título

- Tipo: Bug / UX / Arte / Narrativa / Rendimiento / Infraestructura
- Prioridad: P0 / P1 / P2 / P3
- Versión y commit:
- Archivos o zonas afectadas:
- Evidencia o pasos de reproducción:
- Comportamiento actual:
- Comportamiento esperado:
- Propuesta de cambio:
- Dependencias y riesgos:
- Pruebas de aceptación:
- Requiere aprobación del autor: Sí / No
- Estado: Pendiente / En curso / Comprobado / Aprobado
```

---

## 15. Lista maestra de aceptación para la primera entrega externa

### Código y progreso

- [ ] Nueva partida, guardado y recuperación sin falsos éxitos.
- [ ] Partida v1 migrada correctamente.
- [ ] Tres contratos y ambos finales recorridos desde interfaz.
- [ ] Mensajes, respuestas y decisiones persisten tras recarga.
- [ ] **Para lanzamiento público:** progreso recuperado desde la nube al iniciar sesión en otro navegador/dispositivo, sin perder elecciones.
- [ ] **Para lanzamiento público:** simulación de conflicto y fallo de red sin sobrescritura silenciosa; migraciones desde guardados antiguos.
- [ ] Rutas entre cotas respetan permisos y admiten regreso.
- [ ] Pruebas automatizadas y preservación verdes en el commit entregado.

### Jugabilidad

- [ ] Al menos una partida humana cronometrada completa.
- [ ] Problemas de confusión y atascos documentados y priorizados.
- [ ] Primera misión comprensible sin instrucciones externas.
- [ ] Deck y Pistas permiten saber qué se puede hacer, sin revelar demasiado.
- [ ] Los finales reflejan correctamente la elección efectuada.

### Imagen y sonido

- [ ] Fondos candidatos revisados a tamaño de juego; pendientes etiquetados.
- [ ] Luz de La Fiebre y continuidad entre escenas revisadas.
- [ ] Retratos originales y logo conservados sin alteración.
- [ ] Sonido escuchado y niveles aceptados.
- [ ] Animaciones, si se incorporan, admiten modo de movimiento reducido.

### Compatibilidad y entrega

- [ ] Web jugable por HTTP(S), sin abrir `file://`.
- [ ] **URL pública del juego fijada y probada** bajo `https://universo.israelzamora.es/<slug-aprobado>/`.
- [ ] **Web de autor integrada**: EL DIOS EN LA PLACA, EL ARRECIFE y CARGA ADMISIBLE, con distinción clara entre universo, libro y juego.
- [ ] **Cuentas y nube probadas**: vinculación invitado→cuenta, recuperación entre dispositivos, copia restaurable y límites comunicados.
- [ ] Guardado validado en navegador objetivo y comunicado al jugador.
- [ ] Prueba en móvil físico si se ofrece versión móvil.
- [ ] Rendimiento y consumo medidos en dispositivos objetivo.
- [ ] Créditos/licencias revisados.
- [ ] Build identificada por versión, commit, checksum y notas conocidas.
- [ ] Documento de incidencias y canal de comentarios incluidos.

---

## 16. Primera tanda recomendada de incidencias

Para empezar sin dispersarnos, abriría estas **seis** incidencias por este orden:

1. `P0-01` — Nueva partida no debe iniciarse si falla la persistencia.
2. `P0-02` — Apertura de documentos: aplicar todos los efectos en un único guardado.
3. `P0-03` — Matriz de recuperación y conservación de copias.
4. `P0-06` — Recorrido completo de regresión y revisión de posibles atajos.
5. `P0-08` — Paquete Web reproducible para prueba controlada.
6. `P1-01` — Protocolo y ejecución de primera partida humana.

**Después de esa tanda**, escoger cambios de narrativa, arte e interacción según los resultados del jugador. La escena piloto de La Fiebre puede diseñarse en paralelo, pero no conviene producir las otras veinte en capas antes de aprobarla.

---

## 17. Registro de decisiones que faltan

Estas son decisiones del autor o de producto, no bugs que deban resolverse automáticamente:

| Decisión | Propuesta actual | Estado |
|---|---|---|
| Mantener aventura en primera persona de vistas fijas | Sí; género y enfoque confirmados para el crecimiento episódico | Rumbo creativo confirmado |
| Duración real cercana a 30 minutos | Medir antes de recortar o añadir | Pendiente de playtest |
| Escena maestra para arte por capas | Pasaje de La Fiebre | Propuesta |
| Añadir comparación interactiva de pruebas | Sólo tras una sesión con jugador | Propuesta |
| Qué cambia concretamente tras cada final | Reacción corta y distinta | Propuesta editorial |
| Voz definitiva de Sota y vínculos personales | Revisión del autor | Pendiente |
| Aprobación individual de 21 fondos y menú | Ficha por imagen | Pendiente |
| Plataformas de la primera publicación | Definir según público objetivo | Pendiente |
| Forma definitiva de distribuir la demo | Release/hosting Web cuando se autorice | Pendiente |

---

## 18. Cierre de la auditoría

La 0.2.0 tiene una **base técnica real**: sistema de estado, recorrido completo, 21 escenarios conectados, contratos y pruebas. El siguiente paso adecuado no es crear más zonas ni cambiar otra vez de género.

La secuencia recomendada es: **arreglar los bordes de persistencia, probar con una persona, entender qué se siente al investigar y elevar el acabado de una escena representativa**. Así las decisiones sobre arte, mecánicas y ritmo se apoyarán en el juego que tenemos, no en una lista creciente de ideas.

**Este documento es una hoja de ruta de revisión, no un certificado de que todos los puntos hayan fallado.** Cada incidencia debe distinguir lo comprobado, lo observado por jugadores y lo que necesita aprobación creativa.

---

## 19. Dirección de producto acordada: EL ARRECIFE como aventura episódica persistente

**Origen de la decisión:** conversación de diseño posterior a la auditoría, 22 de octubre de 2026. **Estado: rumbo creativo definido por el autor, aún no convertido en código ni en canon narrativo.** Esta sección amplía el diagnóstico de la 0.2.0; no cambia la situación técnica constatada en el commit de referencia.

### 19.1 Visión

**EL ARRECIFE será una aventura gráfica cyberpunk de exploración en primera persona, formada por casos que se van incorporando al mismo mundo.** La ciudad es el gran personaje: se recorre mediante vistas ilustradas, se comprende observando sus espacios y sus habitantes, y se redescubre conforme Sota acepta nuevos encargos.

Buscamos recuperar la curiosidad de las aventuras clásicas: mirar con atención, descubrir entradas, reconocer un lugar al regresar y deducir qué ocurrió. *Myst* sirve de referencia para el valor de los escenarios, no como exigencia de copiar sus acertijos. *Cyberpunk 2077* sirve de referencia para la llegada orgánica de trabajos por mensajes o llamadas y para la sensación de una ciudad que guarda historias, no para introducir combate, mundo abierto 3D o sistemas que no encajan con el equipo de producción.

**Fórmula orientativa:** ciudad persistente + investigación por casos + escenas que cuentan historias + expansiones que respetan el pasado del jugador.

### 19.2 Decisión frente al antiguo concepto con personaje visible

| Aspecto | Prototipo lateral 2.5D / personaje visible | Dirección actual: primera persona ilustrada |
|---|---|---|
| Lo que mejor transmite | Movimiento físico y espectacularidad | Observación, descubrimiento e intimidad |
| Carga de producción | Sprites animados, físicas, colisiones, transiciones | Fondos, continuidad de vistas, interacción y narrativa |
| Recorrido de una nueva zona | Requiere construir desplazamiento y niveles | Permite incorporar una red de vistas y objetos con reglas claras |
| Riesgo principal | Que el acabado cinematográfico supere la capacidad real | Que el resultado sea un visor de imágenes con texto |
| Encaje con casos periódicos | Posible, pero cada escenario cuesta más | Especialmente adecuado si los encargos tienen mecánicas distintas |

**Decisión:** no abrir un tercer reinicio. Conservar el proyecto de Godot actual. La ausencia de avatar caminando es una elección de diseño; su identidad deberá venir del ambiente, el oficio de Sota y la participación del jugador.

### 19.3 Principios que no deberíamos negociar

1. **El mundo tiene continuidad.** No desaparecen zonas, personajes, documentos ni decisiones porque llega un caso nuevo; cualquier cambio visible debe tener una causa narrativa.
2. **Una actualización continúa la partida.** Un jugador que terminó un caso vuelve a su progreso; nunca necesita empezar desde cero para recibir el siguiente, salvo que lo elija.
3. **Los encargos llegan dentro de la ficción.** Un mensaje de la Jefa, una llamada desconocida, un contacto recuperado o una incidencia local hacen que el siguiente trabajo aparezca de forma natural.
4. **Cada caso vale por sí mismo.** Debe tener planteamiento, investigación y resolución suficiente sin exigir comprar o jugar una futura expansión para comprenderlo.
5. **La ciudad invita a explorar.** Las vistas han de ofrecer señales, cambios, vínculos o información útil, no limitarse a ser pasillos entre documentos.
6. **Cada expansión tiene personalidad.** Puede añadir una mecánica, una relación o un tipo de decisión nuevo. No debe repetir indefinidamente «leer tres papeles y volver».
7. **Canon y ficción de juego continúan separados.** Ninguna novedad altera secretos o personajes de las novelas sin autorización expresa.
8. **No prometemos una cota por actualización ni fechas fijas.** La frecuencia y el tamaño de cada entrega dependerán de la calidad y de los recursos de producción.

---

## 20. El bucle principal del jugador

### 20.1 Entre encargos: la vida de Sota

El **apartamento de Sota en La Fiebre** será el punto de referencia emocional y funcional: un lugar reconocible al que regresar, consultar el deck, revisar archivos y notar el paso del tiempo. **No será obligatorio teletransportar al personaje a casa al actualizar.** Si guardó su partida en Los Puntales, podrá continuar allí y recibir la novedad mediante el sistema de comunicaciones cuando narrativamente corresponda.

Secuencia deseada:

1. El jugador entra en su partida existente y recupera su ubicación, inventario lógico de pruebas, relaciones y decisiones.
2. El juego evalúa el contenido nuevo compatible y muestra un mensaje o llamada **una sola vez**, en el momento previsto por las condiciones.
3. La propuesta llega como algo que existe dentro del mundo: «He recibido un chivatazo», «No conozco este remitente», «Vuelve cuando puedas».
4. El jugador decide cuándo consultar el deck, aceptar o posponer el encargo. Puede seguir visitando zonas conocidas cuando las restricciones de acceso lo permitan.
5. Investiga a través de espacios, pistas, conversaciones, terminales y mecánicas apropiadas al caso.
6. Resuelve o cierra el contrato; la ciudad, el deck y algunos personajes conservan las consecuencias.
7. Queda una pausa natural. Un nuevo contenido podrá reactivar la historia más adelante.

**No confundir pausa narrativa con temporizador obligatorio:** el juego no necesita un reloj real, conexión constante ni esperas artificiales entre contratos.

### 20.2 El deck como enlace entre capítulos

El deck pasa de ser un menú con mensajes a ser **la puerta narrativa de nuevas historias**. Debe seguir siendo una herramienta física y limitada, coherente con el canon tecnológico.

Canales que podemos incorporar con el tiempo:

- **Mensaje de un contacto conocido:** la Jefa llama a Sota por otro encargo o le advierte de una anomalía.
- **Comunicación desconocida:** un emisor nuevo ofrece información parcial; su identidad se descubre jugando, no necesariamente al recibirla.
- **Llamada o comunicación de voz representada:** interfaz diferenciada y registro consultable en el deck, sin necesidad de grabar voces desde el primer día.
- **Seguimiento de un caso anterior:** la persona afectada escribe, una institución cambia su versión o aparecen nuevas consecuencias.

La presentación puede mostrar un contador discreto. Evitar banners invasivos que interrumpan una lectura o una decisión. Si el jugador está en un diálogo, retrasar la notificación visual a un punto seguro, sin perder el evento.

### 20.3 Escenario ilustrativo de una expansión

> **LA JEFA — «Un chivatazo»**  
> «Sota, necesito que vengas. Me han pasado una firma de mantenimiento que no debería estar circulando por La Fiebre. En el documento figura alguien dado por muerto hace años, pero aparece un cobro reciente a su nombre. Si te interesa, trae el deck. No respondas por este canal».

Este texto es **un ejemplo de tono y activación**, no contenido aprobado para el canon o una misión ya comprometida.

Posible desarrollo: investigación inicial en una cota conocida → comparación de un registro con una prueba física → pista hacia una ruta antes inaccesible → nuevo entorno y mecánica → desenlace que cierre el caso sin desvelar las tramas principales de las novelas.

**También debe funcionar algo mucho más pequeño:** una llamada que lleve a dos vistas existentes, con una sola persona y una investigación distinta. No todo mensaje necesita estrenar una cota.

---

## 21. Modelo de expansiones y entregas

### 21.1 Tipos de contenido

| Formato | Alcance orientativo | Qué puede incorporar | Qué no debería exigir |
|---|---|---|---|
| **Parche de calidad** | Correcciones y pulido | Guardado, texto, accesibilidad, rendimiento | Empezar de nuevo |
| **Encargo episódico** | Un caso acotado | Nuevos mensajes, pruebas y personajes en lugares existentes | Una cota completa |
| **Actualización de mundo** | Nuevo contenido de zonas actuales | Escenas adicionales, reacciones a decisiones, cambios visibles | Rehacer el mapa vigente |
| **Expansión mayor / DLC** | Varios casos conectados | Nueva cota o área significativa, nuevos contactos y una mecánica | Resolver los misterios centrales de las novelas |

**DLC describe aquí un formato de contenido, no una decisión comercial.** Gratis, de pago o combinado: queda por decidir. Ninguna elección de monetización debe bloquear retroactivamente la partida base ni las pruebas que ya posee el jugador.

### 21.2 Cadencia y escalado

Evitar comprometer «una misión cada X semanas» o «una cota por trimestre» antes de medir cuánto tarda realmente crear arte, probar interacciones y cerrar una historia. La regla será **entregas pequeñas y cerradas entre ampliaciones mayores**, con una sola expansión en producción cuando no tengamos capacidad demostrada para varias.

Una cota nueva debe tener una identidad espacial, social y sonora propia. Cada acceso entre cotas conserva el peso de las acreditaciones y trayectos físicos; el deck informa o comunica, **no transporta**. Abrir una zona por contrato no concede permiso universal para subir o bajar.

### 21.3 Tres capas de continuidad

- **Capa de ciudad:** zonas conocidas, accesos, condiciones de vida, cambios de infraestructura y lugares recurrentes.
- **Capa personal:** contactos de Sota, mensajes, confianza, deudas, recuerdos de elecciones y vínculos que evolucionan.
- **Capa de casos:** pruebas, contratos, desenlaces y consecuencias locales, con referencias ocasionales a otros encargos.

No hace falta que todos los casos formen una conspiración. La ciudad será más creíble si también existen trabajos ordinarios, conflictos pequeños y asuntos que terminan sin revelar una amenaza global.

---

## 22. Diseño de investigación: que el jugador haga algo más que leer

### 22.1 Riesgo detectado en la 0.2.0

De los 82 hotspots registrados, 46 son desplazamientos y nueve vistas consisten en rutas y una observación. Es un punto de partida válido, pero **no debemos multiplicar el mismo patrón en cinco expansiones**. El problema todavía requiere confirmación con jugadores; esta línea fija cómo queremos prevenirlo.

### 22.2 Catálogo inicial de mecánicas candidatas

| Mecánica | Ejemplo de interacción | Qué expresa de Sota | Reglas de producción |
|---|---|---|---|
| **Contraste de evidencias** | Seleccionar dos lecturas incompatibles y señalar su discrepancia | Rigor y conocimiento del oficio | Pocos elementos, feedback claro, sin adivinar píxeles |
| **Reconstrucción de registros** | Ordenar fragmentos de una traza local a partir de marcas verificables | Experiencia técnica y atención al detalle | Solución deducible desde las pruebas visibles |
| **Entrevista con contradicciones** | Confrontar un testimonio con un documento que el jugador decidió conservar | Carácter y criterio al interrogar | Consecuencias comprensibles, no opciones trampa |
| **Acceso físico restringido** | Conseguir permiso o identificar el trayecto autorizado antes de pasar de cota | Jerarquía social y límites materiales | No convertir el deck en teletransporte o llave universal |
| **Examen ambiental** | Interpretar el estado de una tubería o una zona reparada | Observación del entorno, sin exponerlo todo en texto | Señales visibles y alternativas de accesibilidad |

**Regla:** una mecánica nueva se estrena en un caso pequeño, se prueba y, si funciona, queda disponible para historias posteriores. No añadir un minijuego por obligación en cada entrega.

### 22.3 Reglas para evitar frustración

- La solución debe derivarse de información encontrada, no de conocimiento técnico externo ni de azar.
- Toda prueba importante se puede consultar otra vez en el deck sin repetir una ruta larga sólo para leerla.
- Cuando un jugador falla, la respuesta explica **qué interpretación no encaja**, sin revelar inmediatamente todo el resultado.
- Una pista opcional ayuda a razonar; no sustituye automáticamente la decisión.
- Guardar y salir durante una investigación no la rompe ni duplica recompensas.
- Las interacciones de precisión tienen alternativas accesibles a ratón y toque horizontal.

### 22.4 Decisiones con consecuencias

Las elecciones deben producir efectos proporcionales. No pedimos árboles narrativos infinitos: una respuesta distinta de la Jefa, un mensaje posterior, una anotación de un contacto o un lugar alterado ya pueden hacer que el jugador sienta que el mundo recuerda.

**Condición de diseño:** distinguir resultado del contrato, reputación/relación y pistas descubiertas. No construir un sistema numérico de moralidad sin una necesidad real.

---

## 23. Sota: protagonista con voz propia aunque no aparezca caminando

La primera persona no debe convertir a Sota en una cámara muda. Su identidad aprobada —pasado Vesta, antigua actividad de contrabando, oficio de investigadora, residencia en La Fiebre y relación limitada con la policía— debe sentirse en **lo que observa, cómo formula preguntas y qué considera sospechoso**.

Propuestas de trabajo:

- [ ] Construir una ficha de voz de Sota: ironía, vocabulario, límites éticos y prejuicios que se puedan mostrar sin monólogos extensos.
- [ ] Revisar la primera misión para encontrar momentos donde una reacción de Sota aporte interpretación, y no vuelva a narrar lo evidente en el fondo.
- [ ] Conservar retratos originales e introducir presencia mediante el deck, reflejos narrativos y conversaciones, sin recuperar por inercia un personaje controlable en pantalla.
- [ ] Definir vínculos que puedan evolucionar de un caso a otro, con **aprobación del autor** para familia, Jefa y Lía.
- [ ] Darle un espacio de transición entre casos: apartamento, mensajes personales y recuerdos discretos de sus trabajos.
- [ ] Contrastar cualquier dato sobre Vesta, Synaptek, Intus, corporaciones y personajes literarios con el canon antes de escribirlo como hecho.

**Criterio de aceptación:** tras un caso corto, un tester debería poder describir dos rasgos de Sota apoyándose en acciones o diálogos concretos, no únicamente en su biografía de presentación.

---

## 24. Arquitectura necesaria para crecer sin perder partidas

**Situación actual:** cuatro JSON de datos, `Content` para carga y `State` para persistencia. Es una buena base, pero el contenido está cargado como un conjunto monolítico y el guardado tiene un esquema interno `version = 1`. **Los ejemplos siguientes son contratos de diseño, no código ya existente.**

### 24.1 Identidad estable del contenido

Cada paquete episódico deberá registrar al menos: `id` estable, revisión de esquema, dependencias de otros casos, punto de entrada narrativo, misiones incluidas, mensajes, vistas y requisitos de arte/sonido. Evitar cambiar los IDs una vez publicados. Distinguir:

- `save_schema_version`: versión del formato de partida; cambia cuando hay migración de estructura.
- `content_version` o conjunto de paquetes disponibles: identifica el contenido instalado.
- `case_id` y `message_id`: claves persistentes con ámbito propio para no chocar con las de otras entregas.

Ejemplo mínimo **conceptual**:

```json
{
  "id": "caso_chivatazo_01",
  "content_schema": 1,
  "requires": {
    "completed_cases": ["prueba_presion"]
  },
  "entry": {
    "type": "deck_message",
    "message_id": "caso_chivatazo_01:mensaje_inicial",
    "sender": "jefa"
  },
  "missions": ["caso_chivatazo_01:investigacion"],
  "screens": [],
  "features": ["evidence_comparison"]
}
```

Los campos `completed_cases`, `entry`, `features` y los IDs con prefijos **no existen aún en el cargador actual**. Antes de escribir paquetes deben especificarse el esquema, sus referencias cruzadas y la compatibilidad con `world.json`, `story.json` y `missions.json`.

### 24.2 Entrega de mensajes sin duplicados

Propuesta de ciclo idempotente:

1. Cargar partida y aplicar migraciones verificadas.
2. Reconocer paquetes de contenido instalados y registrar su disponibilidad sin modificar las misiones ya terminadas.
3. Evaluar condiciones narrativas de mensajes nuevos; no dispararlos si faltan requisitos.
4. Marcar cada evento con una clave persistente de **entregado**, separada de **leído** y **respondido**.
5. Guardar la transición de entrega de manera atómica; si falla, no perder ni duplicar el evento en una recarga.
6. Mostrar el indicador de novedad cuando la interfaz esté disponible; las conversaciones abiertas no deben interrumpirse.
7. Permitir posponer el contrato sin que desaparezca el mensaje que lo ofrece.

**Caso esencial:** el jugador terminó el caso base hace meses, instala contenido nuevo y pulsa «Continuar». Debe recibir exactamente una invitación, aunque cierre, recargue o cambie de zona cinco veces.

### 24.3 Migraciones de guardado acumulativas

No confiar sólo en añadir claves faltantes en `State.load_game()`. Necesitamos migraciones explícitas, probadas y repetibles cuando cambie el formato. Exigir:

- Copia verificada antes de migrar y posibilidad de recuperar la versión anterior si algo falla.
- Migración de v1 actual a futuras versiones sin perder ubicación, documentos, respuestas y decisiones.
- Contenido añadido como **pendiente/bloqueado** según sus condiciones, nunca «completado» por defecto.
- Rechazo claro de guardados futuros incompatibles sin sobrescribirlos.
- Política definida para cargar un guardado cuando el paquete que lo creó no esté instalado: **no destruir referencias ni descartar progreso silenciosamente**.
- Pruebas con partidas anteriores a cada expansión y comprobación de segundo arranque (sin volver a migrar).

### 24.4 Consecuencias en el mundo

Separar en el estado:

- Hechos persistentes: evidencia leída, caso completado, elección final y contacto conocido.
- Variantes de vista: mismo lugar con cambios por historia, sin duplicar el mundo entero innecesariamente.
- Disponibilidad de nuevos casos: requisitos cumplidos, mensaje entregado, contrato aceptado y resolución.

Para el jugador, un cambio puede ser pequeño: una señal reparada en Los Puntales o una observación nueva en el pasaje. Para el código, debe ser declarativo y comprobable. Nunca condicionar exclusivamente una variante del entorno a un número de versión de la aplicación: basarse en el estado narrativo de la partida.

### 24.5 Entrega técnica del contenido

**Primera fase recomendada:** distribución de una build completa actualizada (Web/desktop), con los JSON y recursos incorporados en el juego. El paquete de contenido es **lógico**; no hace falta crear desde el primer día un sistema de plugins descargables en caliente.

**Fase posterior, sólo si lo pide la escala del proyecto:** evaluar paquetes independientes de recursos de Godot y un catálogo local de contenidos. Antes de introducir descarga independiente, definir firma/integridad, compatibilidad entre versiones, licencias de recursos, gestión de ausencias y recuperación de fallos.

Una expansión disponible localmente **no puede provocar una notificación real cuando el juego está cerrado** sin un servicio externo. La experiencia prevista es que la llamada o mensaje aparezca al abrir el juego o al cumplirse un hito dentro de una sesión.

### 24.6 Pruebas automáticas obligatorias

- [ ] Partida base completada + expansión instalada = un único mensaje nuevo.
- [ ] Partida base incompleta + expansión instalada = mensaje oculto hasta cumplir requisitos.
- [ ] Expansión instalada + partida nueva = progresión normal desde el comienzo.
- [ ] Reabrir, recargar o reiniciar tras leer mensaje = sin entregas duplicadas.
- [ ] Posponer y aceptar más tarde = oferta disponible y estado coherente.
- [ ] Cambiar el lugar de guardado previo = progreso y acceso conservados.
- [ ] Recuperar `.bak` anterior = migración segura y eventos evaluados de nuevo sin duplicados.
- [ ] Nueva vista entre cotas = permisos físicos comprobados en ambos sentidos.
- [ ] Añadir un caso = no altera el resultado de las misiones anteriores.
- [ ] Falta un paquete de contenido = advertencia clara y ningún borrado silencioso.
- [ ] Guardado en Web después de actualizar desde el mismo origen = continuidad comprobada.

---

## 25. Producción artística pensada para expansiones

El arte debe permitir seguir añadiendo vistas sin que La Fiebre y una cota futura parezcan juegos diferentes.

- **Escena de referencia:** empezar por el pasaje de La Fiebre, con fondos, materiales, escala humana y luz de Penumbra aprobados.
- **Fuentes por capas:** estructura, profundidad, iluminación, atmósfera y objetos con estado cuando merezcan animación; conservar siempre el original editable.
- **Animación contenida:** una luz intermitente, humo, reflejos o figuras lejanas pueden bastar. Movimiento reducido debe ofrecer alternativa estática.
- **Población creíble:** cada cota con vida cotidiana, oficios y diferencias materiales; evitar que todas las personas parezcan figurantes de un mismo decorado.
- **Continuidad:** cada nueva entrada/salida debe corresponder espacialmente con la vista anterior. Revisar el encuadre en escritorio y móvil horizontal.
- **Presupuesto de recursos:** medir VRAM, memoria, tamaño Web y tiempos de primera carga antes de fijar la resolución y la cantidad de capas por vista.
- **Cambios históricos:** preparar variantes de una misma vista cuando una misión cambie visiblemente el lugar; documentar qué flags las seleccionan.

**No producir en masa una cota nueva** hasta haber aprobado una escena completa con su navegación, interacción y coste real de producción.

---

## 26. Hoja de ruta ampliada de contenido (sin fechas comprometidas)

Esta hoja de ruta **continúa la sección 12**, no la sustituye. Primero cerramos los problemas de 0.2.x y validamos el juego con personas.

| Etapa | Producto buscado | Condición para avanzar |
|---|---|---|
| `0.2.1` — Fiabilidad y base de guardado | Guardado local, definición de migraciones y arquitectura de cuentas | Sin bloqueantes locales y diseño de nube aprobado |
| `0.2.2` — Playtest y prototipo cloud | Ritmo real, cuenta recuperable, primera sincronización y pruebas cruzadas | Sesiones medidas; flujos críticos de nube probados o release bloqueada |
| `0.3.0` — Identidad jugable | Escena artística maestra, voz de Sota y primera mecánica investigadora | Mecánica entendida por testers y coste asumible; no reemplaza las pruebas de nube |
| Primer lanzamiento público, versión por definir | Juego integrado en la web de autor, cuentas opcionales y copia recuperable en nube | Matriz SAVE/WEB y migraciones aprobadas |
| Siguiente entrega episódica, versión por definir | Primer **encargo añadido** a partida existente, preferiblemente en cotas conocidas | Sistema de activación y migración local/nube probado |
| Expansión mayor, versión por definir | Nueva área o cota justificada por varios casos | Pipeline artístico estable, acceso físico coherente y continuidad comprobada |
| Entregas futuras | Consecuencias, contactos, casos distintos y nuevas mecánicas cuando aporten valor | Sin regresiones ni deuda de contenido inmanejable |

### 26.1 Tareas nuevas para el backlog

**P1/P2 — Fundamentos episódicos (antes del primer caso adicional)**

- [ ] `EP-01` — Aprobar una breve biblia de producto: tono, estructura episódica, duración objetivo por tipo de caso y límites de canon.
- [ ] `EP-02` — Diseñar esquema de paquetes de casos, IDs estables y condiciones narrativas.
- [ ] `EP-03` — Implementar entregas idempotentes de mensajes y ofertas; añadir pruebas de reentrada.
- [ ] `EP-04` — Preparar migraciones versionadas sin pérdida de progreso.
- [ ] `EP-05` — Definir flags de consecuencias y variantes de escenas reutilizables.
- [ ] `EP-06` — Validar en Web una actualización real sobre una partida de la versión anterior.
- [ ] `EP-07` — Preparar una guía editorial de mensajes, llamadas y contactos desconocidos.
- [ ] `EP-08` — Formalizar el apartamento como lugar recurrente, sin obligar a regresar a él al cargar.

**P2/P3 — Primer encargo nuevo (después del playtest y del sistema episódico)**

- [ ] `EP-09` — Escribir un caso corto con resolución propia, sin abrir otra cota por obligación.
- [ ] `EP-10` — Introducir una mecánica investigadora pequeña y medir si se comprende.
- [ ] `EP-11` — Registrar reacciones a una elección anterior sin obligar a conocer todos los casos.
- [ ] `EP-12` — Probar de inicio a cierre en partida nueva y en partida antigua.

**P3 — Primera expansión mayor**

- [ ] `EP-13` — Decidir la cota/área según su necesidad narrativa, no según un calendario.
- [ ] `EP-14` — Crear mapa, permisos, contactos, entornos y sonidos con criterios de producción cerrados.
- [ ] `EP-15` — Diseñar al menos un caso que haga significativa la nueva zona y permita regresar.
- [ ] `EP-16` — Probar consecuencias de casos anteriores, ausencia de contenido y compatibilidad de saves.
- [ ] `EP-17` — Elegir distribución y condiciones comerciales del DLC si procede.

### 26.2 Puerta de aceptación para cualquier expansión

- [ ] La historia puede empezar desde una partida antigua sin reinicio.
- [ ] El encargo se presenta orgánicamente y una única vez.
- [ ] No exige conocer una novela para comprender su trama inmediata.
- [ ] No reescribe resultados anteriores sin justificación.
- [ ] Se puede completar, guardar y cargar en los dispositivos objetivo.
- [ ] Su escenario o mecánica aporta algo distinguible de los casos previos.
- [ ] Documenta nuevas afirmaciones de mundo y cuenta con aprobación del autor cuando corresponda.
- [ ] Sus assets y licencias están identificados; existen pruebas y resultados de rendimiento.
- [ ] Tiene un final propio y deja el mundo listo para continuar después.

---

## 27. Registro de decisiones nuevas y cuestiones abiertas

### Rumbo definido en esta conversación

| Elemento | Decisión | Estado |
|---|---|---|
| Género y cámara | Aventura de vistas ilustradas fijas, en primera persona, clic/toque | **Rumbo confirmado** |
| Inspiración | Curiosidad de las aventuras clásicas; encargos orgánicos tipo *Cyberpunk 2077* | **Referencia de diseño, no copia** |
| Estructura | Casos cerrados que amplían una ciudad persistente | **Rumbo confirmado** |
| Entradas de contenido | Mensajes y llamadas de Jefa, contactos o desconocidos | **Rumbo confirmado; implementación pendiente** |
| Continuidad | Conservar partidas, relaciones y consecuencias entre entregas | **Objetivo prioritario; arquitectura pendiente** |
| Lugar recurrente | Apartamento de Sota como referencia entre casos | **Rumbo confirmado; no punto de respawn obligatorio** |
| Escalado | Encargos pequeños alternados con expansiones de nuevas áreas/cotas | **Rumbo confirmado; sin frecuencia fijada** |
| Jugabilidad | Introducir mecánicas de investigación según la historia | **Objetivo definido; prototipos pendientes** |
| Canon | No revelar secretos centrales de las novelas ni dar por oficiales los guiones nuevos | **Restricción editorial vigente** |
| Modelo comercial | Contenido gratis, de pago o mixto | **Abierto** |
| Versión y fecha de la primera expansión | No comprometidas | **Abierto** |
| Notificaciones fuera del juego | No necesarias para el modelo inicial offline | **Fuera de alcance** |
| Protección de progreso | Guardado local + cuenta recuperable opcional + copia en nube | **Requisito del lanzamiento público** |
| Destino editorial | `universo.israelzamora.es`: EL DIOS EN LA PLACA, EL ARRECIFE y CARGA ADMISIBLE | **Definido por el autor** |
| Dirección del juego | `/titulodeljuego/` como ubicación conceptual dentro de la web | **Slug concreto pendiente** |

### Preguntas a resolver cuando toque, sin bloquear el pulido actual

- ¿Cuánto debe durar un encargo pequeño y cuándo merece llamarse expansión mayor? Lo decidirán el playtest y el coste de producción.
- ¿Qué datos de relación entre personajes conviene persistir: flags de hechos concretos o un sistema más amplio? Empezar con hechos explícitos.
- ¿Cuánto puede cambiar visualmente una zona por decisiones anteriores sin multiplicar en exceso las versiones del arte?
- ¿Qué plataformas recibirán primero las expansiones y cómo se distribuirán las actualizaciones Web sin perder el almacenamiento local?
- ¿Qué contenido se podrá jugar en cualquier orden y qué encargos necesitarán requisitos estrictos de historia?
- ¿Cómo evitar cruces con la trilogía y preservar el misterio literario a medida que aparezcan nuevas corporaciones o cotas?

### Criterio final

**La ciudad crece porque surgen historias que merecen contarse, no para llenar el mapa.** El objetivo es que una persona regrese a su partida meses después, encuentre un mensaje nuevo y sienta que Sota sigue viviendo en El Arrecife. Que recuerde un taller, una persona o una conducción que conoció antes; que descubra algo diferente y que el caso tenga valor propio.

La tarea inmediata es **cerrar los errores del guardado y poner en marcha desde ya la arquitectura de cuentas y nube**, en paralelo a la 0.2.x y las primeras partidas humanas. No se abre al público una versión de larga duración que prometa conservar el progreso sólo con almacenamiento local. Toda la arquitectura episódica se preparará por etapas, sin sustituir los sistemas que ya están funcionando ni convertir esta visión en una excusa para empezar de nuevo.

---

## 28. NUEVA PRIORIDAD CRÍTICA — Nadie debe perder su partida por cambiar de dispositivo

### 28.1 Decisión de producto y límite de la promesa

**Decisión del autor (22 oct 2026):** la continuidad personal de cada jugador es imprescindible. La protección de guardados se aborda **de inmediato**, no después de añadir nuevas cotas. Las futuras actualizaciones, mensajes y contratos deben llegar sobre **la misma historia que esa persona estaba jugando**, aunque vuelva meses después desde otro dispositivo.

El juego **ya** guarda con `user://partida.json`, copia `.bak` y datos de progreso narrativo (`game/scripts/core/state.gd`). En la exportación Godot Web, `user://` usa almacenamiento del navegador a través de IndexedDB. Eso **no crea una identidad recuperable**: borrar datos, usar otro navegador/perfil o cambiar de móvil puede impedir recuperar la partida. La ejecución local no equivale a copia remota.

**Modelo aprobado a nivel de experiencia:**

1. **Jugar como invitado, sin cuenta obligatoria.** La partida se guarda en el dispositivo; la pantalla debe decir claramente que no está protegida en la nube. Ofrecer acceso fácil a «Proteger mi partida» y, si es viable, exportar una copia manual.
2. **Vincular una cuenta recuperable.** Entrada preferentemente mediante correo y enlace/código de un solo uso, sujeto a prueba de entrega y usabilidad. Una vez verificada, se asocia el historial de la partida al ID de la cuenta; no a la dirección de correo como clave primaria.
3. **Continuar en otro dispositivo.** Inicio de sesión, lista o único slot propio y descarga de la última copia íntegra autorizada; se comprueba el esquema antes de sustituir el guardado local.
4. **Seguir jugando sin red.** El local sigue funcionando; los cambios pendientes se sincronizan al recuperar conexión. La interfaz distingue `guardado localmente`, `sincronización pendiente` y `copia en nube actualizada`.
5. **No sobrescribir a ciegas.** Si hay dos progresos divergentes, detener la sustitución automática, conservar ambos respaldos y ofrecer una elección informada. Nunca usar únicamente el reloj del dispositivo para decidir cuál es «el más nuevo».

**Precisión necesaria:** no existe una garantía absoluta de «cero pérdidas» en cualquier circunstancia, y quien juegue siempre como invitado sigue expuesto a perder el almacenamiento del dispositivo. La promesa honesta será: **partidas protegidas en una cuenta recuperable, restauraciones comprobadas y ninguna sustitución destructiva sin control**. Las cuentas deberán ser sencillas, pero su existencia no puede ocultar qué está sincronizado y qué no.

### 28.2 Estado confirmado frente a trabajo pendiente

| Capacidad | Estado actual 0.2.0 | Trabajo necesario |
|---|---|---|
| Guardado local de vista, zona, misiones, flags, documentos, mensajes y elecciones | **Existe** | Endurecerlo y documentar su esquema |
| Escritura temporal, `.bak` y recuperación | **Existe** | Probar fallos reales, no dar falso éxito |
| Cuenta de jugador y acceso desde otro dispositivo | **No existe** | Autenticación y vinculación |
| Guardado remoto vinculado al jugador | **No existe** | Backend de sincronización, revisión y recuperación |
| Resolución segura de conflictos entre dispositivos/pestañas | **No existe** | Detección, respaldos y decisión explícita |
| Migraciones acumulativas entre DLC y versiones de guardado | **Parcial**: se añaden IDs nuevos de misión, formato `VERSION = 1` | Migraciones reales por versión, ida hacia delante y control de clientes antiguos |
| Borrado voluntario, exportación y privacidad de datos | **Pendiente de definir** | Diseño UX/legal/técnico |

### 28.3 ¿Qué se almacena y qué no?

**En el estado de partida:** posición, cotas abiertas, misiones y objetivos, lecturas, pistas, mensajes recibidos/leídos, decisiones, consecuencias, contenido/expansiones vistas, versión del esquema y metadatos técnicos mínimos.

**En el proveedor de identidad:** ID estable de usuario y credenciales o método de acceso. El juego no debe construir su propia base de contraseñas si un proveedor especializado resuelve la autenticación.

**En la nube:** uno o varios snapshots completos por usuario con IDs estables, revisión monotónica, fecha del servidor, hash de integridad, versión de esquema y respaldo anterior recuperable. La partida sigue siendo **propiedad de ese usuario**, no pública. No subir datos innecesarios, contenido de novelas, archivos de desarrollo ni trazas con tokens.

**Separación vital:** `usuario` ≠ `dispositivo` ≠ `partida` ≠ `revisión`. La autenticación responde **de quién es**; el formato del estado responde **qué hizo**; la sincronización responde **qué copia es válida**.

### 28.4 Ruta técnica candidata — decisión pendiente tras prototipo

**Candidato inicial: Supabase Auth + PostgreSQL con Row Level Security (RLS).** Aporta identidad recuperable y almacenamiento de partidas por usuario. Su idoneidad definitiva depende de probar integración con el Godot Web actual, costes, operación y obligaciones de privacidad. Es **propuesta**, no proveedor contratado ni infraestructura implementada.

- Alternativa válida: servicio propio/API de guardados con autenticación delegada; decidir con una prueba vertical corta, no por moda tecnológica.
- Godot sigue siendo la fuente del estado jugable. Crear una capa `SaveRepository`/`CloudSync` separada de `State.gd`, con contratos de carga/guardado probables; no mezclar autenticación con diálogos, hotspots o lógica de misiones.
- Para Web, evaluar integración **Godot `HTTPRequest`/REST** frente a un adaptador JavaScript limitado (`JavaScriptBridge`) cuando el flujo de autenticación lo requiera. Comprobar redirecciones de login, cookies, CORS, HTTPS y renovación de sesión en la ruta final.
- RLS y permisos comprobados desde dos cuentas diferentes: una cuenta no puede leer, editar ni listar los guardados de otra. Los privilegios administrativos/`service_role` **jamás** se incluyen en el juego descargable ni en el JavaScript de la web. Una clave pública de cliente sólo es aceptable con permisos mínimos correctamente configurados.
- No usar GitHub como almacén de las partidas de usuarios ni poner credenciales del backend en `game/data/`.
- Decidir región de alojamiento, retención, copias de seguridad, acceso y supresión de cuenta con revisión legal de protección de datos antes del público.

### 28.5 Esquema de datos de ejemplo, NO implementado

```json
{
  "save_id": "slot-principal",
  "owner_id": "<uuid-autenticado>",
  "schema_version": 2,
  "revision": 17,
  "content_version": "0.3.0",
  "last_synced_at": "<fecha-del-servidor>",
  "checksum": "<hash-de-carga>",
  "payload": {
    "screen": "fiebre_entrada",
    "zone": "fiebre",
    "missions": {},
    "flags": {},
    "discoveries": [],
    "documents": [],
    "messages": [],
    "unlocked": [],
    "choices": {}
  }
}
```

Es sólo una ilustración de la **envoltura cloud**. Los nombres y campos reales se acordarán tras probar la API; no se debe copiar este ejemplo a la producción sin esquema, validación y reglas de autorización. El `owner_id` se verifica con el usuario autenticado, nunca sólo con un ID enviado por el cliente. El servidor asigna revisión/fecha y comprueba conflictos.

---

## 29. NUEVO DESTINO WEB — `universo.israelzamora.es`

### 29.1 Arquitectura editorial confirmada por el autor

**Web principal de autor:** `https://universo.israelzamora.es/`.

El sitio presentará dos líneas literarias diferenciadas y un acceso al videojuego:

| Contenido | Identidad y papel | Integración prevista |
|---|---|---|
| **EL DIOS EN LA PLACA** | Primer libro del autor | Página de la obra, sin mezclar su identidad con el universo nuevo |
| **EL ARRECIFE** | Nuevo universo narrativo | Introducción al mundo, ambientación y materiales públicos sin spoilers mayores |
| **CARGA ADMISIBLE** | Segundo libro, perteneciente a EL ARRECIFE | Página de la novela, relaciones con el universo y vínculo opcional al juego |
| **Videojuego EL ARRECIFE** | Aventura gráfica de Sota que amplía ese universo | Experiencia jugable en una subruta del mismo dominio; su progreso no depende de leer el libro |

**Ubicación solicitada:** `https://universo.israelzamora.es/titulodeljuego/`.

La cadena `titulodeljuego` representa aquí el nombre pendiente de fijar en la URL. Una opción natural sería `https://universo.israelzamora.es/el-arrecife/`, **pero no queda aprobada automáticamente**; hay que comprobar que no coincida con la ruta editorial dedicada al universo. Si entra en conflicto, una subruta como `/juego/el-arrecife/` puede ser más clara. **Antes de publicar hay que fijar una única URL canónica y mantenerla estable.**

### 29.2 Requisitos para el hosting y el sitio

- Juego Godot Web accesible directamente desde una URL propia bajo el dominio por **HTTPS**, sin necesitar descargar una aplicación.
- La web literaria ofrece navegación clara entre las obras, el nuevo universo y el juego; la página jugable permite volver a la sección editorial.
- El juego debe funcionar servido desde **subdirectorio**, con rutas correctas a `.html`, `.js`, `.wasm`, `.pck`, imágenes y audio; configurar servidor/MIME, compresión y cabeceras necesarias según la exportación final.
- No cambiar de subruta a mitad del lanzamiento sin estrategia de migración; una redirección HTTP **no traslada por sí sola** los datos locales del navegador.
- Si se modifica dominio, subdominio, proyecto Godot o ruta, comprobar la identidad del almacenamiento real, no inferirla de que el sitio parezca el mismo. Los guardados en nube ligados a cuenta ofrecen recuperación independiente de la ruta.
- Separar cacheo de HTML/manifiesto y recursos versionados; probar que una nueva build no mezcle scripts/paquetes viejos y nuevos. Documentar despliegue reversible y comprobación de integridad.
- Confirmar plataforma, límites de archivos y reglas de reescritura del alojamiento antes de elegir el proceso de publicación; **no se ha verificado todavía ninguna configuración real de `universo.israelzamora.es`**.
- Preparar aviso de privacidad de juego/cuentas y tratamiento de datos; no cargar rastreadores ni scripts externos innecesarios en la experiencia de lectura.

### 29.3 Experiencia de entrada recomendada

**Web de autor → sección EL ARRECIFE → Jugar → sesión de Godot.**

La página informativa podría mostrar «Jugar», «Continuar en este dispositivo» y «Recuperar mi partida». Los detalles visuales son propuestas de UX, no diseños finales. En el primer acceso, el jugador puede probar sin registro, pero el juego le informa de manera comprensible de las ventajas de proteger su avance con cuenta.

No hace falta un login diferente para la página del libro y otro para el juego: si se configura una cuenta en el sitio, estudiar que se mantenga una sola identidad para el área interactiva. **Esto no supone que debamos exigir registro para consultar libros o artículos de la web.**

---

## 30. Plan de implementación inmediato — backlog SAVE / WEB

**Regla de prioridad:** `SAVE` y `WEB` se trabajan **en paralelo al pulido 0.2.x**; los componentes básicos de seguridad y continuidad son obligatorios antes de la primera publicación abierta. No se requiere que un jugador de una prueba privada cree cuenta mientras se desarrolla el sistema; hay que advertirle de la limitación.

### Tramo 1 — Empezar con la siguiente iteración (`0.2.1`)

- [ ] **`SAVE-01` · P0 · Estado y esquema de guardado.** Documentar cada campo existente de `State.data`, inmutabilidad de IDs de misión/mensaje, valor de `VERSION`, versión de contenido, validaciones y política de migración. Crear fixtures de partidas de varias edades y versiones. **Aceptación:** una partida v1 y una nueva pueden leerse de forma controlada; datos incompatibles no se borran.
- [x] **`SAVE-02` · P0 · Guardado local fiable.** Corregir `new_game()`/`persist()` y guardados atómicos por evento, `tmp`/`.bak`, fallos de escritura y estados de error. Diseñar exportación/importación manual de partida como segunda vía de recuperación, con aviso de información sensible y pruebas de manipulación. **Aceptación:** nunca se presenta como guardada una partida que falló; importación incorrecta no sustituye el estado sano. Alcance local y comprobaciones en el registro de ejecución; cuota real y otros navegadores siguen en P0-03/P0-05.
- [ ] **`SAVE-03` · P0 · Prueba vertical de identidad.** Elegir proveedor candidato, definir correo + código/enlace, flujo de recuperar sesión y posibilidad de empezar como invitado. Probar realmente desde Godot Web y la página bajo subruta. **Aceptación:** una persona puede salir, identificarse y volver a entrar con el mismo ID sin contraseña propia del juego.
- [ ] **`WEB-01` · P0 · Diseño de la web y URL canónica.** Registrar `universo.israelzamora.es` como destino editorial, confirmar alojamiento y elegir slug sin choque entre página «universo» y página «juego». Montar un entorno de pruebas independiente del público. **Aceptación:** mapa de rutas aprobado y Godot carga en HTTPS desde su subdirectorio de ensayo.

### Tramo 2 — Cuenta vinculada y primera nube (`0.2.2` o iteración técnica inmediata)

- [ ] **`SAVE-04` · P0 · Primer snapshot remoto.** Implementar tabla/API de partida por usuario y slot, autorización real y revisión de contenido, sin secretos administrativos en el cliente. **Aceptación:** dos cuentas no acceden a los datos de la otra; guardar y leer devuelve el mismo estado validado.
- [ ] **`SAVE-05` · P0 · Sincronización con conflictos.** Guardado local inmediato, cola pendiente offline, revisiones controladas por servidor, detección de dos escritores, copias antes de resolver y mensajes claros. **Aceptación:** actualizar desde un dispositivo obsoleto no destruye una partida más avanzada; el fallo de red preserva el progreso local.
- [ ] **`SAVE-06` · P0 · Invitado → cuenta.** Vincular la partida local al usuario recuperable **sin borrar la copia existente antes de que el servidor confirme**. Si la cuenta ya tiene partida, mostrar elección entre ambas o fusión sólo cuando exista una regla segura. **Aceptación:** ninguna vinculación silenciosa sobrescribe una partida previa.
- [ ] **`SAVE-07` · P0 · Carga y migración en otro dispositivo.** Iniciar sesión en navegador nuevo, descargar, validar, migrar, guardar localmente y continuar con ubicación/elecciones exactas. Bloquear escrituras de clientes antiguos incompatibles con un esquema superior. **Aceptación:** misma historia y estado del jugador en Chrome y otro navegador/dispositivo probado.

### Tramo 3 — Puerta de publicación pública (sin aplazar a los DLC)

- [ ] **`SAVE-08` · P0 · Respaldo y recuperación real.** Definir retención, historial de revisiones, simulación de corrupción de snapshot, restauración y recuperación tras pérdida del dispositivo. **Aceptación:** se recupera una copia anterior sin afectar a otras cuentas y se documentan límites y procedimientos.
- [ ] **`SAVE-09` · P0 · Seguridad y privacidad.** Probar RLS/permisos por operación, sesiones vencidas, cierre de sesión, enlace mágico/código, borrado/exportación del usuario, límites de carga, no exposición de secretos, información de privacidad y tratamiento de datos. **Aceptación:** tests de aislamiento entre usuarios pasan; requisitos legales y operativos aprobados para distribución prevista.
- [ ] **`WEB-02` · P0 · Despliegue en el subdirectorio definitivo.** Construir Web reproducible, servir archivos y comprobar rutas, `wasm`, audio, HTTPS, cacheo, navegación y orientación móvil. **Aceptación:** cargar desde URL directa, volver desde la web de autor, recargar y continuar funciona.
- [ ] **`WEB-03` · P0 · Actualización sin pérdida.** Publicar una versión A en staging, jugar y sincronizar, desplegar versión B con misión/mensaje adicional, reabrir la misma cuenta en distinto dispositivo y verificar migración + entrega del mensaje una sola vez. **Aceptación:** ni progreso anterior ni nuevos contenidos desaparecen y no se duplica el aviso.
- [ ] **`WEB-04` · P0 · Prueba de desastre y release.** Simular almacenamiento del sitio borrado, desconexión, pestañas duplicadas, token caducado, nueva versión y rollback. **Aceptación:** cada caso termina en progreso recuperable o aviso honesto sin sobrescribir datos sanos; checklist firmado.

**Dependencias razonables:** `SAVE-01/02` → `SAVE-04/05` → `SAVE-06/07` → `SAVE-08/09` → `WEB-03/04`. `SAVE-03` y `WEB-01` comienzan en paralelo con `SAVE-01/02`. La revisión visual/narrativa puede continuar sin bloquearse por la infraestructura.

### 30.1 Cambios en código y documentación previstos

| Archivo o componente | Acción propuesta |
|---|---|
| `game/scripts/core/state.gd` | Hacer fiable el resultado de guardado, aislar serialización/migración, definir interfaz para snapshots |
| `game/scripts/core/content.gd` y JSON de contenido | IDs estables; nuevas misiones sin alterar la semántica de las antiguas |
| Nuevo módulo de persistencia/sincronización | Guardado local + API remota + conflictos + estado offline; nombre por decidir |
| UI del menú, deck y opciones | Cuenta opcional, «Proteger partida», recuperación, estado de sincronización y errores |
| `game/tests/` | Pruebas de migraciones, corrupción, conflictos, auth mock y recuperaciones en Web real |
| `game/export_presets.cfg` y pipeline de Web | Despliegue en subruta, configuración por entorno, sin credenciales privadas en el build |
| `docs/GAME_DESIGN.md`, `docs/VALIDACION.md`, `README.md`, `task.md` | Formalizar decisión, guardar evidencia, pasos de QA y requisitos de publicación |
| Web de autor (proyecto aún no inspeccionado) | Páginas editoriales y contenedor del juego, respetando rutas, accesibilidad y privacidad |

---

## 31. Matriz obligatoria de pruebas de protección de progreso y publicación

**Se debe ejecutar sobre la exportación Web alojada en una subruta real de prueba**, no sólo en el Godot nativo o en `localhost`. No confundir tests de simulación con recuperación real desde otro equipo.

| Escenario | Resultado exigido |
|---|---|
| Invitado: jugar → cerrar → volver | Continuar recupera el guardado local cuando persiste el almacenamiento; se advierte del riesgo de limpieza |
| Invitado: exportar → borrar navegador → importar | Se restaura el estado exacto de un archivo íntegro, sin permitir que un archivo malicioso corrompa la partida |
| Invitado con avance → vincular cuenta nueva | Snapshot remoto confirmado y copia local conservada; el menú refleja sincronización terminada |
| Cuenta A: mismo navegador → cerrar sesión → abrir cuenta B | B no ve la historia ni la configuración privada de A; aislamiento de guardados correcto |
| Cuenta A: móvil → PC / Chrome → Firefox | La misma partida aparece y se puede seguir, con decisiones y mensajes conservados |
| Cuenta A: borrar datos del navegador → iniciar sesión | Se descarga una copia remota comprobada y se puede continuar |
| Jugar offline → volver online | El avance local se mantiene y sincroniza; se informa del estado real |
| Dos pestañas o dispositivos con cambios incompatibles | Se detecta conflicto, se conservan ambas copias y no se escoge arbitrariamente una |
| Token caducado / fallo del proveedor | El juego no finge sincronizar; conserva copia local y ofrece reautenticación |
| Cuenta A intenta acceder a `save_id` de B | Acceso denegado para lectura y escritura; pruebas de reglas de backend |
| Partida v1 + actualización con contrato nuevo | Migración sin pérdida; misión nueva bloqueada/pendiente correctamente |
| Cliente antiguo intenta subir sobre guardado nuevo | Rechazo seguro de revisión/esquema, sin downgrade destructivo |
| Actualización Web con caché anterior | No se mezclan assets incompatibles ni se sobrescribe la partida por error |
| Cambio de ruta/origen (ensayo controlado) | Riesgo documentado; recuperación por cuenta o estrategia explícita de migración local |
| Copia remota dañada o última revisión equivocada | Se puede seleccionar/restaurar una revisión válida autorizada |
| Desactivación de persistencia/privado/espacio lleno | Advertencia comprensible; ningún mensaje de éxito falso |
| Eliminación de cuenta/exportación de datos | Flujo probado y política de retención coherente con el texto de privacidad |

### Condiciones para considerar la primera publicación pública

- [ ] Existe una URL canónica y estable en `https://universo.israelzamora.es/<slug-aprobado>/`.
- [ ] El visitante conoce la diferencia entre **partida invitada local** y **partida protegida por cuenta**.
- [ ] Guardado local verificable y estado de sincronización visible; ni siquiera sin red se notifica éxito remoto falso.
- [ ] Cuenta recuperable probada desde un segundo dispositivo y un segundo navegador.
- [ ] Restauración de un historial anterior probada de verdad.
- [ ] Migraciones por versión preparadas para misiones y DLC futuros.
- [ ] Pruebas de acceso cruzado entre cuentas, privacidad y sesión superadas.
- [ ] Despliegue Web actualizado sobre otra versión sin perder datos.
- [ ] Documentación de limitaciones y soporte ante problemas de cuentas y partidas.

Si falla cualquiera de estos puntos críticos, **no abrir el lanzamiento al público**. Las pruebas privadas pueden continuar con participantes informados y copias de prueba.

---

## 32. Decisiones nuevas y pendientes vinculadas a cuentas y web

| Tema | Decisión o estado | Responsabilidad |
|---|---|---|
| Plataforma editorial | `universo.israelzamora.es`, centro web literario | **Decisión del autor** |
| Primer libro | **EL DIOS EN LA PLACA** | **Información aportada por el autor** |
| Universo nuevo | **EL ARRECIFE** | **Información aportada por el autor** |
| Segundo libro | **CARGA ADMISIBLE**, del universo EL ARRECIFE | **Información aportada por el autor** |
| Juego | En una subruta de `universo.israelzamora.es` | **Decisión del autor** |
| Slug concreto | `/titulodeljuego/` es marcador; `/el-arrecife/` o `/juego/el-arrecife/` son opciones | **Pendiente de aprobación** |
| Sincronización | Local primero + nube asociada a cuenta recuperable | **Objetivo prioritario aprobado** |
| Acceso invitado | Permitir jugar sin registro con riesgo explicado | **Propuesta UX para aprobar** |
| Autenticación | Correo con código/enlace; backend candidato Supabase | **Pendiente de prototipo y aprobación técnica** |
| Multidispositivo | Recuperación real + conflictos controlados | **Requisito de calidad propuesto para el público** |
| Alojamiento web/backend | Proveedor, configuración, costes y región | **Pendiente; no verificado** |
| Privacidad | Política, gestión de cuentas, exportación y borrado | **Pendiente de diseño y revisión legal** |
| Implementación actual | Sólo guardado local v1 y copias en disco | **Confirmado en código; no confundir con sistema entregado** |

**Siguiente paso operativo:** abrir `SAVE-01`, `SAVE-02`, `SAVE-03` y `WEB-01` en el backlog del proyecto. Esto no reemplaza los arreglos P0 existentes: son la primera parte del sistema que evitará que los jugadores pierdan años de historias con cada nuevo DLC.

### Referencias técnicas para la implementación

- Código actual: [`game/scripts/core/state.gd`](https://github.com/isradev-git/arrecife-game/blob/main/game/scripts/core/state.gd).
- [Godot · Data paths (`user://` en HTML5 / IndexedDB)](https://docs.godotengine.org/en/stable/tutorials/io/data_paths.html).
- [Godot · Exporting for the Web (limitaciones de persistencia)](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html).
- [Supabase · Row Level Security](https://supabase.com/docs/guides/database/postgres/row-level-security).
- [Supabase · Anonymous sign-ins](https://supabase.com/docs/guides/auth/auth-anonymous).

**Principio editorial y técnico:** **el universo se descubre en la web del autor; la historia jugada pertenece a cada jugador y debe poder recuperarse cuando vuelva a EL ARRECIFE.**

## Registro de ejecución · 23 oct 2026

Esta actualización registra **dos tandas locales**, sin cambiar las decisiones pendientes de la sección 32. [Formato, límites y arquitectura](SAVE_SYSTEM_ARCHITECTURE.md) y [resultados](VALIDACION.md).

| Tarea | Estado comprobado | Falta para aceptación completa |
| --- | --- | --- |
| P0-01 | Hecha: fallo de `new_game()` se devuelve y conserva partida previa/memoria. | Prueba física de cuota y permisos Web. |
| P0-02 | Hecha: documento y efectos en una escritura; repetición idempotente. | Ensayo de interrupción real en navegador. |
| P0-03 | Parcial: `.bak`, `.tmp`, primario/backup corruptos y renombrado fallido en tests locales. | Cuota Web, corte real y más etapas del renombrado. |
| P0-04 / SAVE-01 | Parcial: esquema v1 documentado, fixture v1 cargado, misiones nuevas bloqueadas, versión futura protegida. | Matriz exhaustiva de transiciones imposibles y fixtures de futuras versiones cuando existan. |
| SAVE-02 | Hecha en el alcance local: controles nativos y Web, confirmación, copia previa recuperable desde el juego, archivo alterado rechazado, descarga y restauración tras borrar IndexedDB probadas. | Pruebas de cuota real Web y otros navegadores/dispositivos corresponden a P0-03/P0-05. |
| SAVE-03 | Diseño técnico candidato, sin identidad configurada. | Prototipo real de correo/sesión bajo HTTPS y subruta. |
| SAVE-04 / SAVE-05 | Modelo de revisiones, offline y conflicto probado con mock; sin backend. | Auth, RLS y repositorio reales, cola durable, historial, pruebas con dos cuentas y dispositivos. |
| WEB-01 | Parcial: exportación Godot 4.7.2 servida y ejecutada en Chromium desde `/ensayo-022/`; rutas relativas, MIME, archivo y recuperación local comprobados. | Slug aprobado, staging HTTPS y configuración real de Ginernet. |

**Ejecución:** primera tanda: baseline 827/827 headless y 899/899 nativas; después 73/73 de integridad, 7/7 de sincronización simulada, 827/827 headless, 899/899 nativas y preservación correcta. Segunda tanda: nueva prueba de interfaz 13/13 headless y 16/16 nativa, suite principal 827/827 headless y 899/899 nativa; recorrido Web de exportación, archivo incompatible, perfil nuevo, restauración tras borrar IndexedDB y recuperación de una copia local anterior. La revisión inicial añadió la preservación del único `.tmp` válido y el aislamiento de identidad del modelo; la segunda detectó y permitió cerrar la falta de acceso a `.previa-*` desde Web. El aislamiento del mock no equivale a autorización RLS. Nada se ha desplegado ni vinculado a una cuenta.
