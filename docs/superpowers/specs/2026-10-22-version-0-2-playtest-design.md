# El Arrecife 0.2.0 · diseño para la primera prueba

## Propósito y autoridad

El autor pidió el 22 de octubre de 2026 preparar la primera versión para un jugador, renombrarla **0.2.0**, alinear la conversación con los retratos y añadir mensajes personales que lleguen durante la partida. Dio libertad creativa para pulir el conjunto. La madre, la hermana y Lía son vínculos y textos **propuestos para el videojuego**; esta entrega no los incorpora al canon literario. Los chats no fijan dónde vive la familia ni una edad, oficio o trayectoria que el autor no haya definido.

## Diálogo

Los PNG originales de Sota y la Jefa siguen intactos y apoyados en la base de la pantalla. El bloque central de conversación empieza a la altura superior de esos retratos, entre ambos personajes. Texto y decisiones largos se desplazan dentro de ese bloque; «Volver a la escena» permanece visible al pie. Se comprueba a 1280×720 y 844×390, también con texto largo.

## Mensajes del deck

La pestaña «Mensajes» muestra primero los hilos con novedades, agrupados por remitente, con asunto reciente y cantidad sin leer. Abrir un hilo enseña las entradas disponibles en orden, en bocadillos distintos para quien escribe y para Sota; sitúa la vista en el primer mensaje nuevo. Una entrada puede ofrecer una o dos respuestas breves; al elegir una, aparece la réplica del contacto y la vista se sitúa allí. La elección, la lectura y sus efectos se guardan. Lectura y oferta de contrato se escriben juntas; reabrir un mensaje leído recupera una oferta anterior interrumpida. El botón «Deck» muestra un contador discreto de mensajes sin leer; cambiar de zona no repite avisos.

Contenido inicial y hitos:

- La Jefa envía el primer encargo. Tras hablar con ella, pide guardar su contacto directo para localizar a Sota; la tercera misión mantiene su propio mensaje.
- La madre pregunta cómo está Sota al empezar. Un segundo mensaje breve llega tras el informe policial. Su ubicación y la historia de la relación quedan abiertas.
- La hermana pide opinión sobre un grupo nuevo durante el primer contrato. No se define su edad ni residencia.
- Lía, conocida de La Fiebre y contacto original del videojuego, escribe después del encuentro con la Jefa y vuelve a hacerlo tras el cierre. Su oficio no queda fijado.
- El enlace policial conserva el mensaje de la segunda misión. Ningún chat personal exige un informe ni altera el desenlace.

Se reutilizan `story.json`, `State.data.messages` y `State.data.choices`: el formato de guardado permanece en versión interna 1 para no perder partidas existentes. Los mensajes nuevos se descubren por condiciones de misión o flag. Los contactos se muestran cuando son pertinentes; el de la Jefa se activa al guardarlo. No se añade servidor, dependencia, reloj real ni mensajes infinitos.

## Versión y entrega

`project.godot`, créditos, README y documentación vigente dirán **0.2.0**. La exportación Web debe poder abrirse por HTTP y la versión nativa de Godot debe recorrer las tres misiones. La guía de la primera partida indica controles, orientación móvil, duración objetivo y cómo comunicar fallos. Los fondos y la ficción siguen sujetos a valoración del autor durante la prueba; «lista para probar» no significa publicación final.

## Aceptación

Importación, prueba headless, prueba nativa GPU, preservación y exportación Web sin errores. Pruebas de aparición por hitos, lectura, respuestas persistentes, oferta de contratos, carga de guardado anterior y ambos finales. Capturas reales de diálogo y hilos en escritorio y horizontal móvil, inspeccionadas antes de entregar.
