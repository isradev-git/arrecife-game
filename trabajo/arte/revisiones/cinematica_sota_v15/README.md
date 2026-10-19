# Sota · candidata IK 15

**17 de octubre: rechazada por el autor por movimiento robótico y antinatural.** Las pruebas técnicas de esta entrega no acreditaron calidad de movimiento. Véase [cambio de método](../ruta_animacion_humana_v1/README.md).

16 de octubre de 2026. **Implementada y probada; pendiente de valoración artística del autor. No sustituye la animación jugable.**

## Abrir la comparación

- Web local, con el servidor de este proyecto activo: [comparación](http://127.0.0.1:8766/godot/build/web-candidata/?revision=ik15).
- Godot: abrir `godot/project.godot`, seleccionar `candidatas/comparacion_sota_v15.tscn` y pulsar **F6**. F5 sigue abriendo Modelo 14.
- Izquierda: Modelo 14 real, `articulada_v10`. Derecha: candidata `articulada_v11_candidata`. Fila superior hacia la derecha; inferior hacia la izquierda. Suelo, escala, distancia de ciclo, velocidad y fondo comunes.
- Controles: pausa, reanudar, 0,25×, fotograma anterior/siguiente, marcha/transiciones, articulaciones y probar en Velvet. El paso de inspección equivale a 2 px de recorrido; el anterior repite dibujo en pasos alternos.
- La demostración de transiciones se repite cada ocho segundos e incluye arranque, frenada, reanudación e inversión. Las marcas del suelo avanzan con la distancia real. El overlay muestra cadera/rodilla/tobillo, longitudes y un círculo verde en el tobillo en apoyo.
- Velvet conserva A/D, flechas, clic, Esc, colisiones, límites y destinos. Hay un botón para volver a la comparación.

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot res://candidatas/comparacion_sota_v15.tscn
```

Exportación separada, desde la raíz del repositorio:

```sh
mkdir -p godot/build/web-candidata
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --export-release 'Web candidata Sota'
```

El preset añade la característica `candidata_sota`, que selecciona la escena aislada. El preset Web normal y la escena principal normal conservan su destino. No se ha reexportado ni sustituido `build/web` en esta entrega.

## Estado real encontrado

La copia local **ya utilizaba Modelo 14 / articulada_v10**, con 32 dibujos por perfil y ocho niveles de cierre. `recorrido.tscn → recorrido.gd → movimiento_sota.gd → DATA_PATH` es la cadena activa. No estaba cargando el atlas público v5. La izquierda jugable repetía el derecho con `flip_h`, por una decisión anterior del autor.

La instrucción actual exige perfiles propios, sin reflejo, y revisión antes de integrar. La candidata respeta esa instrucción. El comportamiento histórico de Modelo 14 se conserva para comparar; no se confunde con la nueva propuesta.

Se revisaron v4, Modelo 8, Modelo 9 rechazado y las claves experimentales. Estas últimas no se han integrado: los diagnósticos de pelvis, pantalón, botas y silueta siguen siendo relevantes. **Sota 0.1 stable continúa siendo Modelo 12**, no esta candidata.

### Medición independiente de los fallos

`tests/historico_sota_v15.gd`, 32 fases × dos piernas por perfil, amplitud completa:

| Fuente | Perfil | Longitud máxima de tibia | Distancia máxima cadera–tobillo | Objetivos >112 px |
|---|---|---:|---:|---:|
| v4 archivada | Derecho | 63,086 px | 118,992 px | 25/64 |
| v4 archivada | Izquierdo | 61,128 px | 117,032 px | 25/64 |
| Modelo 8 archivado | Derecho | 61,051 px | 116,955 px | 28/64 |
| Modelo 8 archivado | Izquierdo | 61,128 px | 117,032 px | 30/64 |
| Modelo 14 local | Derecho | 58,690 px | 117,017 px | 26/64 |
| Modelo 14 local | Izquierdo de la fuente | 60,741 px | 116,747 px | 26/64 |

Las cifras comunicadas por el autor se reproducen para **Modelo 8**. Allí se limitaba la distancia usada para resolver la rodilla pero se conservaba el tobillo fuera del alcance; la tibia quedaba estirada. Modelo 14 había sustituido ese cálculo por una rodilla dirigida mediante ángulos: ambos segmentos cambiaban de longitud, aproximadamente 50,58–58,69 px en el derecho y 52,26–60,74 px en el izquierdo. El perfil izquierdo de esa fuente no se mostraba en el juego, que reflejaba el derecho.

Otros problemas comprobados:

1. Los cuatro pivotes de bota procedían de una misma fila del atlas, pero no representaban la misma altura anatómica sobre sus suelas. Resolver 56/56 sin recalibrarlos producía demasiada compensación de pelvis.
2. El movimiento vertical anterior dependía de una oscilación independiente, no del pie que sostenía el cuerpo.
3. Con 32 dibujos, la selección por distancia retenía cada apoyo durante 4 px de avance. La prueba sobre píxeles de las botas mide 4 px de deriva de raster; con 64 baja a 2 px. Por eso se aumentó la resolución temporal **después** de corregir las poses y medir el resultado.
4. Cerrar hacia un único reposo no compatible cambiaba la separación de los pies. Cambiar de perfil también heredaba anclajes horizontales distintos.
5. El arranque de 8 px podía atravesar varios niveles de amplitud en una sola actualización. Se midieron saltos articulares de 21,573 px en la primera candidata; se ha reducido a 16,414 px con aceleración real a 30/60/120 Hz. Esta medida incluye el avance de fase, no solo el cambio de amplitud.

## Implementación

### Piernas y suelo

La candidata hereda el montaje y el dibujo existentes y reemplaza únicamente la pose cinemática. Fémur y tibia son **56 px constantes**.

1. La trayectoria calcula primero el tobillo, el giro de la bota y la altura de su suela rotada. No recorta el tobillo después de resolver la rodilla.
2. Cada bota se calibra una sola vez a un pivote situado 18 px por encima de su suela. Se trasladan sus coordenadas locales y el pivote anatómico, conservando las UV. No se añaden superficies ni parches.
3. Para cada pierna, `dx` y el alcance 111,8 definen el límite vertical admisible de pelvis: `tobillo.y − cadera.y − sqrt(alcance² − dx²)`.
4. La pelvis utiliza el mayor límite de las dos piernas y una altura preferida ponderada por el pie en apoyo. Un máximo suave conserva la alcanzabilidad y evita una esquina de derivada al cambiar la pierna limitante.
5. Con la cadera definitiva se calcula la intersección de los dos círculos de radio 56. La rama elegida apunta siempre hacia delante según el perfil. No se interpolan rodillas hacia posiciones que alteren las longitudes.

La trayectoria conserva ciclo **128 px**, velocidad **104 px/s**, apoyo 60 % y recuperación 40 %. Durante el apoyo el pie retrocede a la misma velocidad que avanza la raíz; la rotación compensa el pivote de talón/puntera. La recuperación emplea una curva con posición y velocidad continuas en los extremos y elevación de 14 px. Contacto, carga, apoyo medio, despegue y preparación se representan mediante curvas, sin añadir estados de locomoción.

### Peso, cuerpo y píxel

La altura surge de los apoyos y del alcance, con una pequeña flexión de carga. El desplazamiento horizontal es de ±0,6 px. Torso y brazos acompañan el ciclo, con compensación discreta; la cabeza y el equipo se ajustan a la retícula de píxeles. Las articulaciones se calculan en continuo antes de rasterizar.

Se conserva la fuente v7, su paleta exacta, el marco 256 × 320, el origen común, la escala nominal 252, transparencia binaria y filtro nearest. No hay filtro lineal, escalado por fotograma, nueva imagen generativa ni retoque RGB. La altura visible oscila con el apoyo: 252 es la escala de referencia, no una normalización que estire cada pose.

### Arranque, cierre y giro

El controlador horizontal `movimiento.gd` permanece idéntico. La candidata especializa el reproductor existente:

- La fase sigue la distancia real recorrida, también durante aceleración y frenada.
- Se conservan los ocho niveles de amplitud. El arranque queda limitado tanto por distancia como por 0,4 s; el cierre dura 0,4 s, para no saltar tantos niveles a 30 Hz.
- Cada fase tiene su propio cierre: el pie elevado baja y el reposo conserva los apoyos de esa fase. Reanudar mantiene distancia/fase; no salta a un reposo universal.
- Para invertir se busca la pose del otro perfil con posiciones de pies y altura de pelvis más próximas. Se normaliza el origen horizontal de la cadera entre ambos perfiles.
- La candidata mantiene el reposo compatible estático; no reproduce la respiración del reposo universal, que volvería a cambiar los apoyos. La respiración de la versión normal sigue intacta.

## Resultados de pruebas

Godot 4.7.2, macOS / Apple M4, render Compatibility. Todos los tests de candidata indicados debajo terminaron con código 0. Los diagnósticos `--actual` / `--modelo8` son controles negativos y fallan la integridad de longitudes deliberadamente.

| Comprobación | Resultado |
|---|---|
| IK, 1025 fases × 6 amplitudes × 2 perfiles × 2 piernas | Error máximo por segmento 0,000011 px; cero objetivos finales inalcanzables, NaN o inversiones |
| Alcance final máximo | 111,7967 px derecho; 111,7962 px izquierdo |
| Continuidad entre subfases de 1/1024 | Mayor salto articular 0,588 px; angular 1,309° |
| Bucle | Pose en fase 1 idéntica a fase 0, tolerancia 0,001 px; el test incluye la transición final |
| Pelvis en marcha | Derecho −4,672…1,808; izquierdo −4,094…2,799 px respecto al montaje |
| Dibujos contiguos, incl. cierre del ciclo | Mayor cambio de pelvis 1,913/2,209 px; articulaciones 6,448/6,224 px |
| Suelas realmente rasterizadas, cuatro botas | Distancia al suelo 0–1 px durante apoyo, sin penetración visible mayor de un píxel |
| Suela plana, reproducción a 30/60/120 Hz | Deriva pico a pico 4 px con 32 dibujos → 2 px con 64; el error residual equivale a ±1 px de cuantización |
| 384 paradas/reanudaciones | Tobillo de apoyo plano: deriva numérica 0; mayor salto articular por tick de cierre 6,761 px |
| 384 arranques y sincronía | Distancia acumulada y fotograma coinciden a 30/60/120 Hz; máximo salto articular durante arranque 16,414 px |
| Inversión desde 64 fases y tres amplitudes | Desplazamiento máximo de pies emparejados 4,667 px; cambio de pelvis 2,590 px |
| Atlas | 1170 descriptores: paleta v7 exacta, alfa binaria, cabeza conservada, márgenes, dimensiones, origen y escala correctos |
| Integridad de imagen | 1170 poses: cero piezas desconectadas ≥8 píxeles; mayor fragmento residual 1 píxel |
| Cobertura GPU | 1160 renders sin piel en las zonas de ropa comprobadas ni huecos en núcleos de rodilla/bota/cintura |
| Integración | Aceleración, frenada, teclado, clic/destinos, colisiones reales, límites, inversión, foco, Esc, llegada a Jefa/guardia; sin carrera |
| Regresiones del juego normal | `movimiento`, `movimiento_sota`, `fluidez_marcha`: pasan |
| Preservación | 111 archivos del manifiesto inicial: solo cambian configuración de escena y parametrización del cargador; recursos anteriores intactos. Stable: 11 SHA256 idénticos |
| Nativo/Web | Comparación GPU, controles y escena Velvet; exportación Web separada y ejecución en Helium/WebGL 2.0 |

La deriva de suela se mide leyendo la fila opaca inferior de cada bota renderizada y combinándola con la posición redondeada del mundo a las tres frecuencias. La medición horizontal se limita al apoyo plano (fases 0,15–0,40); durante el rodado cambia el punto de contacto físico. La comprobación vertical sí cubre todo el apoyo. No se presenta la puntera matemática como sustituto de la bota dibujada.

**No se certifica deslizamiento absolutamente cero ni ausencia de todo salto raster.** El atlas contiene poses discretas; los máximos de la tabla son límites observados. La continuidad matemática no equivale a aprobación artística.

### Reproducir las pruebas

Desde la raíz, para cada nombre:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/ik_sota_v15.gd
```

Sin GPU: `ik_sota_v15`, `historico_sota_v15`, `transiciones_sota_v15`, `atlas_sota_v15`, `integridad_sota_v15`, `integracion_sota_v15`, y regresiones `movimiento`, `movimiento_sota`, `fluidez_marcha`.

Con GPU, quitar `--headless`: `contacto_sota_v15`, `cobertura_sota_v15`, `comparacion_sota_v15`. Para regenerar **solo la candidata**: `preparar_sota_ik_v15`, también con GPU; después importar con `--headless --editor --import`. Los logs de cada comprobación están en esta carpeta.

## Evidencia visual y valoración

- [Vídeo real Web, 58,87 s](comparacion_web.mp4): marcha de ambos perfiles, cámara lenta, pausa/paso y secuencia de transiciones. La última mejora del overlay —líneas por encima del sprite y rótulos separados— es posterior a esta grabación; la marcha y el controlador grabados son los finales.
- [Secuencia extraída del vídeo](secuencia_web.jpg).
- [Contacto](comparacion_00.png), [carga](comparacion_08.png), [apoyo/cruce](comparacion_16.png), [recuperación](comparacion_24.png), [segundo contacto](comparacion_32.png), [fase 40](comparacion_40.png), [fase 48](comparacion_48.png), [fase 56](comparacion_56.png).
- [Articulaciones finales](articulaciones.png), [Velvet en reposo](web_velvet_reposo.png), [derecha](web_velvet_derecha.png), [izquierda](web_velvet_izquierda.png), [llegada a Jefa](web_llegada_jefa.png).
- `botas_*` conserva las suelas aisladas; `cobertura_*` conserva los renders de diagnóstico.

La inspección del asistente confirma perfiles propios, apoyo reconocible, separación/recogida de piernas y ausencia de piezas grandes desaparecidas en las fases examinadas. El ciclo se conserva en el vídeo y se puede evaluar continuamente en Godot/Web. **No se declara terminado el dibujo ni aprobada su naturalidad.**

Limitaciones artísticas concretas:

- El montaje heredado reconstruye tela desde una imagen plana v7. Faltan dibujos independientes de la cara interna del muslo y entrepierna, el glúteo al separar las piernas, pliegues de rodilla flexionada y superficies ocultas de la caña de bota. Eso limita volumen, pliegues y continuidad del bolsillo en algunas poses.
- La candidata no añade nuevas UV ni geometría para tapar esos defectos; conserva las reconstrucciones ya existentes. Las pruebas de cobertura detectan huecos, no certifican anatomía de la silueta.
- El cambio directo entre dos perfiles propios conserva mejor el lado físico del equipo, pero cambia la silueta de botas/ropa. No hay pose frontal ni giro de tres cuartos; los 4,667 px medidos de inversión siguen sujetos a valoración visual.
- El reposo depende del punto donde se haya frenado; algunas separaciones de pies son más abiertas. Es continuo con el paso, pero su elegancia requiere valoración del autor.

La prueba Web usa teclas A/D reales, clic en el destino Jefa (llegada x=1260) y cambio real de pestaña: Sota cancela el desplazamiento y permanece en x=1227 al volver. Las dos capturas de comprobación de foco son idénticas. Consola y errores de página sin incidencias. [Overlay Web final](web_overlay_final.png).

## Archivos de esta entrega

| Acción | Archivos |
|---|---|
| Nuevos, lógica de candidata | `godot/candidatas/sota_ik_v15.gd`, `movimiento_sota_v15.gd` |
| Nuevas escenas y scripts | `godot/candidatas/comparacion_sota_v15.gd/.tscn`, `recorrido_sota_v15.gd/.tscn` |
| Nuevo generador | `godot/tests/preparar_sota_ik_v15.gd` |
| Nuevos tests | `ik_sota_v15`, `historico_sota_v15`, `contacto_sota_v15`, `cobertura_sota_v15`, `integridad_sota_v15`, `atlas_sota_v15`, `transiciones_sota_v15`, `integracion_sota_v15`, `comparacion_sota_v15` (todos `.gd`, con sus `.uid`) |
| Nuevos recursos | `godot/assets/personajes/sota/articulada_v11_candidata/`: `movimiento.json`, `marcha.png`, cuatro `cerrar_*.png`, `reposo_inicio.png` y archivos de importación |
| Modificación compatible | `godot/movimiento_sota.gd`: ruta y reflejo opcionales en constructor, validación de cantidad de fases desde JSON; valores por defecto anteriores |
| Configuración | `godot/project.godot`: escena solo para característica candidata; `godot/export_presets.cfg`: segundo preset separado |
| Documentación/evidencia | Este directorio, `task.md`, `proceso/ESTADO_DEL_PROYECTO.md` |
| Generados locales | `godot/build/web-candidata/` (exportación, no fuente) |

El repositorio tenía cambios sin commit de las entregas anteriores. El diff contra Git incluye esos cambios: para atribuir esta tarea, usar `baseline_sha256.json` y las seis copias `.gd.txt`/`.godot.txt` de esta carpeta. El rig activo, `recorrido.gd`, `movimiento.gd`, el generador anterior y todos los atlas anteriores se preservan.

## Pendiente

Valoración del autor antes de cambiar la animación normal. No hay aprobación artística nueva ni cierre de T05; T10 no se ha iniciado.

No se han probado Safari, Firefox, móvil ni sesiones prolongadas. Los seis atlas RGBA ocupan aproximadamente **367,5 MiB sin comprimir**; el PCK de comparación es de **137,25 MiB** porque conserva también recursos históricos. El incremento a 64 dibujos tiene un coste de memoria real. La comparación funciona en este M4/Helium, pero no acredita rendimiento en equipos modestos.
