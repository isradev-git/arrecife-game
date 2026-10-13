# T05 · Las 16 propuestas del perfil derecho

13 de octubre de 2026. Cinco enlaces nuevos completan el objetivo inicial de 16 dibujos del perfil derecho. **Serie para revisar, sin aprobación ni marcha natural demostrada.** [PNG, 12 intentos y prompts exactos](../../personajes/sota/caminar_v2/transiciones.md), generados con imagegen integrado; versiones anteriores y reposo v7 intactos.

| Lámina | Contenido |
| --- | --- |
| [Primer paso, ampliado 2×](paso_a/comparacion_2x.png) | Poses 01–08, lectura de izquierda a derecha y de arriba abajo. |
| [Segundo paso, ampliado 2×](paso_b/comparacion_2x.png) | Poses 09–16. El cierre vuelve a 01. |
| [Primer paso en Velvet](paso_a/comparacion_velvet.png) | Ocho figuras a escala del juego. |
| [Segundo paso en Velvet](paso_b/comparacion_velvet.png) | Ocho figuras a escala del juego, con objetos en sus planos. |

Godot 4.7.2 Compatibility / Apple M4, render nativo. Escala común **252/871**, nearest y CUTOUT compartido con v7; pies y = 705, barandillas detrás/delante. Solo recorte técnico AtlasTexture, sin edición de PNG, filtros de oscuridad ni normalización individual. Estas láminas centran por contorno para inspección estática; no fijan pivote de locomoción. V7 original real es la referencia de medidas, nunca el reposo reconstruido por el generador. [Comparación anterior con original](../marcha_segundo_paso_v1/README.md).

| Enlace nuevo seleccionado | Altura fuente | Media RGB sRGB ponderada | Resultado tonal |
| --- | --- | --- | --- |
| 08 · Llegada B v3 | 867 | 0,175737 | **Alerta pendiente: +15,98 %; límite +15 %** |
| 10 · Carga B v1 | 871 | 0,169639 | Dentro del rango |
| 12 · Despegue B v3 | 877 | 0,170280 | Dentro del rango |
| 14 · Extensión B v2 | 873 | 0,170599 | Dentro del rango |
| 16 · Llegada A v2 | 857 | 0,158238 | Dentro del rango |

[Medidas de v7 y las 16 poses](medidas.json). V7 = 0,151530; promedio sobre alfa ≥ 0,95, afectado por superficie de piel/ropa y por la postura. No prueba igualdad de paleta ni identidad. V1 de llegada B tiene alfa residual 1/255 en una esquina; v2 corrige. Llegada B v4 aumenta media a 0,193405 y se descarta. V3 se conserva solo como candidato pendiente. No se ha ampliado el rango 0,8–1,15 para aceptar el dibujo.

**Comprobado:** dimensiones 1536 × 1024, esquinas transparentes, margen y altura de todas las seleccionadas; cuatro láminas GPU generadas (sin fallo de render), revisadas por el asistente. Los cuatro modos históricos y la prueba de recorrido v7 terminan con código 0. **La nueva revisión termina con código 1 por alerta tonal de llegada B**, tanto headless como GPU. El script recoge las alertas, guarda medidas/capturas para hacerlas revisables y después falla; no se declara una prueba superada.

**Revisión visual:** continuidad de mangas largas remangadas bajo codos, un bolsillo cargo que alterna delante/detrás con su pierna y brazos opuestos a sus piernas en los extremos. Persisten diferencias de sombra/volumen de chaqueta, cabeza, amplitud de zancada y oscilación de altura; más dibujos no las resuelven automáticamente. El cruce B también requiere revisar trayectoria antes de considerarlo natural.

**Siguiente:** resolver continuidad visual y calibrar/probar un bucle derecho aislado, apoyos durante avance, pivotes, cierre 16→01 y ritmo. Después dibujar perfil izquierdo propio; no reflejar estos recursos. No integración del ciclo, exportación ni prueba Web nuevas: el juego conserva v7 al andar. T05 abierta.

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script tests/poses_oscuras.gd -- --ciclo-derecho
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/poses_oscuras.gd -- --ciclo-derecho --capturas
```

Código 1 esperado mientras persista la alerta descrita; nunca tratarlo como éxito. Las carpetas paso_a/paso_b deben existir. Revisión excluida de exportación Web, necesita archivos externos en trabajo/. Los modos anteriores conservan sus destinos.
