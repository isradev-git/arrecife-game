"""Candidata v3: prendas cerradas, pelo por mechones y arnés continuo. Base CC0 preservada."""
import bpy, math
from pathlib import Path
from mathutils import Vector, kdtree
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[4]
bpy.ops.wm.open_mainfile(filepath=str(HERE.parent/'ilustrada_3d_v2/sota.blend'))
rig=bpy.data.objects['Armature']
source=bpy.data.objects['Chaqueta']
kd=kdtree.KDTree(len(source.data.vertices))
for v in source.data.vertices:kd.insert(v.co,v.index)
kd.balance()
source_weights=[{source.vertex_groups[g.group].name:g.weight for g in v.groups} for v in source.data.vertices]

def mat(name,color,metal=0,rough=.8):
    m=bpy.data.materials.new(name);m.use_nodes=True
    c=[int(color[i:i+2],16)/255 for i in (0,2,4)]
    c=[v/12.92 if v<=.04045 else ((v+.055)/1.055)**2.4 for v in c]
    p=m.node_tree.nodes.get('Principled BSDF');p.inputs['Base Color'].default_value=(*c,1)
    p.inputs['Roughness'].default_value=rough;p.inputs['Metallic'].default_value=metal
    m.diffuse_color=(*c,1)
    return m
oxide=mat('Cuero oxido','71402f');edge=mat('Cantos cuero','95583e');lining=mat('Forro carbon','24262a')
seam=mat('Costuras cuero','a47a56');strap=mat('Lona arnes','ac9d80');strapedge=mat('Canto arnes','756a55')
charcoal=mat('Pelo carbon','17161b');hairmid=mat('Mechones marron negro','252128');hairlight=mat('Reflejos pelo','312b30')
gray=mat('Mechon gris ceniza','aba69c');metal=mat('Acero cepillado','596060',.5,.47)
darkmetal=mat('Carcasa grafito','252c2f',.3,.65);amber=mat('Ambar apagado','bd9b55',.2,.5)
skin=mat('Piel ocre','b88c69');lips=mat('Labios naturales','805347');shadow=mat('Contorno ojos','3b2a29')

new=[]
def weights(o, mode=None):
    o.parent=rig
    if mode:
        g=o.vertex_groups.new(name=mode);g.add(list(range(len(o.data.vertices))),1,'REPLACE')
    else:
        groups={n:o.vertex_groups.new(name=n) for n in [b.name for b in rig.data.bones]}
        for v in o.data.vertices:
            blend={}
            for co,i,d in kd.find_n(v.co,4):
                for n,w in source_weights[i].items():blend[n]=blend.get(n,0)+w/max(d,.002)**2
            items=sorted(blend.items(),key=lambda x:-x[1])[:4];total=sum(w for _,w in items)
            for n,w in items:groups[n].add([v.index],w/total,'REPLACE')
    mod=o.modifiers.new('Deformacion','ARMATURE');mod.object=rig
    return o

def mesh(name,vs,fs,material,bone=None,thick=0,sub=0):
    data=bpy.data.meshes.new(name);data.from_pydata(vs,[],fs);data.update()
    o=bpy.data.objects.new(name,data);bpy.context.collection.objects.link(o);data.materials.append(material)
    weights(o,bone)
    for p in data.polygons:p.use_smooth=True
    # Operar en reposo antes del modificador de armadura conserva los pesos interpolados.
    if sub:
        mod=o.modifiers.new('Superficie continua','SUBSURF');mod.levels=sub
        bpy.context.view_layer.objects.active=o;bpy.ops.object.modifier_move_up(modifier=mod.name)
        bpy.ops.object.modifier_apply(modifier=mod.name)
    if thick:
        mod=o.modifiers.new('Grosor real','SOLIDIFY');mod.thickness=thick;mod.offset=0
        bpy.context.view_layer.objects.active=o;bpy.ops.object.modifier_move_up(modifier=mod.name)
        bpy.ops.object.modifier_apply(modifier=mod.name)
    new.append(o)
    return o

def tube(name,points,radii,material,bone=None,sides=12):
    vs=[]
    for i,p in enumerate(points):
        p=Vector(p);t=(Vector(points[min(i+1,len(points)-1)])-Vector(points[max(i-1,0)])).normalized()
        a=t.cross(Vector((0,1,0)))
        if a.length<.01:a=t.cross(Vector((1,0,0)))
        a.normalize();b=t.cross(a).normalized()
        r=radii[i] if isinstance(radii,list) else radii
        rx,ry=r if isinstance(r,tuple) else (r,r)
        for j in range(sides):
            q=p+a*math.cos(j*math.tau/sides)*rx+b*math.sin(j*math.tau/sides)*ry
            vs.append(q)
    fs=[]
    for i in range(len(points)-1):
        for j in range(sides):fs.append((i*sides+j,i*sides+(j+1)%sides,(i+1)*sides+(j+1)%sides,(i+1)*sides+j))
    fs += [tuple(reversed(range(sides))),tuple(range((len(points)-1)*sides,len(points)*sides))]
    return mesh(name,vs,fs,material,bone)

def box(name,center,size,material,bone='pelvis',bevel=.003):
    bpy.ops.object.select_all(action='DESELECT');bpy.ops.mesh.primitive_cube_add(size=1,location=center)
    o=bpy.context.object;o.name=name;o.scale=size;bpy.ops.object.transform_apply(location=True,rotation=True,scale=True)
    m=o.modifiers.new('Cantos redondeados','BEVEL');m.width=bevel;m.segments=3;bpy.ops.object.modifier_apply(modifier=m.name)
    o.data.materials.append(material);weights(o,bone)
    for p in o.data.polygons:p.use_smooth=True
    new.append(o);return o

# Guardar la información de pesos antes de retirar las prendas recortadas.
remove=['Prenda interior','Chaqueta','Puno l','Puno r','Cinturon','Correa diagonal','Pelo corto','Flequillo oscuro','Mechon gris',
        'Implante sien derecha','Luz implante','Modulo mandibula','Solapa -1','Solapa 1','Cuello -1','Cuello 1']
# La KD y los pesos anteriores ya contienen toda la fuente necesaria.
for name in remove:
    o=bpy.data.objects.get(name)
    if o:bpy.data.objects.remove(o,do_unlink=True)
# El origen de nearest-neighbour queda copiado en la KD, no se vuelve a consultar el objeto borrado.

rings=[(1.035,.158,.132),(1.05,.162,.135),(1.10,.161,.14),(1.18,.168,.145),(1.28,.185,.157),(1.36,.202,.145),(1.415,.201,.11),(1.445,.165,.078)]
def shell(name,rs,material,opening=0,n=48,thick=.004):
    vs=[]
    for z,rx,ry in rs:
        for j in range(n+1):
            a=opening+(math.tau-2*opening)*j/n
            vs.append((math.sin(a)*rx,.025-math.cos(a)*ry,z))
    fs=[(i*(n+1)+j,i*(n+1)+j+1,(i+1)*(n+1)+j+1,(i+1)*(n+1)+j) for i in range(len(rs)-1) for j in range(n)]
    return mesh(name,vs,fs,material,None,thick,1)
shirt=shell('Prenda interior',[(1.01,.147,.12),(1.04,.15,.125),(1.2,.157,.14),(1.34,.175,.14),(1.42,.165,.082),(1.45,.073,.061),(1.50,.057,.052)],lining,0,48,.003)
coat=shell('Chaqueta',rings,oxide,.23,48,.006)
for sign,side in [(1,'l'),(-1,'r')]:
    vs=[];N=24
    rs=[(.145,.076,.078),(.165,.079,.079),(.23,.073,.071),(.31,.067,.068),(.38,.061,.063),(.41,.061,.062),(.46,.053,.052),(.485,.05,.05)]
    for x,ry,rz in rs:
        for j in range(N):
            a=math.tau*j/N;vs.append((sign*x,.054+math.cos(a)*ry,1.418+math.sin(a)*rz))
    fs=[(i*N+j,i*N+(j+1)%N,(i+1)*N+(j+1)%N,(i+1)*N+j) for i in range(len(rs)-1) for j in range(N)]
    mesh('Manga '+side,vs,fs,oxide,None,.004,1)
    vs=[]
    for x,r in [(.46,.055),(.467,.058),(.489,.057),(.497,.052)]:
        for j in range(N):
            a=math.tau*j/N;vs.append((sign*x,.054+math.cos(a)*r,1.418+math.sin(a)*r))
    fs=[(i*N+j,i*N+(j+1)%N,(i+1)*N+(j+1)%N,(i+1)*N+j) for i in range(3) for j in range(N)]
    mesh('Puno '+side,vs,fs,edge,None,.005,1)
    tube('Costura manga '+side,[(sign*x,-.006,1.44) for x in [.19,.25,.32,.39,.44,.48]],.0013,seam)
# Cuello elevado y solapas con volumen, sin grandes triángulos colgantes.
shell('Cuello alto',[(1.43,.083,.073),(1.44,.086,.075),(1.495,.073,.067),(1.505,.072,.066)],oxide,.38,40,.006)
for s in [-1,1]:
    vs=[(s*.04,-.063,1.49),(s*.083,-.075,1.47),(s*.11,-.10,1.39),(s*.075,-.132,1.29),(s*.035,-.125,1.36)]
    mesh('Solapa '+str(s),vs,[(0,1,2),(0,2,4),(2,3,4)],edge,None,.007,1)
    tube('Costura solapa '+str(s),[vs[0],vs[1],vs[2],vs[3]],.0011,seam)
    box('Broche cuello '+str(s),(s*.063,-.085,1.454),(.012,.007,.012),metal,'spine_03',.004)

# Pantalón continuo: mantener su anatomía y suavizar volumen en lugar de reescalar poses.
pants=bpy.data.objects['Pantalon']
for v in pants.data.vertices:
    if v.co.z>.8:v.co.x*=.96
    elif .24<v.co.z<.65:
        cx=math.copysign(.1114,v.co.x);v.co.x=cx+(v.co.x-cx)*1.06
for p in pants.data.polygons:p.use_smooth=True
mod=pants.modifiers.new('Superficie pantalon','SUBSURF');mod.levels=1
bpy.context.view_layer.objects.active=pants;bpy.ops.object.modifier_move_up(modifier=mod.name);bpy.ops.object.modifier_apply(modifier=mod.name)
# Bolsillos y sus tapas conservados; eliminar el aspecto de bloque con normales y cantos suaves.
for name in ['Bolsillo exterior derecho','Tapa bolsillo']:
    for p in bpy.data.objects[name].data.polygons:p.use_smooth=True
for s,side in [(-1,'r'),(1,'l')]:
    tube('Costura pantalon '+side,[(s*.19,.04,1.0),(s*.205,.04,.88),(s*.198,.04,.75),(s*.18,.045,.62),(s*.17,.05,.50)],.0013,lining,'thigh_'+side)
# Cinturón y holster físicamente unidos al aparato, ambos sobre pelvis.
shell('Cinturon',[(1.008,.164,.137),(1.035,.164,.137)],lining,0,64,.004)
# El cinturón no sigue columna: anclar cada vértice a pelvis.
belt=bpy.data.objects['Cinturon'];belt.vertex_groups.clear();g=belt.vertex_groups.new(name='pelvis');g.add(list(range(len(belt.data.vertices))),1,'REPLACE')
box('Anclaje correa deck',(-.166,.135,1.12),(.009,.037,.031),metal,'pelvis',.003)
for name,m in [('Cyberdeck',darkmetal),('Marco cyberdeck',metal),('Indicador cyberdeck',amber)]:
    o=bpy.data.objects[name];o.data.materials.clear();o.data.materials.append(m)
    for p in o.data.polygons:p.use_smooth=True
for i in range(3):box('Ranura deck '+str(i),(-.168,.105+i*.018,1.025),(.003,.01,.035),lining,'pelvis',.001)

# Arnés cerrado: frente, hombro, espalda y anclaje pertenecen a una misma superficie.
def front(x,z):
    r=min(rings,key=lambda r:abs(r[0]-z));return .025-r[2]*math.sqrt(max(.04,1-(x/r[1])**2))-.008
path=[(-.167,.135,1.12),(-.182,.06,1.08),(-.176,-.035,1.075),(-.13,front(-.13,1.08),1.08),
      (-.065,front(-.065,1.15),1.15),(.02,front(.02,1.26),1.26),(.09,front(.09,1.36),1.36),(.135,front(.135,1.43),1.43),
      (.143,.025,1.475),(.13,.11,1.405),(.06,.166,1.26),(-.065,.16,1.13),(-.167,.135,1.12)]
centers=[]
for i in range(len(path)-1):
    p0=Vector(path[max(i-1,0)]);p1=Vector(path[i]);p2=Vector(path[i+1]);p3=Vector(path[min(i+2,len(path)-1)])
    for j in range(6):
        t=j/6;centers.append(.5*((2*p1)+(-p0+p2)*t+(2*p0-5*p1+4*p2-p3)*t*t+(-p0+3*p1-3*p2+p3)*t*t*t))
vs=[]
for i,p in enumerate(centers):
    tangent=(centers[(i+1)%len(centers)]-centers[(i-1)%len(centers)]).normalized()
    normal=Vector((p.x*1.2,p.y-.025,0)).normalized();side=tangent.cross(normal).normalized()*.018
    vs.extend([p-side,p+side])
fs=[(i*2,i*2+1,((i+1)%len(centers))*2+1,((i+1)%len(centers))*2) for i in range(len(centers))]
arness=mesh('Correa diagonal',vs,fs,strap,None,.003)
# Mantener la unión al holster en el mismo espacio rígido que el aparato.
for v in arness.data.vertices:
    if v.co.z<1.14 and v.co.y>.02:
        for g in arness.vertex_groups:g.remove([v.index])
        arness.vertex_groups['pelvis'].add([v.index],1,'REPLACE')
# Hebilla en el pecho, sobre el recorrido real de la correa.
box('Hebilla arnes',(.02,front(.02,1.26)-.006,1.26),(.045,.012,.03),metal,'spine_02',.004)

# Rasgos y materiales faciales; conservar articulación de cabeza y manos.
body=bpy.data.objects['Superhero_Female'];body.data.materials.clear()
for m in [skin,lips,shadow]:body.data.materials.append(m)
for v in body.data.vertices:
    if 1.53<v.co.z<1.65:
        v.co.x*=.96
        if v.co.y<-.075 and v.co.z<1.575:v.co.y-=.003
for p in body.data.polygons:
    p.use_smooth=True;c=p.center
    # El centro se actualiza tras los cambios para asignar labios discretos.
body.data.update()
for p in body.data.polygons:
    c=p.center
    if abs(c.x)<.023 and c.y<-.080 and 1.568<c.z<1.59:p.material_index=1
for p in bpy.data.objects['Eyebrows'].data.polygons:p.use_smooth=True
bpy.data.objects['Eyebrows'].data.materials.clear();bpy.data.objects['Eyebrows'].data.materials.append(charcoal)
eyes=bpy.data.objects['Eyes'];eyes.data.materials.clear()
for m in [mat('Esclerotica','b9b2a1'),mat('Iris oliva','77764b'),shadow]:eyes.data.materials.append(m)
for p in eyes.data.polygons:
    c=p.center;cx=math.copysign(.033,c.x)
    if c.y<-.069 and abs(c.x-cx)<.009 and abs(c.z-1.656)<.008:p.material_index=1
    if c.y<-.071 and abs(c.x-cx)<.004 and abs(c.z-1.656)<.005:p.material_index=2
# Pelo de casquete curvo más mechones volumétricos: ningún plano blanco en forma de cuerno.
N=48;vs=[];rows=9
for row in range(rows):
    f=row/(rows-1)
    for j in range(N):
        a=j*math.tau/N;frontness=max(0,-math.sin(a))
        bottom=1.525+.185*(frontness**3)+.009*math.sin(a*5)
        radial=math.sin(f*math.pi/2)*1.07
        z=1.79+(bottom-1.79)*(f**1.8)
        vs.append((.102*math.cos(a)*radial,.025+.117*math.sin(a)*radial,z))
fs=[(r*N+j,r*N+(j+1)%N,(r+1)*N+(j+1)%N,(r+1)*N+j) for r in range(rows-1) for j in range(N)]
mesh('Pelo corto',vs,fs,charcoal,'Head',.003,1)
locks=[]
for i in range(16):
    a=math.tau*i/16
    x=math.cos(a);y=math.sin(a);frontness=max(0,-y)
    endz=1.52+.16*frontness**3+.012*math.sin(i*2)
    points=[(x*.037,.025+y*.043,1.78),(x*.079,.025+y*.09,1.746),(x*.106,.025+y*.12,1.66),(x*.111+.008*math.sin(i),.025+y*.125,endz)]
    # Mechones frontales cortos caen hacia la sien, sin tapar toda la cara.
    if frontness>.65:points[2]=(x*.105,.025+y*.117,1.70)
    locks.append(tube('Mechon oscuro '+str(i),points,[(.012,.006),(.020,.008),(.017,.007),(.001,.001)],hairmid if i%3 else hairlight,'Head',10))
# Flequillo barrido asimétrico y mechón ceniza pegados al volumen del cráneo.
tube('Flequillo barrido',[(.065,-.052,1.77),(.025,-.101,1.747),(-.028,-.113,1.708),(-.077,-.092,1.641)],[(.017,.007),(.025,.009),(.021,.008),(.001,.001)],charcoal,'Head',12)
tube('Mechon gris',[(.032,-.066,1.778),(.005,-.101,1.747),(-.037,-.111,1.70),(-.080,-.085,1.635)],[(.012,.005),(.016,.006),(.012,.006),(.001,.001)],gray,'Head',12)
# Implante lateral integrado y líneas de mandíbula, con espesor milimétrico.
plate=[(-.091,.045,1.69),(-.095,-.005,1.687),(-.096,-.032,1.657),(-.09,-.018,1.607),(-.081,.017,1.575),(-.084,.048,1.60)]
mesh('Implante sien derecha',plate,[(0,1,2),(0,2,5),(2,3,4),(2,4,5)],darkmetal,'Head',.003)
tube('Canal implante',[(x-.002,y,z) for x,y,z in plate[:4]],.0015,metal,'Head',8)
tube('Luz implante',[(-.098,-.009,1.68),(-.099,-.026,1.66),(-.095,-.015,1.63)],.0011,amber,'Head',8)
tube('Modulo mandibula',[(-.081,.02,1.58),(-.079,-.002,1.557),(-.062,-.02,1.535)],.0025,darkmetal,'Head',8)
# Unir mechones oscuros por material para evitar una llamada de dibujo por mechón.
for o in new:
    o.select_set(False)
for o in locks:o.select_set(True)
bpy.context.view_layer.objects.active=locks[0];bpy.ops.object.join();locks[0].name='Mechones oscuros'
# Selección explícita: el auxiliar Icosphere del archivo fuente no forma parte de Sota.
bpy.ops.object.select_all(action='DESELECT')
for o in bpy.context.scene.objects:
    if o==rig or (o.type=='MESH' and o.parent==rig):o.select_set(True)
bpy.context.view_layer.objects.active=rig
bpy.ops.wm.save_as_mainfile(filepath=str(HERE/'sota.blend'))
bpy.ops.export_scene.gltf(filepath=str(ROOT/'godot_ilustrado/assets/sota_3d_v3/sota.glb'),export_format='GLB',use_selection=True,export_animations=False,export_skins=True,export_morph=False)
print('Sota v3 candidata exportada; 65 huesos originales.')
