# Sota · candidata 20 · unión de pelvis y muslos

18 de octubre de 2026. El autor valora la mejora y señala que la entrepierna queda descolocada durante el paso. Corrección localizada entregada para revisión, sin nueva aprobación artística.

## Ver la corrección

[Comparación animada 19/20](index.html): anterior a la izquierda de cada fila, nueva a la derecha; ambos sentidos, detalle de pantalón, pausa, lenta, fotograma y articulaciones.

URL local: `http://127.0.0.1:8766/trabajo/arte/revisiones/sota_pelvis_v20/`. Si falta el servidor: `python3 -m http.server 8766` desde la raíz del repositorio.

En Godot abrir `candidatas/comparacion_sota_pelvis_v20.tscn` y ejecutar **F6**. F5 mantiene el juego normal. Ciclo 140 px a 104 px/s, misma escala, suelo y fondo en ambas versiones.

Evidencias: [captura nativa](comparacion_nativa.png), [fase 40 y claves derechas](fase_40.png), [fase 16 y claves izquierdas](fase_16.png), [grabación real de 78,534 s](comparacion_real.webm), [secuencia temporal extraída](secuencia_real.png). El vídeo incluye velocidad normal y lenta; se captura el navegador a 60 FPS.

## Causa y corrección

La unión de cintura pasaba a recibir todo el giro del muslo en solo 18 px, demasiado cerca del tiro. Además, el extremo superior de la pierna lejana derecha conservaba su separación del dibujo estático, aunque la cadena animada ya había sido centrada. Así, la zona alta del pantalón se desplazaba con cada muslo y podía sobresalir por delante.

En `sota_pelvis_v20.gd` se conserva la malla y se corrige su deformación:

- La parte alta se ancla a la cadera animada en ambos perfiles.
- El tejido permanece con la pelvis hasta la fila 530 de la fuente; entre 530 y 610 se reparte suavemente el giro hacia el muslo. La zona de mezcla mide aproximadamente 23 px en el personaje.
- Rodillas, botas, postura superior y movimiento no se recalculan. No se añaden superficies, parches UV, texturas ni arte generativo; fuente v7 intacta.

El ensayo antes/después mide **vértices reales de la malla** en la fila superior 530, relativos a la pelvis, durante 257 muestras por perfil. Su desplazamiento máximo pasa de **8,573540 px a 0,000004 px**. Esto verifica el anclaje del tiro superior, no que todos los pliegues del pantalón estén terminados.

## Resultados

[Registro completo](validacion.txt).

- Geometría: 4098 subposes; segmentos 56/56, error máximo 0,00001907 px, alcance/orientación/bucle correctos. Ninguna subpose con ambas rodillas >25°.
- Conservación: piernas, pelvis, elevación de suelas y anclajes exactamente iguales a 19 en las 128 poses. Filas superiores 0..124 e inferiores 200..287 idénticas píxel a píxel en ambos perfiles.
- Atlas: 128 celdas 192×288, paleta v7, alfa binaria, cintura cubierta y ningún fragmento separado; sin recortes.
- Suelo: suela y=271..272 con origen 272; deriva raster máxima de 0,938 px en cuatro intervalos de apoyo plano. Altura visible 250..257, sin escalado por fase.
- Comparación nativa: reproducción, pausa y lenta a 30/60/120 Hz correctas.
- Helium: carga, pausa/reanudación, paso 16→17, lenta y selector comprobados; sin errores de página/consola registrados.
- Revisión visual: capturas ampliadas, ocho claves de cada perfil y secuencia temporal real. El tiro permanece más centrado y deja de acompañar el giro completo del muslo. Valoración del asistente, pendiente del autor.

La prueba adicional de triangulación encontró **26 inversiones heredadas bajo la rodilla** entre las muestras inspeccionadas. Se comparan las claves de perfil/fase/pierna/triángulo y sus áreas: son idénticas en 19 y 20, sin inversiones nuevas. Se registra como límite de la deformación histórica; no se oculta bajo un resultado de cobertura correcto. Esta entrega no cambia esa zona.

## Repetir las pruebas

Desde la raíz, con `GODOT` sustituido por el ejecutable (en este equipo `/Applications/Godot.app/Contents/MacOS/Godot`):

```sh
GODOT --headless --path godot --script res://tests/pelvis_sota_v20.gd
GODOT --headless --path godot --script res://tests/captura_sota_v20.gd
GODOT --headless --path godot --script res://tests/ropa_sota_v20.gd
GODOT --path godot --script res://tests/render_sota_pelvis_v20.gd
```

Generador GPU: `GODOT --path godot --script res://tests/preparar_sota_pelvis_v20.gd`.

## Archivos y pendientes

Nuevos: `godot/candidatas/sota_pelvis_v20.gd`, comparación `.gd/.tscn`, atlas/datos `godot/assets/personajes/sota/captura_v20_candidata/`, cinco scripts de prueba/generación anteriores y esta carpeta. Actualizados `task.md` y `proceso/ESTADO_DEL_PROYECTO.md`.

La 19 y las versiones previas permanecen intactas. No se cambia el controlador ni la animación predeterminada. El dibujo aún tiene pliegues y superficies interiores incompletos; no se declara arte final. Persisten las limitaciones de rodilla indicadas y la cuantización temporal de 2,1875 px por dibujo.

Reposo, arranque, parada, giro e integración de esta ruta siguen pendientes. No se han repetido colisiones/clic/foco ni se ha exportado Godot Web; el navegador reproduce PNG nativos con nearest. Otros navegadores/móvil sin comprobar. T05 abierta.
