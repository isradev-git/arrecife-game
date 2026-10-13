# T05 · Poses clave del segundo paso

13 de octubre de 2026. El autor autoriza continuar después de la corrección de mangas. Se entregan cuatro poses del paso de la pierna contraria, siempre de perfil derecho: contacto, apoyo, cruce e impulso. [Originales, 16 intentos y prompts exactos de imagegen integrado](../../personajes/sota/caminar_v2/segundo_paso.md). Continuación no equivale a aprobar las mangas ni estas nuevas propuestas.

| Captura | Contenido |
| --- | --- |
| [Segundo paso y reposo real, 2×](comparacion_2x.png) | V7 original real y cuatro poses nuevas B, 1672 × 941. |
| [Segundo paso en Velvet](comparacion_velvet.png) | Mismas figuras a escala del juego, pies y = 705, barandillas en sus planos. |
| [Fases A/B comparadas, 2×](comparacion_pasos/comparacion_2x.png) | Pares contacto, apoyo, cruce e impulso; 1672 × 1200. Ambas piernas tienen articulación propia, no copia reflejada. |
| [Pares A/B en Velvet](comparacion_pasos/comparacion_velvet.png) | Alternancia a escala del juego, 1672 × 941. |

Godot Compatibility / Apple M4. Escala común **252/871**, mismo CUTOUT y nearest, sin normalizar cada altura ni aplicar filtros de brillo. Posicionamiento horizontal por centro de contorno para esta comparación estática; no es el pivote de locomoción definitivo.

**Revisado visualmente por el asistente:** cargo delante en contacto/apoyo B, cargo en pierna plantada y pierna lisa en el aire durante cruce B, cargo atrás/lisa delante en impulso B, brazos opuestos en extremos y mangas largas remangadas bajo codos. Se corrigieron antes de seleccionar apoyo/zancada del contacto, bolsillos duplicados o cambiados de pierna, oposición de brazos y variantes demasiado claras. Todas las versiones/prompts conservadas.

[Medidas](medidas.json):

| Figura | Altura fuente | Altura a escala común | Media RGB ponderada |
| --- | --- | --- | --- |
| V7 original | 871 | 252 | 0,152 |
| Contacto B v4 | 874 | 252,9 | 0,164 |
| Apoyo B v2 | 870 | 251,7 | 0,169 |
| Cruce B v6 | 852 | 246,5 | 0,174 |
| Impulso B v4 | 875 | 253,2 | 0,174 |

Promedio sobre RGB sRGB codificado con alfa ≥ 0,95, afectado por forma y superficie de piel/ropa. Nuevas poses aproximadamente +8 % a +15 % frente al reposo: pasan el margen de alerta existente, no demuestran misma paleta ni iluminación. La altura del contorno tampoco mide por sí sola centro de masa/transferencia de peso. Las láminas muestran diferencias de proporciones, zancada, sombreado y altura del cruce entre A/B que siguen pendientes; no se camuflan con reescalado individual.

**Comprobado:** dimensiones/alfa/esquinas/márgenes/altura/rango tonal de las cuatro propuestas; tres modos de revisión anteriores conservados; cuatro capturas GPU generadas y revisadas sin errores. Nueva valoración del autor pendiente. No hay prueba animada del bucle, pie plantado durante avance, integración del controlador, exportación ni navegador nuevos. V7 sigue siendo el único sprite del recorrido.

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script tests/poses_oscuras.gd -- --segundo-paso
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/poses_oscuras.gd -- --segundo-paso --capturas
```

Revisión excluida de Web; necesita recursos externos de `trabajo/`. Los modos históricos sin bandera, `--intermedios` y `--mangas` conservan sus archivos; no combinar `--segundo-paso` y `--mangas`.

**Estado:** once dibujos distintos de perfil derecho, todavía sin ciclo natural demostrado. El objetivo inicial de 16 deja cinco intermedios/transiciones pendientes: impulso A→contacto B, contacto B→apoyo B, apoyo B→cruce B, cruce B→impulso B e impulso B→contacto A. Antes de integrar, cerrar continuidad visual y revisar esos enlaces, perfil izquierdo propio, pivotes, ritmo, suelas y límites laterales con las nuevas zancadas. T05 sigue en curso.
