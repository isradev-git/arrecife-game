# Sota · candidata 21 · saliente de la entrepierna

18 de octubre de 2026. El autor confirma que la 20 sigue fallando y aporta una captura marcada: el saliente bajo la cintura produce una lectura anatómica incorrecta. La estabilización matemática anterior no resolvió ese defecto visual. Esta entrega corrige los recortes responsables y queda pendiente de valoración del autor.

## Comparación

[Comparación animada 20/21](index.html): anterior a la izquierda de cada fila y candidata a la derecha, con ambos sentidos y **entrepierna ampliada 4×**. Pausa, reanudar, lenta, fotograma, selector y articulaciones.

URL local: `http://127.0.0.1:8766/trabajo/arte/revisiones/sota_union_v21/`. Si falta el servidor: `python3 -m http.server 8766` desde la raíz.

Godot: abrir `candidatas/comparacion_sota_union_v21.tscn` y pulsar **F6**. Ambas versiones usan 104 px/s, ciclo 140 px, la misma escala y el mismo suelo. F5 conserva el juego normal.

- [Defecto señalado por el autor](defecto_senalado.png).
- [Diagnóstico con piezas separadas](diagnostico_piezas.png): el recorte del torso incluye parte del pantalón.
- [Misma fase 40, detalle 4× y claves derechas](fase_40.png).
- [Fase 16 y claves izquierdas](fase_16.png).
- [Comparación nativa](comparacion_nativa.png).
- [Grabación real, 54,300 s](comparacion_real.webm), capturada a 60 FPS con marcha normal y lenta; [secuencia temporal](secuencia_real.png).

## Causa real y cambio

El defecto no dependía únicamente de los vértices de los muslos que medía la prueba anterior. El torso conservaba una porción de pantalón cuyo borde delantero sobresalía de la unión animada. En el perfil izquierdo, el recorte histórico de la mano original terminaba demasiado pronto en horizontal y dejaba parte de esa mano junto a la bragueta; un pequeño relleno histórico prolongaba el mismo borde.

La candidata aplica un límite de recorte específico al torso y retira ese relleno. El recorte actúa al prerenderizar, sobre las coordenadas del atlas fuente, y conserva la triangulación original. No añade parches, superficies ni colores; no modifica el PNG v7. Las pruebas de recortar y volver a triangular el polígono alteraban algunos píxeles de chaqueta por rasterización y se descartaron.

También se flexiona **6,88°** el antebrazo lejano izquierdo alrededor del codo: evita que aparezca únicamente su extremo junto a la bragueta. Se conserva la longitud del brazo y la continuidad del gesto. Este ajuste pertenece a la candidata, no amplía la aprobación anterior del autor.

Implementación: `godot/candidatas/sota_union_v21.gd` y `recorte_torso_v21.gdshader`. Atlas aislado `godot/assets/personajes/sota/captura_v21_candidata/`.

## Validación

[Registro](validacion.txt).

- 128 poses: paleta v7, alfa binaria, cintura cubierta y ningún fragmento separado.
- Regresión de silueta: la reducción del borde delantero existe en ambos perfiles; los píxeles retirados en la banda inspeccionada quedan comunicados con el fondo. **Ningún agujero interior nuevo** en esa banda. Esta medida no equivale a aprobación artística.
- Piernas, pelvis, elevación de suelas y anclajes exactamente iguales a 20 en las 128 poses. Filas superiores 0..109 e inferiores 200..287 idénticas píxel a píxel; la franja intermedia incluye la corrección y el antebrazo.
- 4098 subposes: segmentos 56/56, error máximo 0,00001907 px, alcance/orientación/bucle correctos; cierre de torso, cabeza, deck y brazos comprobado. Ninguna subpose con ambas rodillas >25°.
- Suelas raster y=271..272, deriva plana máxima 0,938 px; celdas 192×288 sin recortes. Altura visible 250..257 px por postura, sin reescalado.
- Comparación nativa: reproducción, pausa y lenta a 30/60/120 Hz correctas.
- Helium: pausa/reanudación, paso 16→17, lenta, selector y capturas; sin errores de página/consola registrados.
- Referencia derecha 17: 14 copias y originales conservados por SHA256. Stable: 11 archivos conservados.

Se inspeccionaron el detalle de fase 40, las láminas, la comparación nativa y una secuencia extraída de la grabación. La lectura del saliente marcado se reduce al retirar la mano incrustada y el borde sobrante. Es una valoración del asistente; no se declara la animación artísticamente aprobada.

Pruebas desde la raíz, usando el ejecutable Godot instalado:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/saliente_sota_v21.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/ropa_sota_v21.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/captura_sota_v21.gd
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script res://tests/render_sota_union_v21.gd
```

Regeneración GPU: `Godot --path godot --script res://tests/preparar_sota_union_v21.gd`.

## Conservación y pendientes

Nuevos: rig y shader anteriores, comparación `.gd/.tscn`, atlas/JSON 21, cinco scripts de prueba/generación y esta carpeta. Actualizados `task.md` y `proceso/ESTADO_DEL_PROYECTO.md`. Versiones anteriores, predeterminado y controlador conservados.

Siguen pendientes los pliegues y superficies interiores del vestido, las inversiones históricas bajo la rodilla registradas en la 20, transiciones e integración. La comparación del navegador reproduce PNG nativos con nearest; no se exporta una nueva Godot Web ni se repiten pruebas de clic/colisiones/foco al no cambiar el controlador. Otros navegadores/móvil sin comprobar. T05 abierta.
