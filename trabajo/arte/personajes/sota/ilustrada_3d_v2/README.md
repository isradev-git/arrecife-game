# Sota 3D v2 · colocación del cyberdeck

19 de octubre de 2026. Corrección solicitada por el autor: el aparato tapaba la mano durante la marcha.

## Cambio

Carcasa de 8,5 a 5,5 cm de grosor, ceñida a la zona posterior derecha de la cintura. Su centro pasa de `(−0,23; 0,015; 1,035)` a `(−0,13; 0,14; 1,055)` en coordenadas Blender, en metros. Marco e indicador acompañan la colocación. El equipo sigue vinculado a pelvis y en su lado físico derecho; no se refleja al girar.

La posición anterior invadía el recorrido de la mano/antebrazo. Adelgazar sin retrasar y ceñir el conjunto no lo resolvía. Las pruebas intermedias quedan en `intento_01/` e `intento_02/`; no son el modelo activo.

Sólo cambian las tres piezas del aparato. Comparación de datos glTF: las otras 23 mallas conservan vértices, normales, índices, huesos y pesos idénticos. 26 mallas, 13908 vértices ponderados, 65 huesos. Animaciones y controlador sin cambios por esta corrección.

## Fuente y uso

`crear_sota.py` abre la [fuente v1](../ilustrada_3d_v1/sota.blend) y ajusta únicamente estas tres mallas; no regenera el personaje completo. `sota.blend` es la nueva fuente editable. [GLB activo](../../../../../godot_ilustrado/assets/sota_3d_v2/sota.glb), cargado desde `godot_ilustrado/cuerpo.gd`. La v1 queda íntegra y recuperable.

Reproducir con Blender 4.5.3 LTS: `blender --background --factory-startup --python trabajo/arte/personajes/sota/ilustrada_3d_v2/crear_sota.py`. Sobrescribe sólo las salidas v2; conservar una versión nueva antes de otra revisión.

[Evidencias y pruebas](../../../revisiones/sota_equipo_3d_v2/README.md). La corrección técnica no aprueba el acabado artístico del personaje: siguen pendientes cara, pelo, ropa y materiales.
