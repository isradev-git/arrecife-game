# Velvet · Corrección del píxel de Sota

11 de octubre de 2026. El autor rechaza el primer pase pixel art: exige píxel mucho más intenso y cara sin definición, como en su imagen de personajes. **La nueva propuesta todavía no está aprobada.**

La escena actual compara «Versión rechazada» (atlas v2) con «Píxel intenso» (atlas v3). Ambas usan nearest inicialmente, mismo fondo, altura 252 y apoyo (780, 710). Se conservan los botones para cambiar perfil, alturas 232/252/272, galería/recepción y filtro. No se muestran frontal ni tres cuartos ni se reflejan las vistas.

Capturas del viewport nativo de Godot Compatibility en Apple M4, 1672 × 941:

| Perfil | Rechazado, cara definida | Propuesta, píxel intenso |
| --- | --- | --- |
| Derecho | [rechazado_0.png](rechazado_0.png) | [intenso_0.png](intenso_0.png) |
| Izquierdo | [rechazado_1.png](rechazado_1.png) | [intenso_1.png](intenso_1.png) |

Revisión del asistente: rostro resuelto en manchas sin rasgos dibujados, ropa y pelo con bloques mayores, sombras más profundas y acentos de neón en el cuerpo. Transparencia correcta sobre Velvet, siluetas completas y pies apoyados. El criterio solicitado afecta a todas las personas, no solo a Sota; no se generan aún los secundarios.

Importación correcta; pasan `tests/escala.gd` y `tests/verificacion.gd`; exportación Web release código 0. La escena sigue siendo estática. Pendientes valoración estética, retícula final, integración definitiva de luz/sombra, animaciones y revisión visual Web. No se repite el intento de control de Safari bloqueado en la entrega anterior.

[Atlas y prompt](../../personajes/sota/pixel_v2/README.md) · [Referencia del autor](../../referencias/pixel_art_v1/README.md) · [Dirección vigente](../../../direccion_artistica.md).
