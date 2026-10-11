# Velvet · Dos personas del acceso independientes T07.8

12 de octubre de 2026. [Dos recursos y prompts de imagegen](../../entornos/velvet/acompanante_v1/README.md). La persona de mochila mira a la derecha y el acompañante de abrigo oscuro a la izquierda; ambos detrás de Sota, con apoyo y = 675. Nueva entrega pendiente de valoración del autor.

## Capturas

Siete renders nativos de SubViewport sin panel y siete capturas reales de Helium/Chromium, todos a 1672 × 941. Sota mide 252, pies y = 705. Mochila: 236 de alto; acompañante: 248. Recepción anterior visible en todas.

| Estado | Godot | Web |
| --- | --- | --- |
| Galería, ambas personas visibles | [Imagen](godot_galeria.png) | [Imagen](web_galeria.png) |
| Sota x = 1625, perfil derecho | [Imagen](godot_cruce_0.png) | [Imagen](web_cruce_0.png) |
| Sota x = 1625, perfil izquierdo | [Imagen](godot_cruce_1.png) | [Imagen](web_cruce_1.png) |
| Solo persona de mochila | [Imagen](godot_sin_acompanante.png) | [Imagen](web_sin_acompanante.png) |
| Entrada sin ambas personas | [Imagen](godot_entrada_vacia.png) | [Imagen](web_entrada_vacia.png) |
| Solo acompañante | [Imagen](godot_solo_acompanante.png) | [Imagen](web_solo_acompanante.png) |
| Ambas personas, solo barandilla trasera | [Imagen](godot_sin_delantera.png) | [Imagen](web_sin_delantera.png) |

Sota en Galería x = 780 salvo los dos cruces; ambas barandillas visibles salvo la última fila.

## Comprobaciones

Godot 4.7.2 Compatibility, Apple M4. Se amplía la prueba existente `tests/acceso.gd` para comprobar cada persona por separado. Pasan sus dos modos, `tests/escala.gd`, `tests/verificacion.gd`, `tests/capas.gd`, `tests/recepcion.gd` y `tests/mostrador.gd`; importación y exportación Web correctas.

GPU: alfa genuino, nearest, apoyo y orden; materiales distintos, cambiar el contraluz de una no altera el parámetro de la otra. Parche común: 40 089 píxeles reparados y render idéntico fuera al alternarlo. Acompañante: 717 píxeles afectados por contraluz, 826 ocultos por metal delantero y 1817 visibles entre barrotes; Sota delante en ambos perfiles (9315/8624 muestras). Mochila conserva 614 afectados por luz, 694 ocultos y 1530 en aberturas, con 9346/8624 muestras de Sota delante. Recepción y ocho posiciones/perfiles de barandillas siguen pasando.

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/acceso.gd
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/acceso.gd -- --acompanante
```

Añadir `--capturas` tras `--` regenera las siete capturas nativas en esta carpeta, preservando las de T07.7. Necesita render gráfico, sin `--headless`.

Agent-browser, sesión propia `arrecife-acompanante-20261012`, ejecutable Helium y WebGL 2.0. Carga, ambos perfiles, Junto al acompañante, Galería, visibilidad de cada persona y Solo trasera por clic observados sin errores de página/consola. Automatización cerrada; Godot y URL actualizados abiertos. Servidor local existente respondió en `http://127.0.0.1:8766/godot/build/web/`; comprobar que siga activo al retomar.

El autor ha aprobado el criterio de separación y propuesto posibles diálogos. No se han implementado conversaciones, animación ni movimiento/colisiones; luz manual. Arte nuevo con variaciones generativas; Safari/Firefox, rendimiento y juego completo pendientes.
