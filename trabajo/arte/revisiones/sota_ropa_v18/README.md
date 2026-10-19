# Sota · candidata 18 · ropa y coordinación izquierda

18 de octubre de 2026. Entrega del asistente para revisión. La aprobación del autor corresponde exclusivamente a la marcha derecha 17; no se extiende automáticamente a esta candidata.

## Ver y probar

- [Comparación animada](index.html): anterior a la izquierda de cada fila, revisada a la derecha; perfil derecho arriba e izquierdo abajo. Pausa, reanudar, cámara lenta, fotograma, fase, articulaciones y ocho claves por perfil. Detalle de ropa ampliado 2×.
- URL local: `http://127.0.0.1:8766/trabajo/arte/revisiones/sota_ropa_v18/`. Si el servidor no está activo: `python3 -m http.server 8766` desde la raíz del repositorio.
- Godot: abrir `godot/project.godot`, después `candidatas/comparacion_sota_ropa_v18.tscn` y ejecutar **F6**. Controles equivalentes en pantalla; **F5 sigue abriendo el juego normal**.
- [Captura nativa](comparacion_nativa.png), [fase 16 y claves derechas](fase_16.png), [fase 40 y claves izquierdas](fase_40.png), [articulaciones](articulaciones.png).
- [Grabación real del navegador](comparacion_real.webm): 18,284 s, captura a 60 FPS, velocidad normal y lenta. [Secuencia extraída de la grabación](secuencia_real.png).

Ambas versiones: 104 px/s, ciclo 140 px, 64 fases por perfil, escala fija y mismo suelo/fondo. La comparación desplaza las marcas del suelo para representar el avance; no sustituye una prueba de integración del personaje en el recorrido.

## Causas y correcciones

1. **Pantalón hinchado y bolsillo deformado:** la deformación heredada añadía un 18 % transversal al muslo. Se elimina ese término. Se acorta la mezcla de cintura de 30 a 18 px para que no arrastre tanto el bolsillo.
2. **Pelvis plana superpuesta:** una pieza histórica tapaba los pliegues de la unión. Se oculta en la candidata; los muslos existentes cubren la cintura. Se comprueba cobertura en las 128 poses.
3. **Cintura izquierda estirada:** sus UV superiores muestreaban apenas 22 px de tela. Se corrigen esos puntos existentes para tomar 44 px limpios del mismo dibujo (x=1000..1044), recuperando costura/sombra. No se crean parches UV, superficies, texturas ni imágenes de personaje nuevas.
4. **Correas y caña de bota arrastradas por la tibia:** la mezcla con la bota se sitúa entre tobillo−28 y tobillo−18, de modo que la caña acompaña al pie.
5. **Izquierda distinta en coordinación:** emplea la asignación de canales cercano/lejano de la derecha aprobada. Conserva el dibujo del perfil izquierdo y el deck en su lado físico; no se refleja el sprite derecho. Los apoyos se resuelven de nuevo sobre las suelas propias de ese perfil.

La candidata mantiene la cinemática 17: piernas de 56/56 px, pelvis coordinada con soporte y alcance, trayectoria periódica. **La derecha conserva exactamente articulaciones, pelvis, elevación de suelas y anclajes de las 64 poses**. Las primeras 125 filas de cada celda derecha (cabeza y parte superior de chaqueta) son idénticas píxel a píxel. El PNG fuente v7 no se modifica.

## Comprobaciones ejecutadas

Salida conservada en [validacion.txt](validacion.txt).

| Comprobación | Resultado |
| --- | --- |
| Geometría en 4098 subposes, ambos perfiles | Segmentos, alcance, orientación y cierre del ciclo correctos |
| Error máximo de segmento | 0,00001907 px |
| Salto de pelvis por 1/2048 de ciclo | 0,073124 px máximo; no equivale al salto entre dibujos |
| Ambas rodillas flexionadas más de 25° | 0 subposes |
| Inclinación máxima de bota | 32,852° |
| Deriva numérica de apoyo plano por muestra | 0,00000191 px |
| Atlas | 128 celdas, 192×288, alfa binaria, sin recortes en bordes |
| Colores | Todos los píxeles opacos pertenecen a la paleta fuente v7 |
| Piezas separadas | 0 fragmentos secundarios, cintura central cubierta en 128 poses |
| Suela raster | y=271..272, origen y=272 |
| Altura visible | 250..257 px por postura, sin reescalado por fase |
| Deriva raster | 0,938 px máximo en cuatro intervalos de apoyo plano |
| Reproducción nativa | Pausa y cámara lenta a 30/60/120 Hz correctas |
| Navegador Helium | Carga, pausa/reanudación, paso 40→41, lenta, selector y overlay; sin errores de página/consola registrados |
| Conservación | 14 archivos de derecha 17 y sus originales idénticos por SHA256; 11 archivos de Sota 0.1 stable intactos |

Comandos, desde la raíz:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/captura_sota_v18.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/ropa_sota_v18.gd
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script res://tests/render_sota_ropa_v18.gd
```

Para regenerar el atlas con GPU: `Godot --path godot --script res://tests/preparar_sota_ropa_v18.gd`. El generador escribe exclusivamente en el directorio candidato 18.

## Inspección visual y límites

Se revisaron la captura nativa, las dos capturas completas con ocho claves, los detalles ampliados y una secuencia temporal extraída de la grabación real. El bolsillo resulta menos abultado y la caña conserva mejor su forma. La nueva izquierda muestra el mismo orden de apoyos que la derecha con su vestuario propio. Esto es valoración del asistente, no aprobación del autor.

**La ropa aún no está terminada.** La zona alta de la entrepierna izquierda sigue plana y algunos pliegues cambian por deformación de una imagen estática. Faltan dibujos de las caras interiores/traseras ocultas del pantalón y pliegues específicos de flexión; la fuente de perfil solo contiene su superficie visible. La corrección actual mejora el muestreo y la deformación, pero no puede inventar ese volumen con fidelidad. También queda por revisar el solapamiento del brazo lejano. No se declara resuelto mediante las pruebas de cobertura.

La cuantización temporal conserva hasta 2,1875 px de avance entre dibujos. La medida de deriva plana no demuestra ausencia absoluta de deslizamiento durante todo el rodado. La candidata contiene únicamente el bucle de marcha: reposo, arranque, parada, giro e integración jugable siguen pendientes. No se han repetido pruebas de colisión/clic/foco porque no se modifica el controlador ni se conecta este atlas a él.

El navegador reproduce los PNG nativos mediante Canvas con nearest; **no es una nueva exportación Godot Web**. Safari/Firefox, móvil y rendimiento sostenido no comprobados. Modelo 14 sigue predeterminado; anteriores, derecha 17 aprobada y Sota 0.1 stable permanecen recuperables.

## Archivos de esta entrega

Nuevos:

- `godot/candidatas/sota_ropa_v18.gd`: cinemática conservada, coordinación izquierda y deformación del vestido.
- `godot/candidatas/comparacion_sota_ropa_v18.gd` y `.tscn`: comparación nativa aislada.
- `godot/assets/personajes/sota/captura_v18_candidata/marcha.png` y `movimiento.json`: atlas y contrato versionados.
- `godot/tests/preparar_sota_ropa_v18.gd`, `captura_sota_v18.gd`, `ropa_sota_v18.gd`, `render_sota_ropa_v18.gd`: generación y regresiones.
- Esta carpeta: comparación Web, capturas, vídeo, secuencia, informe y resultados. Godot añade metadatos `.uid`/`.import` correspondientes.

Actualizados: `task.md` y `proceso/ESTADO_DEL_PROYECTO.md`. No se modifica el movimiento horizontal, el recurso predeterminado ni las versiones 17/anteriores en esta entrega.
