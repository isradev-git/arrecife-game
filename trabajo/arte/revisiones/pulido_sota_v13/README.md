# Sota · pulido de marcha · Modelo 13

16 de octubre de 2026. El autor considera el Modelo 12 la mejor versión y lo designa **Sota 0.1 stable**; aporta dos capturas de rigidez y autoriza pulir todo el movimiento. Esa base está conservada en [una copia recuperable](../../personajes/sota/versiones/sota_0_1_stable/README.md), con 11 archivos y manifiesto SHA256. Fuentes y atlas originales v8 también permanecen intactos. Modelo 13 es la nueva entrega del asistente, sin aprobación artística posterior del autor.

## Diagnóstico y solución

La prueba `godot/tests/suavidad_sota.gd -- --antes` reproduce cambios abruptos de rodilla sobre el rig real, no sobre una fórmula duplicada. Muestrea 2048 intervalos por ciclo, incluidos sus extremos. Sale con código 1 en stable y 0 en la versión nueva. Este muestreo mide continuidad del cálculo; no equivale al salto entre fotogramas del atlas ni certifica por sí solo naturalidad artística.

| Medida (fondo / cercana) | Sota 0.1 stable | Modelo 13 |
| --- | --- | --- |
| Mayor salto de flexión por 1/2048 ciclo | 3,95° / 8,63° | 0,25° / 0,29° |
| Flexión mínima | 24,10° / 4,71° | 25,53° / 15,93° |
| Elevación máxima de la suela | 10 px | 19,01 px |
| Niveles de transición hacia reposo | 4 | 8, con aceleración y frenado suaves |

1. El balanceo vertical se redondeaba antes de resolver las piernas. Quitar ese redondeo reduce los saltos a 0,13° / 1,00° (`sonda_balanceo.log`). El dibujo superior sigue en píxeles enteros mediante una compensación independiente: cabeza, torso, equipo y brazos mantienen su trayectoria anterior.
2. La pierna cercana llegaba al límite de extensión. Ajustar su cadena a 58+58 px, conservando 60+60 en la lejana, reduce el salto cercano a 0,19° (`sonda_extension.log`).
3. La recuperación del pie ganaba solo 10 px y era simétrica. La curva nueva recoge antes el talón, eleva la suela unos 19 px, flexiona más durante el cruce y extiende hacia el contacto. La llegada del pie deja de cambiar la inclinación linealmente.
4. Se hornean ocho niveles por cierre y se seleccionan con `smoothstep` para suavizar arranque/parada. Se conserva la fase si se interrumpe una parada.

Atlas nuevo `godot/assets/personajes/sota/articulada_v9/`. La izquierda jugable reutiliza exactamente el derecho reflejado, incluyendo todas las transiciones. Se mantienen 32 fases, ciclo de 128 px, velocidad de 104 px/s, escala de 252 px, límites y arte v7. No se han generado imágenes ni prompts nuevos; se renderiza el modelo editable existente. El generador aún conserva el perfil izquierdo histórico, que el controlador no usa.

## Verificación realizada

- `suavidad_sota`: regresión antes/después y apoyos analíticos sin penetración apreciable (error <0,00001 px).
- `modelo_sota`: 584 poses, cobertura de cintura/rodilla/caña, sin piel incrustada; cabeza/tronco/brazos y contornos de botas conservados. Se actualiza el contrato histórico de trayectorias: el autor permite cambiar ahora la flexión y elevación, mientras la trayectoria horizontal de punteras sigue idéntica.
- `integridad_sota`: 594 poses sin piezas separadas de 8 px o más; mayor residuo aislado 1 px.
- `silueta_sota`: 0/768 secciones con pérdida de volumen.
- `reflejo_sota`: 297 parejas renderizadas idénticas al reflejarlas.
- `montaje_sota`: orden correcto en 72.144 cruces opacos; sin fallos de hombros/caderas.
- `movimiento_sota`: paleta original, alfa binaria, cabeza idéntica por píxel, margen del atlas, reposo, reducción de movimiento y límites. Pasa headless y GPU. Veinte capturas nativas.
- `volumen_reposo_sota`: 64 cierres terminan en el reposo exacto, hombros unidos en los nueve niveles contando marcha.
- `reanudar_sota`: 192 casos sin reiniciar la fase.
- `fluidez_marcha`: 30 y 60 Hz, ambos sentidos, sin congelaciones ni saltos adicionales de raíz. Deriva por muestreo de puntera 3,467 / 2,401 px, dentro del umbral previo de 4,2 px; no se afirma deslizamiento nulo del sprite.
- Importación y exportación Web correctas, `git diff --check` sin errores.
- Helium/Chromium WebGL 2.0, canvas 1672×941: grabación de 10,867 s con derecha, izquierda, frenadas, tres reanudaciones breves e inversión. Secuencias extraídas de la captura real inspeccionadas; sin errores de página ni consola. No es un vídeo generado.
- Manifiesto de stable comprobado contra las copias y contra las fuentes/PNG/JSON v8 originales.

`movimiento.log` conserva el fallo detectado en una primera prueba: el cálculo continuo cambiaba el muestreo de la cabeza. Se corrigió separando cálculo y retícula superior. Los resultados finales están en `movimiento_sota.log` y `movimiento_sota_gpu.log`.

## Evidencias y revisión

- [Comparación de ocho fases](comparacion.png): stable arriba, Modelo 13 debajo; dos filas siguientes aíslan la pierna lejana en ese mismo orden.
- [Grabación real del juego](marcha_web.webm).
- [Marcha derecha](secuencia_web.png), [izquierda](secuencia_izquierda_web.png), [transiciones](secuencia_transiciones_web.png).
- [Reposo Web](web_reposo.png) y capturas nativas `derecha_*` / `izquierda_*`.
- `autor_1.png`, `autor_2.png`: capturas que motivan este pase.
- `*_antes.gd.txt`: contratos y generador previos a este pulido; rig/controlador y atlas stable en el respaldo enlazado.

El asistente revisa separación y flexión de piernas, continuidad de ropa y transiciones a escala de juego. Entrega integrada para valoración del autor; no convierte Modelo 13 en una nueva versión estable aprobada ni declara la naturalidad perfecta por pasar pruebas. T05 continúa como prioridad; T10 no se inicia. Safari, Firefox, móvil y rendimiento sostenido no comprobados en este pase. Se conserva el límite conocido de tela reconstruida con UV: los pliegues siguen procediendo del arte v7.
