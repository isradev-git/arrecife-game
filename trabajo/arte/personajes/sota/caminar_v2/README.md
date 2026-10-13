# Sota · Corrección de continuidad desde v7

13 de octubre de 2026. El autor rechaza [la primera marcha](../caminar_v1/README.md): no se parece al reposo y es más clara. Se conserva v7 original como referencia y único sprite del recorrido. No se cambia el reposo para adaptarlo a la propuesta rechazada.

Una sola edición con **imagegen integrado**, sin CLI/API ni retoques de PNG por código: [contacto_identidad_v1.png](contacto_identidad_v1.png), [prompt exacto](prompt_contacto_v1.txt). Referencia de entrada única: [v7 aprobada](../../../../../godot/assets/personajes/sota/perfiles_pixel_v7.png). Solicita editar la postura conservando paleta oscura, sombras/píxel grueso, proporciones, pelo/mecha, chaqueta, correa/deck, ojos mínimos y perfil derecho. Hoja 1536 × 1024 con alfa: reposo reconstruido a izquierda y contacto a derecha. El reposo reconstruido **no se usa como original ni se incorpora al juego**.

[Comparación GPU con el v7 original real](../../../revisiones/marcha_identidad_v2/README.md): escala común 252/871, mismo shader CUTOUT sin filtros de oscurecimiento adicionales. Nuevo contacto medido al alfa 0,1: región [853, 85, 459, 854], altura en comparación ~247; escala/pivote provisionales para evaluar dibujo. No normalizar a 252 por fotograma para esconder diferencias. Revisar proporciones y pequeñas variaciones generativas antes del ciclo.

Propuesta de una pose, pendiente de valoración del autor. No hay ciclo ni perfil izquierdo nuevo. PNG, prompts y modelos anteriores conservados; archivos de esta corrección no están en los assets del juego. Oscuridad cercana no demuestra continuidad perfecta de anatomía/equipo.
