# Sota · Píxel intenso y rostro simplificado

11 de octubre de 2026. Corrección solicitada por el autor: el primer pase se rechaza por píxel demasiado fino y cara demasiado definida. El nuevo criterio se aplica a **todas las personas** del juego: bloques más intensos y rostros sin rasgos dibujados, tomando la imagen de personajes aportada por el autor como referencia principal.

**Nueva propuesta del asistente, pendiente de valoración del autor.** Generada con imagegen integrado. Se usa la imagen de personajes primero para el estilo y la referencia original de Sota solo para silueta, ropa y equipo; se pide expresamente no heredar su cara detallada.

- [Atlas v3](../../../../../godot/assets/personajes/sota/perfiles_pixel_v3.png): 1536 × 1024, dos perfiles propios en celdas de 768 × 1024, con transparencia real.
- [Prompt completo](../prompt_pixel_v3.txt).
- [Regiones y pivotes medidos](../../../../../godot/assets/personajes/sota/perfiles_pixel_v3.json): alturas de silueta 870 y 859 al umbral alfa 0,1, base común original y = 946. La revisión normaliza ambas a altura 252 y suelo y = 710.
- [Comparación nativa con la versión rechazada](../../../revisiones/escala_v4/README.md).

Revisión visual del asistente: bloques mayores en silueta, pelo, pliegues y manos; cara reducida a masas de color, sin ojos, labios ni modelado facial detallado. Chaqueta marrón rojiza, parche derecho, pantalón oscuro, botas, correa clara y deck en su lado físico conservados; el deck queda al lado lejano en el perfil izquierdo. Se mantienen diferencias pequeñas de proporción propias de la generación, pendientes de revisión antes de animar.

La petición de resolución lógica baja se usa como guía de generación, no como prueba de una cuadrícula uniforme en el PNG. La retícula de producción definitiva sigue pendiente. No se ha aplicado una reducción de resolución ni una edición del alfa por código. Se conserva el descarte de alfa menor que 0,1 al dibujar en Godot.

Original: `/Users/glitchbane/.codex/generated_images/01a12073-55ef-7ed1-8a16-ad74d5324000/exec-8dc196f2-425c-4f39-b513-ce33eacf0fe3.png`. La copia del proyecto es idéntica byte a byte. [Primer pase rechazado y prompts anteriores](../pixel_v1/README.md) conservados.

Comprobados importación, ambos perfiles/alturas/apoyos/transparencia/filtros, escena técnica y exportación Web. Pendientes valoración del autor, retícula final, luz/sombra de contacto y comprobación visual en navegador. Sin respiración ni locomoción.
