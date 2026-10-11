# Revisión · Suelo horizontal de Velvet

11 de octubre de 2026. Render nativo Godot 4.7.2, Apple M4. Sota altura 252, apoyo y = 675 constante, luz de Velvet. [Recurso, variantes y prompts](../../entornos/velvet/suelo_v1/README.md).

| Comparación | Perfil derecho | Perfil izquierdo |
| --- | --- | --- |
| Barandilla delante | [Captura](delante_0.png) | [Captura](delante_1.png) |
| Barandilla detrás | [Captura](detras_0.png) | [Captura](detras_1.png) |
| Sin barandilla | [Captura](sin_barandilla_0.png) | [Captura](sin_barandilla_1.png) |

La pasarela conserva altura y espesor visual de izquierda a derecha. La ciudad mantiene profundidad. Barandilla y Sota comparten línea de apoyo. Capturas anteriores de [T07.1](../capas_v1/README.md) conservadas para comparar.

`tests/escala.gd` comprueba pivote/suela en seis posiciones x y base de barandilla en y = 675, además de vistas, alturas, alfa y materiales. `tests/capas.gd` confirma 144/191 píxeles ocultos por metal y 4241/3900 visibles entre barrotes, según perfil, e inversión del orden. Importación, escena técnica y exportación Web correctas. Revisión visual del asistente; no son una prueba de locomoción, de todos los objetos ni de navegador.
