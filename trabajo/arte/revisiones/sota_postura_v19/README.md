# Sota · candidata 19 · postura y perfil izquierdo

18 de octubre de 2026. El autor señala que Sota va demasiado encorvada y que la izquierda está peor resuelta. Esta entrega corrige postura y unión izquierda; está pendiente de valoración. La aprobación anterior sigue limitada a la marcha derecha 17.

## Comparar

[Comparación animada 18/19](index.html), también en `http://127.0.0.1:8766/trabajo/arte/revisiones/sota_postura_v19/` con el servidor local activo. Si no está activo, ejecutar `python3 -m http.server 8766` desde la raíz.

En Godot, abrir `candidatas/comparacion_sota_postura_v19.tscn` y pulsar **F6**. Versión 18 a la izquierda de cada fila, 19 a la derecha; perfil derecho arriba, izquierdo abajo. Controles de pausa, reanudar, lenta, fotograma y articulaciones. Velocidad común 104 px/s, ciclo 140 px, escala y suelo iguales. F5 mantiene el juego normal.

Evidencias:

- [Captura nativa](comparacion_nativa.png).
- [Fase 16 y ocho claves izquierdas](fase_16.png).
- [Fase 40 y ocho claves derechas](fase_40.png).
- [Articulaciones](articulaciones.png).
- [Grabación real de 24,167 s](comparacion_real.webm), capturada a 60 FPS, velocidad normal y lenta; [secuencia temporal extraída](secuencia_real.png).

## Causas y cambios

- La versión anterior añadía `0.14 rad` (8,02°) de inclinación base al dibujo. Se reduce a `0.035 rad` (2,01°), conservando la oscilación capturada. Máximo añadido durante el ciclo: **3,030°**. Esto mide la transformación adicional, no la inclinación anatómica absoluta del dibujo.
- Cabeza, torso, deck y hombros se recolocan con la misma postura. Hombro y codo se trasladan juntos: no cambia la longitud ni el balanceo angular del brazo.
- En el perfil izquierdo, la cadera lejana original estaba separada 70 píxeles de fuente de la cercana. Las piernas ya se habían llevado a apoyos comunes, pero la cintura seguía naciendo sobre la posición estática anterior. Se corrige el origen de la deformación superior de cada muslo y se centra el conjunto superior **10,197 px hacia delante** sobre ese conjunto. Se conserva la malla existente; no se añaden superficies, parches ni UV nuevos.
- La cabeza izquierda se abre **3,44°** alrededor del cuello para reducir la barbilla caída. Se transforma el dibujo propio, sin reflejar el derecho ni modificar el PNG fuente.
- **Ambos perfiles mantienen exactamente sus articulaciones de piernas, pelvis, elevación de suelas y anclajes de las 64 poses de la 18.** El paso derecho aprobado no se recalcula. Su parte superior sí cambia para atender la corrección del autor y requiere valoración nueva.

## Comprobaciones

[Salida completa](validacion.txt).

| Comprobación | Resultado |
| --- | --- |
| Cinemática, alcance, orientación y bucle | 4098 subposes correctas |
| Error máximo de segmento 56/56 | 0,00001907 px |
| Ambas rodillas >25° | 0 subposes |
| Salto de pelvis por 1/2048 de ciclo | 0,073124 px máximo |
| Deriva numérica plana por muestra | 0,00000191 px |
| Paleta y alfa | Paleta v7 conservada, alfa binaria en todo el atlas |
| Cobertura | 128 poses, cintura cubierta, 0 fragmentos secundarios |
| Atlas y suelas | 192×288 por celda, sin recortes, suela y=271..272 con origen 272 |
| Altura visible | 250..257 px por postura, sin reescalado por fase |
| Deriva raster en cuatro apoyos planos | 0,938 px máximo |
| Reproducción nativa | Pausa y lenta a 30/60/120 Hz correctas |
| Navegador Helium | Pausa/reanudación, paso 40→41, lenta, selector y overlay; sin errores de página/consola registrados |
| Conservación | 14 copias y originales de la derecha 17 intactos por SHA256; 11 archivos de stable intactos |

Se inspeccionaron la captura nativa, las dos láminas con ocho claves y la secuencia extraída del vídeo. La nueva silueta muestra menos inclinación y menos prominencia de la cintura izquierda hacia atrás. Es una valoración del asistente, no aprobación artística.

Para repetir desde la raíz del repositorio:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/captura_sota_v19.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/ropa_sota_v19.gd
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script res://tests/render_sota_postura_v19.gd
```

Generación GPU: `Godot --path godot --script res://tests/preparar_sota_postura_v19.gd`.

## Archivos y límites

Nuevos: `godot/candidatas/sota_postura_v19.gd`, comparación `.gd/.tscn`, `godot/assets/personajes/sota/captura_v19_candidata/{marcha.png,movimiento.json}`, cuatro pruebas/generadores anteriores y esta carpeta de revisión. Actualizados `task.md` y `proceso/ESTADO_DEL_PROYECTO.md`.

El rig 19 hereda el 18 y modifica únicamente la postura superior y el nacimiento de la cintura izquierda. Versiones anteriores y fuente v7 conservadas. No se modifica el controlador ni el predeterminado.

El perfil izquierdo todavía conserva limitaciones gráficas del vestido reconstruido: superficies interiores del pantalón, pliegues y solapamientos del brazo lejano. No se declara igualado por completo al derecho. La prueba de componentes solo detecta separación; no demuestra acabado artístico. Permanecen la cuantización temporal de 2,1875 px por dibujo y la deriva raster medida; no se extrapola la prueba plana a todo el rodado.

Reposo, arranque, parada, giro e integración de esta ruta siguen pendientes. No se han repetido colisiones/clic/foco, ni exportado una nueva Godot Web: la comparación del navegador reproduce PNG nativos con nearest. Otros navegadores/móvil sin comprobar. T05 abierta.
