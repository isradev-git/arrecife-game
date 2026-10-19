"""Estudio 3D de Sota sobre malla CC0, conservando esqueleto/pesos y fuente original."""
import bpy,bmesh,math
from mathutils import Vector
from pathlib import Path
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[4]
bpy.ops.wm.read_factory_settings(use_empty=True)
bpy.ops.import_scene.gltf(filepath=str(ROOT/'godot_ilustrado/assets/base/Superhero_Female_FullBody.gltf'))
rig=bpy.data.objects['Armature'];body=bpy.data.objects['Superhero_Female']
objects=[rig,body,bpy.data.objects['Eyes'],bpy.data.objects['Eyebrows']]

def material(name,hexcode):
    rgb=[int(hexcode[i:i+2],16)/255 for i in (0,2,4)]
    linear=[v/12.92 if v<=0.04045 else ((v+0.055)/1.055)**2.4 for v in rgb]
    m=bpy.data.materials.new(name);m.use_nodes=True
    shader=m.node_tree.nodes.get('Principled BSDF')
    shader.inputs['Base Color'].default_value=(*linear,1)
    shader.inputs['Roughness'].default_value=.85
    m.diffuse_color=(*linear,1)
    return m
skin=material('Piel','c19471');hair=material('Pelo oscuro','19181e');grey=material('Mechon gris','b6b3ae')
jacket=material('Chaqueta oxido','80422f');lapel=material('Solapas','9b543b');dark=material('Camiseta y punos','24242a')
pants=material('Pantalon cargo','3a3d34');pocket=material('Bolsillo cargo','494b3e');boots=material('Botas','202426')
strap=material('Correa clara','c5b498');metal=material('Metal usado','62626b');amber=material('Circuitos ambar','e8a341')
def assign(o,m):o.data.materials.clear();o.data.materials.append(m)
assign(body,skin);assign(bpy.data.objects['Eyebrows'],hair);assign(bpy.data.objects['Eyes'],material('Ojos','302c26'))

def garment(name,predicate,mat,offset,shape=None):
    o=body.copy();o.data=body.data.copy();o.name=name;bpy.context.collection.objects.link(o)
    bm=bmesh.new();bm.from_mesh(o.data)
    bmesh.ops.delete(bm,geom=[v for v in bm.verts if not predicate(v.co)],context='VERTS')
    bm.normal_update()
    for v in bm.verts:
        v.co+=v.normal*offset
        if shape:shape(v.co)
    bm.to_mesh(o.data);bm.free();o.data.update();assign(o,mat)
    objects.append(o)
    return o

def expand_pants(v):
    center=math.copysign(.1114,v.x) if v.z<.83 else 0
    v.x=center+(v.x-center)*(1.18 if v.z<.83 else 1.05)
    v.y=.045+(v.y-.045)*1.13
shirt=garment('Prenda interior',lambda v:.95<v.z<1.49 and abs(v.x)<.205,dark,.004)
coat=garment('Chaqueta',lambda v:.96<v.z<1.49 and abs(v.x)<.48,jacket,.013)
for v in coat.data.vertices:
    if 1.08<v.co.z<1.44 and abs(v.co.x)<.17 and v.co.y<0:v.co.y=min(v.co.y,-.125)
# Abrir la chaqueta sobre la camiseta; no se elimina superficie del cuerpo.
bm=bmesh.new();bm.from_mesh(coat.data)
bmesh.ops.delete(bm,geom=[f for f in bm.faces if (c:=f.calc_center_median()).y<-.075 and abs(c.x)<.035+max(0,c.z-1.05)*.12 and abs(c.x)<.19],context='FACES')
bm.to_mesh(coat.data);bm.free()
trousers=garment('Pantalon',lambda v:v.z<1.015 and v.z>.145,pants,.009,expand_pants)
boot=garment('Botas completas',lambda v:v.z<.205,boots,0.0)
for v in boot.data.vertices:
    center=math.copysign(.1114,v.co.x)
    v.co.x=center+(v.co.x-center)*1.05
# Conservar la suela articulada de la malla: una caja rígida atravesaba el suelo durante el rodado.

# Los elementos rígidos se vinculan a huesos reales en coordenadas de reposo.
def bind(o,bone):
    o.parent=rig
    group=o.vertex_groups.new(name=bone);group.add(range(len(o.data.vertices)),1.0,'REPLACE')
    mod=o.modifiers.new('Deformacion','ARMATURE');mod.object=rig
    objects.append(o)
    return o

def box(name,location,size,mat,bone,bevel=.004):
    bpy.ops.mesh.primitive_cube_add(size=1,location=location)
    o=bpy.context.object;o.name=name;o.scale=size
    bpy.ops.object.transform_apply(location=False,rotation=False,scale=True)
    # Vértices en el mismo espacio de reposo que la malla humana.
    bpy.ops.object.transform_apply(location=True,rotation=True,scale=False)
    if bevel:
        mod=o.modifiers.new('Bordes','BEVEL');mod.width=bevel;mod.segments=2
        bpy.ops.object.modifier_apply(modifier=mod.name)
    assign(o,mat);return bind(o,bone)

def surface(name,vertices,faces,mat,bone,thickness=0):
    mesh=bpy.data.meshes.new(name);mesh.from_pydata(vertices,[],faces);mesh.update()
    o=bpy.data.objects.new(name,mesh);bpy.context.collection.objects.link(o)
    assign(o,mat)
    if thickness:
        bpy.context.view_layer.objects.active=o;o.select_set(True)
        mod=o.modifiers.new('Grosor','SOLIDIFY');mod.thickness=thickness
        bpy.ops.object.modifier_apply(modifier=mod.name)
    return bind(o,bone)

for sign,side in [(1,'l'),(-1,'r')]:
    box('Puno '+side,(sign*.465,.055,1.418),(.042,.10,.105),dark,'lowerarm_'+side,.01)
# Un bolsillo exterior en la pierna derecha; no cambia de lado al girar.
box('Bolsillo exterior derecho',(-.205,.035,.72),(.045,.105,.145),pocket,'thigh_r',.008)
box('Tapa bolsillo',(-.232,.035,.77),(.008,.113,.033),pants,'thigh_r',.003)
box('Cinturon',(0,.035,1.005),(.30,.225,.034),dark,'pelvis',.015)
# Equipo ceñido a la cintura y ligeramente retrasado: liberar el paso de la mano.
box('Cyberdeck',(-.13,.14,1.055),(.055,.115,.175),dark,'pelvis',.009)
box('Marco cyberdeck',(-.161,.13,1.055),(.008,.10,.15),metal,'pelvis',.003)
box('Indicador cyberdeck',(-.167,.109,1.08),(.003,.055,.027),amber,'pelvis',.002)
for sign in [-1,1]:
    surface('Solapa '+str(sign),[(sign*.055,-.135,1.44),(sign*.13,-.135,1.40),(sign*.073,-.157,1.22),(sign*.045,-.155,1.29)],[(0,1,2,3)],lapel,'spine_03',.004)
    surface('Cuello '+str(sign),[(sign*.045,-.045,1.48),(sign*.072,.065,1.48),(sign*.097,.065,1.43),(sign*.07,-.08,1.43)],[(0,1,2,3)],jacket,'spine_03',.006)

# Correa con pesos copiados de la superficie corporal más cercana.
points=[Vector((.135,-.12,1.435)),Vector((.065,-.168,1.32)),Vector((-.025,-.154,1.18)),Vector((-.155,-.14,1.025))]
vertices=[]
for i,p in enumerate(points):
    tangent=(points[min(i+1,len(points)-1)]-points[max(0,i-1)]).normalized()
    side=Vector((tangent.z,0,-tangent.x))*.022
    vertices.extend([p-side,p+side])
mesh=bpy.data.meshes.new('Correa');mesh.from_pydata(vertices,[],[(i*2,i*2+1,i*2+3,i*2+2) for i in range(3)]);mesh.update()
o=bpy.data.objects.new('Correa diagonal',mesh);bpy.context.collection.objects.link(o);assign(o,strap);o.parent=rig
for g in body.vertex_groups:o.vertex_groups.new(name=g.name)
for i,p in enumerate(vertices):
    nearest=min(body.data.vertices,key=lambda v:(v.co-p).length_squared)
    for g in nearest.groups:o.vertex_groups[g.group].add([i],g.weight,'REPLACE')
mod=o.modifiers.new('Deformacion','ARMATURE');mod.object=rig;objects.append(o)

# Casquete y melena corta volumétricos, con abertura frontal sobre las cejas.
N=32;vertices=[]
for row,radius in enumerate([.12,.75,1.04,1.08,1.03]):
    fraction=row/4
    for i in range(N):
        angle=2*math.pi*i/N
        x=.106*math.cos(angle)*radius;y=.02+.113*math.sin(angle)*radius
        bottom=1.70 if math.sin(angle)<-.65 else (1.675 if math.sin(angle)<.25 else 1.535+.025*math.cos(angle*3))
        z=[1.80,1.77,1.715,1.715+(bottom-1.715)*.5,bottom][row]
        vertices.append((x,y,z))
faces=[tuple(range(N))]
for r in range(4):
    for i in range(N):faces.append((r*N+i,(r+1)*N+i,(r+1)*N+(i+1)%N,r*N+(i+1)%N))
surface('Pelo corto',vertices,faces,hair,'Head',.004)
surface('Flequillo oscuro',[(.015,-.068,1.784),(.088,-.058,1.75),(.079,-.105,1.63),(.039,-.099,1.695),(-.025,-.093,1.73)],[(0,1,2,3,4)],hair,'Head',.006)
surface('Mechon gris',[(.007,-.086,1.788),(-.035,-.078,1.779),(-.085,-.072,1.70),(-.077,-.103,1.617),(-.047,-.116,1.679),(-.009,-.11,1.724)],[(0,1,2,3,4,5)],grey,'Head',.006)
box('Implante sien derecha',(-.083,-.015,1.655),(.015,.065,.075),metal,'Head',.007)
box('Luz implante',(-.092,-.045,1.66),(.005,.025,.009),amber,'Head',.002)
box('Modulo mandibula',(-.071,-.012,1.565),(.017,.053,.033),dark,'Head',.006)

# Retirar la piel completamente cubierta evita caras coplanares y conserva sólo cabeza/cuello y manos/antebrazos.
bm=bmesh.new();bm.from_mesh(body.data)
bmesh.ops.delete(bm,geom=[v for v in bm.verts if v.co.z<1.465 and abs(v.co.x)<.476],context='VERTS')
bm.to_mesh(body.data);bm.free()

# Exportar sólo las piezas del personaje y su esqueleto, sin objetos auxiliares del importador.
bpy.ops.object.select_all(action='DESELECT')
for o in objects:o.select_set(True)
bpy.context.view_layer.objects.active=rig
bpy.ops.wm.save_as_mainfile(filepath=str(HERE/'sota.blend'))
output=ROOT/'godot_ilustrado/assets/sota_3d_v2/sota.glb'
bpy.ops.export_scene.gltf(filepath=str(output),export_format='GLB',use_selection=True,export_animations=False,export_skins=True,export_morph=False)
print('Sota estudio 3D v2 exportada:',output,'piezas:',len(objects),'huesos:',len(rig.data.bones))
