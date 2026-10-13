# T05 · Continuidad de las mangas

13 de octubre de 2026. El autor advierte «cuidado con la manga» y aporta [este recorte de extensión/impulso](referencia_autor.png). La manga del brazo adelantado terminaba demasiado arriba, como una manga corta, frente a la manga larga remangada del reposo aprobado.

**Criterio registrado para todos los fotogramas:** ambas mangas pertenecen a la misma chaqueta; cubren hombro/brazo hasta el codo y llevan puño oscuro remangado justo por debajo. Solo quedan expuestos antebrazo y mano. El balanceo cambia orientación y pliegues de forma gradual, no longitud/diseño del remangado, parche o color de la prenda.

Se corrigen extensión e impulso con **imagegen integrado**, cinco llamadas incluyendo correcciones de acabado. [PNG originales, intentos y prompts exactos](../../personajes/sota/caminar_v2/README.md). Extensión nueva `cruce_impulso_v7.png`; impulso nuevo `impulso_v2.png`. El nombre de versión de extensión no cambia la referencia aprobada `perfiles_pixel_v7.png`, que sigue intacta.

| Captura | Contenido |
| --- | --- |
| [Antes/después ampliado](detalle/comparacion_2x.png) | V7 original real, extensión anterior/corregida e impulso anterior/corregido. Misma escala 2× y material. |
| [Antes/después en Velvet](detalle/comparacion_velvet.png) | Las mismas figuras en los planos actuales, pies y = 705. |
| [Serie completa ampliada](comparacion_2x.png) | Las siete posturas con las dos mangas corregidas, 1672 × 1200. |
| [Serie completa en Velvet](comparacion_velvet.png) | Escala del juego, 1672 × 941. |

Capturas nativas Godot Compatibility / Apple M4. Misma escala 252/871 y CUTOUT, nearest y encuadre estático por contorno; sin filtros de brillo ni retoque de PNG por código. El asistente revisa visualmente cobertura hasta el codo y puños en ambas fases contra v7; no es aprobación artística del autor ni invariancia píxel por píxel del resto del dibujo.

**Intentos conservados:** extensión v4 corrige manga pero pierde contraluz; v5 lo recupera, con fondo negro parcialmente opaco detectado por la prueba; v6 recupera alfa vacío pero aclara demasiado la figura; v7 corrige paleta. Impulso v2 corrige manga y conserva contraluz/alfa. [Medidas de la serie vigente](medidas.json): extensión 0,172 e impulso 0,171 frente a v7 0,152, aproximadamente +13 %. Promedio de RGB sRGB codificado sobre alfa ≥ 0,95, afectado por forma, tela y piel; pasa el margen de alerta existente (+15 %), pero no prueba igualdad de paleta. La continuidad tonal/proporciones sigue por revisar al animar; no se relaja la prueba para aceptar intentos defectuosos.

**Comprobado:** dimensiones, esquinas transparentes, márgenes/alfa, altura y rango tonal de la serie corregida; modos históricos de cuatro/siete poses conservados; cuatro capturas GPU generadas y revisadas sin errores. Ediciones generativas conservan las fases globales, con pequeñas variaciones de dibujo. No se integra esta serie en el recorrido, no hay exportación/prueba Web nueva ni ciclo animado.

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script tests/poses_oscuras.gd -- --mangas
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/poses_oscuras.gd -- --mangas --capturas
```

Modo de revisión con archivos externos de `trabajo/`, excluido de Web. `--intermedios` conserva la serie anterior y sus capturas. Pendiente: valoración de la corrección, revisar vestuario en todos los próximos fotogramas, completar otro paso/perfil y probar bucle, ritmo y apoyos. T05 sigue en curso.
