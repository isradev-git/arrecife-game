# T05 · Mano lejana, bolsa y continuidad de piernas

14 de octubre de 2026. El autor valora la mejora del movimiento, pero identifica tres defectos que siguen abiertos: mano pintada en el pantalón izquierdo, bolsa sobre el brazo al caminar a la derecha y piernas entrecortadas. Corrección integrada para valoración; la naturalidad ya aprobada no se rehace.

## Diagnóstico y corrección

[Antes](antes.png), [antes sin brazos](antes_sin_brazos.png), [después](despues.png) y [después sin brazos](despues_sin_brazos.png). Ocho muestras ampliadas por lámina, cuatro fases por perfil. [Modelo anterior](articulacion_antes.gd.txt) conservado; `lamina.gd.txt` conserva el script de la lámina.

La prueba anterior de piel cálida no detectaba todos los restos oscuros. La zona de la mano lejana del original izquierdo (x = 958–1000, y = 509–574) seguía entrando en los UV de torso/muslo. Se excluye con margen y se reconstruye la tela con UV limpios del mismo v7. La prueba revisa el origen de esos píxeles, incluyendo sombras y contorno, sin depender del color de piel.

La bolsa/deck estaba en z = 4, por encima del brazo cercano z = 3. Pasa a z = 2: delante del torso y detrás del brazo; el lado físico y el movimiento no cambian. La misma regla se aplica al perfil izquierdo.

Las botas también incluían el puño del pantalón de la imagen aplanada, aunque ese puño ya estaba en la pierna: se elimina de su recorte (UV de bota desde y = 810), conservando suela/puntera y datos de apoyo. Un pliegue de tela con UV opacos se deforma entre muslo y pantorrilla, cubriendo el borde rígido de la rodilla. Se conserva el relleno entre pantalón y bota. No cambian las articulaciones ni sus trayectorias; la valoración visual del pliegue sigue correspondiendo al autor.

Los cuatro atlas nuevos son [articulada_v3](../../../../godot/assets/personajes/sota/articulada_v3/), generados por el preparador nativo de Godot. V7 y articulada_v1/v2 intactos. No hay edición del PNG original, generaciones ni prompts nuevos: se corrige el modelo editable Polygon2D/UV y se renderizan sprites completos.

## Prueba reproducible del defecto

[Antes](regresion_antes.txt), devuelve código 1; [después](regresion_despues.txt), código 0. [Script](../../../../godot/tests/recortes_sota.gd):

| Medida | Modelo anterior | Modelo 6 |
| --- | ---: | ---: |
| Píxeles opacos de la región de la mano lejana presentes en UV de ropa | 631 | 0 |
| Píxeles opacos del puño de pantalón presentes también en UV de botas, perfil izquierdo | 1987 | 0 |
| Píxeles donde bolsa tapa brazo, 5327 cruces opacos examinados en 32 fases derechas | 5281 | 0 |

Los dos primeros conteos comprueban regiones fuente, no significan que todos esos píxeles sean piel. La prueba GPU de bolsa compara imagen completa/sin bolsa con máscaras de brazo y bolsa aislados; el control de profundidad también comprueba su orden.

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script res://tests/recortes_sota.gd -- --antes
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script res://tests/recortes_sota.gd
```

El primer comando falla deliberadamente con el modelo v5 conservado. Headless comprueba UV y orden; GPU comprueba también los solapamientos reales.

## Resultado probado

- [Modelo](modelo.txt): 328 poses articuladas (marcha, arranque y cierre) conservan transformaciones, contornos de apoyo, ciclo y punteras del movimiento aprobado v4. Cobertura de torso/cintura, núcleo de rodillas y unión con botas pasa, sin la señal de piel cálida en ropa; seis hojas `cobertura_*` conservadas.
- [Marcha GPU](marcha_gpu.txt): 338 poses; 3.700.446 píxeles opacos usan RGB exactos presentes en v7, alfa binaria; región de cabeza comprobada idéntica al reposo rasterizado. Fases, escala, cierre, reducción y extremos pasan. Veinte capturas nativas conservadas.
- [Fluidez](fluidez.txt) y [controlador](controlador.txt): cero congelación/salto extra de raíz; puntera proyectada 3,467 px a 30 Hz y 2,401/2,400 a 60 Hz; controles, destinos, colisiones y foco pasan. Se mantienen 104 px/s, ciclo 128 px y cadencia. Centro 705 y planos del escenario intactos.
- Importación/exportación release terminan con código 0. [Vídeo Web](marcha_web.webm), 9,400 s, ambos sentidos y paradas; [reposo derecho](web_reposo.png) e [izquierdo](web_izquierda.png). Helium/Chromium, WebGL 2, canvas 1672 × 941; rótulo Modelo 6 observado, sin errores de página/consola.
- [Hashes](hashes.sha256) de fuente, modelo, preparador, pruebas y recursos finales.

Para regenerar: ejecutar `tests/preparar_sota_articulada.gd` con GPU, importar con `--headless --editor --import`, ejecutar `tests/recortes_sota.gd`, `tests/modelo_sota.gd`, `tests/movimiento_sota.gd -- --capturas` con GPU y exportar Web. El preparador escribe articulada_v3; las capturas nuevas van a esta carpeta.

Pendiente: valoración del acabado nuevo, especialmente pliegues/contornos de piernas a escala real; las pruebas de cobertura examinan regiones concretas, no certifican todo el arte. Velocidad algo lenta anotada anteriormente, sin ajuste en este pulido. Safari, Firefox, móvil y rendimiento en equipos modestos sin comprobar. No hay cambios de historia, NPC, diálogos ni capas del escenario.
