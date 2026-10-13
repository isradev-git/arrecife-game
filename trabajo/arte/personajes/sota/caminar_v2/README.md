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

## Corrección de mangas · vigente

El autor advierte una diferencia de manga en extensión/impulso. La manga adelantada se había acortado; ambas deben cubrir hasta el codo con el mismo puño oscuro remangado justo por debajo, exponiendo solo antebrazo/mano. Cinco ediciones con **imagegen integrado**, sin retoque por código:

| Fase | Propuesta corregida | Intentos / prompts exactos |
| --- | --- | --- |
| Extensión | [cruce_impulso_v7.png](cruce_impulso_v7.png) | [v4](cruce_impulso_v4.png) / [prompt v4](prompt_cruce_impulso_v4.txt): manga corregida, falta contraluz; [v5](cruce_impulso_v5.png) / [prompt v5](prompt_cruce_impulso_v5.txt): contraluz pero fondo parcialmente opaco; [v6](cruce_impulso_v6.png) / [prompt v6](prompt_cruce_impulso_v6.txt): alfa limpio pero demasiado clara; [prompt v7](prompt_cruce_impulso_v7.txt): paleta corregida. |
| Impulso | [impulso_v2.png](impulso_v2.png) | [prompt v2](prompt_impulso_v2.txt): manga adelantada larga remangada. |

Entradas: extensión v4 desde v3 y master aprobado; impulso v2 desde impulso v1 y master. Extensión v5 desde v4/v3 e impulso v2; v6 desde v5; v7 desde master, v6 y v3. PNG íntegros 1536 × 1024 con alfa; v5 conserva el fallo de transparencia como intento descartado. Versiones y prompts anteriores intactos. [Recorte del autor, antes/después y comprobaciones](../../../revisiones/marcha_mangas_v1/README.md).

La versión `cruce_impulso_v7` es un intento de extensión, no el reposo aprobado: este continúa siendo `perfiles_pixel_v7.png`. Las mangas nuevas se seleccionan solo para comparar; todavía no hay aprobación del autor ni prueba animada de continuidad tonal/dibujo.

## Segundo medio paso derecho · entrega anterior

El autor autoriza continuar. [Cuatro poses de la pierna contraria, todos sus intentos y prompts](segundo_paso.md): contacto B v4, apoyo B v2, cruce B v6 e impulso B v4. Dibujos propios siempre de perfil derecho, con mangas/bolsillo/deck conservados, sin reflejar el primer paso. [Comparación nativa con v7 real y fases A/B](../../../revisiones/marcha_segundo_paso_v1/README.md). Recursos y modos anteriores intactos.

Propuesta de **once posturas distintas del perfil derecho**, pendiente de valoración del autor. Objetivo inicial del asistente: 16 dibujos por ciclo completo y perfil, ajustable tras probarlo. Faltan cinco intermedios/transiciones, perfil izquierdo propio y cerrar coherencia de dibujo/paleta/proporciones, pivotes y apoyos; no hay ciclo natural demostrado ni marcha integrada. PNG, prompts y modelos anteriores conservados; archivos de esta corrección no están en los assets del juego. Oscuridad cercana no demuestra continuidad perfecta de anatomía/equipo.

## Cinco enlaces · entrega actual para revisión

[Originales, 12 intentos y prompts exactos](transiciones.md). Se añaden llegada B, carga B, despegue B, extensión B y llegada A: **16 propuestas distintas del perfil derecho**, ordenadas en [cuatro láminas Godot con medidas y alertas](../../../revisiones/marcha_ciclo_derecho_v1/README.md). Mangas bajo el codo y bolsillo único revisados; versiones previas intactas. Llegada B v3 sigue fuera del margen tonal (+15,98 %, límite +15 %); v4 descartada. Nueva revisión devuelve código 1, no supera el control tonal. Antes de integrar: corregir continuidad y probar bucle derecho aislado con pivotes/apoyos/cierre/ritmo; después perfil izquierdo propio. Recorrido/Web conservan v7; sin aprobación nueva.

## Integración posterior · movimiento v3 vigente

[Perfil izquierdo, transiciones y fuentes seleccionadas](../movimiento_v3/README.md); [pruebas/capturas/demo](../../../revisiones/movimiento_completo_v1/README.md). Llegada B derecha v5/v7 empeoran paleta y se conservan como descartadas; v6 parte de contacto B v4 pero roza límite, v8 edita solo su bota desde contacto B v4 y pasa el margen. Se conservan PNG/prompt_impulso_a_contacto_b_v5.txt a v8.txt. V8 sustituye el candidato v3 en producción; láminas/alerta previas se conservan sin sobrescribir. Recorrido ahora tiene 16 fases por perfil y transiciones; ya no solo v7 deslizándose. Entrega funcional del asistente, sin aprobación artística nueva.
