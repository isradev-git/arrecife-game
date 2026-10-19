"""Construcción de prendas y mapas UV propios; ejecutado por crear_sota.py."""
import bmesh
import numpy as np
from mathutils import kdtree

TEXTURES=ROOT/'godot_ilustrado/assets/sota_3d_v5/texturas'
TEXTURES.mkdir(parents=True,exist_ok=True)

def image_map(name, values, color=False):
    h,w=values.shape[:2]
    pixels=np.ones((h,w,4),dtype=np.float32)
    pixels[:,:,:3]=values[:,:,None] if values.ndim==2 else values
    im=bpy.data.images.new(name,width=w,height=h,alpha=False)
    im.colorspace_settings.name='sRGB' if color else 'Non-Color'
    im.pixels.foreach_set(pixels.ravel()); im.update()
    im.filepath_raw=str(TEXTURES/(name+'.png')); im.file_format='PNG'; im.save()
    return im

def textile(name, color, kind, roughness, size=512):
    # Mapas periódicos: albedo, rugosidad y normal tangente, sin recursos externos.
    v,u=np.mgrid[0:size,0:size].astype(np.float32)/size
    tau=math.tau
    rng=np.random.default_rng(517)
    freq=np.fft.fftfreq(size)
    radius=freq[:,None]**2+freq[None,:]**2
    def noise(cutoff):
        values=np.fft.ifft2(np.fft.fft2(rng.standard_normal((size,size)))*np.exp(-radius/cutoff**2)).real
        return values/max(.001,values.std())/3
    broad=noise(.016)
    grain=noise(.28)
    weave=np.sin(tau*u*128)*np.sin(tau*v*128)
    if kind=='cuero':
        height=.50+.09*grain+.12*broad
        wear=np.maximum(0,np.sin(tau*(u*13+v*3))+np.sin(tau*v*19)-1.55)
        value=1+.05*broad+.018*grain+.04*wear
        strength=.45
    elif kind=='cargo':
        height=.5+.12*weave+.035*grain
        value=1+.04*broad+.008*weave
        strength=.32
    elif kind=='lona':
        height=.5+.17*np.sin(tau*u*96)*np.sin(tau*v*48)
        value=1+.04*broad+.06*weave
        strength=.4
    else:
        height=.5+.045*grain
        value=1+.035*broad+.02*grain
        strength=.22
    rgb=np.array([int(color[i:i+2],16)/255 for i in (0,2,4)])
    albedo=image_map(name+'_color',np.clip(value[:,:,None]*rgb,0,1),True)
    rough=image_map(name+'_rugosidad',np.clip(roughness+.045*broad+.045*grain,0,1))
    dx=(np.roll(height,-1,1)-np.roll(height,1,1))*strength
    dy=(np.roll(height,-1,0)-np.roll(height,1,0))*strength
    normal=np.stack((-dx,-dy,np.ones_like(dx)),axis=2)
    normal/=np.linalg.norm(normal,axis=2,keepdims=True)
    normals=image_map(name+'_normal',normal*.5+.5)
    mat=bpy.data.materials.new(name); mat.use_nodes=True; mat.diffuse_color=(*rgb,1)
    nodes=mat.node_tree.nodes; links=mat.node_tree.links; p=nodes.get('Principled BSDF')
    for im,socket in [(albedo,'Base Color'),(rough,'Roughness')]:
        node=nodes.new('ShaderNodeTexImage'); node.image=im
        links.new(node.outputs['Color'],p.inputs[socket])
    node=nodes.new('ShaderNodeTexImage'); node.image=normals
    normalnode=nodes.new('ShaderNodeNormalMap'); normalnode.inputs['Strength'].default_value=.5
    links.new(node.outputs['Color'],normalnode.inputs['Color']); links.new(normalnode.outputs['Normal'],p.inputs['Normal'])
    assert float(np.std(value))>.005 and np.isfinite(normal).all()
    return mat

leather=textile('Cuero chaqueta','8d4831','cuero',.69)
canvas=textile('Sarga cargo','44483b','cargo',.92)
bootleather=textile('Cuero botas','303238','cuero',.68)
rubber=textile('Goma suela','1e2226','goma',.96,256)
webbing=textile('Lona arnes','b6a88c','lona',.9,256)
knit=textile('Tejido interior','292a2e','cargo',.98,256)
seam_mat=material('Pespunte v5','a37a58',0,.95)
welt_mat=material('Canto prenda v5','4b3329',0,.85)

def uv_material(o,mat,unwrap=True):
    o.data.materials.clear(); o.data.materials.append(mat)
    for p in o.data.polygons: p.material_index=0
    for layer in list(o.data.color_attributes): o.data.color_attributes.remove(layer)
    if unwrap:
        bpy.ops.object.select_all(action='DESELECT'); o.select_set(True); bpy.context.view_layer.objects.active=o
        while o.data.uv_layers: o.data.uv_layers.remove(o.data.uv_layers[0])
        o.data.uv_layers.new(name='PrendaUV')
        bpy.ops.object.mode_set(mode='EDIT'); bpy.ops.mesh.select_all(action='SELECT')
        bpy.ops.uv.smart_project(angle_limit=math.radians(75),island_margin=.025)
        bpy.ops.object.mode_set(mode='OBJECT')

def solidify(o,thickness):
    mod=o.modifiers.new('Espesor prenda','SOLIDIFY'); mod.thickness=thickness; mod.offset=-1
    mod.use_even_offset=False
    # Construir espesor en reposo, antes de deformar con el rig.
    bpy.context.view_layer.objects.active=o
    while list(o.modifiers).index(mod)>0: bpy.ops.object.modifier_move_up(modifier=mod.name)
    bpy.ops.object.modifier_apply(modifier=mod.name)

# El hueco frontal deja ver una prenda interior independiente, con aire entre capas.
source_points=[v.co.copy() for v in coat.data.vertices]
coat.data.calc_loop_triangles()
source_faces=[tuple(t.vertices) for t in coat.data.loop_triangles]
vertices=[]; faces=[]
def clip(poly,field):
    output=[]
    for a,b in zip(poly,poly[1:]+poly[:1]):
        fa,fb=field(a),field(b)
        if fa>=0: output.append(a)
        if (fa>=0)!=(fb>=0): output.append(a+(b-a)*(fa/(fa-fb)))
    return output
for face in source_faces:
    points=[source_points[i] for i in face]
    points=clip(points,lambda p:p.z-1.048)
    if len(points)<3: continue
    center=sum(points,Vector())/len(points)
    pieces=[points]
    if center.y<-.032 and abs(center.x)<.13:
        pieces=[clip(points,lambda p,s=s:s*p.x-(.035+max(0,p.z-1.05)*.12)) for s in [-1,1]]
    for polygon in pieces:
        if len(polygon)<3: continue
        ids=list(range(len(vertices),len(vertices)+len(polygon)))
        vertices.extend(polygon); faces.append(ids)
oldcoat=coat
coat=mesh('Chaqueta nueva',vertices,faces,leather)
bm=bmesh.new(); bm.from_mesh(coat.data); bmesh.ops.remove_doubles(bm,verts=list(bm.verts),dist=.000001)
bm.normal_update(); bm.to_mesh(coat.data); bm.free(); coat.data.update()
# Pliegues amplios: compresión de cintura y manga; no tocar el rig ni escalar huesos.
for v in coat.data.vertices:
    p=v.co; normal=v.normal
    waist=math.exp(-((p.z-1.115)/.055)**2)*max(0,1-abs(p.x)/.24)
    sleeve=math.exp(-((abs(p.x)-.375)/.07)**2)*math.exp(-((p.z-1.418)/.09)**2)
    fold=.0038*waist*math.sin(p.z*120+abs(p.x)*32)+.0045*sleeve*math.sin(abs(p.x)*135+(p.z-1.418)*28)
    v.co+=normal*fold
coat.data.update()
bpy.data.objects.remove(oldcoat,do_unlink=True); coat.name='Chaqueta'
coat.data.materials.append(knit); coat.data.materials.append(welt_mat)
solidify(coat,.004)
# La camiseta queda detrás de la abertura, sin colorear la superficie exterior.
uv_material(coat,leather)
uv_material(bpy.data.objects['Prenda interior'],knit)

# Volumen de tela y arrugas que siguen la deformación existente del pantalón.
pants=bpy.data.objects['Pantalon']; pants.data.update()
for v in pants.data.vertices:
    p=v.co
    if abs(p.x)<.065 and p.z>.73: continue
    if .20<p.z<.72:
        t=max(0,min(1,(p.z-.22)/.5))
        rx=.052+.033*t; ry=.058+.033*t
        cx=math.copysign(.1114,p.x)
        angle=math.atan2((p.y-.045)/ry,(p.x-cx)/rx)
        p.x=.35*p.x+.65*(cx+math.cos(angle)*rx)
        p.y=.35*p.y+.65*(.045+math.sin(angle)*ry)
    knee=math.exp(-((p.z-.51)/.10)**2)
    ankle=math.exp(-((p.z-.23)/.055)**2)
    fold=.003+knee*.0032*math.sin(p.z*104+abs(p.x)*30)+ankle*.0035*math.sin(p.z*160)
    p+=v.normal*fold
uv_material(pants,canvas)
relax=pants.modifiers.new('Caida de tela','SMOOTH'); relax.factor=.6; relax.iterations=5
bpy.context.view_layer.objects.active=pants
bpy.ops.object.modifier_move_up(modifier=relax.name); bpy.ops.object.modifier_apply(modifier=relax.name)
bm=bmesh.new(); bm.from_mesh(pants.data)
for v in bm.verts:
    if v.co.z<.25 and any(e.is_boundary for e in v.link_edges):
        cx=math.copysign(.12,v.co.x)
        a=math.atan2((v.co.y-.082)/.046,(v.co.x-cx)/.043)
        v.co=Vector((cx+.043*math.cos(a),.082+.046*math.sin(a),.16))
bm.to_mesh(pants.data); bm.free()
solidify(pants,.0025)
for name in ['Bolsillo exterior derecho','Tapa bolsillo']:
    uv_material(bpy.data.objects[name],canvas)
uv_material(bpy.data.objects['Correa diagonal'],webbing)
strap=bpy.data.objects['Correa diagonal']
sub=strap.modifiers.new('Continuidad cinta','SUBSURF'); sub.levels=2
bpy.context.view_layer.objects.active=strap; bpy.ops.object.modifier_move_up(modifier=sub.name); bpy.ops.object.modifier_apply(modifier=sub.name)
for o in list(bpy.context.scene.objects):
    if o.type!='MESH' or o.parent!=rig: continue
    if o.name.startswith(('Solapa retrato','Panel bolsillo','Cuello alto','Puno ','Tapa bolsillo ')):
        uv_material(o,leather)
        if o.name.startswith(('Solapa retrato','Panel bolsillo')): solidify(o,.0035)

# Botas: suela articulada intacta. Cuero y goma tienen materiales distintos.
boots=bpy.data.objects['Botas completas']
upper_ids={i for p in boots.data.polygons if p.material_index==1 for i in p.vertices}
for i in upper_ids:
    p=boots.data.vertices[i].co; cx=math.copysign(.12,p.x)
    p.x=cx+(p.x-cx)*1.12
    p.z+=.008*max(0,min(1,(p.z-.017)/.035))
for i,m in enumerate(list(boots.data.materials)):
    boots.data.materials[i]=rubber if i==0 else bootleather
# No cambiar UV ni vértices de la suela original; desplegar sólo las cubiertas nuevas.
bpy.ops.object.select_all(action='DESELECT'); boots.select_set(True); bpy.context.view_layer.objects.active=boots
boots.data.uv_layers.active_index=0
boots.data.uv_layers[0].active_render=True
bpy.context.tool_settings.mesh_select_mode=(False,False,True)
for p in boots.data.polygons: p.select=p.material_index>0
bpy.ops.object.mode_set(mode='EDIT'); bpy.ops.uv.smart_project(angle_limit=math.radians(75),island_margin=.025); bpy.ops.object.mode_set(mode='OBJECT')

# Cordones, lengüeta y cerco: geometría propia sobre la cubierta, nunca bajo la suela.
bootkd=kdtree.KDTree(len(boots.data.vertices))
for v in boots.data.vertices: bootkd.insert(v.co,v.index)
bootkd.balance()
def bind_boot(o):
    o.vertex_groups.clear()
    groups={b.name:o.vertex_groups.new(name=b.name) for b in rig.data.bones}
    for v in o.data.vertices:
        result={}
        for co,i,d in bootkd.find_n(v.co,4):
            for g in boots.data.vertices[i].groups:
                n=boots.vertex_groups[g.group].name; result[n]=result.get(n,0)+g.weight/max(d,.002)**2
        items=sorted(result.items(),key=lambda p:-p[1])[:4]; total=sum(w for n,w in items)
        for n,w in items: groups[n].add([v.index],w/total,'REPLACE')
    assert min(v.co.z for v in o.data.vertices)>-.009
bootparts=[]
for sign,side in [(-1,'r'),(1,'l')]:
    cx=sign*.122
    stations=[(-.132,.025,.105),(-.115,.044,.108),(-.085,.062,.12),(-.04,.063,.125),(.015,.057,.125),(.06,.05,.122),(.105,.044,.12),(.133,.024,.12)]
    contour=[(sign*c-r,y) for y,r,c in stations]+[(sign*c+r,y) for y,r,c in reversed(stations)]
    def sole_rise(y):
        return .011*max(0,(-y-.06)/.073)**2+.003*max(0,(y-.08)/.053)**2
    vs=[(x,y,z+sole_rise(y)) for z in [-.006,.014,.027] for x,y in contour]
    n=len(contour)
    fs=[(layer*n+j,layer*n+(j+1)%n,(layer+1)*n+(j+1)%n,(layer+1)*n+j) for layer in range(2) for j in range(n)]
    fs.extend([tuple(reversed(range(n))),tuple(range(2*n,3*n))])
    sole=mesh('Suela construida '+side,vs,fs,rubber,'foot_'+side)
    bevel=sole.modifiers.new('Canto de goma','BEVEL'); bevel.width=.0025; bevel.segments=3
    bpy.context.view_layer.objects.active=sole; bpy.ops.object.modifier_move_up(modifier=bevel.name); bpy.ops.object.modifier_apply(modifier=bevel.name)
    bind_boot(sole); uv_material(sole,rubber); bootparts.append(sole)
    tongue=mesh('Lengueta bota '+side,[(cx-.016,-.048,.089),(cx+.016,-.048,.089),(cx+.016,.06,.136),(cx-.016,.06,.136)],[(0,1,2,3)],bootleather,'foot_'+side)
    bind_boot(tongue); uv_material(tongue,bootleather); solidify(tongue,.002); bootparts.append(tongue)
    for j in range(5):
        y=-.04+j*.019; z=.093+j*.007
        o=tube('Cordones bota '+side+str(j),[(cx-.023,y,z),(cx,y+.007,z+.002),(cx+.023,y,z)],.0016,webbing,'foot_'+side)
        bind_boot(o); uv_material(o,webbing); bootparts.append(o)
    points=[]
    for j in range(33):
        a=math.tau*j/32; points.append((cx+math.cos(a)*.043,.002+math.sin(a)*.12,.024))
    o=tube('Cerco bota '+side,points,.0018,welt_mat,'foot_'+side); bind_boot(o); bootparts.append(o)

# Dobladillo y costura de borde exterior, siguiendo pesos de la superficie próxima.
for sign in [-1,1]:
    points=[]
    for j in range(30):
        z=1.055+j*.013
        if z>1.425: break
        x=sign*(.037+max(0,z-1.05)*.12)
        p,normal,index,distance=coat_bvh.find_nearest(Vector((x,-.14,z)))
        points.append(p+normal*.002)
    tube('Pespunte abertura '+str(sign),points,.0008,seam_mat)

# Ribetes y nuevos detalles se agrupan por prenda, manteniendo sus pesos.
def join_parts(parts,name):
    bpy.ops.object.select_all(action='DESELECT')
    for o in parts: o.select_set(True)
    bpy.context.view_layer.objects.active=parts[0]; bpy.ops.object.join(); parts[0].name=name
join_parts(bootparts,'Detalles calzado')

assert not coat.data.color_attributes
assert len(coat.data.uv_layers)>0 and len(pants.data.uv_layers)>0
print('Prendas: abertura frontal real, espesor 4 mm, pliegues geométricos y seis materiales UV con color/rugosidad/normal.')
