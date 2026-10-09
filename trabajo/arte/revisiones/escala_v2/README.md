# Velvet · Sota solo de perfil

10 de octubre de 2026. El autor aprueba cómo queda Sota en escena y decide que solo se verá de perfil. Descarta frontal y tres cuartos: reposo, conversación, respiración y cambios de dirección deberán mantener perfil derecho o izquierdo.

## Aplicado

La revisión Godot carga únicamente las dos primeras vistas del atlas (perfil derecho e izquierdo) y ofrece solo esos botones. Se conservan escala 252, apoyos, encuadre y controles de comparación de la entrega aceptada. El PNG y el JSON originales no se modifican; sus otras vistas quedan como historial, sin uso en esta escena. El prototipo JavaScript conserva su comportamiento anterior como referencia histórica de migración.

Capturas del render nativo Godot:

- [Perfil derecho](perfil_0.png).
- [Perfil izquierdo](perfil_1.png).

Comprobación `godot/tests/escala.gd`: pasa con dos perfiles, tres alturas, apoyo estable, recortes en la mitad superior del atlas y sin reflejo horizontal. La exportación Web regenerada termina con código 0. Las capturas muestran que han desaparecido los controles frontal y tres cuartos.

Las [capturas de la revisión anterior](../escala_v1/README.md), hojas y prompts se conservan sin sobrescribir. [Dirección artística vigente](../../../direccion_artistica.md); [tareas](../../../../task.md).

Pendiente: respiración y animaciones de T06, acabado fino de bordes y comprobación visual en navegador. No se implementa respiración en esta corrección de dirección; la escena sigue siendo estática. La aprobación del autor corresponde al aspecto en escena y la elección de perfiles, no a animaciones aún inexistentes.
