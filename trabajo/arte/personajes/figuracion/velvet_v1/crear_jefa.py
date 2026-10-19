"""Estudio provisional de la jefa para la demo; retrato original como referencia."""
import bpy
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[4]
bpy.ops.wm.open_mainfile(filepath=str(ROOT/'trabajo/arte/personajes/sota/ilustrada_3d_v6/sota.blend'))
rig=bpy.data.objects['Armature']
for o in list(bpy.data.objects):
 if o.type=='MESH' and o.parent==rig:
  if any(s in o.name.lower() for s in ['deck','correa','arnes','mechon gris','marca mejilla','lunar','parche','ranura']):bpy.data.objects.remove(o,do_unlink=True)
# Chaqueta violeta de trabajo; mapa propio duplicado, sin alterar los mapas de Sota.
m=bpy.data.materials['Cuero chaqueta']
for node in m.node_tree.nodes:
 if node.type=='TEX_IMAGE' and 'color' in node.image.name:
  import numpy as np
  old=node.image; im=old.copy(); im.name='Cuero granate jefa'
  pixels=np.empty(len(im.pixels),dtype=np.float32); im.pixels.foreach_get(pixels)
  pixels=pixels.reshape(-1,4); gray=pixels[:,:3].mean(axis=1)
  pixels[:,:3]=gray[:,None]*np.array([.80,.42,.58])
  im.pixels.foreach_set(pixels.ravel()); im.pack(); node.image=im
for name in ['Pelo corto','Mechones oscuros']:
 if name in bpy.data.objects:
  o=bpy.data.objects[name]
  for v in o.data.vertices:
   v.co.x*=1.08
   if v.co.z<1.7:v.co.z-=.04*(1.7-v.co.z)/.16
# Suprimir la abertura del flequillo gris con el cabello oscuro del mismo volumen.
for name in ['Carbon pelo v4','Planos pelo v4','Pelo carbon']:
 m=bpy.data.materials.get(name)
 if m and m.use_nodes:
  p=m.node_tree.nodes.get('Principled BSDF'); p.inputs['Base Color'].default_value=(.012,.009,.014,1)
# Recogido posterior y herrajes dorados del retrato. Modelo secundario aún provisional.
bpy.ops.mesh.primitive_uv_sphere_add(segments=24,ring_count=12,radius=1,location=(0,.15,1.72))
bun=bpy.context.object; bun.name='Recogido jefa'; bun.scale=(.082,.058,.073)
bpy.ops.object.transform_apply(location=True,rotation=True,scale=True)
bun.parent=rig; bun.data.materials.append(bpy.data.materials['Carbon pelo v4'])
bun.vertex_groups.new(name='Head').add(list(range(len(bun.data.vertices))),1,'REPLACE')
mod=bun.modifiers.new('Cabeza','ARMATURE'); mod.object=rig
for f in bun.data.polygons:f.use_smooth=True
for o in list(bpy.context.scene.objects):
 if o.type=='MESH' and any(t in o.name.lower() for t in ['implante','mandibula','cuello retrato','sien retrato']):
  for v in o.data.vertices:v.co.x=-v.co.x
for name in ['Acero v4','Acero cepillado','Circuito ambar v4','Ambar apagado']:
 m=bpy.data.materials.get(name)
 if m and m.use_nodes:
  p=m.node_tree.nodes.get('Principled BSDF'); p.inputs['Base Color'].default_value=(.45,.31,.13,1); p.inputs['Metallic'].default_value=.6
objects=[o for o in bpy.context.scene.objects if o.type=='MESH' and o.parent==rig]
for o in objects:
 bpy.context.view_layer.objects.active=o
 for mod in list(o.modifiers):
  if mod.type!='ARMATURE':bpy.ops.object.modifier_apply(modifier=mod.name)
bpy.ops.object.select_all(action='DESELECT')
for o in objects:o.select_set(True)
bpy.context.view_layer.objects.active=objects[0]; bpy.ops.object.join(); objects[0].name='Jefa estudio'
bpy.ops.object.select_all(action='DESELECT')
for o in bpy.context.scene.objects:
 if o==rig or (o.type=='MESH' and o.parent==rig):o.select_set(True)
bpy.context.view_layer.objects.active=rig
bpy.ops.wm.save_as_mainfile(filepath=str(HERE/'jefa_estudio.blend'))
bpy.ops.export_scene.gltf(filepath=str(ROOT/'godot_ilustrado/assets/velvet_3d_v1/jefa_estudio.glb'),export_format='GLB',use_selection=True,export_animations=False,export_skins=True,export_morph=False)
