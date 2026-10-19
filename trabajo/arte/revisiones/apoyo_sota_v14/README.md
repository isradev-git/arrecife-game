# Sota · extensión de la pierna de apoyo · Modelo 14

16 de octubre de 2026. El autor confirma que Modelo 13 es más fluido, pero señala postura agachada y ambas rodillas permanentemente flexionadas. Esa valoración aprueba la mejora de fluidez, no la postura. Se corrige sobre el rig actual; Sota 0.1 stable y atlas v8/v9 permanecen intactos.

## Causa y cambio

El Modelo 13 imponía cadenas de 60+60 / 58+58 px a unos tobillos y caderas ya fijados. La longitud sobrante se resolvía doblando ambas rodillas incluso al apoyar. La prueba anterior exigía una flexión mínima >8° y no limitaba la flexión de apoyo: detectaba tirones, pero permitía esta postura incorrecta.

Se sustituye esa resolución de rodilla por una curva de poses según la fase de cada pierna: contacto casi extendido (6°), absorción moderada (hasta 16°), extensión a mitad del apoyo, flexión progresiva al despegar y recuperación de 62°, regresando suavemente al contacto. La rodilla se coloca sobre la mediatriz cadera-tobillo con el ángulo definido. Es animación dirigida del modelo 2D, con deformación de tela ya existente; no un esqueleto físico de huesos rígidos ni una nueva simulación biomecánica.

Cambian las rodillas y su tela. Trayectorias de botas, balanceo corporal, brazos, cabeza, velocidad, ciclo, escala y ocho niveles de transición se conservan. Izquierda reflejada como pidió el autor. Se hornea `articulada_v10` y se actualizan controlador y Web. Fuentes anteriores en `*_antes.gd.txt`; comparación con Modelo 13, no con stable.

## Regresión reproducida y comprobaciones

`Godot --headless --path godot --script res://tests/suavidad_sota.gd -- --modelo13` sale con código 1; sin el argumento sale con código 0. 2049 muestras incluyendo cierre del ciclo:

| Medida | Modelo 13 | Modelo 14 |
| --- | --- | --- |
| Máxima flexión en apoyo medio, fondo/cercana | 39,88° / 41,17° | 16° / 16° |
| Flexión mínima, fondo/cercana | 25,53° / 15,93° | 6° / 6° |
| Máxima flexión en recuperación | 78,80° / 83,20° | 62° / 62° |
| Muestras con ambas rodillas >20° | 1957 de 2049 | 0 de 2049 |
| Mayor salto angular por 1/2048 ciclo | 0,29° | 0,17° |

La prueba conserva límites de continuidad, recuperación y suelo; ahora exige extensión suficiente en apoyo. Las cifras son medidas del rig y criterios de esta animación, no una certificación de naturalidad ni medidas entre fotogramas del atlas.

- `flexion_sota`: trayectorias de botas y cuerpo iguales a Modelo 13; comparación GPU de ocho fases.
- `modelo_sota`: 584 poses con cobertura de cintura/rodilla/bota, sin piel incrustada; invariantes superiores y punteras horizontales conservados.
- `silueta_sota`: 0/768 secciones por debajo del volumen mínimo.
- `integridad_sota`: 594 poses, ninguna con piezas separadas ≥8 px; mayor residuo 1 px.
- `reflejo_sota`: 297 parejas exactas píxel a píxel.
- `movimiento_sota`: paleta, alfa, cabeza, escala, ciclo, cierre, reducción y límites correctos; veinte capturas nativas.
- `fluidez_marcha`: ambos sentidos, 30 y 60 Hz, sin congelaciones/saltos adicionales de raíz; deriva de puntera 3,467 / 2,401 px, igual al pase anterior.
- Importación/exportación Web y `git diff --check` correctos.
- Helium/Chromium WebGL 2.0: grabación real de 8,467 s, marcha derecha/izquierda, paradas y pulsaciones cortas. Secuencia extraída revisada visualmente; consola sin errores registrados.
- Manifiesto SHA256 de Sota 0.1 stable comprobado; sus copias y fuentes/atlas originales intactos.

## Evidencias y estado

[Comparación](comparacion.png): Modelo 13 arriba, Modelo 14 debajo; dos filas inferiores aíslan la pierna del fondo en el mismo orden. [Grabación real](marcha_web.webm), [secuencia en el juego](secuencia_web.png), [reposo](web_reposo.png), capturas nativas y logs en esta carpeta.

Corrección entregada e integrada por el asistente, pendiente de valoración visual del autor. Modelo 13 queda como referencia de fluidez con postura rechazada. Modelo 12 sigue siendo Sota 0.1 stable. T05 continúa como prioridad y T10 pendiente. No se han probado Safari, Firefox, móvil ni rendimiento sostenido en este pase.
