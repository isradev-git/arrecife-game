# Sota v5 · prendas construidas y texturizadas

19 octubre 2026. El autor señala [esta captura concreta](../../../revisiones/sota_retrato_3d_v4/ensayo_01/v4_cabeza.png) como parecido cercano a Sota. La v5 recupera esa configuración de pelo/rostro y trabaja el vestuario. **No equivale a una aprobación artística del modelo completo.** Movimiento aprobado, clips, rig, retarget, velocidad y cámara conservados.

## Qué cambia

- Chaqueta con **abertura frontal real** que deja ver una prenda interior independiente. Se retira la simulación de camiseta mediante color sobre el exterior. Piel/manos no se recolorean como ropa.
- Espesor de chaqueta de 4 mm, solapas y paneles con 3,5 mm, puños, cantos y costura exterior; arrugas geométricas de cintura/manga. Superficie exterior e interior separadas físicamente.
- Pantalón cargo con holgura en pierna, pliegues, caída suavizada y espesor de 2,5 mm. Se conserva la unión de pelvis/entrepierna.
- Cubiertas de botas con más volumen, lengüeta, cordones y suela continua con cantos redondeados. La puntera tiene curvatura para no invadir el suelo durante el rodado. La base de apoyo articulada anterior se conserva dentro del calzado.
- Seis materiales con mapas UV propios de **color, rugosidad y normal tangente**: cuero de chaqueta, sarga cargo, cuero de botas, goma, lona y tejido interior. Grano irregular discreto; sin efecto de cuadrícula en cuero. Texturas PNG de 256/512 px, incluidas en el GLB; no nodos procedurales necesarios en ejecución.

## Reproducir

`crear_sota.py` conserva la receta de aspecto de la captura elegida, sobre el `.blend` v3. Antes de exportar ejecuta `acabado_prendas.py`: construye las prendas y genera los mapas con NumPy incluido en Blender. Sin plugins ni dependencia nueva de ejecución. `sota.blend` es la fuente editable.

```sh
Blender --background --python trabajo/arte/personajes/sota/ilustrada_3d_v5/crear_sota.py
```

Salida: `godot_ilustrado/assets/sota_3d_v5/sota.glb` y `texturas/*.png`. Base Quaternius CC0 y originales conservados [aquí](../../../terceros/quaternius_20261018/README.md). No se han generado imágenes con IA ni sustituido el diseño completo de Sota.

## Validación y límites

[Capturas cercanas, comparación y resultados](../../../revisiones/sota_prendas_3d_v5/README.md). El generador comprueba finitud, pesos normalizados, 65 huesos y geometría intacta de manos y soporte original. Godot comprueba rig, mapas/UV, retarget, equipo y contacto renderizado, incluyendo la suela nueva. El calzado cambia de volumen, por lo que no se afirma que todas sus superficies coincidan con v4.

La textura no resuelve por sí sola anatomía, ajuste de patronaje ni parecido. La base sigue necesitando valoración artística del autor; las prendas no incluyen simulación física de tela. Contacto probado en marcha estable, con cobertura parcial del rodado y transiciones. Primeros ensayos defectuosos conservados e identificados en las evidencias.
