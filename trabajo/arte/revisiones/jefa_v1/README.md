# Velvet · Jefa adaptada al retrato T08.1

12 de octubre de 2026. [Sprite, procedencia y prompt](../../personajes/jefa/pixel_v1/README.md); [retratos originales y decisión de diálogo](../../personajes/retratos_v1/README.md). Identidad y composición aportadas por el autor; adaptación entregada por el asistente y **aprobada visualmente por el autor el 12 de octubre**.

Seis renders nativos sin panel y seis capturas reales de Helium/Chromium, todos a 1672 × 941. Guardia/cabina, acceso y barandillas conservados. Sota de 252 con pies y = 705; Jefa de 244 con apoyo y = 675.

| Estado | Godot | Web |
| --- | --- | --- |
| Galería, Sota x = 780 | [Imagen](godot_galeria.png) | [Imagen](web_galeria.png) |
| Frente al mostrador x = 1345, perfil derecho | [Imagen](godot_completa_0.png) | [Imagen](web_completa_0.png) |
| Frente al mostrador, perfil izquierdo | [Imagen](godot_completa_1.png) | [Imagen](web_completa_1.png) |
| Mostrador y equipo sin Jefa | [Imagen](godot_sin_jefa.png) | [Imagen](web_sin_jefa.png) |
| Jefa y mostrador sin equipo | [Imagen](godot_sin_equipo.png) | [Imagen](web_sin_equipo.png) |
| Interior sin Jefa, mostrador ni equipo | [Imagen](godot_interior.png) | [Imagen](web_interior.png) |

Las tres últimas usan Sota x = 1345 y perfil derecho. Ambas barandillas visibles en todas.

Godot 4.7.2 Compatibility, Apple M4: se reutiliza `tests/recepcion.gd`, ampliando la anchura de muestreo al nuevo sprite. Pasan alfa genuino, nearest, apoyo y orden. GPU: 13 680 muestras de figura, 2283 de equipo, 7919 de cuerpo correctamente tapadas por mostrador; Sota delante en ambos perfiles, 9346/8624 muestras conservadas. Pasan también escala, escena técnica, barandillas en ocho posiciones/perfiles, mostrador y cabina. Importación y exportación Web con código 0. Retratos y copia generada idénticos a sus originales por SHA-256.

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/recepcion.gd
```

Añadir `-- --capturas` guarda los seis renders actuales en esta carpeta; no sobrescribe capturas históricas de recepción. Requiere GPU, sin `--headless`.

Agent-browser, sesión propia `arrecife-jefa-20261012`, Helium/WebGL 2.0: carga, Frente al mostrador, ambos perfiles y visibilidad de Jefa/equipo/mostrador por clic comprobados sin errores de página/consola. Automatización cerrada, Godot/URL actualizados abiertos; HTTP local comprobado en `http://127.0.0.1:8766/godot/build/web/`.

Todavía sin animación ni interfaz de diálogo; contraluz manual. Retratos guardados para su integración posterior. Safari/Firefox, rendimiento sostenido y juego completo no comprobados en esta entrega.

Continuación T08.2: [libro independiente y nuevas capturas](../libro_v1/README.md). Estas imágenes se conservan; la prueba de recepción guarda ahora siete renders en `libro_v1`.
