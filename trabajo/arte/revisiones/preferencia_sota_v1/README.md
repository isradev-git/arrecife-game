# Sota · V7 preferida y predeterminada

12 de octubre de 2026. El autor compara ambas opciones en navegador y prefiere **Referencia aprobada**, atlas `perfiles_pixel_v7.png`, frente a **Base e iluminación**, `perfiles_base_v1.png`. Se usa v7 al arrancar, con su shader original y el aspecto del botón Referencia aprobada. Ambos PNG/JSON y prompts quedan intactos; la alternativa sigue disponible para comparar.

| Estado Web | Captura |
| --- | --- |
| Arranque predeterminado v7, perfil derecho | [Imagen](web_v7_derecho.png) |
| V7, perfil izquierdo | [Imagen](web_v7_izquierdo.png) |
| Base e iluminación conservada para comparación | [Imagen](web_base_comparacion.png) |

Godot 4.7.2, Apple M4: pasan `tests/escala.gd`, `tests/capas.gd` y `tests/recepcion.gd`. Se comprueba explícitamente el atlas/shader inicial y que la recoloración esté desactivada en el modo Luz de Velvet; la prueba de escala sigue recorriendo ambas variantes, alturas, perfiles y modos de luz. GPU de barandillas en ocho posiciones/perfiles correcta. Sota v7 delante de recepción/libro en ambos perfiles: 9862/9116 muestras de cuerpo conservadas. Jefa y libro mantienen apoyo y oclusión de manos. Exportación release termina con código 0.

Agent-browser, sesión propia `arrecife-preferencia-20261012`, Helium/WebGL 2.0: arranque v7, perfil izquierdo, alternativa y retorno a Referencia aprobada por clic observados sin errores de página/consola. Tres PNG a 1672 × 941; automatización cerrada y Godot/URL actualizados abiertos. Sin arte generado ni modificado.

La preferencia por v7 no revoca el criterio de luz acorde al entorno. V7 conserva neón pintado y los controles actuales de recoloración por selección de colores; la separación definitiva de luz debe conservar este dibujo aprobado. Base_v1 es una prueba conservada, sin aprobación equivalente. Animación, luz espacial, retícula y otros navegadores siguen pendientes.
