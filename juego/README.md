# Pase pendiente · v0.2

**Actualización del 9 de octubre de 2026:** el autor ha decidido producir el juego completo en Godot. Esta carpeta conserva el prototipo funcional de referencia. La instalación y la prueba de exportación están en [godot/](../godot/README.md); el orden de producción está en [PLAN_GODOT.md](../proceso/PLAN_GODOT.md).

Primera versión jugable del caso de Sota, en El Arrecife. Cuatro pantallas, conversaciones, siete pruebas más el encargo, contraste documental y desenlace. Sin instalación de dependencias ni conexión externa.

## Abrir

Abre `index.html` con Safari o con tu navegador. Se ha comprobado el recorrido completo en Safari abriendo el archivo directamente. Si haces doble clic y se abre un editor, usa «Abrir con → Safari» desde Finder.

Alternativa desde esta carpeta: `npm start` y después `http://127.0.0.1:8765`. Requiere Node para el comando npm y Python 3 para el servidor. La primera prueba se hizo como archivo local por una restricción del entorno anterior; el 9 de octubre se comprobó también el arranque por HTTP local en el puerto 8766.

## Jugar

- Flechas o A/D: caminar. También puedes pulsar el suelo.
- Mayús mientras caminas: correr. «Correr» activa un modo persistente; doble clic corre hasta un punto.
- F o «De frente»: detenerse y mirar al frente. Al descansar, Sota gira sola después de una pausa breve.
- Pulsa un punto para acercarte e interactuar. «Explorar» enumera todas las interacciones.
- J: libreta. M: recorrido. H: mostrar nombres. E: interactuar cerca.
- La libreta conserva las copias completas. En «Contrastar», elige dos pruebas y una afirmación.
- El recorrido se amplía al leer direcciones. El informe indica qué falta antes del cierre.
- Opciones permite ampliar texto y reducir movimiento.

Guardado automático local después de las acciones; una conversación se registra al terminarla. «Comenzar» pide confirmación antes de sustituir una partida. Usa siempre el mismo navegador y la misma ruta para retomarla; los guardados de archivo local y servidor son distintos. No hay cuentas ni envío de datos.

## Archivos de trabajo

- `src/content.js`: guion de conversaciones, escenarios y deducciones.
- `src/evidence.js`: tarjetas completas procedentes de `../trabajo/diseno/prueba_mesa_v2/jugador/`.
- `src/engine.js`: reglas, progreso y validación del guardado.
- `src/app.js`: composición, interacción, libreta e interfaz.
- `src/motion.js`: aceleración, frenada, destinos y cadencia por distancia.
- `src/sprites.js`: hojas y puntos de apoyo medidos.
- `src/atmosphere.js`: vapor, lluvia localizada, iluminación, ventilación y tránsito lejano.
- `assets/`: fondos y hoja de Sota. Instrucciones y procedencia en `arte/`.
- `PRODUCCION.md`: alcance y criterios de esta entrega.

El canon y los archivos sincronizados no se modifican. Los locales y personajes dibujados en los fondos nuevos son propuestas visuales del proyecto.

## Verificación · 9 de octubre de 2026

`npm test`: trece pruebas pasan; siete comprueban movimiento, límites, llegada a destinos, recortes de sprites y efectos ambientales. Se conservan las seis pruebas del caso (recorrido completo con deducción tardía; errores sin pérdida; consentimiento y lectura; copias al salir de Sanz; guardados inválidos; integridad del contenido y recursos).

Recorrido manual completo en Safari: encargo, casillero, Sanz, Berta e Iria, ocho documentos, respuesta incorrecta con explicación, deducción correcta, informe, devolución parcial y pantalla de cierre. Comprobados arranque directo, desplazamiento hasta interacción, opciones de movimiento, libreta y comparación de documentos.

Comprobada también la recarga de Safari: «Continuar» recupera el cierre y las ocho tarjetas. La partida de comprobación queda en ese navegador; pulsa «Comenzar» para sustituirla con tu propia prueba.

## Límites actuales

- No se ha medido una partida de lectura natural de 25–35 minutos. La prueba funcional avanza diálogos rápidamente.
- Fondos aplanados, sin parallax ni animación propia de los personajes secundarios principales. Ahora hay efectos ambientales y pequeñas siluetas lejanas móviles. La coda se narra sobre el escenario existente.
- Sota usa ocho poses de caminar, ocho de correr y una hoja de reposo con vistas de perfil, tres cuartos y frente. La respiración y el leve balanceo se componen en el motor con los pies anclados. Los sprites generados aún tienen pequeñas variaciones de ropa entre fotogramas; al ir hacia la izquierda se refleja también el equipo. La escala entre personajes y las oclusiones necesitan una revisión visual específica.
- No hay una retícula de píxel de producción fijada. Los fondos conservan la estética aprobada, pero no constituyen un tileset.
- Sin audio ni consumo de ElevenLabs. Sin enlace de Amazon hasta verificarlo.
- No se ha validado aún móvil, otros navegadores ni rendimiento en equipos modestos.

La siguiente prueba útil es que el autor complete una partida y anote dónde duda, qué texto sobra y dónde la deducción se vuelve demasiado obvia. Después se ajustan ritmo, sprite y composición; no se añaden localizaciones.

## Revisión de movimiento

Detalles, recursos versionados, prompts y valoración: [arte/movimiento_v2.md](arte/movimiento_v2.md). Comprobados en Safari el arranque de esta revisión, la vista frontal, caminar y correr hasta conversaciones. Los nuevos efectos no cambian pistas, texto, estructura de guardado ni condiciones del caso. «Reducir movimiento» desactiva respiración y ambiente; la libreta pausa la animación y una pestaña oculta suspende la actualización.
