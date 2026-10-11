# Velvet · Revisión de guardia y cabina T07.9

12 de octubre de 2026. [Tres recursos originales y prompts de imagegen](../../entornos/velvet/cabina_v1/README.md). Nueva entrega del asistente, pendiente de valoración artística del autor. El autor establece que la cabina permitirá conversación y viaje entre cotas; esas funciones siguen pendientes.

## Capturas

Siete renders nativos de SubViewport sin panel y siete capturas reales de Helium/Chromium, todos a 1672 × 941. Sota mide 252 y pisa y = 705; guardia de 260 con apoyo y = 675. Recepción y personas del acceso conservadas.

| Estado | Godot | Web |
| --- | --- | --- |
| Galería, Sota x = 780 | [Imagen](godot_galeria.png) | [Imagen](web_galeria.png) |
| Frente a cabina x = 300, perfil derecho | [Imagen](godot_frente_0.png) | [Imagen](web_frente_0.png) |
| Frente a cabina x = 300, perfil izquierdo | [Imagen](godot_frente_1.png) | [Imagen](web_frente_1.png) |
| Sin guardia, frontal visible | [Imagen](godot_sin_guardia.png) | [Imagen](web_sin_guardia.png) |
| Guardia visible sin frontal | [Imagen](godot_sin_frontal.png) | [Imagen](web_sin_frontal.png) |
| Interior vacío, sin guardia ni frontal | [Imagen](godot_interior.png) | [Imagen](web_interior.png) |
| Cabina completa, solo barandilla trasera | [Imagen](godot_solo_trasera.png) | [Imagen](web_solo_trasera.png) |

Ambas barandillas visibles salvo la última fila. Las cuatro últimas revisiones usan Sota x = 300 y perfil derecho. En Web el panel se aparta al revisar la cabina; en Galería conserva su posición habitual.

## Comprobaciones

Godot 4.7.2 Compatibility, Apple M4. `tests/cabina.gd`: alfa genuino, nearest, apoyos y orden; material propio del guardia; desplazamiento/retorno del panel. GPU: 36 763 píxeles reparados y render idéntico fuera del parche; frontal tapa 6064 muestras del cuerpo, deja 7675 visibles por la ventanilla y conserva 97 píxeles azules del terminal. Sota queda delante del conjunto en ambos perfiles: 9346/8624 muestras de cuerpo conservadas.

Pasan también escala, escena técnica, barandillas en ocho posiciones/perfiles, mostrador, recepción y ambos modos de acceso. Importación y exportación Web terminan con código 0.

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/cabina.gd
```

Añadir `-- --capturas` regenera las siete capturas nativas en esta carpeta. Requiere render gráfico, sin `--headless`; versiones anteriores conservadas.

Agent-browser, sesión propia `arrecife-cabina-20261012`, ejecutable Helium, Chromium 154/WebGL 2.0. Carga, Frente al guardia, ambos perfiles, visibilidad independiente del guardia/frontal, Solo trasera y retorno a Galería por clic observados sin errores de página/consola. Un primer comando batch tuvo sintaxis incorrecta; corregido tras consultar ayuda y doctor. Doctor no encuentra Chrome estándar; la sesión propia con ejecutable Helium funciona. Automatización cerrada; Godot y URL actualizados abiertos. HTTP local responde en `http://127.0.0.1:8766/godot/build/web/`; comprobar el servidor al retomar.

No se comprueban Safari/Firefox, accesibilidad ni rendimiento sostenido en esta entrega. Sin animación, movimiento/colisiones, diálogo o viajes; contraluz manual. Generación cambia detalles de la cabina; señalización del viaje pendiente.
