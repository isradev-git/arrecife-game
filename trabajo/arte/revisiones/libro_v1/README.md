# Velvet · Libro propio de la Jefa T08.2

12 de octubre de 2026. El autor aprueba explícitamente el sprite de la Jefa de T08.1. [Libro, recurso y prompt de imagegen](../../personajes/jefa/libro_v1/README.md) entregados por el asistente; objeto nuevo pendiente de valoración.

Siete renders nativos sin panel y siete capturas reales de Helium/Chromium, 1672 × 941. Jefa y recursos de escena anteriores intactos. Libro apoyado en superficie y = 538, detrás de sus manos; Sota en centro y = 705. Ambas barandillas visibles.

| Estado | Godot | Web |
| --- | --- | --- |
| Galería, Sota x = 780 | [Imagen](godot_galeria.png) | [Imagen](web_galeria.png) |
| Frente al mostrador x = 1345, perfil derecho | [Imagen](godot_completa_0.png) | [Imagen](web_completa_0.png) |
| Frente al mostrador, perfil izquierdo | [Imagen](godot_completa_1.png) | [Imagen](web_completa_1.png) |
| Jefa y equipo sin libro | [Imagen](godot_sin_libro.png) | [Imagen](web_sin_libro.png) |
| Libro visible sin Jefa | [Imagen](godot_sin_jefa.png) | [Imagen](web_sin_jefa.png) |
| Libro y Jefa sin equipo | [Imagen](godot_sin_equipo.png) | [Imagen](web_sin_equipo.png) |
| Interior sin mostrador, Jefa, equipo ni libro | [Imagen](godot_interior.png) | [Imagen](web_interior.png) |

Las cuatro últimas usan Sota x = 780 y perfil derecho. La vista sin Jefa permite ver el objeto completo sin la oclusión de sus manos.

Godot 4.7.2 Compatibility, Apple M4. `tests/recepcion.gd` amplía la comprobación existente: alfa genuino, nearest, tapa apoyada en superficie, libro detrás de Jefa y manos delante. GPU aislada sin equipo: 232 muestras de páginas visibles y 519 de manos/cuerpo conservadas sobre el libro; la prueba admite el alfa parcial real del sprite mediante su tolerancia existente. Jefa conserva 13 680 muestras, equipo 2283, mostrador tapa 7919 del cuerpo. Sota delante de recepción y libro en ambos perfiles: 9346/8624 muestras conservadas. Pasan escala, ocho posiciones/perfiles de barandillas y mostrador; importación/exportación con código 0. Se corrigieron calibración inicial y muestreo de bordes antes de la ejecución final sin errores.

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/recepcion.gd
```

Añadir `-- --capturas` guarda siete renders en esta carpeta, conservando las revisiones anteriores. Requiere GPU, sin `--headless`.

Agent-browser, sesión propia `arrecife-libro-20261012`, Helium/WebGL 2.0: carga, Frente al mostrador/Galería, ambos perfiles, interruptor Libro y visibilidad independiente de Jefa/equipo/mostrador por clic correctos, sin errores de página/consola. Automatización cerrada; Godot/URL actualizados abiertos. HTTP local comprobado en `http://127.0.0.1:8766/godot/build/web/`; verificar servidor al retomar.

Libro y Jefa todavía estáticos; no consulta, anotación ni diálogo implementados. Diseño del libro pendiente de valoración. Safari/Firefox, rendimiento sostenido y caso completo no comprobados en esta entrega.
