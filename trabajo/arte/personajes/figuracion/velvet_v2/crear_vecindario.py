"""Jefa y tres vecinos: prendas, pelo e implantes propios sobre el rig humano existente.
No modifica Sota ni sus clips. Las propuestas se contrastan con el retrato original.
"""
import bpy, math, numpy as np, bmesh
from pathlib import Path
from mathutils import Vector
from mathutils.bvhtree import BVHTree
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[4]
OUT=ROOT/'godot_ilustrado/assets/velvet_3d_v2'
OUT.mkdir(exist_ok=True)

def material(name, color, metal=0, rough=.8):
    m = bpy.data.materials.new(name); m.use_nodes = True
    c = [int(color[i:i+2], 16)/255 for i in (0, 2, 4)]
    c = [v/12.92 if v <= .04045 else ((v+.055)/1.055)**2.4 for v in c]
    m.diffuse_color = (*c, 1)
    p = m.node_tree.nodes.get('Principled BSDF')
    p.inputs['Base Color'].default_value = m.diffuse_color
    p.inputs['Roughness'].default_value = rough
    p.inputs['Metallic'].default_value = metal
    return m

def surface_data(o):
    o.data.calc_loop_triangles()
    points = [v.co.copy() for v in o.data.vertices]
    triangles = [tuple(t.vertices) for t in o.data.loop_triangles]
    return BVHTree.FromPolygons(points, triangles, all_triangles=True), points, triangles

def bind(o, bone=None):
    o.parent = rig
    if bone:
        assert bone in rig.data.bones, bone
        o.vertex_groups.new(name=bone).add(list(range(len(o.data.vertices))), 1, 'REPLACE')
    else:
        groups = {b.name:o.vertex_groups.new(name=b.name) for b in rig.data.bones}
        for v in o.data.vertices:
            p, normal, index, distance = coat_bvh.find_nearest(v.co)
            ids = coat_triangles[index]; a,b,c = [coat_points[i] for i in ids]
            u=b-a; w=c-a; q=p-a
            denominator=u.dot(u)*w.dot(w)-u.dot(w)**2
            if abs(denominator)<1e-16: factors=[1,0,0]
            else:
                t=(w.dot(w)*q.dot(u)-u.dot(w)*q.dot(w))/denominator
                s=(u.dot(u)*q.dot(w)-u.dot(w)*q.dot(u))/denominator
                factors=[max(0,1-t-s),max(0,t),max(0,s)]
            values={}
            for i,f in zip(ids,factors):
                for n,weight in coat_weights[i].items(): values[n]=values.get(n,0)+f*weight
            items=sorted(values.items(),key=lambda x:-x[1])[:4]; total=sum(w for _,w in items)
            assert total>0
            for n,w in items: groups[n].add([v.index],w/total,'REPLACE')
    mod=o.modifiers.new('Deformacion','ARMATURE'); mod.object=rig

def mesh(name, points, faces, mat, bone=None):
    data=bpy.data.meshes.new(name); data.from_pydata(points,[],faces); data.update()
    o=bpy.data.objects.new(name,data); bpy.context.collection.objects.link(o)
    data.materials.append(mat)
    for p in data.polygons: p.use_smooth=True
    bind(o,bone)
    return o

def tube(name, points, radii, mat, bone=None, sides=8):
    vertices=[]
    for i,p in enumerate(points):
        p=Vector(p); tangent=(Vector(points[min(i+1,len(points)-1)])-Vector(points[max(i-1,0)])).normalized()
        a=tangent.cross(Vector((0,1,0)))
        if a.length<.01: a=tangent.cross(Vector((1,0,0)))
        a.normalize(); b=tangent.cross(a).normalized()
        radius=radii[i] if isinstance(radii,list) else radii
        for j in range(sides): vertices.append(p+radius*(a*math.cos(j*math.tau/sides)+b*math.sin(j*math.tau/sides)))
    faces=[(i*sides+j,i*sides+(j+1)%sides,(i+1)*sides+(j+1)%sides,(i+1)*sides+j) for i in range(len(points)-1) for j in range(sides)]
    faces.extend([tuple(reversed(range(sides))),tuple(range((len(points)-1)*sides,len(points)*sides))])
    return mesh(name,vertices,faces,mat,bone)

def lock(name,controls,widths,mat,depth=.006):
    points=[]; radii=[]
    for i in range(len(controls)-1):
        p0,p1,p2,p3=[Vector(controls[max(0,min(k,len(controls)-1))]) for k in [i-1,i,i+1,i+2]]
        for j in range(6):
            t=j/6
            points.append(.5*((2*p1)+(-p0+p2)*t+(2*p0-5*p1+4*p2-p3)*t*t+(-p0+3*p1-3*p2+p3)*t*t*t))
            radii.append(widths[i]*(1-t)+widths[i+1]*t)
    points.append(Vector(controls[-1])); radii.append(.0005)
    vs=[]; sides=12
    for i,p in enumerate(points):
        tangent=(points[min(i+1,len(points)-1)]-points[max(i-1,0)]).normalized()
        normal=Vector((p.x,(p.y-.025),max(.012,(p.z-1.7)*.7))).normalized()
        a=tangent.cross(normal).normalized(); b=a.cross(tangent).normalized()
        for j in range(sides):
            angle=j*math.tau/sides
            vs.append(p+a*math.cos(angle)*radii[i]+b*math.sin(angle)*min(depth,radii[i]*.45))
    fs=[(i*sides+j,i*sides+(j+1)%sides,(i+1)*sides+(j+1)%sides,(i+1)*sides+j) for i in range(len(points)-1) for j in range(sides)]
    fs.extend([tuple(reversed(range(sides))),tuple(range((len(points)-1)*sides,len(points)*sides))])
    return mesh(name,vs,fs,mat,'Head')

def quitar(criterio):
 for o in list(bpy.context.scene.objects):
  if o.type=='MESH' and o.parent==rig and criterio(o.name.lower()):bpy.data.objects.remove(o,do_unlink=True)

def esfera(nombre,centro,escala,mat,bone='Head'):
 bpy.ops.mesh.primitive_uv_sphere_add(segments=32,ring_count=16,location=centro)
 o=bpy.context.object; o.name=nombre; o.scale=escala
 bpy.ops.object.transform_apply(location=True,rotation=True,scale=True)
 o.data.materials.append(mat); bind(o,bone)
 for f in o.data.polygons:f.use_smooth=True
 return o

def textura_tinte(nombre,color):
 m=bpy.data.materials[nombre]
 for node in m.node_tree.nodes:
  if node.type=='TEX_IMAGE' and 'color' in node.image.name:
   im=node.image.copy(); im.name=nombre+' '+version
   pixels=np.empty(len(im.pixels),dtype=np.float32);im.pixels.foreach_get(pixels)
   pixels=pixels.reshape(-1,4); lum=pixels[:,:3].mean(axis=1)
   pixels[:,:3]=lum[:,None]*np.array(color)
   im.pixels.foreach_set(pixels.ravel());im.pack();node.image=im
 return m

def parche(nombre,puntos,mat,bone=None):
 o=mesh(nombre,puntos,[tuple(range(len(puntos)))],mat,bone)
 sol=o.modifiers.new('Espesor prenda','SOLIDIFY');sol.thickness=.003
 bev=o.modifiers.new('Cantos','BEVEL');bev.width=.0015;bev.segments=2
 return o

def peinado(recogido):
 # Casquete corto en la frente y amplio detrás: sin conservar el flequillo de Sota.
 vs=[];N=64;rows=12
 for r in range(rows):
  f=r/(rows-1)
  for j in range(N):
   a=j*math.tau/N; front=max(0,-math.sin(a))
   bottom=1.65+.075*front**3 if recogido else 1.68+.045*front**3
   vs.append((.107*math.cos(a)*math.sin(f*math.pi/2),.026+.119*math.sin(a)*math.sin(f*math.pi/2),1.803+(bottom-1.803)*f**1.7))
 fs=[(r*N+j,r*N+(j+1)%N,(r+1)*N+(j+1)%N,(r+1)*N+j) for r in range(rows-1) for j in range(N)]
 mesh('Cabello base',vs,fs,hair,'Head')
 if recogido:
  esfera('Recogido trenzado',(0,.132,1.7),(.087,.066,.095),hair)
  for side in [-1,1]:
   for i in range(6):
    f=i/5
    lock('Barrido recogido '+str(side)+' '+str(i),[(side*(.015+.055*f),-.075+.035*f,1.773+.02*(1-f)),(side*(.045+.058*f),-.012,1.812-.038*f),(side*(.04+.06*f),.09,1.78-.055*f),(side*.045,.17,1.715-.035*f)],[.012,.018,.018,.002],hairmid if i%4==0 else hair,.004)
   lock('Mechon rostro '+str(side),[(side*.035,-.073,1.785),(side*.079,-.087,1.725),(side*.095,-.061,1.63),(side*.082,-.06,1.52)],[.024,.029,.014,.001],hair,.004)
  lock('Flequillo lateral',[(-.018,-.071,1.799),(-.065,-.1,1.758),(-.09,-.094,1.689),(-.09,-.06,1.575)],[.02,.033,.022,.001],hair,.004)
 else:
  for i in range(9):
   x=(i-4)*.018
   lock('Cresta corta '+str(i),[(x,.09,1.76),(x,.02,1.82),(x,-.08,1.768)],[.009,.014,.001],hairmid,.004)

def atlas(obj):
 # Un material por vecino evita repetir el skinning por cada superficie pequeña.
 mats=list(obj.data.materials);grid=math.ceil(math.sqrt(len(mats)));tile=256;pad=4;size=grid*tile
 arrays={k:np.zeros((size,size,4),dtype=np.float32) for k in ['Color','Normal','Rugosidad','Metal']}
 def sample(image):
  pixels=np.empty(len(image.pixels),dtype=np.float32);image.pixels.foreach_get(pixels)
  pixels=pixels.reshape(image.size[1],image.size[0],4)
  yy=np.linspace(0,image.size[1]-1,tile-2*pad).astype(int);xx=np.linspace(0,image.size[0]-1,tile-2*pad).astype(int)
  return np.pad(pixels[yy[:,None],xx[None,:]],((pad,pad),(pad,pad),(0,0)),mode='edge')
 for i,m in enumerate(mats):
  p=m.node_tree.nodes.get('Principled BSDF')
  for kind,slot,default in [('Color','Base Color',None),('Normal','Normal',(.5,.5,1,1)),('Rugosidad','Roughness',None),('Metal','Metallic',None)]:
   value=p.inputs[slot].default_value if default is None else default
   if isinstance(value,(int,float)):value=(value,value,value,1)
   array=np.zeros((tile,tile,4),dtype=np.float32);array[:]=value
   if kind=='Color':array[:,:,:3]=np.where(array[:,:,:3]<=.0031308,array[:,:,:3]*12.92,1.055*np.power(array[:,:,:3],1/2.4)-.055)
   links=p.inputs[slot].links
   if links:
    node=links[0].from_node
    if node.type=='NORMAL_MAP' and node.inputs['Color'].links:node=node.inputs['Color'].links[0].from_node
    if node.type=='TEX_IMAGE':array=sample(node.image)
   x=(i%grid)*tile;y=(i//grid)*tile;arrays[kind][y:y+tile,x:x+tile]=array
 uv=obj.data.uv_layers.active.data
 for f in obj.data.polygons:
  i=f.material_index
  for loop in f.loop_indices:
   v=uv[loop].uv.copy();uv[loop].uv=((i%grid)*tile+pad+max(0,min(1,v.x))*(tile-2*pad))/size,((i//grid)*tile+pad+max(0,min(1,v.y))*(tile-2*pad))/size
  f.material_index=0
 m=bpy.data.materials.new('Vestuario atlas '+version);m.use_nodes=True;p=m.node_tree.nodes.get('Principled BSDF')
 for kind,array in arrays.items():
  im=bpy.data.images.new(version+' '+kind,width=size,height=size,alpha=True)
  im.colorspace_settings.name='sRGB' if kind=='Color' else 'Non-Color'
  im.pixels.foreach_set(array.ravel());im.pack()
  node=m.node_tree.nodes.new('ShaderNodeTexImage');node.image=im
  if kind=='Normal':
   normal=m.node_tree.nodes.new('ShaderNodeNormalMap');m.node_tree.links.new(node.outputs['Color'],normal.inputs['Color']);m.node_tree.links.new(normal.outputs['Normal'],p.inputs['Normal'])
  else:m.node_tree.links.new(node.outputs['Color'],p.inputs[{'Color':'Base Color','Rugosidad':'Roughness','Metal':'Metallic'}[kind]])
 obj.data.materials.clear();obj.data.materials.append(m)

for version in (['jefa'] if '--jefa' in __import__('sys').argv else ['jefa','vecina_tecnica','vecino_visor','vecina_brazo']):
 bpy.ops.wm.open_mainfile(filepath=str(ROOT/'trabajo/arte/personajes/sota/ilustrada_3d_v6/sota.blend'))
 rig=bpy.data.objects['Armature']; coat=bpy.data.objects['Chaqueta'];body=bpy.data.objects['Superhero_Female']
 original=[(b.name,tuple(tuple(row) for row in b.matrix_local)) for b in rig.data.bones]
 quitar(lambda n:any(t in n for t in ['deck','correa','arnes','mechon','pelo corto','marca mejilla','lunar','parche','implante','mandibula','canal sien','canal cuello','solapa','panel bolsillo','borde bolsillo','tapa bolsillo','cuello alto','pespunte abertura']))
 # Cintura continua; conserva piernas, botas y pesos de articulaciones originales.
 pants=bpy.data.objects['Pantalon']
 for v in pants.data.vertices:
  if v.co.z>.94:
   f=min(1,(v.co.z-.94)/.07);v.co.z+=.047*f
   old=[(g.group,g.weight) for g in v.groups]
   for idx,w in old:pants.vertex_groups[idx].add([v.index],w*(1-f),'REPLACE')
   g=pants.vertex_groups.get('pelvis');base=next((w for idx,w in old if pants.vertex_groups[idx].name=='pelvis'),0);g.add([v.index],base*(1-f)+f,'REPLACE')
 for v in bpy.data.objects['Cinturon'].data.vertices:v.co.z=1.024+(v.co.z-1.01)*1.28
 tonos={'jefa':(.48,.17,.27),'vecina_tecnica':(.23,.58,.55),'vecino_visor':(.88,.56,.19),'vecina_brazo':(.26,.29,.38)}
 cuero=textura_tinte('Cuero chaqueta',tonos[version]);textura_tinte('Sarga cargo',(.38,.39,.42) if version=='jefa' else (.49,.57,.59))
 piel=material('Piel '+version,{'jefa':'c5a68e','vecina_tecnica':'9b705b','vecino_visor':'b8a38e','vecina_brazo':'d1bba4'}[version]);body.data.materials[0]=piel
 body.data.materials[1]=material('Labios '+version,'67423e' if version=='jefa' else '79534d')
 for layer in list(body.data.color_attributes):body.data.color_attributes.remove(layer)
 hair=material('Cabello '+version,'17151c' if version!='vecina_brazo' else '92968b',rough=.67)
 hairmid=material('Plano cabello '+version,'27242c' if version!='vecina_brazo' else '6a756f',rough=.74)
 gold=material('Laton envejecido '+version,'bca16a',.73,.4)
 black=material('Panel sintetico '+version,'171d25',.25,.61)
 edge=material('Costura '+version,'684552' if version=='jefa' else '748887',rough=.9)
 luz=material('Circuito '+version,'84d8cd',.3,.4)
 coat_bvh,coat_points,coat_triangles=surface_data(coat)
 coat_weights=[{coat.vertex_groups[g.group].name:g.weight for g in v.groups} for v in coat.data.vertices]
 peinado(version=='jefa')
 if version=='jefa':
  # Identidad: mandíbula más estrecha, pómulo definido, labio oscuro y lunar lateral.
  for v in body.data.vertices:
   if 1.55<v.co.z<1.625 and v.co.y<.02:v.co.x*=.94
  head_bvh,_,_=surface_data(body)
  def skin(p,offset=.003):
   hit,n,_,_=head_bvh.find_nearest(Vector(p));return hit+n*offset
  contour=[(.086,-.003,1.68),(.092,-.016,1.648),(.088,-.033,1.613),(.068,-.063,1.581),(.038,-.087,1.56),(.006,-.091,1.558)]
  inner=[(.075,-.006,1.684),(.081,-.026,1.648),(.075,-.047,1.618),(.057,-.073,1.595),(.026,-.097,1.574),(.006,-.1,1.568)]
  for i in range(5):
   pts=[skin(contour[i]),skin(contour[i+1]),skin(inner[i+1]),skin(inner[i])]
   parche('Mandibula segmentada '+str(i),pts,black,'Head');tube('Borde dorado mandibula '+str(i),pts+[pts[0]],.0018,gold,'Head')
  tube('Pendiente largo',[(.105,.008,1.632),(.108,.009,1.54)],.003,gold,'Head')
  tube('Pasador recogido',[(.08,.15,1.755),(.085,.172,1.65)],.003,gold,'Head')
  p=skin((.06,-.073,1.641),.0008);esfera('Lunar jefa',p,(.0012,.001,.0012),black)
  # Cuello alto negro separado del abrigo, con borde de metal y cierre frontal.
  vs=[]
  for z in [1.463,1.524]:
   for i in range(40):
    a=i*math.tau/40;vs.append((.061*math.cos(a),.01+.061*math.sin(a),z))
  parche('Cuello alto interior',vs[:40],black,'neck_01')
  mesh('Cuello interior paredes',vs,[(i,(i+1)%40,(i+1)%40+40,i+40) for i in range(40)],black,'neck_01')
  tube('Cierre cuello',[(0,-.054,1.47),(0,-.054,1.518)],.003,gold,'neck_01')
  for side in [-1,1]:
   pts=[(side*.057,-.057,1.51),(side*.16,-.034,1.512),(side*.19,-.08,1.405),(side*.085,-.149,1.3),(side*.12,-.119,1.412)]
   parche('Solapa granate '+str(side),pts,cuero)
   tube('Ribete solapa '+str(side),pts+[pts[0]],.0018,edge)
   parche('Herraje solapa '+str(side),[(side*.117,-.075,1.475),(side*.142,-.069,1.478),(side*.127,-.085,1.45)],gold)
  # Corsé negro y cinchas oblicuas apoyadas en la prenda interior.
  shirt=bpy.data.objects['Prenda interior'];shirt.data.materials.clear();shirt.data.materials.append(black)
  shirt_bvh,_,_=surface_data(shirt)
  for i,z in enumerate([1.17,1.29,1.39]):
   controls=[(-.085,-.13,z+.025),(.085,-.13,z-.018)]
   pts=[]
   for j in range(12):
    p=Vector(controls[0]).lerp(Vector(controls[1]),j/11); hit,n,_,_=shirt_bvh.find_nearest(p);pts.append(hit+n*.004)
   tube('Cincha corse '+str(i),pts,.006,black)
   tube('Cierre cincha '+str(i),pts[5:7],.008,gold)
  # Filigrana discreta sobre la pieza izquierda del corsé.
  tube('Panel pecho',[(.08,-.135,1.355),(.098,-.13,1.32),(.08,-.147,1.28)],.003,gold)
 else:
  # Siluetas y aumentos distintos para vecinos sin diálogo.
  if version=='vecina_tecnica':
   # Delantal corto con paneles articulados a pelvis; no interfiere con las rodillas.
   for side in [-1,1]:
    parche('Faldon tecnico '+str(side),[(side*.02,-.135,1.07),(side*.17,-.1,1.07),(side*.17,-.11,.86),(side*.025,-.15,.85)],cuero,'pelvis')
   parche('Auricular sien',[(.098,-.015,1.71),(.103,-.045,1.69),(.1,-.025,1.64),(.096,.01,1.66)],black,'Head')
   tube('Conector auricular',[(.105,.0,1.68),(.108,.02,1.64)],.006,luz,'Head')
  elif version=='vecino_visor':
   for v in body.data.vertices:
    if 1.56<v.co.z<1.62:v.co.x*=1.08
   pts=[(-.087,-.047,1.674),(-.05,-.087,1.674),(0,-.09,1.67),(.05,-.087,1.674),(.087,-.047,1.674)]
   tube('Visor optico',pts,.012,black,'Head');tube('Banda visor',[(x,y-.009,z) for x,y,z in pts],.002,luz,'Head')
   for side in [-1,1]:parche('Hombrera '+str(side),[(side*.2,-.03,1.48),(side*.28,-.025,1.475),(side*.29,-.06,1.435),(side*.21,-.06,1.44)],black)
  else:
   # Cubierta de antebrazo y nudillos con sus propios pesos del rig.
   for side,bone in [(1,'lowerarm_l')]:
    a=rig.data.bones[bone].head_local;b=rig.data.bones[bone].tail_local
    tube('Protesis antebrazo',[a.lerp(b,.18),a.lerp(b,.85)],[.038,.026],black,bone,16)
    tube('Canal protesis',[a.lerp(b,.25)+Vector((0,-.036,0)),a.lerp(b,.8)+Vector((0,-.025,0))],.003,luz,bone)
   parche('Placa clavicula',[(-.09,-.07,1.46),(.09,-.07,1.46),(.075,-.105,1.43),(-.075,-.105,1.43)],black)
 # Acabados nuevos con UV; mantener el patrón de cuero en las solapas.
 objects=[o for o in bpy.context.scene.objects if o.type=='MESH' and o.parent==rig]
 for o in objects:
  bpy.context.view_layer.objects.active=o
  for mod in list(o.modifiers):
   if mod.type!='ARMATURE':bpy.ops.object.modifier_apply(modifier=mod.name)
  if not o.data.uv_layers:
   bpy.ops.object.select_all(action='DESELECT');o.select_set(True)
   bpy.ops.object.mode_set(mode='EDIT');bpy.ops.mesh.select_all(action='SELECT');bpy.ops.uv.smart_project(island_margin=.02);bpy.ops.object.mode_set(mode='OBJECT')
  for v in o.data.vertices:
   assert all(math.isfinite(c) for c in v.co)
   assert abs(sum(g.weight for g in v.groups)-1)<.002,(o.name,v.index)
 assert original==[(b.name,tuple(tuple(row) for row in b.matrix_local)) for b in rig.data.bones]
 # Figuración lejana: reducir superficies antes de unir, conservando rig y materiales.
 if version!='jefa':
  for o in objects:
   if len(o.data.vertices)>1000 and o.name not in ['Botas completas','Superhero_Female']:
    bpy.context.view_layer.objects.active=o;dec=o.modifiers.new('Detalle de calle','DECIMATE');dec.ratio=.28;bpy.ops.object.modifier_apply(modifier=dec.name)
 bpy.ops.object.select_all(action='DESELECT')
 for o in objects:o.select_set(True)
 bpy.context.view_layer.objects.active=objects[0];bpy.ops.object.join();objects[0].name=version
 atlas(objects[0])
 bpy.ops.object.select_all(action='DESELECT');rig.select_set(True);objects[0].select_set(True)
 bpy.context.view_layer.objects.active=rig
 bpy.ops.wm.save_as_mainfile(filepath=str(HERE/(version+'.blend')))
 bpy.ops.export_scene.gltf(filepath=str(OUT/(version+'.glb')),export_format='GLB',use_selection=True,export_animations=False,export_skins=True,export_morph=False)
 print('FIGURACION',version,len(objects[0].data.vertices),'vertices; rig conservado')
