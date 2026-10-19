"""Prepara recursos mínimos del laboratorio a partir de los ZIP originales CC0."""
import json,struct,hashlib
from pathlib import Path
from zipfile import ZipFile
ROOT=Path(__file__).resolve().parent
SOURCE=ROOT.parent/'trabajo/arte/terceros/quaternius_20261018'
with ZipFile(SOURCE/'universal-animation-library.zip') as z:
    data=z.read(next(n for n in z.namelist() if n.endswith('/UAL1_Standard_RM.glb')))
    length=struct.unpack_from('<I',data,12)[0]
    scene=json.loads(data[20:20+length])
    scene['animations']=[a for a in scene['animations'] if a['name'] in ['Walk_Loop','Idle_Loop']]
    assert len(scene['animations'])==2
    encoded=json.dumps(scene,separators=(',',':')).encode()
    encoded+=b' '*((-len(encoded))%4)
    binary=data[20+length:]
    result=struct.pack('<III',0x46546c67,2,20+len(encoded)+len(binary))+struct.pack('<II',len(encoded),0x4e4f534a)+encoded+binary
    (ROOT/'assets/base/locomocion.glb').write_bytes(result)
with ZipFile(SOURCE/'universal-base-characters.zip') as z:
    for suffix in ['Superhero_Female_FullBody.bin','Superhero_Female_FullBody.gltf']:
        data=z.read(next(n for n in z.namelist() if n.endswith('Godot - UE/'+suffix)))
        if suffix.endswith('gltf'):
            scene=json.loads(data)
            for key in ['images','textures','samplers']:scene.pop(key,None)
            for material in scene['materials']:
                material.clear()
                material.update({'name':'Material_neutro','pbrMetallicRoughness':{'baseColorFactor':[0.15,0.22,0.28,1.0],'metallicFactor':0,'roughnessFactor':0.9}})
            data=json.dumps(scene,separators=(',',':')).encode()
        (ROOT/'assets/base'/suffix).write_bytes(data)
for name in ['universal-base-characters','universal-animation-library']:
    print(name,hashlib.file_digest((SOURCE/(name+'.zip')).open('rb'),'sha256').hexdigest())
print('Preparadas malla humana y sólo reposo/marcha con root motion. Fuentes originales intactas.')
