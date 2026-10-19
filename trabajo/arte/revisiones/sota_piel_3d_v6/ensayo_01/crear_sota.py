"""Corrección de piel ligeramente morena; conserva la geometría de v5."""
import bpy, math
from pathlib import Path

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[4]
bpy.ops.wm.open_mainfile(filepath=str(HERE.parent/'ilustrada_3d_v5/sota.blend'))
body=bpy.data.objects['Superhero_Female']
before=[tuple(v.co) for v in body.data.vertices]
skin=body.data.materials[0]
old=tuple(skin.diffuse_color)
rgb=[int('c8a17e'[i:i+2],16)/255 for i in (0,2,4)]
tone=[v/12.92 if v<=.04045 else ((v+.055)/1.055)**2.4 for v in rgb]
colors=body.data.color_attributes['Piel']
for p in body.data.polygons:
    if p.material_index!=0: continue
    for i in p.loop_indices:
        factor=max(.5,min(1,colors.data[i].color[0]/old[0]))
        colors.data[i].color=tuple(c*factor for c in tone)+(1,)
# El color estaba aplicado dos veces: factor del material por color de vértice.
skin.diffuse_color=(1,1,1,1)
skin.node_tree.nodes.get('Principled BSDF').inputs['Base Color'].default_value=(1,1,1,1)
assert before==[tuple(v.co) for v in body.data.vertices]
assert all(math.isfinite(c) for item in colors.data for c in item.color)
rig=bpy.data.objects['Armature']
bpy.ops.object.select_all(action='DESELECT')
for o in bpy.context.scene.objects:
    if o==rig or (o.type=='MESH' and o.parent==rig):o.select_set(True)
bpy.context.view_layer.objects.active=rig
bpy.ops.wm.save_as_mainfile(filepath=str(HERE/'sota.blend'))
bpy.ops.export_scene.gltf(filepath=str(ROOT/'godot_ilustrado/assets/sota_3d_v6/sota.glb'),export_format='GLB',use_selection=True,export_animations=False,export_skins=True,export_morph=False)
print('Piel v6: tono cálido ligeramente moreno, aplicado una sola vez; geometría intacta.')
