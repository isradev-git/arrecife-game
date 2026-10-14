# Sota · prueba anatómica de cuatro claves derechas

14 de octubre de 2026. **Diagnóstico, no sprites aprobados ni listos para el juego.** La marcha v4 y la identidad v7 sí están aprobadas por el autor; estas cuatro siluetas nuevas no lo están. El autor pidió comprobar cuatro claves antes de producir 32 fotogramas y permitir una base anatómica editable si la fuente actual no bastaba.

[Comparación a 2×](comparacion_v7_claves_2x.png): de izquierda a derecha, reposo original v7, contacto, apoyo, impulso y avance. Los [cuatro PNG transparentes](contacto.png) están separados en `contacto.png`, `apoyo.png`, `impulso.png` y `avance.png`; son una **prueba de diagnóstico**. Las fases 0, 0,25, 0,50 y 0,75 se toman de la cinemática v4, con nombres de trabajo que todavía no validan el gesto artístico. Cada fotograma tiene 256 × 320 y raíz común `(128, 300)`; la oscilación vertical natural hace que su silueta visible mida entre 250 y 254 px. El reposo v7 sirve solo para comparación y no se ha sustituido.

## Resultado de la revisión

| Criterio | Observación |
| --- | --- |
| Identidad superior | La cabeza, la mecha gris, la chaqueta, la correa y el deck proceden del original v7; la zona superior mantiene el perfil derecho. |
| Pelvis y muslos | **No superado.** La unión de la pelvis a las piernas sigue cambiando de forma. Contacto y apoyo muestran una entrepierna artificial; impulso deja una cuña oscura y el avance comprime la pierna elevada. |
| Pantalón y bolsillo | **No superado.** Las superficies textiles se deforman y los pliegues/paneles del bolsillo no mantienen un volumen uniforme entre claves. |
| Botas y apoyo | Las botas originales están presentes y las cuatro imágenes terminan en la fila 299. **No superado artísticamente:** solapamientos del puño, caña y pantorrilla impiden leer bien ambos apoyos; esto no certifica ausencia de deslizamiento en un ciclo. |
| Color/píxel | Filtro `nearest` y alfa binaria. La tela obtenida de la base generada introduce entre 247 y 735 píxeles opacos por clave cuyo RGB no existe en v7; **no cumple aún la paleta exacta**. |
| Tamaño/posición | Los cuatro marcos miden 256 × 320, sin recortes de borde. Raíz común, sin recentrado individual. |

[Medidas reproducibles](medidas.json). Esta revisión visual tiene prioridad sobre los chequeos técnicos: las dimensiones y la transparencia pasan, pero la anatomía no.

## Fuentes y base editable

- [`referencia_autor_v71.png`](referencia_autor_v71.png) es la lámina conceptual aportada por el autor. Se conservó intacta; **ningún fotograma se recortó de ella**. Define la intención visual, no suministra sprites importables.
- [`godot/assets/personajes/sota/perfiles_pixel_v7.png`](../../../../godot/assets/personajes/sota/perfiles_pixel_v7.png) es idéntico bit a bit al `perfiles_pixel_v7.png` adjunto por el autor (SHA-256 `c1fe26186ad169ed4473025721e0fe06daf276f5544ecac5d9d251534cfafa6a`). No se duplicó ni modificó.
- [`base_anatomica_intento1.png`](base_anatomica_intento1.png) y [`base_anatomica_intento2.png`](base_anatomica_intento2.png) son **dos intentos de una sola base completa cada uno**, no cuatro generaciones independientes. El primero separa mejor las piernas pero altera brazo y torso; el segundo conserva mejor la parte superior y junta demasiado las piernas. Ninguno es arte aprobado.
- [`godot/tests/preparar_claves_sota_v71.gd`](../../../../godot/tests/preparar_claves_sota_v71.gd) es la **base anatómica editable de trabajo**: define explícitamente pelvis, muslo y pantorrilla de cada pierna, jerarquía delante/detrás, puntos cadera/rodilla/tobillo, mapeo de tela y el anclaje común. Usa una sola base de textura y las articulaciones de v4 para las cuatro muestras. Permite corregir geometría y textura desde un lugar y volver a prerenderizar las cuatro poses. Todavía necesita redibujo de pelvis/pantalón y paleta desde v7 antes de servir para producción.
- [`godot/tests/inspeccionar_claves_sota_v71.gd`](../../../../godot/tests/inspeccionar_claves_sota_v71.gd) inspecciona articulaciones; [`godot/tests/verificar_claves_sota_v71.gd`](../../../../godot/tests/verificar_claves_sota_v71.gd) mide marcos, alfa y coincidencia cromática. Son herramientas aisladas. Ningún atlas, controlador ni escena de Velvet se ha cambiado.

## Encargo visual usado para las dos bases

Se conserva aquí la especificación operativa de las dos peticiones al generador de imágenes; el texto está **reconstruido para documentación**, no presentado como transcripción literal. Ambas tomaron como referencias el reposo v7 y la lámina v7.1. Primera petición: una sola Sota completa de perfil derecho, píxel intenso, rostro poco definido, pelo corto oscuro con mecha gris, chaqueta marrón rojiza, correa clara, deck externo, pantalón oscuro y dos piernas de trabajo con pelvis y glúteo completos, botas completas, fondo realmente transparente. Se pidió separar el volumen de ambos muslos para usar el resultado como base anatómica. Segunda petición: repetir una sola base derecha más fiel al torso/cabeza y paleta de v7, manteniendo pelvis, piernas y botas enteras, sin introducir otro personaje ni múltiples poses. Los PNG exactos de ambos intentos están conservados arriba.

## Siguiente corrección artística, pendiente del autor

Redibujar sobre esta base una pelvis y dos pantalones continuos con volúmenes fijos y paleta muestreada de v7; fijar bolsillo a la pierna correcta y revisar contactos, puños y suelas en las cuatro claves a tamaño real. Si esas cuatro claves pasan revisión del autor, se podrán prerenderizar intermedios del perfil derecho desde la **misma** base y después diseñar el izquierdo propio. No producir aún 32 fotogramas ni integrar esta prueba en el recorrido.

Reproducción: desde la raíz del repositorio, `Godot --path godot --script res://tests/preparar_claves_sota_v71.gd` con GPU; después `Godot --headless --path godot --script res://tests/verificar_claves_sota_v71.gd`.
