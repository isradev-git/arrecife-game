# Sota 3D v7 · revisión alrededor del cuerpo

19 de octubre de 2026. Candidata para la demo de Velvet, sobre v6. No equivale a aprobación artística del autor ni a un modelo final certificado.

`crear_sota.py` abre la fuente v6 y produce `sota.blend` y `godot_ilustrado/assets/sota_3d_v7/sota.glb`. Se ejecuta con Blender 4.5.3 en segundo plano. Conserva piel cálida ligeramente morena, rostro y cabello de la referencia elegida, materiales de v5, huesos, clips, botas y control.

Correcciones:

- Cintura del pantalón prolongada hasta solaparse con la prenda interior. Los pesos superiores pasan progresivamente a pelvis; la cintura deja de abrirse al flexionar las caderas.
- Arnés ceñido a la superficie del hombro, conservando el anclaje original al deck.
- Canesú, costadillos, bajo y pespuntes traseros de chaqueta. Bolsillos posteriores y costuras laterales del pantalón.
- Cuello y puños con el cuero texturizado de la chaqueta; remaches unidos a los pesos de la prenda.
- Transferencia baricéntrica de pesos para las nuevas piezas, máximo cuatro influencias normalizadas.

Las aserciones del generador comprueban geometría finita, rig idéntico y apoyo original de botas intacto. El proyecto añade inspección interactiva `sota_360.tscn`, con giro, elevación, zoom, reposo y marcha. El estudio de ocho ángulos y los detalles se guardan en `trabajo/arte/revisiones/demo_velvet_3d_v1/`.

La revisión de 360° permite detectar defectos; no demuestra por sí sola ausencia absoluta de intersecciones en futuras poses. No se ha producido una animación nueva de conversación ni expresiones faciales. V1–v6 se conservan.

Los adornos compatibles se agrupan por materiales conservando vértices y pesos: resultado final de 32 mallas, 56.336 vértices ponderados y 65 huesos. Las piezas de apoyo y equipo verificadas permanecen identificables. El ensayo anterior a la agrupación se conserva en `revisiones/demo_velvet_3d_v1/ensayo_02/`.
