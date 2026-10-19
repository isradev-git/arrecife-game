"""Corrección de piel ligeramente morena; conserva la geometría de v5."""
import bpy, math
from pathlib import Path

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[4]
bpy.ops.wm.open_mainfile(filepath=str(HERE.parent/'ilustrada_3d_v5/sota.blend'))
body=bpy.data.objects['Superhero_Female']
before=[tuple(v.co) for v in body.data.vertices]
skin=body.data.materials[0]
rgb=[int('c8a17e'[i:i+2],16)/255 for i in (0,2,4)]
tone=[v/12.92 if v<=.04045 else ((v+.055)/1.055)**2.4 for v in rgb]
# Material uniforme: evita la interpretación oscura del color de vértices en Compatibility.
for layer in list(body.data.color_attributes):body.data.color_attributes.remove(layer)
for node in list(skin.node_tree.nodes):
    if node.type=='VERTEX_COLOR':skin.node_tree.nodes.remove(node)
skin.diffuse_color=(*tone,1)
skin.node_tree.nodes.get('Principled BSDF').inputs['Base Color'].default_value=(*tone,1)
assert before==[tuple(v.co) for v in body.data.vertices]
assert all(math.isfinite(c) for c in skin.diffuse_color)
rig=bpy.data.objects['Armature']
bpy.ops.object.select_all(action='DESELECT')
for o in bpy.context.scene.objects:
    if o==rig or (o.type=='MESH' and o.parent==rig):o.select_set(True)
bpy.context.view_layer.objects.active=rig
bpy.ops.wm.save_as_mainfile(filepath=str(HERE/'sota.blend'))
bpy.ops.export_scene.gltf(filepath=str(ROOT/'godot_ilustrado/assets/sota_3d_v6/sota.glb'),export_format='GLB',use_selection=True,export_animations=False,export_skins=True,export_morph=False)
print('Piel v6: material cálido ligeramente moreno, sin color de vértices; geometría intacta.')
