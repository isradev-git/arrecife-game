"""Retarget angular de CMU 07_04. La fuente humana y los recursos anteriores se conservan."""
import json, math
from pathlib import Path
ROOT = Path(__file__).resolve().parents[4]
SOURCE = ROOT/'trabajo/arte/revisiones/ruta_animacion_humana_v1/captura.js'
OUT = ROOT/'godot/assets/personajes/sota/captura_v16_candidata/ciclo.json'
frames = json.loads(SOURCE.read_text().removeprefix('const CAPTURAS=').strip().removesuffix(';'))[1]['frames'][211:381]

def angle(p,a,b):
    return math.atan2(p[b][1]-p[a][1],p[b][0]-p[a][0])

def fourier(values):
    # Ocho armónicos conservan el gesto y cierran valor y velocidad sin empalme de fotogramas.
    n=len(values)
    return [sum(values)/n]+[[2*sum(v*math.cos(k*i*math.tau/n) for i,v in enumerate(values))/n,2*sum(v*math.sin(k*i*math.tau/n) for i,v in enumerate(values))/n] for k in range(1,9)]

channels={}
for s in 'lr':
    for name,a,b in [('muslo','hipjoint','femur'),('tibia','femur','tibia'),('bota','tibia','foot'),('brazo','clavicle','humerus'),('antebrazo','humerus','radius')]:
        channels[s+'_'+name]=fourier([angle(f['points'],s+a,s+b) for f in frames])
channels['tronco']=fourier([angle(f['points'],'root','thorax') for f in frames])

def evaluate(coeff,p):
    return coeff[0]+sum(a*math.cos(k*p*math.tau)+b*math.sin(k*p*math.tau) for k,(a,b) in enumerate(coeff[1:],1))

for coeff in channels.values():
    assert abs(evaluate(coeff,0)-evaluate(coeff,1))<1e-12
    assert all(math.isfinite(evaluate(coeff,i/2048)) for i in range(2049))
result={'fuente':'CMU 07_04, muestras AMC 212–381','canales':channels,'nota':'Ángulos humanos periódicos; vestuario v7 existente, pendiente de acabado por poses. No aprobación artística.'}
OUT.write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
print('OK: 11 canales humanos periódicos, 2049 muestras finitas por canal. Fuente CMU intacta.')
