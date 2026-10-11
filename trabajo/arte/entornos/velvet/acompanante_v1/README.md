# Velvet · Acompañante del acceso T07.8

12 de octubre de 2026. El autor aprueba el criterio de separar personas para actividad/interacción y abre la posibilidad de conversar con algunas de esta escena. Se prepara la persona de abrigo oscuro junto a la de mochila; no se escriben diálogos ni se asigna identidad narrativa en esta entrega. Recurso nuevo pendiente de valoración.

## Recursos y prompts

Dos ediciones con imagegen integrado, tras observar las referencias aprobadas de [Velvet](../../../referencias/pixel_art_v1/velvet_estilo.png) y [personajes](../../../referencias/pixel_art_v1/personajes_estilo.png), y el montaje actual. Recorte desde el [fondo horizontal](../../../../../godot/assets/entornos/velvet/fondo_suelo_recto_v1.png) con referencia de personajes; reconstrucción desde el [fondo sin la primera persona](../../../../../godot/assets/entornos/velvet/fondo_acceso_reparado_v1.png). PNG originales copiados sin retoque, versiones anteriores y prompts conservados.

| Recurso | Medidas | Prompt exacto |
| --- | --- | --- |
| [acompanante_acceso_v1.png](../../../../../godot/assets/entornos/velvet/acompanante_acceso_v1.png) | 1024 × 1536, RGBA transparente; región alfa ≥ 10 %: x = 389, y = 141, ancho 374, alto 1329 | [Acompañante](prompt_acompanante.txt) |
| [fondo_acceso_reparado_v2.png](../../../../../godot/assets/entornos/velvet/fondo_acceso_reparado_v2.png) | 1672 × 941, opaco, entrada sin las dos personas pintadas | [Fondo](prompt_fondo.txt) |

Adulto anónimo vestido, perfil izquierdo propio, abrigo carbón con cuello alto, pantalón oscuro y botas; sin armas. Píxel grueso, rostro en sombras y ojo apenas sugerido. Perfil estático; no es un sprite reflejado de otra persona. Edición generativa con variaciones de proporciones, pose y detalles; no extracción idéntica.

AtlasTexture, escala uniforme 248 / 1329, altura 248, x = 1594, y = 427 y apoyo inferior y = 675. Nearest y z = −4; detrás de Sota (z = 0, pies y = 705) y barandilla delantera (z = +5). Base sin contorno de neón pintado, material propio que reutiliza el shader de contraluz: ámbar desde izquierda y rojo/rosa desde derecha, intensidad 0.7. Modificarlo no cambia el material de la otra persona; fuentes espaciales pendientes.

El nuevo parche común ocupa x = 1510–1664, y = 414–675 (154 × 261), sustituyendo el menor de T07.7. El resto del fondo y la recepción siguen usando sus recursos anteriores. La persona de mochila conserva su PNG, geometría y material. Al ocultar ambas se ve puerta y escalera, sin sus versiones antiguas.

Controles **Acceso** para la mochila y **Acompañante** para el nuevo sprite. **Junto al acceso** coloca a Sota en x = 1560; **Junto al acompañante**, en x = 1625. Son controles de revisión, sin movimiento ni conversación.

[Catorce capturas y pruebas Godot/Web](../../../revisiones/acompanante_v1/README.md). Diálogos de figurantes posibles en T11: selección y textos pendientes, cotejados con canon/guion; no se convierten automáticamente en personajes o pruebas del caso. Separar las siguientes personas según actividad/interacción; las distantes decorativas pueden seguir aplanadas. Arquitectura/ciudad, atmósfera, retícula, animación, movimiento y luz espacial pendientes.
