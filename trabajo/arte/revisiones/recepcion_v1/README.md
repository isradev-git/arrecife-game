# Velvet · Revisión de recepción T07.6

11 de octubre de 2026. [Recursos y tres prompts de imagegen](../../entornos/velvet/recepcion_v1/README.md). Figurante detrás del mostrador, equipo sobre él, Sota en la pasarela por delante y barandilla delantera en primer plano. Entrega del asistente pendiente de valoración del autor.

## Capturas

Todas a 1672 × 941, con ambas barandillas. Cinco renders nativos de SubViewport sin panel y siete capturas reales de Helium/Chromium con controles. Sota mide 252, pies y = 705; x = 1345 salvo Galería y Figurante entera, donde x = 780.

| Estado | Godot nativo | Navegador |
| --- | --- | --- |
| Todo visible, perfil derecho | [Imagen](godot_completa_0.png) | [Imagen](web_completa_0.png) |
| Todo visible, perfil izquierdo | [Imagen](godot_completa_1.png) | [Imagen](web_completa_1.png) |
| Figurante oculta, equipo y mostrador visibles | [Imagen](godot_sin_figurante.png) | [Imagen](web_sin_figurante.png) |
| Equipo oculto, figurante y mostrador visibles | [Imagen](godot_sin_equipo.png) | [Imagen](web_sin_equipo.png) |
| Interior sin los tres elementos | [Imagen](godot_interior.png) | [Imagen](web_interior.png) |
| Todo visible, Sota en Galería | — | [Imagen](web_galeria.png) |
| Figurante completa, mostrador y equipo ocultos | — | [Imagen](web_figurante_entera.png) |

## Comprobaciones

Godot 4.7.2, Compatibility, Apple M4; importación y exportación Web correctas. Pasan `tests/escala.gd`, `tests/verificacion.gd`, `tests/capas.gd`, `tests/mostrador.gd` y la nueva `tests/recepcion.gd`.

Recepción GPU: transparencia genuina y nearest, pies de figurante y base de equipo calibrados, orden de planos fijo. Al activar figurante/equipo cambian 12 523/2283 píxeles respectivamente; el mostrador oculta correctamente 6855 muestras de cuerpo de la figurante. Ambos perfiles de Sota quedan delante de toda la recepción (9346/8624 muestras comprobadas). Prueba del mostrador: 54 688 píxeles reparados y render idéntico fuera del parche al alternarlo; Sota conserva 5919/5403 muestras delante del mueble. La barandilla sigue pasando sus ocho combinaciones de posición/perfil y las dos filas sin huecos.

Prueba gráfica y regeneración opcional de las cinco capturas nativas:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/recepcion.gd -- --capturas
```

Sin `--capturas` solo comprueba; no usar `--headless` para las pruebas GPU. Un primer intento de esta prueba muestreaba una columna fuera del recorte escalado; corregidos los límites y repetida sin errores. No fue un defecto del montaje.

Agent-browser en sesión propia `arrecife-recepcion-20261011`, ejecutable Helium y WebGL 2.0: carga, perfiles, posición frente al mostrador/Galería y visibilidad independiente por clic observados. Sin errores de página/consola registrados. Automatización cerrada; Godot actualizado y URL abiertos en aplicaciones visibles. Servidor local existente respondió en `http://127.0.0.1:8766/godot/build/web/`; comprobar que sigue activo al retomar.

Sin caminar, respiración, colisiones ni interacción narrativa. El equipo es un grupo, el contraluz es manual, generación con variaciones de detalle. Resto de figurantes, arquitectura, ciudad, humo/luz, Safari/Firefox, rendimiento y juego completo pendientes.

**Continuación T07.7:** [figura del acceso y escalera reconstruida](../acceso_v1/README.md). Estas capturas conservan el montaje de recepción, que sigue integrado; la nueva figura se revisa en su propia entrega.
