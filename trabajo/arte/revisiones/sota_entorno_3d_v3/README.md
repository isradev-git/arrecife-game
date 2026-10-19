# Candidata Sota v3 y plano de entorno

19 de octubre de 2026. Respuesta al rechazo visual del modelo v2 y al pedido de encuadre lejano. **No es una aprobación artística ni el juego narrativo de 30 minutos.**

## Revisar

- [Plano de juego, zona inicial](tramo_120.png), [centro](tramo_300.png), [izquierda](tramo_480.png).
- [Cuerpo, derecha](v3_perfil_040.png), [otra fase derecha](v3_perfil_060.png), [izquierda](v3_perfil_120.png), [otra fase izquierda](v3_perfil_140.png).
- [Cabeza, luz neutra](v3_cabeza.png). Se conserva una inspección cercana para revisar parecido, superficies y prendas.
- [Modelo anterior bajo el estudio actual](v2_perfil_040.png), [cabeza anterior](v2_cabeza.png). Esa comparación usa la geometría v2 con los ajustes de luz/material del estudio actual; no reproduce píxel a píxel el render antiguo.
- [Vídeo nativo del recorrido](recorrido.mp4), 9 s. Tasa de archivo 60 FPS; no es un benchmark de rendimiento.
- [Web local](http://127.0.0.1:8766/godot_ilustrado/build/web/). A/D, flechas o clic; pausa con Espacio. Botón Laboratorio para inspección cercana.

Los ensayos con roturas de hombro, pelo o material incorrecto quedan bajo `ensayos_render/` y las fuentes `intento_*`; no son la candidata final de esta carpeta.

## Qué se cambia

Cámara de 9 a 22 m, FOV 29°, objetivo más alto: Sota ocupa **15,59 % de altura de pantalla** en la muestra inicial, sin reescalar su cuerpo. Se ven unos veinte metros de anchura en el plano de paso. El escenario muestra más ciudad, estructura inferior y pasarela elevada. Desgaste discreto en materiales, sin nuevo contenido canónico.

La candidata reconstruye ropa, pelo, implantes y unión al equipo. [Proceso, fuente editable y límites](../../personajes/sota/ilustrada_3d_v3/README.md). Las animaciones, rig y root motion continúan siendo los anteriores. Se mantiene el lado anatómico del aparato.

La geometría estática se agrupa mediante `MultiMesh`; suelo/barreras y obstáculos físicos conservan sus cuerpos de colisión. La muestra central pasó de 1.991 a 314 llamadas de dibujo durante esta iteración. Es una medida de llamadas, no una garantía de FPS ni una prueba en equipos modestos.

## Pruebas

Los resultados completos y avisos están en `validacion.txt`; los archivos de la entrega quedan identificados en `recursos_sha256.json`.

- `modelo.gd`: partes requeridas, posiciones finitas, pesos normalizados, animación recibida por la rodilla, deck entero en el lado derecho y color de chaqueta activo.
- `equipo.gd`, GPU: 1.920 poses a 120 Hz, reposo/arranque/marcha/parada en ambos sentidos; aristas de mano/antebrazo distal fuera del volumen del aparato ampliado 3 mm. Además, correa unida al anclaje en cada muestra. No valida futuras animaciones de interacción.
- `contacto.gd`, GPU: mide todas las superficies nuevas de botas, no sólo la original. Se mantienen los marcadores de la suela original y sus límites anteriores.
- `locomocion.gd`: avance a 30/60/120 FPS, 65 huesos sin escalado, parada y recorrido lateral.
- `control.gd` y `recorrido.gd`: teclado, clic, inversión/interrupción, llegada, bordes/obstáculos, cámara, suelo, foco y pausa. El recorrido verifica la proporción proyectada con el área lógica de 1280×720; en headless la ventana física es 64×64 y no sirve para calcular el encuadre.

En el renderizador **Dummy/headless** se observó un aviso al destruir materiales importados (`material_get_instance_shader_parameters`). Las aserciones y los procesos terminan correctamente; la validación con GPU se registra por separado. No confundir el resultado lógico con una ejecución sin avisos, ni usar Dummy para aprobar el render. El comportamiento observado requiere revisar ese cierre antes de convertirlo en un gate CI sin GPU.

## Límites de la entrega

El encuadre lejano y el arnés tienen comprobación concreta. La fidelidad al retrato y el acabado profesional **siguen sujetos a revisión artística**. El escenario sigue siendo una muestra con geometría simple, sin personas conversables, objetos narrativos ni guardado. No se han producido los 30 minutos ni se han validado Safari/Firefox o hardware modesto.

## Reproducir las imágenes

`Godot --path godot_ilustrado --script res://tests/capturar_candidata.gd --fixed-fps 60`; añadir `-- --anterior` para la geometría v2. Para el entorno, usar `tests/capturar_recorrido.gd`. Para vídeo, añadir a este último `--write-movie /tmp/sota_v3.avi -- --video` y convertir con ffmpeg. `capturar_equipo.gd` conserva explícitamente el modelo v2 para su comparación histórica.

## Archivos principales

Nuevos: fuente/modelo `ilustrada_3d_v3`, `assets/sota_3d_v3`, `tests/capturar_candidata.gd` y esta carpeta.

Modificados: `cuerpo.gd`, `laboratorio.gd`, `recorrido_3d.gd`, `pasarela.gd`, pruebas de modelo/equipo/contacto/encuadre/captura y documentos de continuidad, dirección, tareas y plan. No se cambia `godot/movimiento.gd`, el canon ni `sources/`.

## Web de esta entrega

Exportación Web 3D regenerada y probada en Helium/WebGL 2: carga, clic para caminar, seguimiento lejano de cámara y pausa por Espacio, sin errores registrados. [Carga](web.png) · [Desplazamiento y pausa](web_camara_pausa.png) · [Consola](consola_web.txt).
