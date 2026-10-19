# Sota 17 · paso más breve y postura centrada

17 de octubre de 2026. El autor señala que la candidata 16 anda «como una modelo», muy artificial. Esta revisión responde a esa observación. **Actualización: el autor aprueba visualmente la marcha hacia la derecha («me parece guay»). Izquierda y transiciones pendientes.**

[Referencia aprobada conservada, con 14 archivos y SHA256 verificados](../../personajes/sota/versiones/marcha_derecha_v17_aprobada/README.md). La aprobación se limita al ciclo derecho y no declara terminado el vestuario ni la integración.

## Ver el resultado

- [Comparación animada local](http://127.0.0.1:8766/trabajo/arte/revisiones/sota_captura_v17/): izquierda, candidata 16; centro/derecha, revisión 17 con ambos perfiles propios.
- Godot: abrir `godot/candidatas/comparacion_sota_captura_v17.tscn` y pulsar **F6**.
- [Derecha](derecha.png), [izquierda](izquierda.png), [captura nativa](comparacion_nativa.png), [grabación real](marcha_real.webm).
- Pausa, cámara lenta, avance, articulaciones; la página incluye ocho claves por perfil.

## Diagnóstico y corrección

La percepción de «modelo» es la valoración del autor; las siguientes causas son la interpretación del asistente apoyada en el ciclo y su geometría:

- **Paso largo a poca cadencia:** 168 px a 104 px/s daba un ciclo de 1,615 s. Se acorta a **140 px / 1,346 s**, manteniendo la velocidad horizontal. Es una elección de animación, no una nueva medida de la captura.
- **Torso retrasado:** el retarget anterior quitaba la inclinación media de la captura y conservaba la postura retrasada del dibujo de reposo. Se adelanta el torso 0,14 rad (~8°) respecto a esa postura. Cabeza, cuello, hombros y deck acompañan la colocación, conservando los dibujos y el lado físico del equipo.
- **Punta de bota excesiva:** la transferencia directa de ángulo de la captura llevaba la bota a ~73° durante recuperación. Se reduce su amplitud al 45 %, de forma continua, sin topar la curva con una meseta.
- **Carga y rodillas:** acortar solo el paso aumentaba la flexión. Se coordina la altura de pelvis con el pie de apoyo y una extensión de soporte de 8–18°, manteniendo la captura en recuperación y el límite de alcance para ambas piernas. Esto evita la regresión a caminar agachada.
- **Gestos superiores:** oscilación de torso al 50 % y desviación angular de brazos respecto a vertical al 75 %, para una marcha más contenida.

Se conservan 56/56 px de segmentos, origen fijo, nearest, alfa binaria y dos perfiles sin reflejo. No hay imágenes generativas, nuevas reconstrucciones UV ni escalado de personaje por fotograma. La 16 se conserva íntegra como referencia.

## Comprobaciones

[Registro completo](validacion.txt).

- 4098 poses/subposes: error máximo de segmento **0,00001907 px**, alcance válido, sin inversión de rodillas ni salto en el cierre 0/1.
- Ambas rodillas >25°: **20/64 poses en la derecha de la 16 → 0/4098 subposes en ambos perfiles de la 17**. La prueba nueva comprueba explícitamente esta regresión.
- Inclinación máxima de bota: **32,852°**; prueba de límite <35°.
- Desplazamiento máximo de pelvis por 1/2048 ciclo: **0,065651 px**.
- 128 renders: sin recorte en celdas, transparencia binaria, suela en filas **271–272**, origen 272. Altura visible **251–257 px**, variable por postura; no se normaliza cada frame.
- Deriva de borde de suela renderizada durante cuatro tramos de apoyo plano: **0,938 px**. No incluye el rodado completo ni la retención temporal entre frames, cuyo paso es **2,1875 px**.
- Comparación nativa: reproducción, pausa y cámara lenta en el código real a **30/60/120 Hz**.
- Helium: página, perfiles, fase, pausa/reanudación, lenta, paso y articulaciones; captura de ambos lados y grabación real. Inspección de láminas y secuencia renderizada.

Estas comprobaciones no demuestran naturalidad ni aprobación estética. Se conserva la limitación del vestuario: pelvis/entrepierna y superficies ocultas del pantalón siguen usando la malla anterior. Reposo, arranque, parada e inversión de la ruta humana siguen pendientes. No se cambia el juego predeterminado ni el controlador, y no se hace una nueva exportación Godot Web; el navegador muestra PNG renderizados por Godot.

## Archivos

- `godot/candidatas/sota_captura_v17.gd`: revisión aislada de la pose; reutiliza los canales CMU de `captura_v16_candidata/ciclo.json`.
- `godot/assets/personajes/sota/captura_v17_candidata/`: atlas y JSON de marcha.
- `godot/candidatas/comparacion_sota_captura_v17.gd` y `.tscn`: antes/después nativo.
- `godot/tests/preparar_sota_captura_v17.gd`, `captura_sota_v17.gd`, `render_sota_captura_v17.gd`: generación y pruebas.
- Esta carpeta: revisión Web, capturas, vídeo, diagnóstico y registro.
- `task.md` y `proceso/ESTADO_DEL_PROYECTO.md`: observación del autor, entrega y pendientes.

Para regenerar y comprobar, desde la raíz:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script res://tests/preparar_sota_captura_v17.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --editor --import --quit
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/captura_sota_v17.gd
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script res://tests/render_sota_captura_v17.gd
```
