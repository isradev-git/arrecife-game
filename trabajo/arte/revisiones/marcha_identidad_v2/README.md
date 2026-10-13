# T05.1 · Corrección de dibujo y oscuridad

13 de octubre de 2026. El autor rechaza la marcha anterior por no parecerse al reposo oscuro v7. Se retira Pasos en prueba del recorrido; v7 continúa intacta al caminar/parar. Se conserva el archivo anterior y se prepara **una pose nueva** desde v7 para revisar antes de rehacer la hoja.

[PNG y prompt de imagegen integrado](../../personajes/sota/caminar_v2/README.md). En las comparaciones, izquierda = **original v7 real**, derecha = nuevo contacto. La figura de reposo reconstruida por imagegen no participa en esta comparación.

| Captura | Comprobación |
| --- | --- |
| [Comparación en Velvet](comparacion_velvet.png) | Ambas figuras en y = 705 con barandillas, mismo shader CUTOUT y escala 252/871. |
| [Comparación ampliada 2×](comparacion_2x.png) | Mismo dibujo/render, ampliación nearest común para revisar píxel, sombras y proporciones. |

Capturas GPU Godot Compatibility Apple M4, 1672 × 941. No hay máscara/filtro de brillo nuevo ni edición de PNG por código. El color procede del recurso. La postura nueva mide 854 px frente a 871 de reposo (~247 frente a 252 en escena): calibración aún provisional, no se reescala individualmente para ocultarlo.

[Medidas](medidas.json): luminancia media de RGB sRGB codificado sobre alfa ≥ 0,95: v7 0,152; contacto anterior rechazado 0,223; nuevo contacto 0,144. El dibujo anterior tenía un promedio ~47% mayor; el nuevo ~5% menor que v7. Diferencias de forma/cantidad de ropa/piel cambian el promedio: estas cifras apoyan la revisión de oscuridad, no demuestran igualdad de paleta, identidad ni aprobación.

Pruebas del controlador y retirada pasan: siete llegadas, límites, colisión, foco y solo v7 al moverse. `tests/identidad_marcha.gd -- --capturas` mide y renderiza esta propuesta; necesita GPU para capturas y archivos externos de `trabajo/`. No se exporta como juego. Importación/exportación correctas; el recorrido Web mantiene v7 y no ofrece la marcha rechazada.

**Pendiente:** valoración del contacto, coherencia de dibujo/anatomía/equipo y escala, luego ambos perfiles/ciclo y después intermedios. No hay marcha corregida terminada ni nueva aprobación del autor.

**Web comprobada:** Helium/Chromium WebGL 2.0: [v7 restaurada mientras camina](web_v7_restaurada.png); no aparece Pasos en prueba, sin errores de página/consola. No se integra el contacto nuevo en la ejecución.
