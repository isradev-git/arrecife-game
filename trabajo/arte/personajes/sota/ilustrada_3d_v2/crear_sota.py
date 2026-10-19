"""Corregir sólo el equipo de Sota; conservar mallas, pesos y rig del estudio v1."""
import bpy
from pathlib import Path
HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
bpy.ops.wm.open_mainfile(filepath=str(HERE.parent / 'ilustrada_3d_v1/sota.blend'))
# Ceñir la carcasa y llevar el conjunto a la zona posterior derecha de la cintura.
for v in bpy.data.objects['Cyberdeck'].data.vertices:
    v.co.x = -.13 + (v.co.x + .23) * (.055 / .085)
    v.co.y += .125
    v.co.z += .02
for nombre in ['Marco cyberdeck', 'Indicador cyberdeck']:
    for v in bpy.data.objects[nombre].data.vertices:
        v.co.x += .115
        v.co.y += .125
        v.co.z += .02
bpy.ops.wm.save_as_mainfile(filepath=str(HERE / 'sota.blend'))
bpy.ops.export_scene.gltf(
    filepath=str(ROOT / 'godot_ilustrado/assets/sota_3d_v2/sota.glb'),
    export_format='GLB', use_selection=True, export_animations=False,
    export_skins=True, export_morph=False,
)
print('Sota v2: corregidas únicamente las tres piezas del equipo.')
