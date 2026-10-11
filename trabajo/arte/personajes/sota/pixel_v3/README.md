# Sota · Ojos apenas visibles

11 de octubre de 2026. El autor precisa: «los ojos deben verse muy poco no pintar solo la cara vacía». Se mantiene el píxel intenso y el rostro en masas de sombra; se añade una pequeña marca oscura de ojo a cada perfil, sin blancos ni iris detallados. Este criterio se incorpora a la dirección de todas las personas; en esta entrega solo se retoca Sota.

**Propuesta del asistente, pendiente de valoración estética del autor.** Ediciones con imagegen integrado, conservando intentos y prompts. La edición generativa puede variar otros píxeles; no se afirma conservación exacta del cuerpo.

## Versiones conservadas

| Intento | Imagen y prompt | Resultado del asistente |
| --- | --- | --- |
| v4 | [Imagen](ojos_demasiado_sutiles_v4.png), [prompt](../prompt_pixel_v4.txt) | Primera marca demasiado sutil; la cara seguía pareciendo vacía. |
| v5 | [Imagen](ojos_con_alfa_incorrecto_v5.png), [prompt](../prompt_pixel_v5.txt) | Ojo discreto legible al ampliar, pero la edición introdujo opacidad fuera de los personajes. Se retira de la ejecución. |
| v6 | [Imagen](limpieza_con_variacion_de_luz_v6.png), [prompt](../prompt_pixel_v6.txt) | El intento de limpiar alfa cambió demasiado la iluminación del cuerpo. Descartado por aspecto; no se valida para integración. |
| v7 | [Atlas integrado](../../../../../godot/assets/personajes/sota/perfiles_pixel_v7.png), [prompt](../prompt_pixel_v7.txt) | Recupera la base con transparencia y luz oscura, usando v5 como referencia solo para la pequeña marca de ojo. Entrega vigente. |

La base previa se conserva en [pixel_v2](../pixel_v2/README.md). Para v7 se editaron v4 y v5 mediante referencias locales; no se limpiaron ni redibujaron imágenes por código.

## Integración comprobada

Atlas de **1536 × 1024**, dos perfiles propios en celdas de 768 × 1024. [JSON de regiones y pivotes](../../../../../godot/assets/personajes/sota/perfiles_pixel_v7.json), medido con `Image` de Godot al umbral alfa 0,1: alturas 871/868 y bases locales y = 946/947. En escena se normalizan altura y apoyo, sin reflejar las vistas. No son fotogramas de animación.

[Comparación nativa antes/después en Velvet](../../../revisiones/escala_v5/README.md): altura propuesta 252, apoyo (780, 710), nearest inicial. El asistente observa ojos como marcas mínimas dentro de la sombra a tamaño de juego; ambos perfiles conservan silueta, chaqueta marrón rojiza, pantalón oscuro, botas, correa y lado físico del deck. La luz/sombra definitiva y la coherencia fina del equipo siguen pendientes.

Importación correcta. Pasan `tests/escala.gd` (ambas versiones, perfiles, tres alturas, apoyo, filtros y alfa transparente en bordes y separación central) y `tests/verificacion.gd`; exportación Web release termina con código 0. Capturas finales hechas después de corregir el alfa; no se usan las capturas del intento fallido.

Pendientes: valoración del autor, retícula lógica uniforme de producción, luz/sombra de contacto, respiración, locomoción y comprobación visual Web. No se repite el control de Safari bloqueado en la revisión anterior. La exportación correcta no demuestra validación en navegador.

## Procedencia

Originales en `/Users/glitchbane/.codex/generated_images/01a12073-55ef-7ed1-8a16-ad74d5324000/`, copiados sin edición al proyecto:

- v4: `exec-ccffd7f5-6747-46af-8fbe-5358ec4feac5.png`.
- v5: `exec-17257663-b54b-4f98-9d09-8817dbbf33a9.png`.
- v6: `exec-6bda7b60-6373-4028-aa4e-a40ca1c6a4d0.png`.
- v7: `exec-12257778-a78a-4633-b187-d96d924c39cc.png`.
