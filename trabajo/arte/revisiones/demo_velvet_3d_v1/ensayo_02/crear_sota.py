"""Acabado 360: confección de espalda, cintura, bolsillos y herrajes. Base v6 intacta."""
import bpy, math
from pathlib import Path
from mathutils import Vector
from mathutils.bvhtree import BVHTree
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[4]
bpy.ops.wm.open_mainfile(filepath=str(HERE.parent/'ilustrada_3d_v6/sota.blend'))
rig=bpy.data.objects['Armature']
original_rig=[(b.name,tuple(tuple(r) for r in b.matrix_local)) for b in rig.data.bones]
boots=bpy.data.objects['Botas completas']
original_boots=[tuple(v.co) for v in boots.data.vertices]

def mat(name,hexcolor,metal=0,rough=.8):
 m=bpy.data.materials.new(name); m.use_nodes=True
 c=[int(hexcolor[i:i+2],16)/255 for i in (0,2,4)]
 c=[v/12.92 if v<=.04045 else ((v+.055)/1.055)**2.4 for v in c]
 m.diffuse_color=(*c,1); p=m.node_tree.nodes.get('Principled BSDF')
 p.inputs['Base Color'].default_value=(*c,1); p.inputs['Metallic'].default_value=metal; p.inputs['Roughness'].default_value=rough
 return m
thread=mat('Pespunte encerado v7','8d6950',rough=.94)
edge=mat('Union panel cuero v7','442c25')
metal=mat('Herrajes cepillados v7','8e928c',.72,.42)
pants=bpy.data.objects['Pantalon']
# La cintura de la prenda debe seguir la pelvis y solaparse con camiseta/cinturón.
for v in pants.data.vertices:
 if v.co.z>.94:
  f=min(1,(v.co.z-.94)/.07)
  v.co.z+=.047*f
  old=[(g.group,g.weight) for g in v.groups]
  for idx,w in old:pants.vertex_groups[idx].add([v.index],w*(1-f),'REPLACE')
  group=pants.vertex_groups.get('pelvis') or pants.vertex_groups.new(name='pelvis')
  base=next((w for idx,w in old if pants.vertex_groups[idx].name=='pelvis'),0)
  group.add([v.index],base*(1-f)+f,'REPLACE')
belt=bpy.data.objects['Cinturon']
for v in belt.data.vertices:v.co.z=1.024+(v.co.z-1.01)*1.28

cache={}
def surface(o):
 if o.name not in cache:
  o.data.calc_loop_triangles(); tris=[tuple(t.vertices) for t in o.data.loop_triangles]
  pts=[v.co.copy() for v in o.data.vertices]
  weights=[{o.vertex_groups[g.group].name:g.weight for g in v.groups} for v in o.data.vertices]
  cache[o.name]=(BVHTree.FromPolygons(pts,tris,all_triangles=True),pts,tris,weights)
 return cache[o.name]
def project(o,p,offset=.002):
 hit,n,idx,d=surface(o)[0].find_nearest(Vector(p)); return hit+n*offset

def mesh(name,pts,faces,material,source):
 data=bpy.data.meshes.new(name); data.from_pydata(pts,[],faces); data.update()
 obj=bpy.data.objects.new(name,data); bpy.context.collection.objects.link(obj); obj.parent=rig
 data.materials.append(material)
 groups={b.name:obj.vertex_groups.new(name=b.name) for b in rig.data.bones}
 bvh,points,tris,weights=surface(source)
 for v in data.vertices:
  hit,n,idx,d=bvh.find_nearest(v.co); ids=tris[idx]; a,b,c=[points[k] for k in ids]
  u=b-a; w=c-a; q=hit-a; den=u.dot(u)*w.dot(w)-u.dot(w)**2
  if abs(den)<1e-16: fs=[1,0,0]
  else:
   t=(w.dot(w)*q.dot(u)-u.dot(w)*q.dot(w))/den
   s=(u.dot(u)*q.dot(w)-u.dot(w)*q.dot(u))/den
   fs=[max(0,1-t-s),max(0,t),max(0,s)]
  values={}
  for k,f in zip(ids,fs):
   for name,weight in weights[k].items():values[name]=values.get(name,0)+weight*f
  values=sorted(values.items(),key=lambda p:-p[1])[:4]; total=sum(v for _,v in values)
  assert total>0
  for name,weight in values:groups[name].add([v.index],weight/total,'REPLACE')
 for p in data.polygons:p.use_smooth=True
 mod=obj.modifiers.new('Confeccion articulada','ARMATURE'); mod.object=rig
 # UV para el mismo cuero/sarga que la prenda base.
 bpy.ops.object.select_all(action='DESELECT'); obj.select_set(True); bpy.context.view_layer.objects.active=obj
 bpy.ops.object.mode_set(mode='EDIT'); bpy.ops.mesh.select_all(action='SELECT'); bpy.ops.uv.smart_project(island_margin=.02); bpy.ops.object.mode_set(mode='OBJECT')
 return obj

def line(name,controls,radius,material,source,offset=.002):
 pts=[]
 for a,b in zip(controls,controls[1:]):
  for j in range(8):pts.append(project(source,Vector(a).lerp(Vector(b),j/8),offset))
 pts.append(project(source,controls[-1],offset)); verts=[]; sides=6
 for i,p in enumerate(pts):
  axis=(pts[min(len(pts)-1,i+1)]-pts[max(0,i-1)]).normalized()
  tangent=axis.cross(Vector((0,1,0)))
  if tangent.length<.01:tangent=axis.cross(Vector((1,0,0)))
  tangent.normalize(); cross=axis.cross(tangent).normalized()
  for k in range(sides):verts.append(p+radius*(tangent*math.cos(k*math.tau/sides)+cross*math.sin(k*math.tau/sides)))
 faces=[(i*sides+k,i*sides+(k+1)%sides,(i+1)*sides+(k+1)%sides,(i+1)*sides+k) for i in range(len(pts)-1) for k in range(sides)]
 return mesh(name,verts,faces,material,source)
coat=bpy.data.objects['Chaqueta']
# Ceñir el borde del arnés al hombro; conservar el anclaje rígido de pelvis.
strap=bpy.data.objects['Correa diagonal']
for v in strap.data.vertices:
 if v.co.z>1.39:v.co=project(coat,v.co,.004)
# Canesú, costadillos y bajo: la espalda también tiene construcción de prenda.
line('Canesu espalda', [(-.19,.13,1.4),(-.1,.15,1.375),(0,.16,1.37),(.1,.15,1.375),(.19,.13,1.4)],.0018,edge,coat)
line('Doble pespunte espalda',[(-.19,.13,1.392),(-.1,.15,1.367),(0,.16,1.362),(.1,.15,1.367),(.19,.13,1.392)],.0008,thread,coat)
for side in [-1,1]:
 line('Costadillo espalda '+str(side),[(side*.105,.14,1.37),(side*.085,.14,1.26),(side*.10,.14,1.1),(side*.13,.13,1.05)],.0012,edge,coat)
 line('Pespunte lateral '+str(side),[(side*.16,.04,1.35),(side*.16,.04,1.18),(side*.16,.04,1.055)],.0011,thread,coat)
 # Bolsillo trasero con tapa que sigue la superficie de los pantalones.
 controls=[(side*.04,.20,.945),(side*.135,.20,.945),(side*.139,.20,.865),(side*.045,.20,.85)]
 pts=[project(pants,p,.003) for p in controls]
 mesh('Bolsillo trasero '+str(side),pts,[(0,1,2,3)],bpy.data.materials['Sarga cargo'],pants)
 line('Costura bolsillo trasero '+str(side),controls+[controls[0]],.0011,thread,pants,.004)
 line('Tapa trasera '+str(side),controls[:2],.002,edge,pants,.005)
 line('Costura exterior cargo '+str(side),[(side*.2,.07,.88),(side*.205,.055,.7),(side*.17,.065,.5),(side*.14,.07,.3)],.001,thread,pants)
line('Costura bajo posterior',[(-.15,.10,1.055),(-.08,.15,1.055),(0,.16,1.055),(.08,.15,1.055),(.15,.10,1.055)],.0013,edge,coat)
# Las superficies de cuello y puños reciben el mismo cuero, con UV explícitas.
for name in ['Cuello alto','Puno l','Puno r']:
 o=bpy.data.objects[name]; o.data.materials.clear(); o.data.materials.append(bpy.data.materials['Cuero chaqueta'])
 for p in o.data.polygons:p.material_index=0
 for layer in list(o.data.color_attributes):o.data.color_attributes.remove(layer)
 bpy.ops.object.select_all(action='DESELECT'); o.select_set(True); bpy.context.view_layer.objects.active=o
 bpy.ops.object.mode_set(mode='EDIT'); bpy.ops.mesh.select_all(action='SELECT'); bpy.ops.uv.smart_project(island_margin=.02); bpy.ops.object.mode_set(mode='OBJECT')
# Pequeños broches del cuello y remaches de bolsillo, unidos a la prenda.
for side in [-1,1]:
 for p in [(side*.065,-.075,1.485),(side*.11,-.14,1.12)]:
  center=project(coat,p,.004)
  bpy.ops.mesh.primitive_uv_sphere_add(segments=12,ring_count=6,radius=.004,location=center)
  temp=bpy.context.object
  pts=[temp.matrix_world@v.co for v in temp.data.vertices]; faces=[tuple(p.vertices) for p in temp.data.polygons]
  bpy.data.objects.remove(temp,do_unlink=True)
  mesh('Remache prenda',pts,faces,metal,coat)
assert original_boots==[tuple(v.co) for v in boots.data.vertices]
assert original_rig==[(b.name,tuple(tuple(r) for r in b.matrix_local)) for b in rig.data.bones]
for o in bpy.context.scene.objects:
 if o.type=='MESH' and o.parent==rig:assert all(math.isfinite(c) for v in o.data.vertices for c in v.co)
bpy.ops.object.select_all(action='DESELECT')
for o in bpy.context.scene.objects:
 if o==rig or (o.type=='MESH' and o.parent==rig):o.select_set(True)
bpy.context.view_layer.objects.active=rig
bpy.ops.wm.save_as_mainfile(filepath=str(HERE/'sota.blend'))
bpy.ops.export_scene.gltf(filepath=str(ROOT/'godot_ilustrado/assets/sota_3d_v7/sota.glb'),export_format='GLB',use_selection=True,export_animations=False,export_skins=True,export_morph=False)
print('V7: cintura y confección 360; huesos y apoyo de botas idénticos a v6.')
