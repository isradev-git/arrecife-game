# Sota · nuevo intento aislado de la cuarta clave

15 de octubre de 2026. Tras aprobar las manos y el cierre del hueco, el autor autoriza continuar con el apoyo de la cuarta postura. Se hicieron tres ediciones de imagen, conservadas como **referencias artísticas rechazadas**, no como sprites jugables. Los [prompts exactos en inglés](prompts.md) acompañan a cada intento.

| Referencia | Resultado |
| --- | --- |
| [Intento 1](referencia_ia_intento1_piernas_invertidas.png) | Conserva volumen, pero apoya la pierna con bolsillo y levanta la pierna lisa: invierte la cinemática v4. |
| [Intento 2](referencia_ia_intento2_apoyos_correctos.png) | Asigna el apoyo a la pierna lisa, pero la bota elevada de la pierna con bolsillo apunta a la izquierda. No respeta ambas punteras. |
| [Intento 3](referencia_ia_intento3_bota_invertida.png) | Se pide corregir solo esa bota; sigue apuntando a la izquierda y pierde parte del contraluz. |

Las tres referencias son PNG de 1122 × 1402, con una figura aproximadamente cuatro veces mayor que la cuadrícula lógica. La escala grande oculta el problema: al reducirlas con `nearest` a 256 × 320, habría que comprimir o desplazar las piernas de forma distinta para llevar la puntera elevada a `(128,280)` y la plantada a `(152,298)`. Eso deformaría pelvis, muslos o botas. **No se hizo ese collage ni se creó una cuarta clave v3.**

Para el redibujo manual: partir de la [cuarta copia con manos aprobadas y hueco corregido](../manos_sota_v1/clave_3_manos_prueba_v2.png) y la [guía de punteras a 4×](../avance_derecho_v1/guia_fase24_hueco_corregido_4x.png). Mantener arriba cabeza, chaqueta, equipo y manos; redibujar desde pelvis hasta suelo a 256 × 320. La pierna cercana con **un solo bolsillo** se eleva y termina en puntera **hacia la derecha** `(128,280)`; la lejana lisa soporta el peso y termina, también hacia la derecha, en `(152,298)`. Reconstruir la pelvis y los dos volúmenes de muslo, rodilla, pantorrilla y bota, sin desplazar solo la suela. Usar colores de v7/contacto, alfa 0/255 y comprobar a 1× y 4×. Antes de integrar, revisar bolsillo, manos, continuidad con las otras tres claves y apoyos en juego.

Ningún recurso activo de Godot, atlas, controlador ni sprite aprobado se ha modificado. Esta entrega documenta un límite artístico real: la edición generativa no resolvió a la vez asignación de piernas, dirección de las dos botas y medidas v4; declarar una de estas láminas como sprite acabado repetiría el fallo rechazado.
