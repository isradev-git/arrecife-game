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

## Intermedios solicitados por el autor

El autor pide más posturas para que el andar sea más natural. Se producen tres intermedios entre las cuatro fases anteriores: **siete posturas en total de un medio paso derecho**. Siete llamadas a imagegen integrado incluyendo correcciones, sin retoque por código; todas las hojas y prompts conservados:

| Transición | Propuesta seleccionada para comparación | Intentos y prompts |
| --- | --- | --- |
| Contacto → apoyo · carga | [contacto_apoyo_v3.png](contacto_apoyo_v3.png) | [v1](contacto_apoyo_v1.png) / [prompt v1](prompt_contacto_apoyo_v1.txt), [v2](contacto_apoyo_v2.png) / [prompt v2](prompt_contacto_apoyo_v2.txt), [prompt v3](prompt_contacto_apoyo_v3.txt). V1 pierde contraluz; v2 demasiado clara; v3 corrige paleta. |
| Apoyo → cruce · despegue | [apoyo_cruce_v1.png](apoyo_cruce_v1.png) | [prompt v1](prompt_apoyo_cruce_v1.txt). |
| Cruce → impulso · extensión | [cruce_impulso_v3.png](cruce_impulso_v3.png) | [v1](cruce_impulso_v1.png) / [prompt v1](prompt_cruce_impulso_v1.txt), [v2](cruce_impulso_v2.png) / [prompt v2](prompt_cruce_impulso_v2.txt), [prompt v3](prompt_cruce_impulso_v3.txt). V1 demasiado próxima al impulso; v2 corrige articulación pero queda más clara; v3 corrige paleta. |

Entradas iniciales: v7 original y ambas poses contiguas (solo sus figuras derechas). Corrección de carga v2: intento v1, v7 y apoyo; extensión v2: intento v1, cruce e impulso. Correcciones de paleta v3: v7 original e intento v2 correspondiente. PNG íntegros 1536 × 1024 con alfa. La figura de reposo reconstruida a izquierda de cada hoja nunca sustituye al original.

[Serie, comparación con v7 real, medidas y comprobaciones](../../../revisiones/marcha_intermedios_v1/README.md). Mismo shader y escala 252/871; las nuevas variantes tienen un promedio tonal entre +5,8 % y +8,4 % frente a v7. Coherencia completa de paleta/dibujo y naturalidad aún por comprobar en el ciclo.

Propuesta de siete posturas de un medio paso derecho, pendiente de valoración del autor. Objetivo inicial del asistente: 16 dibujos por ciclo completo y perfil, ajustable tras probarlo. Faltan transición al contacto contrario, paso de la pierna contraria y perfil izquierdo propio; no hay ciclo completo ni marcha integrada. PNG, prompts y modelos anteriores conservados; archivos de esta corrección no están en los assets del juego. Oscuridad cercana no demuestra continuidad perfecta de anatomía/equipo.
