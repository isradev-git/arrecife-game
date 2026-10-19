"""Revisión del retrato sobre v3; conserva rig, pesos de cuerpo, manos y botas."""
import bpy, math
from pathlib import Path
from mathutils import Vector
from mathutils.bvhtree import BVHTree

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[4]
bpy.ops.wm.open_mainfile(filepath=str(HERE.parent / 'ilustrada_3d_v3/sota.blend'))
rig = bpy.data.objects['Armature']
coat = bpy.data.objects['Chaqueta']
body = bpy.data.objects['Superhero_Female']
boot_before = [tuple(v.co) for v in bpy.data.objects['Botas completas'].data.vertices]
hands_before = {v.index:tuple(v.co) for v in body.data.vertices if abs(v.co.x)>.48}

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

rust = material('Cuero oxido v4', '965237')
edge = material('Cantos cuero v4', 'b2734c')
dark = material('Costura oscura v4', '352c29')
hair = material('Carbon pelo v4', '19191f')
hairmid = material('Planos pelo v4', '232128')
gray = material('Gris ceniza v4', 'bcb4a6')
steel = material('Acero v4', '9a9990', .55, .5)
graphite = material('Grafito v4', '2d3437', .25)
amber = material('Circuito ambar v4', 'dca74b', .15)

def surface_data(o):
    o.data.calc_loop_triangles()
    points = [v.co.copy() for v in o.data.vertices]
    triangles = [tuple(t.vertices) for t in o.data.loop_triangles]
    return BVHTree.FromPolygons(points, triangles, all_triangles=True), points, triangles

coat_bvh, coat_points, coat_triangles = surface_data(coat)
coat_weights = [{coat.vertex_groups[g.group].name:g.weight for g in v.groups} for v in coat.data.vertices]

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

def remove(names):
    for name in names:
        if name in bpy.data.objects: bpy.data.objects.remove(bpy.data.objects[name],do_unlink=True)

def on_coat(p, offset=.002):
    hit,normal,index,distance=coat_bvh.find_nearest(Vector(p))
    return hit+normal*offset

# Mantener la superficie y sus pesos; definir cuero, paneles y prendas sobre ella.
colors=coat.data.color_attributes['Prenda']
lining=bpy.data.materials['Forro carbon']
for loop in coat.data.loops:
    p=coat.data.vertices[loop.vertex_index].co
    width=.035+max(0,p.z-1.05)*.12
    f=max(0,min(1,(width-abs(p.x)+.007)/.014))*max(0,min(1,(-p.y+.006)/.02))
    f=f*f*(3-2*f)
    # Variación amplia, sin ruido por vértice ni triángulos de colores aislados.
    panel=1-.07*math.exp(-((p.z-1.18)/.035)**2)
    colors.data[loop.index].color=tuple(rust.diffuse_color[k]*(1-f)*panel+lining.diffuse_color[k]*f for k in range(3))+(1,)
remove(['Solapa -1','Solapa 1','Costura solapa -1','Costura solapa 1','Broche cuello -1','Broche cuello 1'])
collar=bpy.data.objects['Cuello alto']
collar.data.materials.clear(); collar.data.materials.append(rust)
for v in collar.data.vertices:
    if v.co.z>1.47: v.co.z+=.022*(v.co.z-1.47)/.035
for side in [-1,1]:
    points=[(side*.036,-.063,1.515),(side*.087,-.078,1.492),(side*.121,-.10,1.407),
            (side*.093,-.13,1.324),(side*.055,-.142,1.356),(side*.064,-.115,1.428)]
    mesh('Solapa retrato '+str(side),points,[(0,1,5),(1,2,5),(2,3,4,5)],rust)
    tube('Ribete solapa '+str(side),points+[points[0]],.0015,dark)
    # Bolsillos con contorno adherido y tapa, visibles también en el perfil.
    for z,h in [(1.31,.035),(1.135,.052)]:
        controls=[(side*.09,-.14,z),(side*.145,-.105,z+.004),(side*.155,-.103,z-h),(side*.098,-.132,z-h-.005)]
        outline=[on_coat(p,.003) for p in controls]
        mesh('Panel bolsillo '+str(side)+' '+str(z),outline,[(0,1,2,3)],rust)
        tube('Borde bolsillo '+str(side)+' '+str(z),outline+[outline[0]],.0014,dark)
        tube('Tapa bolsillo '+str(side)+' '+str(z),[on_coat(p,.0045) for p in controls[:2]],.003,edge)
    # Parche del brazo y sus bordes en la manga, siguiendo sus pesos originales.
    controls=[(side*.23,-.010,1.464),(side*.30,-.013,1.464),(side*.31,-.010,1.420),(side*.235,-.010,1.420)]
    points=[on_coat(p,.003) for p in controls]
    mesh('Parche manga '+str(side),points,[(0,1,2,3)],graphite)
    tube('Marco parche '+str(side),points+[points[0]],.002,steel)

# Correa y anclaje conservan geometría y pesos de v3; sólo gana lectura de material.
strap=bpy.data.objects['Correa diagonal']
strapmat=material('Lona clara v4','bfb198',0,.94)
strap.data.materials.clear(); strap.data.materials.append(strapmat)

# Rasgos algo más angulares y piel con planos suaves; no se alteran manos ni cuello.
for v in body.data.vertices:
    p=v.co
    if 1.54<p.z<1.62 and p.y<.01:
        jaw=math.exp(-((p.z-1.575)/.028)**2)
        p.x*=1+.055*jaw
    if 1.605<p.z<1.65 and p.y<-.085:
        p.y+=.002*math.exp(-((p.z-1.625)/.018)**2)
skin=material('Piel retrato v4','c29570')
body.data.materials[0]=skin
body.data.materials[1]=material('Labios retrato v4','87543f')
skincolors=body.data.color_attributes.new(name='Piel',type='FLOAT_COLOR',domain='CORNER')
vertexnode=skin.node_tree.nodes.new('ShaderNodeVertexColor'); vertexnode.layer_name='Piel'
skin.node_tree.links.new(vertexnode.outputs['Color'],skin.node_tree.nodes.get('Principled BSDF').inputs['Base Color'])
for loop in body.data.loops:
    p=body.data.vertices[loop.vertex_index].co
    factor=1
    if p.z>1.53 and p.y<-.015:
        cheek=.12*math.exp(-((abs(p.x)-.054)/.027)**2-((p.z-1.625)/.015)**2)
        orbit=.17*math.exp(-((abs(p.x)-.032)/.023)**2-((p.z-1.65)/.012)**2)
        factor-=cheek+orbit
    skincolors.data[loop.index].color=tuple(skin.diffuse_color[k]*factor for k in range(3))+(1,)
head_bvh,_,_=surface_data(body)
def on_skin(p,offset=.0008):
    hit,normal,index,distance=head_bvh.find_nearest(Vector(p)); return hit+normal*offset
for x,z in [(-.063,1.632),(-.032,1.556)]:
    p=on_skin((x,-.085,z))
    tube('Lunar retrato '+str(z),[p,p+Vector((0,-.0004,.0004))],.0011,dark,'Head')
# Ojos: contorno superior fino y extremos, sin agrandar el globo ocular.
for side in [-1,1]:
    pts=[(side*.016,-.073,1.654),(side*.026,-.077,1.663),(side*.04,-.073,1.664),(side*.052,-.061,1.659)]
    tube('Parpado superior '+str(side),[on_skin(p,.001) for p in pts],[.0007,.0012,.0014,.0004],dark,'Head')

# Corte asimétrico por capas. El gris cae junto a la sien, no en una franja horizontal.
remove(['Pelo corto','Mechones oscuros','Flequillo barrido','Mechon gris'])
N=64; rows=10; vertices=[]
for row in range(rows):
    f=row/(rows-1)
    for j in range(N):
        a=j*math.tau/N; front=max(0,-math.sin(a)); right=max(0,-math.cos(a))
        bottom=1.565+.151*front**4+.112*right**10
        bottom+=.009*math.sin(7*a)+.005*math.sin(11*a)
        radial=.025+math.sin(f*math.pi/2)
        vertices.append((.105*math.cos(a)*radial,.025+.119*math.sin(a)*radial,1.802+(bottom-1.802)*f**1.65))
faces=[(r*N+j,r*N+(j+1)%N,(r+1)*N+(j+1)%N,(r+1)*N+j) for r in range(rows-1) for j in range(N)]
faces.append(tuple(reversed(range(N))))
mesh('Pelo corto',vertices,faces,hair,'Head')

def lock(name,controls,widths,mat):
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
            vs.append(p+a*math.cos(angle)*radii[i]+b*math.sin(angle)*min(.006,radii[i]*.45))
    fs=[(i*sides+j,i*sides+(j+1)%sides,(i+1)*sides+(j+1)%sides,(i+1)*sides+j) for i in range(len(points)-1) for j in range(sides)]
    fs.extend([tuple(reversed(range(sides))),tuple(range((len(points)-1)*sides,len(points)*sides))])
    return mesh(name,vs,fs,mat,'Head')

locks=[]
for i in range(14):
    a=.05+i*math.tau/14; x=math.cos(a); y=math.sin(a); front=max(0,-y); right=max(0,-x)
    endz=1.56+.13*front**3+.105*right**8+.014*math.sin(i*2.3)
    controls=[(.025+x*.018,.008+y*.018,1.8),(.012+x*.079,.023+y*.094,1.767),
              (x*.108,.025+y*.124,1.704),
              (x*.115+.012*math.sin(i),.025+y*.131,endz)]
    locks.append(lock('Capa pelo '+str(i),controls,[.009,.024,.025,.001],hairmid if i%3==0 else hair))
# Capas cortas laterales: rompen la silueta de casco y descubren la oreja derecha.
for i in range(7):
    a=.2+i*.43; x=math.cos(a); y=math.sin(a)
    controls=[(x*.09,.025+y*.108,1.724),(x*.114,.025+y*.13,1.663),(x*.12+.009,.025+y*.143,1.591+.012*math.sin(i*3))]
    locks.append(lock('Capa nuca '+str(i),controls,[.02,.022,.001],hairmid if i%2 else hair))
locks.append(lock('Flequillo oscuro',[(.055,-.048,1.792),(.075,-.091,1.75),(.084,-.106,1.675),(.093,-.09,1.584)],[.018,.029,.019,.001],hair))
graylock=lock('Mechon gris',[(-.013,-.059,1.806),(-.040,-.101,1.772),(-.066,-.114,1.703),(-.083,-.105,1.636),(-.077,-.102,1.596)],[.009,.021,.018,.010,.001],gray)
# Separaciones oscuras discretas en el mechón, sin forma de cuerno ni banda de ceja.
locks.append(lock('Canto mechon gris',[(-.027,-.072,1.804),(-.055,-.105,1.768),(-.081,-.116,1.70),(-.092,-.104,1.628)],[.004,.006,.004,.001],hair))
bpy.ops.object.select_all(action='DESELECT')
for o in locks: o.select_set(True)
bpy.context.view_layer.objects.active=locks[0]; bpy.ops.object.join(); locks[0].name='Mechones oscuros'

# Vías luminosas de sien y cuello, ajustadas a la piel y al hueso correspondiente.
for name,points,bone in [('Canal sien retrato',[(-.097,.009,1.689),(-.098,-.013,1.68),(-.097,-.025,1.646)],'Head'),
                          ('Canal cuello retrato',[(-.057,.025,1.555),(-.053,.017,1.525),(-.049,.012,1.501)],'neck_01')]:
    tube(name,[on_skin(p,.0025) for p in points],.0015,amber,bone)

# El contrato de exportación conserva exactamente huesos, escala y superficies de contacto.
assert len(rig.data.bones)==65
assert boot_before == [tuple(v.co) for v in bpy.data.objects['Botas completas'].data.vertices]
assert all(tuple(body.data.vertices[i].co)==p for i,p in hands_before.items())
for o in bpy.context.scene.objects:
    if o.type=='MESH' and o.parent==rig:
        for v in o.data.vertices:
            assert all(math.isfinite(x) for x in v.co)
            assert abs(sum(g.weight for g in v.groups)-1)<.001, (o.name,v.index)
bpy.ops.object.select_all(action='DESELECT')
for o in bpy.context.scene.objects:
    if o==rig or (o.type=='MESH' and o.parent==rig): o.select_set(True)
bpy.context.view_layer.objects.active=rig
bpy.ops.wm.save_as_mainfile(filepath=str(HERE/'sota.blend'))
bpy.ops.export_scene.gltf(filepath=str(ROOT/'godot_ilustrado/assets/sota_3d_v4/sota.glb'),export_format='GLB',use_selection=True,export_animations=False,export_skins=True,export_morph=False)
print('Candidata v4 exportada. Marcha y rig de v3 conservados; no implica aprobación artística.')
