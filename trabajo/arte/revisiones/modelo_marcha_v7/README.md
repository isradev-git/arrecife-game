# T05 · Hombro, planos de piernas y superficie continua

14 de octubre de 2026. El autor señala hombro lejano demasiado adelantado, pierna izquierda que atraviesa la cercana, bota tapada y piernas entrecortadas. Entrega del asistente para valoración; no es una aprobación nueva ni cierre del acabado.

[Antes](antes.png), [después](despues.png), [vídeo Web](web_marcha.webm) y [captura Web](web_izquierda.png). Modelo anterior y script de lámina conservados en `articulacion_antes.gd.txt` y `lamina.gd.txt`. `propuesta_1/2.png` y `actual.png` conservan pasos diagnósticos intermedios, no la entrega final.

El hombro lejano estaba 33,059 px adelantado a la derecha y 24,472 a la izquierda. Queda a 3 px del cercano y ligeramente más bajo durante marcha; el cierre mezcla hacia los anclajes de reposo. La cadera lejana también queda a 3 px: se corrige su articulación y rodilla, conservando exactamente raíces y trayectorias de pies. El centro de la rodilla fuente derecha lejana se ajusta al interior real de la tela. No se afirma que todas las transformaciones sean idénticas: estas correcciones anatómicas son intencionadas.

Cada cadena de pierna ocupa un plano: tela lejana −2, bota lejana −1; tela cercana 2, bota cercana 3. Los UV de muslo/pantorrilla forman una superficie subdividida y deformada con continuidad; la caña comparte ese campo y el pie conserva su inclinación/apoyo. Se retiran tapas rígidas de rodilla y cuñas de tobillo. Se reconstruyen pequeñas partes de cuero oculto con UV limpios; los recortes originales incluían fragmentos de la otra bota. La reconstrucción sigue requiriendo valoración artística, sobre todo contornos/pliegues/talón del perfil izquierdo.

Cuatro atlas nuevos en `godot/assets/personajes/sota/articulada_v4/`, 338 poses. Fuente v7, contornos de apoyo y atlas/datos v1/v2/v3 idénticos al commit anterior: [comprobación y SHA-256](conservacion.txt). Sin generaciones ni prompts nuevos; edición del modelo nativo Polygon2D/UV y render en Godot. Reposo/respiración conservan la referencia v7. Altura 252, suelo 705, planos del entorno y velocidad 104/ciclo 128 intactos.

## Comprobaciones

- [Regresión anterior](regresion_antes.txt): 256 fallos de hombro/cadera/orden de botas en 64 poses; código 1. [Montaje nuevo](prueba_montaje.txt): cero; código 0. Tres renders con posiciones iguales comprueban 46.204 cruces opacos entre ambas piernas: el resultado siempre coincide con la cercana, incluidos sus UV reconstruidos.
- [328 estados](prueba_modelo.txt): cuerpo/cabeza/brazo cercano/raíces de botas y apoyos invariables frente a marcha v4; cobertura de torso/cintura, núcleo de rodilla y caña, sin piel incrustada. Las seis hojas `cobertura_*` y `planos_piernas_*_*` conservan los renders.
- [Recortes](prueba_recortes.txt): cero UV de mano en ropa, cero puño duplicado, cero píxeles donde bolsa tapa brazo en 5327 cruces.
- [338 poses y escena](prueba_marcha.txt): 3.531.688 píxeles opacos con RGB exactos de v7, alfa binaria, región de cabeza idéntica, 32 fases por perfil, arranque/cierre/reducción/límites. Veinte capturas nativas de marcha y parada.
- [Fluidez](prueba_fluidez.txt) y [controlador](prueba_controlador.txt): cero congelaciones/saltos extra; desviación proyectada de puntera 3,467 px a 30 Hz y 2,400–2,401 a 60 Hz; siete llegadas, colisiones y foco pasan. La medición usa los contornos de apoyo originales; no demuestra pie inmóvil ni naturalidad perfecta.
- Preparación, importación y exportación Web completadas. [Helium](web.txt), WebGL 2: D/A, paradas, retorno a x=780/reposo, Modelo 7 confirmado, sin errores. Vídeo original 12,966 s a 30 fps y dos capturas Web.

Repetir desde la raíz: `/Applications/Godot.app/Contents/MacOS/Godot --path godot --script res://tests/montaje_sota.gd` (GPU); añadir `--headless` y `-- --antes` reproduce el defecto. Preparar atlas antes de importar y ejecutar las pruebas de marcha.

T05 permanece abierta para valoración del modelo. No cambia velocidad ni se inicia otra tarea. Safari/Firefox/móvil/equipos modestos sin comprobar; cobertura geométrica no certifica todos los contornos artísticos.
