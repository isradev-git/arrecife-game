# Velvet · Revisión del acceso T07.7

12 de octubre de 2026. [Recursos y tres prompts de imagegen](../../entornos/velvet/acceso_v1/README.md). Nueva figurante de perfil con mochila, independiente detrás de Sota y de la barandilla delantera. Entrega pendiente de valoración del autor; la valoración positiva del progreso no equivale a aprobación individual de este recurso.

## Capturas

Cinco renders nativos de SubViewport sin panel y cinco capturas reales de Helium/Chromium, todos a 1672 × 941. Sota mide 252, pies y = 705. Figurante mide 236, límite de apoyo y = 675. Recepción anterior visible en todas las capturas.

| Estado | Godot nativo | Web |
| --- | --- | --- |
| Galería, Sota x = 780, ambas barandillas | [Imagen](godot_galeria.png) | [Imagen](web_galeria.png) |
| Cruce x = 1560, perfil derecho | [Imagen](godot_cruce_0.png) | [Imagen](web_cruce_0.png) |
| Cruce x = 1560, perfil izquierdo | [Imagen](godot_cruce_1.png) | [Imagen](web_cruce_1.png) |
| Acceso oculto, escalera reconstruida, Sota x = 1560 | [Imagen](godot_escalera.png) | [Imagen](web_escalera.png) |
| Figura completa, Sota en Galería y solo barandilla trasera | [Imagen](godot_sin_delantera.png) | [Imagen](web_sin_delantera.png) |

## Pruebas

Godot 4.7.2, Compatibility, Apple M4. Importación y exportación Web correctas. Pasan `tests/acceso.gd`, `tests/escala.gd`, `tests/verificacion.gd`, `tests/capas.gd`, `tests/recepcion.gd` y `tests/mostrador.gd`.

Prueba nueva GPU: alfa genuino, nearest, altura/apoyo y orden de planos; material propio que no comparte parámetros con recepción. Parche: 23 396 píxeles reparados, render idéntico fuera al alternarlo. Contraluz calculado: 614 píxeles afectados al cambiar intensidad 0/0.7. Barandilla delante de la nueva figura: 694 muestras ocultas por metal y 1530 conservadas en aberturas. Sota delante del acceso: 9346/8624 muestras en los dos perfiles. También pasan los apoyos/oclusiones de recepción y ocho posiciones/perfiles de barandillas.

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/acceso.gd
```

Añadir `-- --capturas` regenera las cinco capturas nativas. Las pruebas GPU requieren render gráfico, sin `--headless`.

Agent-browser, sesión propia `arrecife-acceso-20261012`, ejecutable Helium y WebGL 2.0: carga/recarga, Junto al acceso, perfiles, ocultación/activación de Acceso y Solo trasera por clic comprobados. Sin errores de página/consola registrados. Automatización cerrada; Godot actualizado y URL abiertos en aplicaciones visibles. Servidor existente en `http://127.0.0.1:8766/godot/build/web/` respondió; comprobar que sigue activo al retomar.

Sin animación, caminar, colisiones ni historia nueva. Contraluz manual y retícula definitiva pendientes. Figura y reparación generativas con variaciones; persona contigua aún en el fondo. Safari/Firefox, rendimiento y juego completo sin comprobar.

**Continuación T07.8:** [acompañante y ambas personas independientes](../acompanante_v1/README.md). Estas diez imágenes conservan T07.7. El script actual amplía el parche y usa `--acompanante` para la segunda figura; `--capturas` ahora guarda la revisión T07.8 en su propia carpeta.
