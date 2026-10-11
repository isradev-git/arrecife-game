# Velvet · Sota solo de perfil

**Revisión histórica:** se conserva esta entrega; la comparación actual con el primer pase pixel art está en [escala_v3](../escala_v3/README.md), todavía pendiente de valoración del autor.

10 de octubre de 2026. El autor aprueba cómo queda Sota en escena y decide que solo se verá de perfil. Descarta frontal y tres cuartos: reposo, conversación, respiración y cambios de dirección deberán mantener perfil derecho o izquierdo.

**Nueva dirección posterior:** el autor solicita un acabado más pixel art, cercano a REPLACED. Estas capturas conservan la iteración aprobada anterior; no acreditan la renovación, que sigue pendiente en T02/T03. Escala, retícula y filtrado se revisarán con recursos nuevos según la [dirección vigente](../../../direccion_artistica.md).

## Aplicado

La revisión Godot carga únicamente las dos primeras vistas del atlas (perfil derecho e izquierdo) y ofrece solo esos botones. Se conservan escala 252, apoyos, encuadre y controles de comparación de la entrega aceptada. El PNG y el JSON originales no se modifican; sus otras vistas quedan como historial, sin uso en esta escena. El prototipo JavaScript conserva su comportamiento anterior como referencia histórica de migración.

Capturas del render nativo Godot:

- [Perfil derecho](perfil_0.png).
- [Perfil izquierdo](perfil_1.png).

Comprobación `godot/tests/escala.gd`: pasa con dos perfiles, tres alturas, apoyo estable, recortes en la mitad superior del atlas y sin reflejo horizontal. La exportación Web regenerada termina con código 0. Las capturas muestran que han desaparecido los controles frontal y tres cuartos.

Las [capturas de la revisión anterior](../escala_v1/README.md), hojas y prompts se conservan sin sobrescribir. [Dirección artística vigente](../../../direccion_artistica.md); [tareas](../../../../task.md).

Pendiente: nuevo acabado pixel art en T02/T03, respiración y animaciones de T06 y comprobación visual en navegador. No se implementa respiración en esta corrección de dirección; la escena sigue siendo estática. La aprobación del autor corresponde al aspecto en escena y la elección de perfiles, no a animaciones aún inexistentes.
