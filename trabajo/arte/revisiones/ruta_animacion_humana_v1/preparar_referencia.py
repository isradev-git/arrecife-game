"""Prueba aislada: cinemática directa ASF/AMC; no altera Sota ni corrige la captura."""
import json, math, re
from pathlib import Path
BASE = Path(__file__).resolve().parent

def mul(a,b): return [[sum(a[i][k]*b[k][j] for k in range(3)) for j in range(3)] for i in range(3)]
def vec(a,v): return [sum(a[i][k]*v[k] for k in range(3)) for i in range(3)]
def transpose(a): return list(map(list,zip(*a)))
def rotation(values):
    x,y,z=map(math.radians,values)
    cx,sx,cy,sy,cz,sz=math.cos(x),math.sin(x),math.cos(y),math.sin(y),math.cos(z),math.sin(z)
    return mul(mul([[cz,-sz,0],[sz,cz,0],[0,0,1]],[[cy,0,sy],[0,1,0],[-sy,0,cy]]),[[1,0,0],[0,cx,-sx],[0,sx,cx]])

text=(BASE/'referencia_cmu/07.asf').read_text()
bones={}
for block in re.findall(r'\bbegin\b(.*?)\bend\b',text.split(':bonedata')[1].split(':hierarchy')[0],re.S):
    fields={line.split()[0]:line.split()[1:] for line in block.splitlines() if line.strip()}
    name=fields['name'][0]
    bones[name]={'direction':list(map(float,fields['direction'])),'length':float(fields['length'][0]),'axis':rotation(map(float,fields['axis'][:3])),'dof':fields.get('dof',[])}
parents={}
for line in text.split(':hierarchy')[1].splitlines():
    words=line.split()
    if words and words[0] not in ['begin','end']:
        for child in words[1:]: parents[child]=words[0]
assert len(parents)==len(bones)==30
clips=[]
for name,label in [('07_01','Marcha natural · CMU 07_01'),('07_04','Marcha lenta · CMU 07_04')]:
    frames=[]
    for line in (BASE/f'referencia_cmu/{name}.amc').read_text().splitlines():
        words=line.split()
        if not words or words[0].startswith(('#',':')): continue
        if words[0].isdigit(): frames.append({})
        else: frames[-1][words[0]]=list(map(float,words[1:]))
    poses=[]
    max_error=0
    for frame in frames:
        points={'root':frame['root'][:3]}; matrices={'root':rotation(frame['root'][3:])}
        def resolve(name):
            if name in points:return
            bone=bones[name];parent=parents[name];resolve(parent)
            angles={'rx':0,'ry':0,'rz':0};angles.update(zip(bone['dof'],frame.get(name,[])))
            local=mul(mul(bone['axis'],rotation([angles['rx'],angles['ry'],angles['rz']])),transpose(bone['axis']))
            matrices[name]=mul(matrices[parent],local)
            offset=vec(matrices[name],[v*bone['length'] for v in bone['direction']])
            points[name]=[points[parent][i]+offset[i] for i in range(3)]
        for bone in bones:resolve(bone)
        for bone in bones:
            length=math.dist(points[bone],points[parents[bone]])
            max_error=max(max_error,abs(length-bones[bone]['length']))
            assert all(math.isfinite(v) for v in points[bone])
        poses.append(points)
    assert max_error<0.0001
    start,end=poses[0]['root'],poses[-1]['root']
    forward=[end[0]-start[0],end[2]-start[2]]
    norm=math.hypot(*forward);forward=[v/norm for v in forward]
    floor=min(p[j][1] for p in poses for j in ['ltoes','rtoes','lfoot','rfoot'])
    top=max(p['head'][1] for p in poses)
    scale=240/(top-floor) # Margen de cráneo de 12 px; escala constante de toda la toma.
    result=[]
    for p in poses:
        root=p['root']
        points={k:[round(((v[0]-root[0])*forward[0]+(v[2]-root[2])*forward[1])*scale,3),round((floor-v[1])*scale,3)] for k,v in p.items()}
        travel=((root[0]-start[0])*forward[0]+(root[2]-start[2])*forward[1])*scale
        result.append({'points':points,'travel':round(travel,3)})
    clips.append({'name':label,'fps':120,'frames':result})
    print(f'{name}: {len(poses)} muestras, {len(poses)/120:.3f} s, error de longitud 3D {max_error:.8f}, avance {result[-1]["travel"]:.1f} px')
(BASE/'captura.js').write_text('const CAPTURAS='+json.dumps(clips,separators=(',',':'))+';\n')

# Selección de trabajo del 17 de octubre: conservar las muestras capturadas sin mezclarlas.
f=clips[1]['frames']; start=211; period=170
keys=[]
for i in range(8):
    index=start+round(i*period/8)
    keys.append({'clave':i+1,'fase':i/8,'muestra_amc':index+1,'points':f[index]['points']})
names=['root','head','thorax','lhipjoint','rhipjoint','lfemur','rfemur','ltibia','rtibia','ltoes','rtoes','lhumerus','rhumerus','lradius','rradius']
errors=[math.dist(f[start]['points'][k],f[start+period]['points'][k]) for k in names]
cycle={'fuente':'CMU 07_04','inicio_indice':start,'periodo_muestras':period,'frecuencia':120,'duracion_segundos':period/120,'distancia_capturada_px':f[start+period]['travel']-f[start]['travel'],'error_cierre_max_px':max(errors),'error_cierre_rms_px':math.sqrt(sum(v*v for v in errors)/len(errors)),'nota':'Guía de dibujo sin adaptación a Sota. Ocho muestras del ciclo humano; el cierre conserva un corte residual, no es un bucle final.','claves':keys}
assert len(keys)==8 and all(keys[i]['muestra_amc']<keys[i+1]['muestra_amc'] for i in range(7))
(BASE/'ocho_claves.json').write_text(json.dumps(cycle,ensure_ascii=False,indent=2)+'\n')
(BASE/'ocho_claves.js').write_text('const CICLO='+json.dumps(cycle,ensure_ascii=False,separators=(',',':'))+';\n')
print(f'Ocho claves, muestras {[k["muestra_amc"] for k in keys]}; cierre sin corregir {max(errors):.3f} px')
