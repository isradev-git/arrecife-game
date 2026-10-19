# Sota · candidata 23 · encaje de las caderas

18 de octubre de 2026. El autor rechaza la 22: **el muslo nace demasiado atrás respecto a la pelvis**. La [anotación del autor](encaje_senalado.png) aclara el defecto anatómico. Las pruebas anteriores de cobertura y contorno no detectaban ese problema; rellenar la hendidura no lo resolvía.

## Revisar

- [Misma fase 40, detalle 4× de ambos perfiles](detalle_40.png).
- [Articulaciones en esa misma fase](caderas_40.png).
- [Comparación animada 22/23](index.html): pausa, reanudar, lenta, paso, perfil y articulaciones. URL local: `http://127.0.0.1:8766/trabajo/arte/revisiones/sota_cadera_v23/`.
- [Claves derechas](fase_40.png), [claves izquierdas](fase_16.png), [captura nativa](comparacion_nativa.png).
- [Grabación real de 27,184 s](comparacion_real.webm), capturada a 60 FPS; [secuencia temporal](secuencia_real.png).

Godot: abrir `candidatas/comparacion_sota_cadera_v23.tscn` y pulsar **F6**. Izquierda: 22; derecha: 23; arriba: perfil derecho; abajo: izquierdo. Ambas versiones usan 104 px/s, ciclo de 140 px, misma escala y suelo. F5 conserva el juego normal. Para servir la comparación web: `python3 -m http.server 8766` desde la raíz del repositorio.

## Corrección implementada

La 22 conservaba los centros de cadera de la marcha anterior y modificaba la superficie para tapar el entrante. La 23 cambia **el anclaje real del fémur**, 8 px hacia delante en cada perfil (caderas cercana/lejana de 0/2 a 8/10 px respecto al eje del cuerpo, con signo según dirección).

Se recalculan altura de pelvis y ambas rodillas con IK 56/56, manteniendo los objetivos mundiales de los tobillos y sus rotaciones. La pelvis respeta los límites de alcance de las dos piernas y el apoyo activo: no se desplaza el pie para compensar ni se alargan los segmentos. La parte superior conserva su gesto heredado y acompaña la nueva altura; sus píxeles no se declaran idénticos a la 22.

Se retira la prolongación/ensanchamiento de la 22 al heredar de la 21. Los dos anillos superiores existentes del pantalón conservan sus alturas fuente 490/530; sus bordes se adaptan a la cadera nueva para mantener el volumen posterior de la pelvis y compartir contorno entre piernas. No se añaden nodos, caras ni UV. No se modifica v7, no se refleja un perfil ni se genera arte con IA.

El cambio queda en `godot/candidatas/sota_cadera_v23.gd`; recursos separados en `godot/assets/personajes/sota/captura_v23_candidata/`. Cambian las caderas, rodillas y altura de pelvis de ambos perfiles: esta candidata no hereda automáticamente la aprobación de la derecha 17.

## Validación

[Registro de resultados](validacion.txt).

- 4098 subposes, ambos perfiles: segmentos 56/56 con error máximo 0,00001907 px; alcance válido, coordenadas finitas, orientación de rodilla y cierre de ciclo correctos.
- Continuidad de pelvis: desplazamiento máximo por 1/2048 de ciclo 0,160491 px. Ninguna subpose con ambas rodillas flexionadas más de 25°.
- 128 poses: tobillos mundiales coinciden con 22 y caderas adelantadas 8 px. Paleta v7 exacta, alfa binaria, cintura cubierta y sin fragmentos separados de al menos 8 px.
- Raster: 128 celdas sin recortes, suela y=271..272 respecto al origen 272; altura visible 250..257 px por postura, sin escalado individual. Deriva raster máxima medida en cuatro apoyos planos: 0,938 px; no equivale a ausencia absoluta de deslizamiento durante todo el rodado.
- Comparación nativa: reproducción, pausa y lenta a 30/60/120 Hz. Helium: controles de pausa/reanudación, fase, perfil y articulaciones; sin errores de página/consola registrados.
- Ensayo comparativo de todas las caras de los muslos, 514 poses por versión: 26 inversiones en 22 y ninguna en 23. La regresión de la 23 amplía esa comprobación a las 4098 subposes.

Inspeccionados el render nativo, la fase señalada ampliada, las articulaciones, las claves de ambos perfiles y la secuencia temporal real. El muslo parte ahora de una posición más adelantada bajo la pelvis. Es una entrega para revisión del autor; las pruebas no constituyen aprobación artística.

## Reproducir las pruebas

Desde la raíz del repositorio:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/ropa_sota_v23.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/captura_sota_v23.gd
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script res://tests/render_sota_cadera_v23.gd
```

Regenerar atlas mediante GPU: `Godot --path godot --script res://tests/preparar_sota_cadera_v23.gd`.

## Archivos y límites

Creados: rig 23; comparación `.gd/.tscn`; atlas/JSON 23; generador, pruebas de cinemática/ropa/render y sus `.uid`; esta carpeta de evidencias. Actualizados `task.md` y `proceso/ESTADO_DEL_PROYECTO.md`. Las versiones anteriores permanecen recuperables.

El pantalón sigue reconstruido con las superficies/UV históricos: faltan dibujos específicos de caras interiores y pliegues durante el paso. No se declara acabado artístico final. Reposo, arranque, parada, giro e integración de esta ruta humana siguen pendientes. La comparación web reproduce PNG nativos con nearest; no es una nueva exportación Godot Web. No se modificó ni se repitió la batería del controlador horizontal. Juego predeterminado, Sota 0.1 stable y copia aprobada derecha 17 conservados. T05 abierta.
