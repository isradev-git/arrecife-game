# Sota · equipo 3D v2

19 de octubre de 2026. El autor señaló que el cyberdeck quedaba encima de la mano. El volumen anterior cruzaba el brazo en movimiento. Se adelgaza la carcasa y se ciñe el equipo a la cintura posterior derecha, conservando sus pesos y hueso de anclaje.

## Comparación visual

- Derecha: [antes](antes_derecha_020.png) y [después](despues_derecha_020.png), misma pose y cámara.
- Mano junto a cadera: [antes](antes_derecha_060.png) y [después](despues_derecha_060.png).
- Izquierda: [antes](antes_izquierda_120.png) y [después](despues_izquierda_120.png).
- Cuatro capturas por sentido y versión, separadas 20 fotogramas a 60 Hz. Cámara cercana para inspeccionar el cruce. Son renders de Godot, sin retoque de píxeles ni cambios de orden de dibujado.

Para reproducir: `Godot --path godot_ilustrado --script res://tests/capturar_equipo.gd --fixed-fps 60`, añadiendo `-- --anterior` para la comparación previa. La comparación anterior sustituye únicamente las tres mallas del aparato por las v1; el resto del personaje y la animación son idénticos.

## Validación

`tests/equipo.gd` necesita GPU. Comprueba 1.920 poses a 120 Hz, ambos sentidos: reposo de 2,5 s, arranque, más de dos ciclos de marcha, parada y vuelta a reposo. Lleva la mano y la sección distal del antebrazo al espacio de pelvis y comprueba sus aristas contra el volumen envolvente del equipo ampliado 3 mm. **Sin cruces en v2.** Usando el volumen v1 sobre la misma animación: **1.727 poses con cruce**. El margen es una comprobación geométrica local, no una certificación de todas las animaciones futuras.

Regresiones de modelo, control y recorrido pasan. El test de lado físico comprueba ahora que toda la carcasa queda en el semiespacio derecho; el umbral anterior fijaba una posición concreta del modelo v1. [Datos de mallas](mallas.txt): sólo cambian las tres del equipo, las otras 23 son idénticas. V1, animaciones, locomoción y arte histórico preservados.

Capturas revisadas en ambos sentidos. [Fuente y dimensiones](../../personajes/sota/ilustrada_3d_v2/README.md). Este ajuste no constituye aprobación artística del modelo completo. No se han validado interacciones de mano con objetos ni animaciones nuevas.

[Resultados completos](validacion.txt). Exportación Web 3D regenerada; carga y render revisados en Helium/WebGL 2 sin errores registrados. [Captura Web](web.png).
