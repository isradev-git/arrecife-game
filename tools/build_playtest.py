#!/usr/bin/env python3
"""Genera una entrega Web privada desde el código actual."""

import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import zipfile


ROOT = Path(__file__).resolve().parent.parent
GAME = ROOT / "game"
BUILD = GAME / "build"
STAGE = BUILD / "playtest-web"
FILES = (
    "index.html",
    "index.js",
    "index.pck",
    "index.wasm",
    "index.png",
    "index.audio.worklet.js",
    "index.audio.position.worklet.js",
)


def output(*args):
    return subprocess.check_output(args, cwd=ROOT, text=True).strip()


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for chunk in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main():
    godot = os.environ.get("GODOT_BIN") or shutil.which("godot")
    if not godot and Path("/Applications/Godot.app/Contents/MacOS/Godot").is_file():
        godot = "/Applications/Godot.app/Contents/MacOS/Godot"
    if not godot:
        raise SystemExit("Falta Godot 4.7.2; indica su ruta con GODOT_BIN.")
    engine = subprocess.check_output([godot, "--version"], text=True).strip()
    if not engine.startswith("4.7.2."):
        raise SystemExit(f"Se requiere Godot 4.7.2; encontrado: {engine}")
    project = (GAME / "project.godot").read_text()
    version = re.search(r'^config/version="([^"]+)"$', project, re.MULTILINE)
    if not version:
        raise SystemExit("No se encuentra config/version en project.godot.")
    version = version.group(1)
    commit = output("git", "rev-parse", "--short=8", "HEAD")
    dirty = bool(output("git", "status", "--porcelain", "--untracked-files=normal"))

    BUILD.mkdir(exist_ok=True)
    shutil.rmtree(STAGE, ignore_errors=True)
    STAGE.mkdir()
    subprocess.run([godot, "--headless", "--path", str(GAME), "--editor", "--import", "--quit"], check=True)
    subprocess.run([godot, "--headless", "--path", str(GAME), "--export-release", "Web", "build/playtest-web/index.html"], check=True)
    for name in FILES:
        if not (STAGE / name).is_file() or (STAGE / name).stat().st_size == 0:
            raise SystemExit(f"La exportación no produjo {name}.")

    guide = ROOT / "docs" / "LEEME_PRUEBA.md"
    paths = {name: STAGE / name for name in FILES}
    paths["LEEME_PRUEBA.md"] = guide
    manifest = {
        "version": version,
        "godot": engine,
        "commit": commit,
        "dirty": dirty,
        "sha256": {name: sha256(path) for name, path in paths.items()},
    }
    label = f"el-arrecife-{version}-{commit}{'-dirty' if dirty else ''}-web"
    archive = BUILD / f"{label}.zip"
    temp = archive.with_suffix(".zip.tmp")
    try:
        with zipfile.ZipFile(temp, "w") as package:
            for name, path in paths.items():
                info = zipfile.ZipInfo(name, (2020, 1, 1, 0, 0, 0))
                info.compress_type = zipfile.ZIP_DEFLATED
                info.external_attr = 0o644 << 16
                with path.open("rb") as source, package.open(info, "w") as target:
                    shutil.copyfileobj(source, target)
            info = zipfile.ZipInfo("MANIFEST.json", (2020, 1, 1, 0, 0, 0))
            info.compress_type = zipfile.ZIP_DEFLATED
            package.writestr(info, json.dumps(manifest, indent=2, ensure_ascii=False) + "\n")
        temp.replace(archive)
    finally:
        temp.unlink(missing_ok=True)
    checksum = sha256(archive)
    archive.with_suffix(".zip.sha256").write_text(f"{checksum}  {archive.name}\n")
    print(f"Paquete: {archive}\nSHA-256: {checksum}\nGodot: {engine}\nCommit: {commit}{' (sucio)' if dirty else ''}")


if __name__ == "__main__":
    main()
