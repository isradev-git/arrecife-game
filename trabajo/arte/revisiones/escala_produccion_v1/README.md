# Velvet · Comparación de escala y raster T02.1

12 de octubre de 2026. El autor autoriza preparar una comparación concreta de escala/píxel antes del movimiento. Sota v7 y Jefa aprobadas conservan sus PNG, materiales y planos. **Propuesta del asistente, pendiente de valoración visual; no se declara T02 completada.**

[Ver lámina completa](comparacion.png) · [Abrir comparación HTML](comparacion.html). La página muestra recortes mediante CSS de los renders originales; no modifica los PNG. Cada recorte de 400 × 350 corresponde a x = 1110, y = 400 de la escena, a tamaño real. En el juego, **Comparar Jefa** sitúa a Sota en x = 1260; permiten comparar los botones 232/252/272.

## Propuesta de base

| Elemento | Propuesta | Motivo observado |
| --- | --- | --- |
| Sota | V7, altura 252 | A 232 pierde presencia junto a mostrador/Jefa; a 272 domina la recepción. 252 conserva proporciones y lectura del equipo. |
| Jefa | Altura 244, posición y diseño actuales | Aprobada; sin cambios de dibujo, escala ni apoyo. |
| Raster de referencia | 1672 × 941 y nearest | Conserva mejor ojos mínimos, correa, neón fino y piezas doradas. |
| Alternativa de comparación | 836 × 471, ampliada 2× sin suavizado | Píxel de 2×2 a escala de escena; engrosa toda la ciudad y pierde detalle. Solo comparación, no aplicada al juego. |
| Apoyos | Sota y = 705; Jefa y = 675 | Centro de pasarela y plano trasero distintos; no igualar sus pies ni sus cabezas. |

La retícula de esta comparación es la del **render**, no una supuesta retícula artística común de los PNG generativos. Los atlas actuales tienen escalas fraccionarias y agrupaciones propias; esta entrega no los redibuja ni los convierte en hojas de animación. Conservar el aspecto aprobado al preparar ciclos y probar el escalado final en distintas ventanas. El raster a mitad tiene 471 filas para contener la escena: al ampliar mide 942, una fila más que el original de 941.

Godot diferencia el render a resolución de ventana (`canvas_items`, usado en la escena actual) del render a resolución fija (`viewport`) y permite escalado entero. No se cambia la configuración principal por comparar un raster menor; la elección deberá comprobarse también con movimiento y tamaños de ventana. [Documentación oficial de múltiples resoluciones](https://docs.godotengine.org/en/stable/tutorials/rendering/multiple_resolutions.html).

## Capturas

Doce renders nativos, tres alturas × dos perfiles × dos posiciones; un raster reducido; cuatro capturas reales de la exportación Web y una lámina capturada en navegador.

| Altura de Sota | Junto a Jefa, derecho / izquierdo | Junto a cabina, derecho / izquierdo | Web junto a Jefa |
| --- | --- | --- | --- |
| 232 | [Derecho](godot_jefa_232_0.png) / [Izquierdo](godot_jefa_232_1.png) | [Derecho](godot_guardia_232_0.png) / [Izquierdo](godot_guardia_232_1.png) | [Imagen](web_jefa_232.png) |
| 252 | [Derecho](godot_jefa_252_0.png) / [Izquierdo](godot_jefa_252_1.png) | [Derecho](godot_guardia_252_0.png) / [Izquierdo](godot_guardia_252_1.png) | [Derecho](web_jefa_252.png) / [Izquierdo](web_jefa_252_izquierdo.png) |
| 272 | [Derecho](godot_jefa_272_0.png) / [Izquierdo](godot_jefa_272_1.png) | [Derecho](godot_guardia_272_0.png) / [Izquierdo](godot_guardia_272_1.png) | [Imagen](web_jefa_272.png) |

[Raster reducido](godot_pixel_2.png), 836 × 471. Los demás renders/capturas del juego son 1672 × 941; la lámina tiene el alto completo del documento.

## Comprobaciones

Godot 4.7.2 Compatibility, Apple M4. Pasan `tests/escala.gd` y la nueva `tests/escala_produccion.gd`: tres alturas, ambos perfiles, posiciones 1260/300, suela de Sota en 705, altura/posición/escala de Jefa invariantes y nearest. Render GPU de las 12 combinaciones y raster reducido capturados; cambiar la resolución de prueba no cambia los pivotes lógicos. Materiales/planos originales conservados; no se vuelven a ejecutar las pruebas de oclusión, ya superadas con los mismos recursos en la entrega anterior.

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/escala_produccion.gd
```

Añadir `-- --capturas` guarda los 13 renders nativos en esta carpeta. Requiere GPU, sin `--headless`. Importación del script y exportación Web correctas; release termina con código 0.

Agent-browser, sesión propia `arrecife-escala-produccion-20261012`, Helium/WebGL 2.0: Comparar Jefa, las tres alturas y ambos perfiles por clic, sin errores de página/consola. Lámina HTML revisada visualmente, sus cinco imágenes cargadas con dimensiones correctas y enlaces locales comprobados. Automatización cerrada; Godot y comparación abiertos. HTTP local en `http://127.0.0.1:8766/`; comprobar servidor al retomar.

Sin generación ni edición de arte. Pendientes valoración de esta propuesta, escalado final a otras ventanas/DPR, movimiento, animación, luz espacial y otros navegadores. La aprobación previa de los dibujos no equivale a aprobación de toda esta comparación.

**Decisión posterior · 13 de octubre:** el autor dice «252 mucho mejor» y aprueba esa altura de Sota. Se mantiene v7 y Jefa 244. No se interpreta como aprobación de toda la retícula/raster ni de iluminación; T02 permanece abierta técnicamente. Continúa T04 con el sprite provisional.
