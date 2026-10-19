# Sota · primer estudio de cuerpo completo 3D

18 de octubre de 2026. La dirección ilustrada está aprobada por el autor; **este modelo concreto no está aprobado ni reproduce todavía el acabado del retrato**.

## Recursos

- `sota.blend`: fuente editable del modelo.
- `crear_sota.py`: construcción reproducible mediante Blender 4.5.3 LTS.
- [Modelo para Godot](../../../../../godot_ilustrado/assets/sota_3d_v1/sota.glb).
- [Revisión nativa, vídeo y Web](../../../revisiones/sota_ilustrada_3d_v1/README.md).
- `intento_01/` e `intento_02/`: fuentes previas conservadas; no son el modelo activo. El segundo conserva las suelas rígidas rechazadas por la prueba de contacto. `.blend1` conserva además el guardado anterior.

## Construcción

Base femenina de Quaternius Universal Base Characters Standard, licencia CC0; geometría original completa y licencia conservadas en [fuentes](../../../terceros/quaternius_20261018/README.md). No se generan imágenes del personaje ni se deforma el sprite anterior.

65 huesos. Chaqueta, prenda interior, pantalón y botas derivados de la topología corporal completa con sus pesos; se da volumen al pantalón, se abre la chaqueta sobre la prenda oscura y se construyen cuello, solapas y puños. Pelo volumétrico corto y mechón gris, hardware de sien/mandíbula, correa clara con pesos de la superficie próxima, bolsillo y cyberdeck en el lado físico derecho. La piel cubierta por la ropa se retira del modelo vestido para evitar superficies coincidentes, conservando cabeza/cuello y antebrazos/manos. La malla base original no se modifica.

Resultado exportado: **26 piezas de malla, 13908 vértices con pesos normalizados y 65 huesos**. No hay espejado para cambiar de dirección: gira el cuerpo completo, con su asimetría y el deck. Materiales de colores propios; en Godot se aplica sombreado toon y contorno. Ese tratamiento no equivale por sí solo al dibujo de los retratos.

Las primeras suelas de caja rígida penetraban hasta 39,49 mm al rodar el pie. Se retiran; la bota conserva la articulación y la superficie inferior de la malla de pie. Resultado actual medido: −4,952..+7,477 mm respecto al suelo en marcha estable. El volumen y el dibujo definitivo de las botas siguen pendientes.

## Reproducir

Con Blender instalado, desde la raíz del repositorio:

```sh
blender --background --factory-startup --python trabajo/arte/personajes/sota/ilustrada_3d_v1/crear_sota.py
```

El script requiere los recursos base preparados por `godot_ilustrado/preparar_fuentes.py`. Sobrescribe el estudio `sota.blend`/`sota.glb`; guardar una versión nueva antes de una revisión artística significativa.

Para esta entrega se usó Blender **4.5.3 LTS arm64**, descargado de `https://download.blender.org/release/Blender4.5/blender-4.5.3-macos-arm64.dmg`; SHA256 oficial cotejado: `73ea841053b55404bb3a71a9a22366f1f8821787fe5c899f8b55a7fff929d01b`. Se ejecutó desde una imagen montada en `/tmp`, sin instalar plugins ni añadir Blender al juego. No es necesario para ejecutar el GLB en Godot.

## Límites artísticos

Estudio inicial de anatomía/vestuario y movimiento: faltan parecido facial, pelo y mechones más trabajados, ajuste del cuello/solapas/puños, volumen y pliegues de la ropa, detalles de equipo, materiales y luz cercanos al retrato. Las proporciones de la base femenina no están aprobadas como Sota. No hay simulación de tela ni animación facial. Tampoco se declara acabado ilustrado final o marcha profesional terminada; faltan transiciones específicas y revisión del personaje a escala de escena.
