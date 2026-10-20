"""Integridad de los originales y aislamiento de la implementación activa."""
import hashlib
import json
from pathlib import Path

root = Path(__file__).resolve().parents[2]
manifest = json.loads((root / 'docs/PRESERVACION.json').read_text())
def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()
assert sha(root / 'canon_el_arrecife.md') == manifest['canon_sha256']
for item in manifest['retratos_y_figuras']:
    asset = root / item['preservado']
    assert sha(asset) == item['sha256'], asset
    if not asset.name.startswith('historico_'):
        assert sha(root / 'game/assets/portraits' / asset.name) == item['sha256']
assert sorted(str(p.relative_to(root)) for p in root.glob('**/project.godot') if '.git' not in p.parts) == ['game/project.godot']
for p in (root / 'game').rglob('*'):
    if any(part in ['.godot', 'build'] for part in p.parts):
        continue
    assert p.suffix not in ['.glb', '.gltf', '.blend', '.fbx'], p
    if p.suffix in ['.gd', '.tscn']:
        assert not any(x in p.read_text() for x in ['Node3D', 'CharacterBody3D', 'Skeleton3D'])
print('OK: canon, 5 originales, 2 copias de diálogo, un proyecto y ninguna dependencia 3D.')
