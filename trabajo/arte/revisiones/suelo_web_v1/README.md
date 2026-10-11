# Velvet · Capturas de la exportación Web

11 de octubre de 2026. Exportación Godot 4.7.2 de T07.2, servida por HTTP local en `http://127.0.0.1:8766/godot/build/web/`. Capturas reales del navegador, sin edición, con viewport y canvas 1672 × 941; no son renders nativos ni imágenes generadas.

Herramienta `agent-browser` 0.39.0, sesión aislada y ejecutable instalado `/Applications/Helium.app/Contents/MacOS/Helium` en modo headless. Chromium 154 según user-agent, WebGL 2.0; consola de Godot confirma Compatibility, Emscripten 4.0.20, sin hilos ni extensiones. Safari no pudo controlarse por `cgWindowNotFound`; no se presenta esta prueba como validación de Safari.

| Estado observado | Captura |
| --- | --- |
| Inicio: perfil derecho, barandilla delante | [delante_0.png](delante_0.png) |
| Clic en perfil izquierdo | [delante_1.png](delante_1.png) |
| Clic en «Detrás»: Sota cubre el metal | [detras_1.png](detras_1.png) |

Carga y recarga completas observadas, fondo horizontal, Sota y barandilla visibles, cambios por clic correctos. Sin errores de página ni errores en la consola registrada. Se abrió también la URL en Helium visible; sesión automatizada cerrada. El servidor ya existente queda activo, pero debe comprobarse al retomar.

No se modificó código ni se regeneró arte. [Entrega y prompts](../../entornos/velvet/suelo_v1/README.md); [comparación nativa conservada](../suelo_v1/README.md). Pendientes Safari/Firefox, teclado/accesibilidad y rendimiento; no se ha probado el caso completo, movimiento ni toda la matriz de luz/altura. No hay publicación pública ni aprobación estética nueva del autor.
