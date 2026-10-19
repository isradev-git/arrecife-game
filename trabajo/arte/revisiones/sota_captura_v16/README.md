# Sota · adaptación humana 16

17 de octubre de 2026. **Primera adaptación a Sota para revisar el movimiento; T05 sigue abierta.** El autor valoró favorablemente la referencia humana y autorizó continuar. Esta candidata todavía no tiene aprobación artística.

## Probar

- [Comparación animada en navegador](http://127.0.0.1:8766/trabajo/arte/revisiones/sota_captura_v16/). Requiere el servidor local del repositorio en 8766.
- Godot: abrir `godot/candidatas/comparacion_sota_captura_v16.tscn` y pulsar **F6**.
- Pausa, reanudación, cámara lenta, avance de fotograma y articulaciones. La página también ofrece selector de fase y ocho claves de cada perfil.
- [Grabación real del navegador, 37,95 s](comparacion_real.webm), [secuencia de la grabación](secuencia_real.png), [derecha](claves_derecha.png), [izquierda](claves_izquierda.png), [articulaciones](articulaciones.png), [Godot nativo](comparacion_nativa.png).

La izquierda de la comparación muestra IK 15, rechazada. Centro/derecha muestran los dos perfiles propios de la candidata humana. Misma escala de recursos, fondo, suelo y velocidad horizontal de 104 px/s. **Los ciclos difieren deliberadamente:** 128 px en la anterior, 168 px en esta candidata. No es una comparación a igual cadencia.

## Qué se ha implementado

1. Se usa la toma **CMU 07_04, muestras AMC 212–381**, seleccionada en la prueba anterior. [Datos, procedencia y condiciones conservados](../ruta_animacion_humana_v1/README.md). Datos de mocap.cs.cmu.edu, financiados por NSF EIA-0196217.
2. Once canales angulares de piernas, botas, brazos y tronco se ajustan a ocho armónicos periódicos. El bucle cierra posición y derivada de los canales sin interpolar entre dos siluetas incompatibles. No son ocho dibujos nuevos.
3. Retarget a segmentos de 56/56 px, con alcance limitado mediante pelvis y apoyos. La proyección lateral puede invertir ligeramente la rodilla cerca de extensión: se conserva la orientación anatómica. La solución final calcula ambos segmentos desde el mismo tobillo alcanzable.
4. El primer retarget angular desplazaba las suelas. Los tramos de apoyo medidos daban recorridos de 168,18 y 166,45 px/ciclo; 184 px producía ~8,09/6,91 px de deriva de tobillo. Se eligen **168 px**, con velocidad conservada. El paso queda en 1,615 s a 104 px/s. El juego normal mantiene sus constantes.
5. El apoyo medio fija el tobillo respecto al suelo y aplana la bota; los extremos conservan el rodado. La recuperación procede de la captura, con corrección cúbica que conecta posición y velocidad a los apoyos. La pelvis se coordina con ambas suelas y el alcance, mientras brazos/tronco comparten la fase humana.
6. Se generan 64 fases por perfil, 128 celdas de 192 × 288, origen (96,272), fondo transparente y nearest. Los dos perfiles usan su propio dibujo v7 y su lado físico de equipo. No hay reflejo de sprites, recoloración, imágenes generativas ni parches UV nuevos.

## Qué NO se ha terminado

**El vestuario reutiliza la malla anterior y sus reconstrucciones UV históricas. No es el acabado manual por poses que necesita la versión final.** Esta entrega comprueba la adaptación de la captura con la identidad visible de Sota. No sustituye el método de dibujo pendiente ni convierte el rig heredado en arte aprobado.

Al inspeccionar ambas láminas y la secuencia renderizada siguen visibles:

- Pelvis y entrepierna: masa demasiado plana, con pliegues que no describen bien la carga. Hace falta dibujar cintura/glúteo/entrepierna en contacto, apoyo y cruce, incluyendo las superficies que v7 oculta.
- Pierna interior: la prenda original no contiene todos los lados que aparecen al separarla; textura y volumen de la cara oculta necesitan dibujo propio.
- Bolsillo cargo: se conserva la pieza del diseño, pero su pliegue acompaña la deformación heredada; necesita acabado por postura.
- Caña de bota y brazo lejano: las uniones proceden del montaje previo; falta revisar sus siluetas con las nuevas poses.

No se añaden parches para disimular estas carencias. Cabello, rostro, chaqueta, correa y deck conservan los recursos de v7. Los pliegues y volúmenes **no se declaran terminados**.

La candidata solo contiene marcha cíclica. **Reposo, arranque, parada, inversión e integración en el controlador quedan pendientes para esta ruta humana.** El JSON conserva el contrato de celdas/anclas de marcha, pero aún no contiene el contrato completo de transiciones del reproductor normal: no debe seleccionarse como su DATA_PATH.

## Comprobaciones ejecutadas

[Registro](validacion.txt).

| Comprobación | Resultado |
| --- | --- |
| Canales humanos | 11 canales, 2049 muestras finitas por canal; cierre periódico |
| Anatomía | 4098 poses/subposes en ambos perfiles; error máximo 0,00001526 px en segmentos de 56 px; sin alcance imposible ni inversión de rodilla |
| Bucle | Articulaciones idénticas en fase 0/1 dentro de 0,0001 px |
| Pelvis | Máximo 0,071359 px por 1/2048 de ciclo; entre celdas del atlas hasta 1,924 px; no confundir ambas medidas |
| Apoyo plano matemático | Deriva por submuestra ≤0,00000191 px |
| Apoyo plano dibujado | Cuatro tramos de apoyo, borde de suela de la bota correspondiente: deriva máxima 0,875 px entre poses |
| Suelo renderizado | Las 128 celdas apoyan en filas 271–272 respecto a origen 272; variación raster de 1 px |
| Atlas | 1536 × 4608; alfa binaria; ninguna silueta cortada por celda; altura visible 247–255 px por postura, sin reescalar por frame |
| Reproducción nativa | Marcha, pausa y cámara lenta comprobadas en el código real de la comparación a 30/60/120 Hz |
| Navegador | Helium: carga, slider, perfiles, pausa, paso, cámara lenta y overlay; consola y errores de página vacíos al comprobar |
| Evidencia visual | Ocho claves de ambos perfiles, captura nativa y secuencia de una grabación real revisadas |
| Conservación | SHA256 de los 11 archivos del respaldo Sota 0.1 stable coincidente; Modelos 14/15 y atlas históricos conservados |

La deriva raster de 0,875 px compara poses en sus distancias exactas. **No mide el deslizamiento temporal completo del atlas sostenido entre frames**, cuyo paso es 168/64 = 2,625 px. Tampoco demuestra contacto perfecto durante todo el rodado talón/punta. No se declara «cero deslizamiento» ni aprobación estética automática.

No se repiten las regresiones completas de teclado, clic, colisiones, foco y llegadas: no se ha integrado ni modificado el controlador. No hay nueva exportación Godot Web; la prueba Web usa los PNG nativos en Canvas 2D. Safari/Firefox/móvil y rendimiento prolongado no comprobados.

## Archivos

Nuevos:

- `godot/candidatas/sota_captura_v16.gd`: captura, contacto y retarget; hereda extracción/vestuario y calibración de bota existentes.
- `godot/candidatas/comparacion_sota_captura_v16.gd` / `.tscn`: revisión nativa aislada.
- `godot/assets/personajes/sota/captura_v16_candidata/`: `ciclo.json`, `movimiento.json`, `marcha.png` y metadatos de importación.
- `godot/tests/preparar_sota_captura_v16.gd`: generador GPU del atlas.
- `godot/tests/captura_sota_v16.gd`: geometría, bucle y contacto matemático.
- `godot/tests/render_sota_captura_v16.gd`: atlas, suela raster, temporización y carga de escena.
- Esta carpeta: conversión reproducible, comparación Web, evidencia y primer retarget angular conservado como texto.

Actualizados: `task.md`, `proceso/ESTADO_DEL_PROYECTO.md` y enlace desde la guía humana. Controlador horizontal, reproductor predeterminado, escena normal y recursos anteriores sin cambios de esta entrega.

## Reproducir

Desde la raíz del repositorio:

```sh
python3 trabajo/arte/revisiones/sota_captura_v16/preparar_ciclo.py
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script res://tests/preparar_sota_captura_v16.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --editor --import --quit
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/captura_sota_v16.gd
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script res://tests/render_sota_captura_v16.gd
```

El generador necesita render GPU. Para servir la comparación si no está activo el servidor: `python3 -m http.server 8766` desde la raíz.
