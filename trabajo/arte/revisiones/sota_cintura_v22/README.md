# Sota · candidata 22 · hendidura entre cintura y muslos

18 de octubre de 2026. El autor rechaza el resultado 21 y aporta [captura del hueco abierto](hueco_senalado.png). La prueba anterior comprobaba agujeros encerrados, pero permitía una hendidura comunicada con el fondo. La 21 no resolvía la unión visible.

## Ver el resultado

- [Misma fase, detalle 4× de ambas versiones y perfiles](detalle_40.png).
- [Comparación animada 21/22](index.html), también en `http://127.0.0.1:8766/trabajo/arte/revisiones/sota_cintura_v22/`.
- [Fase 40 y claves derechas](fase_40.png), [fase 16 y claves izquierdas](fase_16.png), [captura nativa](comparacion_nativa.png).
- [Grabación real de 57,034 s](comparacion_real.webm), captura a 60 FPS con marcha normal y lenta; [secuencia temporal](secuencia_real.png).

Godot: abrir `candidatas/comparacion_sota_cintura_v22.tscn` y pulsar **F6**. Controles de pausa, reanudar, lenta, fotograma y articulaciones. Ambas versiones usan ciclo 140 px, velocidad 104 px/s, escala y suelo iguales. F5 mantiene el juego normal. Si falta el servidor local: `python3 -m http.server 8766` desde la raíz del repositorio.

## Corrección

La superficie del pantalón comenzaba demasiado abajo y su parte superior era más estrecha que el torso. Retirar el saliente del torso dejó al descubierto esa zona incompleta.

Se modifica la parte superior de **las superficies existentes** del pantalón: la primera fila llega al cinturón (fila fuente 430 en vez de 490), la segunda pasa de 530 a 490, y sus bordes se ajustan al volumen de la cintura. Las dos caderas comparten el borde delantero, compensando sus 2 px de separación, y enlazan con el muslo conservado. No se añaden polígonos de relleno, nodos de parche ni UV nuevos; se mantiene la textura v7.

Se ordena el torso por delante de esa cintura y el deck por delante del torso; cabeza y brazos conservan sus planos. Las articulaciones, el paso, la postura y las suelas no se recalculan. El cambio queda en `godot/candidatas/sota_cintura_v22.gd`, con atlas aislado `captura_v22_candidata`.

## Comprobaciones

[Salida completa](validacion.txt).

La regresión nueva recorre el **contorno renderizado** que comunica cintura y muslos en las 128 poses. Mide los retrocesos hacia dentro entre filas consecutivas: detecta el corte de **8 px** de la 21; en la 22 el máximo es **2 px**. El umbral de 3 px permite los escalones propios del píxel y falla con la hendidura señalada. Se comprueba además que el centro de esa banda permanezca cubierto. Esta prueba no equivale a aprobación del dibujo.

También pasan:

- 128 poses: cobertura central, sin piezas separadas, alfa binaria y paleta v7.
- Articulaciones, pelvis, suelas y anclajes idénticos a 21. Filas 0..109 y 200..287 idénticas píxel a píxel.
- 4098 subposes: cintura y muslo superior sin caras invertidas ni colapsadas; IK 56/56 con error máximo 0,00001907 px; alcance, orientación y bucle correctos. Cierre de cabeza, torso, deck y brazos conservado.
- Atlas sin recortes; suelas y=271..272, deriva raster plana máxima 0,938 px. Altura visible 250..257 px por postura, sin escalado por fase.
- Comparación nativa: reproducción, pausa y lenta a 30/60/120 Hz.
- Helium: pausa/reanudación, lenta, fase, selector y capturas; sin errores de página/consola registrados.

Se revisaron el detalle 4× de la fase señalada, las claves por perfil y la secuencia temporal real. La unión tiene ahora un contorno continuo en esa zona. Entrega del asistente para valoración, sin nueva aprobación del autor.

## Reproducir

Desde la raíz del repositorio:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/cintura_sota_v22.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/ropa_sota_v22.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/captura_sota_v22.gd
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script res://tests/render_sota_cintura_v22.gd
```

Generación GPU: `Godot --path godot --script res://tests/preparar_sota_cintura_v22.gd`.

## Archivos y límites

Nuevos: rig 22, comparación `.gd/.tscn`, atlas/JSON 22, cinco scripts anteriores y esta carpeta de revisión. Actualizados `task.md` y `proceso/ESTADO_DEL_PROYECTO.md`. La 21 se conserva como resultado rechazado y caso de regresión.

El acabado de los pliegues y las superficies interiores sigue pendiente; tampoco se han modificado las inversiones históricas bajo la rodilla. Esta entrega no declara terminado el vestuario. Reposo/transiciones/integración de la ruta humana permanecen abiertos. Comparación Web mediante PNG nativos con nearest; no se exporta Godot Web ni se repiten pruebas del controlador horizontal, que no cambia. Predeterminado y versiones aprobadas conservados. T05 abierta.
