# Velvet · Ojos sutiles de Sota

**Revisión posterior:** el autor aprueba el estilo vigente y pide resolver el rosa fijo entre escenarios. [Prueba actual de iluminación](../luz_v1/README.md); este registro y sus capturas conservan la entrega del retoque de ojos.

11 de octubre de 2026. El autor pide ojos muy poco visibles, sin dejar la cara vacía. **Retoque entregado por el asistente, pendiente de valoración del autor.**

La escena Godot compara «Antes del retoque» (atlas v3) con «Ojos sutiles» (atlas v7). Mismo fondo Velvet aprobado, altura 252, apoyo (780, 710) y nearest inicial. Se mantienen ambos perfiles, alturas 232/252/272, ubicación galería/recepción y filtro; sin frontal, tres cuartos ni reflejo de las vistas.

Capturas finales del viewport nativo Godot Compatibility, Apple M4, **1672 × 941**:

| Perfil | Antes, sin marca de ojo | Después, ojo apenas insinuado |
| --- | --- | --- |
| Derecho | [sin_ojos_0.png](sin_ojos_0.png) | [ojos_sutiles_0.png](ojos_sutiles_0.png) |
| Izquierdo | [sin_ojos_1.png](sin_ojos_1.png) | [ojos_sutiles_1.png](ojos_sutiles_1.png) |

Revisión del asistente: pequeña marca oscura de ojo en ambos perfiles, sin blancos ni iris detallados; píxel intenso y sombras conservados. La cara ya tiene una indicación mínima a tamaño de juego. Transparencia correcta y pies apoyados; el ajuste generativo puede variar otros píxeles y no cierra la integración de luz/sombra.

Importación correcta; pasan `tests/escala.gd` y `tests/verificacion.gd`. Exportación Web release con código 0. Pendientes valoración estética, retícula final, luz/sombra, animaciones y revisión visual Web; no se repite el control de Safari bloqueado previamente. La revisión sigue siendo estática.

[Atlas, intentos y prompts](../../personajes/sota/pixel_v3/README.md) · [Referencia del autor](../../referencias/pixel_art_v1/README.md) · [Dirección vigente](../../../direccion_artistica.md) · [Tareas](../../../../task.md).
