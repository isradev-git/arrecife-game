# Sota · Corrección de continuidad desde v7

13 de octubre de 2026. El autor rechaza [la primera marcha](../caminar_v1/README.md): no se parece al reposo y es más clara. Se conserva v7 original como referencia y único sprite del recorrido. No se cambia el reposo para adaptarlo a la propuesta rechazada.

Una sola edición con **imagegen integrado**, sin CLI/API ni retoques de PNG por código: [contacto_identidad_v1.png](contacto_identidad_v1.png), [prompt exacto](prompt_contacto_v1.txt). Referencia de entrada única: [v7 aprobada](../../../../../godot/assets/personajes/sota/perfiles_pixel_v7.png). Solicita editar la postura conservando paleta oscura, sombras/píxel grueso, proporciones, pelo/mecha, chaqueta, correa/deck, ojos mínimos y perfil derecho. Hoja 1536 × 1024 con alfa: reposo reconstruido a izquierda y contacto a derecha. El reposo reconstruido **no se usa como original ni se incorpora al juego**.

[Comparación GPU con el v7 original real](../../../revisiones/marcha_identidad_v2/README.md): escala común 252/871, mismo shader CUTOUT sin filtros de oscurecimiento adicionales. Nuevo contacto medido al alfa 0,1: región [853, 85, 459, 854], altura en comparación ~247; escala/pivote provisionales para evaluar dibujo. No normalizar a 252 por fotograma para esconder diferencias. Revisar proporciones y pequeñas variaciones generativas antes del ciclo.

## Continuación · primer medio paso derecho

El autor autoriza continuar; no se registra aprobación artística nueva. Se generan tres poses más con **imagegen integrado**, una llamada por fase. Cada llamada usa como entradas v7 original y `contacto_identidad_v1.png`; no usa las hojas rechazadas. PNG conservados íntegros, 1536 × 1024 y alfa, sin edición por código:

| Fase | Original generado | Prompt exacto |
| --- | --- | --- |
| Apoyo / amortiguación | [apoyo_v1.png](apoyo_v1.png) | [prompt_apoyo_v1.txt](prompt_apoyo_v1.txt) |
| Cruce / paso de pierna | [cruce_v1.png](cruce_v1.png) | [prompt_cruce_v1.txt](prompt_cruce_v1.txt) |
| Impulso / elevación | [impulso_v1.png](impulso_v1.png) | [prompt_impulso_v1.txt](prompt_impulso_v1.txt) |

La figura derecha de cada hoja es la pose propuesta; izquierda contiene reposo reconstruido, no utilizado. Todas las poses se comparan con **v7 original real**: [láminas Godot y comprobaciones](../../../revisiones/marcha_poses_oscuras_v1/README.md). Mismo CUTOUT y escala 252/871, sin normalizar alturas por fotograma. Promedio tonal próximo al original, pendiente de revisar coherencia de dibujo y proporciones en movimiento.

Propuesta de cuatro fases de un medio paso derecho, pendiente de valoración del autor. Falta el paso de la pierna contraria y el perfil izquierdo propio; no hay ciclo completo ni marcha integrada. PNG, prompts y modelos anteriores conservados; archivos de esta corrección no están en los assets del juego. Oscuridad cercana no demuestra continuidad perfecta de anatomía/equipo.
