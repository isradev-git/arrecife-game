# Velvet · Primera separación de capas

Entrega T07.1 del 11 de octubre de 2026. El autor pide dar prioridad a los objetos delante/detrás de Sota, elementos móviles del fondo, humo y luz. Esta entrega separa **solo el tramo central de barandilla**; no cierra T07 ni añade animación.

## Recursos y procedencia

Editados con la herramienta integrada `imagegen` desde [Velvet aprobado](../../../referencias/pixel_art_v1/velvet_estilo.png), conservado intacto:

- [Fondo reparado](../../../../../godot/assets/entornos/velvet/fondo_reparado_v1.png), 1671 × 941. [Prompt exacto](prompt_fondo.txt). Solo se integra el parche correspondiente a x = 450–935, y = 548–678 del encuadre 1672 × 941; el resto de la escena conserva la referencia original. La diferencia de un píxel de anchura se compensa al colocar el parche en Godot.
- [Barandilla transparente](../../../../../godot/assets/entornos/velvet/barandilla_v1.png), 1672 × 941. [Prompt exacto](prompt_barandilla.txt). Límites alfa ≥ 10 %: x = 382, y = 506, ancho = 910, alto = 186. Godot recorta con AtlasTexture y coloca ese tramo en x = 450, y = 552, ancho = 485, alto = 126.

La edición generativa reconstruye detalles y cambia posiciones/proporciones de los postes; **no es una extracción idéntica píxel a píxel**. Los PNG se copian sin retoque posterior. El alfa generado contiene residuos tenues y metal casi opaco: `metal_opaco.gdshader` descarta alfa < 0,5 y hace opaco el resto para evitar halos y que Sota se transparente a través del metal. Filtrado nearest.

## Montaje real

| Elemento | Orden actual (`z_index`) |
| --- | --- |
| Referencia aplanada | −20 |
| Parche del fondo reconstruido | −19 |
| Barandilla en la prueba «Detrás» | −5 |
| Sota | 0 |
| Barandilla en la prueba «Delante», inicial | 5 |

«Ocultar» retira la barandilla y deja ver el fondo reconstruido. La comparación detrás/delante sirve para revisar oclusión; no representa dos recorridos físicos ya diseñados. Recepción está fuera de este tramo separado y sigue usando objetos aplanados. [Capturas y comprobación](../../../revisiones/capas_v1/README.md).

## Requisitos para continuar T07 y T09

Separar el resto de barandillas y objetos que crucen el recorrido. Después, arquitectura y ciudad distante, elementos móviles y atmósfera por profundidad. Humo detrás y delante de Sota necesita emisores/capas distintos; luces, reflejos y sus oclusiones deben responder a las fuentes del entorno. Reconstruir lo oculto antes de animar cualquier pieza, para no revelar siluetas duplicadas ni agujeros. Mantener accesos, pistas y personajes legibles y una opción de movimiento reducido.

Prueba parcial entregada y revisada por el asistente. Pendientes valoración del autor, retícula/acabado final, resto de capas, movimiento y visual Web; exportación Web correcta.
