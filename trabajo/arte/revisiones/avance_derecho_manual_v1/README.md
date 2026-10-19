# Sota · prueba manual aislada de la cuarta clave

15 de octubre de 2026. El autor autoriza redibujar la fase 24. Se parte de la [cuarta copia con manos y hueco corregidos](../manos_sota_v1/clave_3_manos_prueba_v2.png) y se inspecciona el fotograma 24 de los [atlas v4](fase24_atlas_v4_4x.png) y [v5](fase24_atlas_v5_4x.png). Ambos acercan las punteras v4, pero pertenecen a los modelos rechazados por piernas y pelvis finas.

[`probar_union.gd`](probar_union.gd) ensaya cuatro cortes a las filas 220, 230, 240 y 250; conserva la parte superior aprobada y toma solo la zona inferior del atlas v5. Los cortes altos conservan mejor las botas pero vuelven a estrechar la pantorrilla; los bajos producen una costura visible. [Una prueba de volumen](union_pintada_4x.png) conserva el borde cercano del pantalón hasta la espinilla. [Comparación con las otras tres claves a 1×](comparacion_1x.png) · [objetivos de punteras a 4×](union_pintada_objetivos_4x.png).

La prueba de volumen tampoco supera la revisión: la pierna cercana termina en un bulto sobre la bota, la puntera elevada queda confundida con la bota plantada y la silueta inferior recupera la estrechez v5. [Un ensayo de elevar la bota](union_bota_elevada_4x.png) introduce un corte en la espinilla y más solapamiento; se descarta. El script comprueba marco 256 × 320, alfa binaria y parte superior idéntica a la copia aprobada hasta la fila 219. **Estas imágenes son diagnósticos rechazados por el asistente, no una cuarta clave terminada ni aprobada por el autor.**

La [guía principal](../avance_derecho_v1/README.md) sigue siendo el plano de trabajo: pie cercano con un solo bolsillo elevado, puntera a la derecha `(128,280)`; pie lejano liso plantado, puntera a la derecha `(152,298)`. Hay que dibujar los volúmenes continuos desde la pelvis hasta ambas botas directamente en 256 × 320 y revisar a 1× y 4×. Copiar las botas v5 o desplazar una suela reproduce la misma falta de anatomía que el autor rechazó.

PNG v7, claves anteriores, atlas activos, controlador y exportación Web intactos. No se construyen intermedios ni ciclo completo.
