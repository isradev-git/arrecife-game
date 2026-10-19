# Piel v6 · moreno suave

19 octubre 2026. El autor rechaza la piel demasiado oscura de v5 y precisa que Sota es sólo ligeramente morena.

- [Rostro cercano](v6_cabeza.png).
- [Brazos y rostro](v6_chaqueta.png).
- [V5 anterior, misma iluminación y pose](../sota_prendas_3d_v5/v5_chaqueta.png).
- [Resultados](validacion.txt), [fuente editable](../../personajes/sota/ilustrada_3d_v6/README.md).

Se retira el color de vértices de piel y se usa un material cálido `#c8a17e`; no se altera la luz del estudio. La primera hipótesis de doble pigmento se descartó inspeccionando el GLB. La diferencia se reproduce entre material uniforme y color de vértices en Compatibility. La documentación de [BaseMaterial3D](https://docs.godotengine.org/en/4.4/classes/class_basematerial3d.html#class-basematerial3d-property-vertex-color-is-srgb) señala que el ajuste de conversión sRGB de vértices no tiene efecto en ese renderizador.

La prueba nativa de modelo pasa y las capturas se inspeccionan. Sin cambios de geometría, rig, ropa, clips, controlador o cámara. V5/fuentes/mapas intactos por SHA256. No se repiten pruebas físicas completas por un cambio de material. Tono pendiente de valoración artística. `ensayo_01/` conserva el primer ajuste, aún demasiado oscuro.
