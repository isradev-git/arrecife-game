# Velvet · Figurante junto a la escalera T07.7

12 de octubre de 2026. El autor valora positivamente el progreso y pide continuar con calma, pieza a pieza. Se separa únicamente la persona con mochila que está delante de la escalera, junto a la persona más alta del extremo derecho. Entrega del asistente pendiente de valoración del recurso nuevo.

## Recursos y prompts

Herramienta integrada imagegen. Se observaron las referencias aprobadas de [Velvet](../../../referencias/pixel_art_v1/velvet_estilo.png) y [personajes](../../../referencias/pixel_art_v1/personajes_estilo.png), el [fondo horizontal](../../../../../godot/assets/entornos/velvet/fondo_suelo_recto_v1.png) y el montaje anterior. Para extraer la figura se suministraron fondo y referencia de personajes; para reparar la escalera, el fondo. PNG generados copiados sin retoque; versiones y prompts anteriores conservados.

| Recurso guardado | Uso | Prompt |
| --- | --- | --- |
| [figurante_acceso_v1.png](figurante_acceso_v1.png) | Primer intento conservado; añadió un moño ausente en la figura original, no integrado | [Extracción](prompt_figurante.txt) |
| [figurante_acceso_v2.png](../../../../../godot/assets/entornos/velvet/figurante_acceso_v2.png) | Corrección de pelo corto desde v1; RGBA transparente, 1024 × 1536 | [Corrección](prompt_pelo.txt) |
| [fondo_acceso_reparado_v1.png](../../../../../godot/assets/entornos/velvet/fondo_acceso_reparado_v1.png) | Fondo opaco 1672 × 941 sin la figura, con escalera reconstruida | [Fondo](prompt_fondo.txt) |

Figura adulta anónima, vestida, perfil derecho propio: pelo oscuro corto, chaqueta ciruela, mochila rojiza, pantalón cargo y botas. Rostro en masas y ojos mínimos; no se asignan nombre ni papel narrativo. Un único perfil estático, sin animación ni giro automático.

Base sin contorno de neón pintado. Godot reutiliza el shader de contraluz y duplica el material de recepción para ajustarlo sin modificar otra persona: ámbar desde izquierda y rojo/rosa desde derecha, intensidad 0.7. Fuentes espaciales, reflejos interiores y luz ambiente definitiva pendientes.

Edición generativa, no extracción idéntica píxel a píxel: cambian detalles de ropa, pose y rostro. La corrección de pelo también altera pequeños detalles. El fragmento de la persona contigua que entra en el parche puede variar; esa persona sigue aplanada y es la siguiente candidata a separar.

## Montaje

AtlasTexture con región alfa ≥ 10 %: x = 323, y = 116, ancho 399, alto 1345. Escala uniforme 236 / 1345; posición x = 1522, y = 439, altura 236 y límite inferior en y = 675, borde posterior de la pasarela. Filtrado nearest. Sota mantiene pies y = 705 y ambos perfiles.

Solo se integra el parche x = 1510–1606, y = 430–675 (96 × 245) del fondo reparado; el resto del fondo horizontal y el parche de recepción continúan intactos. Suelo y barandillas no cambian.

| Plano | Orden z |
| --- | --- |
| Fondo / parche de escalera | −20 / −19 |
| Figurante de acceso | −4 |
| Sota | 0 |
| Barandilla delantera | +5 |

Controles **Acceso** para visibilidad y **Junto al acceso** para colocar a Sota en x = 1560. Permiten inspeccionar el fondo y el cruce; no implementan caminar ni diálogo.

[Diez capturas nativas/Web y pruebas](../../../revisiones/acceso_v1/README.md). Quedan persona contigua, restantes figurantes/objetos, arquitectura/ciudad, atmósfera, luces espaciales, retícula definitiva y movimiento/colisiones.

**Continuación T07.8:** [acompañante independiente y fondo común ampliado](../acompanante_v1/README.md). PNG de mochila y versiones anteriores conservados; el parche de entrada vigente pasa a 154 × 261. El autor aprueba el criterio de separación y propone posibles diálogos, sin textos implementados todavía.
