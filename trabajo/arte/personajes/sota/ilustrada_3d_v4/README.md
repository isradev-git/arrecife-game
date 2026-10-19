# Sota 3D v4 · revisión de identidad

19 octubre 2026. Candidata de aspecto sobre [v3](../ilustrada_3d_v3/README.md), preservada. El autor aprueba el movimiento actual y pide más definición y parecido al [retrato original](../../../../../godot/assets/personajes/sota/retrato_dialogo_v1.png). El modelo v4 todavía no tiene aprobación artística.

## Cambios

- Corte oscuro por capas, oreja/sien derechas descubiertas y mecha gris lateral plana, con dos planos de color. Sustituye el casquete/mecha horizontal anteriores.
- Párpados, marcas faciales y ajustes discretos de mandíbula/nariz. Piel y labios revisados; no es una reconstrucción exacta del rostro del retrato.
- Implante de sien con borde/canal y placa de cuello; siguen el lado anatómico y no se reflejan al girar.
- Cuello más alto, solapas angulares, bolsillos, parche de manga y paleta de cuero más legible. Correa suavizada antes de deformar, con pesos y conexión al anclaje conservados.
- Cámara de juego de 22 a 24 m, FOV 29°, sin cambiar escala del personaje.

## Fuentes y reproducción

`sota.blend` es la fuente editable; `crear_sota.py` abre el `.blend` v3 y aplica esta revisión. Exporta `godot_ilustrado/assets/sota_3d_v4/sota.glb`, sin animaciones propias. Ejecutar con Blender 4.5.3:

```sh
Blender --background --python trabajo/arte/personajes/sota/ilustrada_3d_v4/crear_sota.py
```

Conserva la base Quaternius CC0 y su licencia [registrada](../../../terceros/quaternius_20261018/README.md). Sin nuevas dependencias de ejecución ni imágenes generadas con IA. Huesos, clips, retarget y controlador siguen siendo los del movimiento aprobado. El generador comprueba pesos, finitud, huesos válidos y geometría intacta de manos/botas. Godot compara además reposos/jerarquía del rig y todos los arrays de botas con v3.

## Revisión

[Capturas cercanas y a escala de juego, resultados y límites](../../../revisiones/sota_retrato_3d_v4/README.md). Los primeros renders fallidos se conservan como ensayos. El parecido y el acabado ilustrado siguen sujetos a valoración del autor: añadir geometría no certifica calidad profesional. La pasarela es un entorno técnico, sin contenido narrativo definitivo.
