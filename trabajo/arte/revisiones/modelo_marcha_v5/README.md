# T05 · Modelo pulido, movimiento aprobado

13 de octubre de 2026. El autor prueba v4 y aprueba expresamente la naturalidad del movimiento: «el movimiento está perfecto». Lo nota un poco lento y pide pulir huecos, manos que aparecen en pantalones y otros restos de las piezas. La aprobación se refiere al movimiento; el acabado nuevo queda entregado para valoración.

**Valoración posterior · 14 de octubre:** el autor reconoce mejora del movimiento, pero sigue viendo mano izquierda pintada, bolsa sobre brazo y piernas entrecortadas. La prueba de piel cálida no detectaba todos los restos oscuros. [Corrección posterior, con regresión UV y oclusión GPU](../modelo_marcha_v6/README.md).

## Corrección integrada

El juego consume [articulada_v2](../../../../godot/assets/personajes/sota/articulada_v2/). Se conservan intactos v7 y los cuatro atlas v4 de `articulada_v1`. El [modelo nativo](../../../../godot/sota_articulada.gd) conserva las mismas trayectorias, giros, balanceo y oscilación; el controlador y la cadencia no cambian: ciclo 128 px, velocidad 104, aceleración 650/frenada 750.

- Recortes de torso/muslos izquierdos excluyen la mano que había quedado pintada dentro de la ropa.
- Tela bajo brazos y manos reconstruida con piezas UV de zonas limpias del mismo v7: chaqueta, cinturón, pelvis y muslos. Las piezas siguen al torso o a su pierna, sin tintes ni nuevos colores.
- Equipo derecho separado del recorte del torso y del comienzo del muslo, evitando que sus restos se muevan con otra pieza. Bolsillo, manga y deck conservan su lado físico.
- Antebrazos/manos recortados con su contorno completo, sin arrastrar pantalón ni recortar dedos.
- Recortes de pierna terminan en el puño del pantalón; las botas no se dibujan también dentro de esa pieza. Un relleno de cuero cubre la unión al inclinarse pantorrilla y bota, con muestra opaca y oscura del mismo atlas. El contorno de apoyo y la puntera preparados permanecen iguales.

No hay nuevas generaciones ni prompts en esta entrega: se corrige el recurso editable de Godot (Polygon2D/UV) y se renderizan nuevos sprites completos. No se edita el PNG original con código. [Modelo anterior](articulacion_antes.gd.txt) conservado para comparar transformaciones y reproducir el defecto.

## Antes, después y ejecución

- [Antes](antes.png) y [después](despues.png): ocho muestras ampliadas, sobre fondo uniforme, cuatro fases por perfil.
- [Antes sin brazos](antes_sin_brazos.png) y [después sin brazos](despues_sin_brazos.png): hacen visible la piel incrustada y las zonas ocultas reconstruidas.
- [Vídeo Web](marcha_web.webm), 9,333 s: tres segundos de D, parada, tres de A y parada. [Reposo inicial](web_reposo.png) y [reposo izquierdo](web_izquierda.png). Helium/Chromium, WebGL 2, canvas 1672 × 941; sin errores de página ni consola.
- Veinte capturas nativas en esta carpeta: siete momentos de marcha y tres de parada por perfil. Seis hojas `cobertura_*` muestran las 328 poses articuladas con los brazos/cabeza ocultos, para comprobar la ropa. `lamina.gd.txt` conserva el script usado para la comparación, no es una escena del juego.

## Comprobaciones

[Prueba del modelo](modelo.txt), [script](../../../../godot/tests/modelo_sota.gd): compara 328 estados articulados (marcha, arranque y cierre) contra v4. Transformaciones de cuerpo, torso, cabeza, piernas, botas, brazos, manos y deck idénticas; contornos de apoyo, distancia del ciclo y punteras de los metadatos idénticos. Reproduce 178 píxeles de piel en ropa de v4, perfil izquierdo sin brazos. En las 328 imágenes nuevas no detecta esa señal en la zona de ropa y las zonas reconstruidas de torso/cintura y eje de unión con botas son opacas. La detección usa un rango de piel cálida y una región concreta, no clasifica cada píxel de anatomía ni certifica todo el contorno artístico.

[Marcha GPU](marcha_gpu.txt): 338 poses, paleta de todos los 3.701.441 píxeles opacos presente exactamente en v7, alfa binaria; región de cabeza 110 × 48 idéntica al reposo rasterizado. Fases, escala, bucle, reducción y extremos pasan. [Fluidez](fluidez.txt): mismos resultados que v4, cero congelación/salto extra y puntera proyectada 3,467 px a 30 Hz, 2,401/2,400 a 60 Hz. [Controlador](controlador.txt): destinos, inversión, frenada, límites, colisiones y foco pasan. Importación y exportación Web release terminan con código 0; fuentes y archivos finales identificados en [hashes](hashes.sha256).

## Repetir

Desde la raíz del proyecto; preparar, importar y después comprobar:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script res://tests/preparar_sota_articulada.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --editor --import
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script res://tests/modelo_sota.gd
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script res://tests/movimiento_sota.gd -- --capturas
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/fluidez_marcha.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/movimiento.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --export-release Web
```

`tests/modelo_sota.gd` necesita GPU para comprobar cobertura; en headless solo compara transformaciones/datos. Las piezas UV reconstruidas conservan paleta, pero no añaden pliegues dibujados a mano; revisar el acabado a escala real. La velocidad algo lenta queda anotada para calibración posterior. Safari, Firefox, móvil y equipos modestos no comprobados en este pulido. T05/T06 conservan el movimiento aprobado; el pulido nuevo no tiene todavía aprobación del autor. Capas, historia, NPC y diálogos sin cambios.
