"""Comprueba el contenido real de una entrega Web privada."""

import hashlib
import json
import sys
import zipfile


EXPECTED = {
    "index.html",
    "index.js",
    "index.pck",
    "index.wasm",
    "index.png",
    "index.audio.worklet.js",
    "index.audio.position.worklet.js",
    "LEEME_PRUEBA.md",
    "MANIFEST.json",
}


with zipfile.ZipFile(sys.argv[1]) as package:
    assert set(package.namelist()) == EXPECTED
    manifest = json.loads(package.read("MANIFEST.json"))
    assert manifest["version"] == "0.2.0"
    assert manifest["godot"].startswith("4.7.2.")
    assert len(manifest["commit"]) >= 7
    assert set(manifest["sha256"]) == EXPECTED - {"MANIFEST.json"}
    for name, digest in manifest["sha256"].items():
        assert hashlib.sha256(package.read(name)).hexdigest() == digest, name
    assert "contrato" not in package.read("LEEME_PRUEBA.md").decode().lower()

print(f"Paquete verificado: {sys.argv[1]}")
