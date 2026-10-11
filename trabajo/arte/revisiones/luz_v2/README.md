# Sota · Base e iluminación separadas

11 de octubre de 2026. El autor autoriza continuar tras aprobar el contraluz acorde al entorno. **Nueva base y resultado del shader entregados por el asistente, pendientes de valoración del autor.** Se conserva el atlas v7 aprobado y la [prueba anterior de recoloración](../luz_v1/README.md).

La escena compara «Referencia aprobada» (v7) con «Base e iluminación» (base_v1). La base no lleva neón fijo; el [shader de contraluz](../../../../godot/assets/personajes/sota/contraluz.gdshader) calcula una máscara del borde alfa, sin seleccionar colores de piel o ropa. Dos colores y direcciones independientes, intensidad y anchura ajustables. El modo «Sin neón» pone intensidad cero; «Luz de Velvet» combina rosa desde la izquierda y ámbar desde la derecha, también al cambiar de perfil.

## Capturas nativas

Godot Compatibility, Apple M4, 1672 × 941. Mismo fondo aplanado, altura 252, apoyo (780, 710), nearest y dos perfiles sin reflejo:

| Versión / luz | Perfil derecho | Perfil izquierdo |
| --- | --- | --- |
| Referencia aprobada v7 | [aprobada_0.png](aprobada_0.png) | [aprobada_1.png](aprobada_1.png) |
| Base + luz de Velvet | [velvet_0.png](velvet_0.png) | [velvet_1.png](velvet_1.png) |
| Base sin neón | [sin_neon_0.png](sin_neon_0.png) | [sin_neon_1.png](sin_neon_1.png) |
| Base + azul | [azul_0.png](azul_0.png) | [azul_1.png](azul_1.png) |
| Base + ámbar | [ambar_0.png](ambar_0.png) | [ambar_1.png](ambar_1.png) |

Los modos azul y ámbar demuestran independencia del recurso; no cambian la iluminación del fondo de Velvet. El asistente revisa ambos perfiles con la combinación de Velvet y la base sin neón: mantienen ojos sutiles, píxel intenso y apoyos. La nueva edición tiene pequeñas variaciones y no conserva exactamente todos los píxeles de v7.

## Comprobaciones

- `tests/escala.gd`: ambas versiones, recortes, alturas, apoyo, filtros, alfa y cambio de material/modo correctos.
- `tests/iluminacion.gd`: la solución histórica sobre v7 sigue pasando, con restauración idéntica del render aprobado.
- `tests/contraluz.gd`, sin `--headless`: render GPU de la base. 23 492 píxeles afectados por modo de prueba; menos del 15 % de la silueta opaca. Alfa idéntico, muestras interiores de rostro/ojos/ropa/equipo conservadas, intensidad cero restaura exactamente la base. Invertir la dirección desplaza la luz al lado opuesto en ambos perfiles; no se invierte el sprite.
- Importación, escena técnica y exportación Web release correctas.

## Límites y siguiente paso

La máscara del contorno se calcula en el shader a partir de transparencia; no es una máscara artística de reflejos interiores. Las sombras dibujadas en el cuerpo siguen en la base. Las direcciones representan dos aportes de luz controlados por parámetros: todavía no siguen lámparas, distancias, movimiento u oclusiones del escenario. No se atribuye al fondo estático una simulación de luz que no tiene.

Pendientes valoración de esta variante, retícula/escala definitivas en T02, conexión con fuentes del escenario, sombra de contacto, reflejos interiores, visual Web y animaciones. La nueva base permite avanzar después al controlador T04 sin producir ciclos ligados al neón de Velvet. El control de Safari bloqueado anteriormente no se reintenta en esta entrega.

[Base y prompt](../../personajes/sota/base_v1/README.md) · [Dirección](../../../direccion_artistica.md) · [Tareas](../../../../task.md). Consultada la documentación oficial de [CanvasItem shaders](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/canvas_item_shader.html) y [AtlasTexture](https://docs.godotengine.org/en/stable/classes/class_atlastexture.html).
