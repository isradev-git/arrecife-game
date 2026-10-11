# Velvet · Sota pixel art · Comparación en Godot

**Revisión histórica rechazada:** el autor pide píxel mucho más intenso y caras sin definición. [Comparación vigente](../escala_v4/README.md). Las notas siguientes documentan la entrega anterior.

11 de octubre de 2026. Entrega del asistente autorizada por el autor tras fijar las dos referencias de estilo. **Pendiente valoración visual del autor; no equivale a aprobación de los sprites nuevos.**

La escena principal carga [dos perfiles pixel art](../../../../godot/assets/personajes/sota/perfiles_pixel_v2.png) sobre [Velvet pixel art](../../../../godot/assets/fiebre_velvet_pixel_v1.png), copia idéntica de la imagen 1 aportada por el autor. El atlas anterior se conserva y puede elegirse mediante «Arte anterior»; «Pixel art» vuelve al nuevo. La comparación mantiene el mismo fondo, posición y altura; cada versión arranca con su filtro propuesto (anterior suave, nueva nítida), con opción de cambiarlo.

- Atlas nuevo: 1536 × 1024, dos celdas de 768 × 1024. Recortes y pivotes medidos en [JSON](../../../../godot/assets/personajes/sota/perfiles_pixel_v2.json). Ambas siluetas miden 908 píxeles al umbral alfa 0,1.
- Propuesta en escena: altura 252, apoyo en (780, 710), composición 1672 × 941, filtro nearest. Se conservan alternativas 232/272 y ubicación junto a recepción en x = 1160.
- Perfil derecho e izquierdo propios, sin `flip_h`. Deck, parche y detalle de la sien permanecen en su lado físico; en la izquierda el deck aparece parcialmente al otro lado del cuerpo. No se muestran frontal ni tres cuartos.
- Transparencia comprobada en la textura importada. Se conserva el shader existente que descarta alfa menor que 0,1 al dibujar; no se modifican los píxeles del PNG.

## Comparación a escala real

Capturas del viewport nativo de Godot Compatibility, Apple M4, 1672 × 941. No son composiciones del generador.

| Vista | Sota anterior | Sota pixel art |
| --- | --- | --- |
| Perfil derecho | [anterior_0.png](anterior_0.png) | [pixel_0.png](pixel_0.png) |
| Perfil izquierdo | [anterior_1.png](anterior_1.png) | [pixel_1.png](pixel_1.png) |

Abrir `godot/project.godot` y ejecutar F5. Comparar ambos estilos, perfiles, alturas, ubicación y filtrado mediante los botones. La escena sigue siendo estática.

## Comprobación y límites

Importación correcta; pasan `tests/escala.gd` (dos versiones, perfiles, tres alturas, apoyo estable, ausencia de reflejo, transparencia y filtros) y `tests/verificacion.gd`. Exportación Web release correcta, código 0. Render nativo observado por el asistente: siluetas completas, pies apoyados y ausencia de fondo/halo visible alrededor del personaje.

Pendientes: valoración estética del autor, prueba visual en navegador, iluminación de integración y sombra de contacto definitiva. La herramienta de control de Safari vuelve a fallar con `cgWindowNotFound` (-10005); no se presenta la exportación como validada visualmente en Web. La resolución lógica y retícula final siguen abiertas: nearest y un atlas generativo de alta resolución no acreditan por sí solos una cuadrícula de producción uniforme. Sota todavía no respira, camina ni corre. El fondo conserva figuración integrada y no tiene capas ni oclusiones independientes; no cierra T07.

[Recursos y prompts](../../personajes/sota/pixel_v1/README.md) · [Referencias aprobadas](../../referencias/pixel_art_v1/README.md) · [Tareas](../../../../task.md).
