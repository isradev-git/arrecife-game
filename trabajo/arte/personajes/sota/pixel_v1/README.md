# Sota · Primer pase pixel art

11 de octubre de 2026. **Entrega del asistente, pendiente de valoración del autor.** Generada con `imagegen` integrado, usando la Sota v3 como referencia de identidad y las dos imágenes aprobadas como referencias de estilo y entorno. No modifica canon ni historia.

| Versión | Imagen | Prompt | Resultado |
| --- | --- | --- | --- |
| v1 | [Atlas conservado](atlas_pixel_v1.png) | [Generación](../prompt_pixel_v1.txt) | Dos perfiles, chaqueta marrón, parche derecho y deck en su lado físico; acentos azules/rojos marcados. |
| v2 | [Atlas integrado](../../../../../godot/assets/personajes/sota/perfiles_pixel_v2.png) | [Edición](../prompt_pixel_v2.txt) | Reduce los acentos de borde y conserva dos vistas; transparencia real comprobada en Godot. No se afirma conservación exacta de píxeles entre generaciones. |

El primer preview del generador parecía incluir un fondo/halo. Se pidió limpiarlo; la lectura posterior del alfa muestra que el color exterior de los PNG queda bajo transparencia y que sus siluetas se recortan correctamente al umbral 0,1. El render de Godot confirma que ese fondo no aparece sobre Velvet. No se ha borrado ni reconstruido alfa por código.

Atlas final de 1536 × 1024; dos celdas de 768 × 1024. No son dos fotogramas consecutivos de animación: son reposos de perfil derecho e izquierdo. Se consumen como regiones `AtlasTexture`, sin reflejo horizontal. [Regiones y pivotes medidos](../../../../../godot/assets/personajes/sota/perfiles_pixel_v2.json).

Revisión del asistente: rostro reconocible, pelo corto oscuro, detalle gris de la sien derecha, chaqueta marrón rojiza, parche de manga derecha, pantalón oliva, botas negras, correa clara y deck en cadera derecha. La izquierda conserva el equipo al lado lejano. La edición ha introducido variaciones pequeñas de forma y color: revisar cara, manos y ropa con el autor antes de convertirla en base de animación.

[Comparación nativa en Velvet](../../../revisiones/escala_v3/README.md). Propuesta de altura 252 con nearest; escala lógica, retícula, luz y sombra de contacto definitivas pendientes. No se entrega todavía respiración ni locomoción.

Procedencia original, conservada en `/Users/glitchbane/.codex/generated_images/01a12073-55ef-7ed1-8a16-ad74d5324000/`:

- v1: `exec-0766b985-ad4b-4ce5-bd38-ea08839cd79b.png`.
- v2: `exec-499b9093-50c1-4910-9103-831d69684fc8.png`.

Las copias dentro del proyecto son idénticas a esos originales; los prompts y las referencias anteriores se conservan.
