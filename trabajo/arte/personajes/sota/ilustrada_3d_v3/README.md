# Sota 3D v3 · candidata para plano de entorno

19 de octubre de 2026. El autor rechazó la v2 por parecido insuficiente, aspecto poligonal y cyberdeck desconectado. Pidió cámara lejana y protagonismo del entorno. **La v3 es una candidata nueva, sin aprobación artística.**

## Cambios reales

- Chaqueta y mangas como superficie continua, unión volumétrica de hombros/axilas y reducción de topología antes de ponderar. Cuello, solapas, broches y puños con volumen. La zona de prenda interior usa una transición de color continua en la superficie exterior; no se superponen recortes del sprite.
- Transferencia de pesos por punto más próximo y coordenadas baricéntricas sobre los triángulos de la fuente. Evita el salto de pesos que producía la interpolación por distancia entre unos pocos vértices. Se conservan los 65 huesos y su reposo.
- Pantalón suavizado, bolsillo exterior conservado y costuras discretas. Botas con cubiertas y cañas: se conservan los vértices de la suela anterior y se transfieren pesos de pie/tobillo a las cubiertas.
- Arnés cerrado por frente, hombro y espalda hasta un anclaje real en el deck. El tramo superior se ajusta a la superficie de la chaqueta. La unión al aparato comparte los pesos de pelvis, sin cambiarlo de lado al girar.
- Pelo de superficie curva y mechones, flequillo asimétrico y gris integrado por material; ojos, labios y marca de mejilla revisados. Implantes ajustados a la piel y sus pesos para evitar piezas flotantes.
- Materiales de superficie suave y luz, sin el pase de contorno que acentuaba facetas/intersecciones. Color por vértice importado explícitamente en Godot para conservar la paleta de chaqueta y prenda interior.

No se modifican clips, velocidad, root motion, controlador horizontal ni el retarget nativo. No hay simulación de tela o pelo ni animación facial.

## Recursos y reproducción

`crear_sota.py` abre la fuente v2, conserva rig/manos/suelas y construye la candidata. Blender 4.5.3 LTS, sin plugins. Desde la raíz:

```sh
blender --background --factory-startup --python trabajo/arte/personajes/sota/ilustrada_3d_v3/crear_sota.py
```

Salida editable `sota.blend`; [GLB activo](../../../../../godot_ilustrado/assets/sota_3d_v3/sota.glb). El script sobrescribe sólo v3; conservar otra versión antes de futuras revisiones. `intento_01`–`intento_03` y `.blend1` conservan ensayos; no son entregas aprobadas. V1/v2 y sus generadores permanecen intactos. `ilustrada_3d_v2/cuerpo_godot_v2.gd` conserva el render anterior.

[Evidencias y pruebas](../../../revisiones/sota_entorno_3d_v3/README.md). Malla base Quaternius CC0; fuentes/licencias originales conservadas en `trabajo/arte/terceros/quaternius_20261018`.

## Límites

La dirección viene del retrato, pero el parecido facial, el pelo, el acabado de materiales y las deformaciones de ropa todavía requieren valoración artística del autor. No se declara modelado final ni calidad profesional alcanzada. El personaje se revisa también de cerca; el plano lejano no sustituye esa revisión.
