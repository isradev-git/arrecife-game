# Recursos de referencia y producción · Quaternius

Descargados de las páginas oficiales el 18 de octubre de 2026, versión gratuita Standard, sin cuenta ni pago. Se conservan los ZIP y las licencias completas; `.gdignore` impide importar estas fuentes en un proyecto Godot que abarque esta carpeta.

- [Universal Base Characters](https://quaternius.com/packs/universalbasecharacters.html), [distribución oficial](https://quaternius.itch.io/universal-base-characters). ZIP 128968391 bytes.
- [Universal Animation Library](https://quaternius.itch.io/universal-animation-library). Edición actual con root motion, biblioteca v3.0 según página oficial, publicada 16 junio 2026. ZIP 15904933 bytes.
- Licencia de ambos: **CC0 1.0 Universal**, permite uso personal, educativo y comercial. Licencias originales junto a los ZIP.

## SHA256 completos

- `universal-base-characters.zip`: `fdbf1804c90dfc1ea03e992bff7da2dfd1a79318e13270a660180f9308455f40`.
- `universal-animation-library.zip`: `cc73fc4e495b82958207316596317a3f40b9fa38065bde1027937452da537724`.

## Uso y modificaciones

Malla `Superhero_Female_FullBody` glTF/bin, geometría y pesos intactos. Se retiran las referencias a texturas y se usa material neutro. No se presenta esta base como diseño aprobado de Sota. Biblioteca `Unreal-Godot/UAL1_Standard_RM.glb`: sólo se conservan los clips Idle_Loop y Walk_Loop en el recurso de laboratorio; el ZIP íntegro queda como fuente. Binario de geometría/animación original sin alteraciones; se filtra la lista JSON de clips. Generación reproducible: `python3 godot_ilustrado/preparar_fuentes.py`.

La adaptación de esqueletos usa nodos de Godot, sin dependencia de un plugin: [RetargetModifier3D](https://docs.godotengine.org/en/stable/classes/class_retargetmodifier3d.html). No se comparten directamente canales entre esqueletos de reposo distintos: [documentación de retargeting](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/retargeting_3d_skeletons.html).
