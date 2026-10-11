# PASE PENDIENTE · Base Godot

Preparación técnica del 9 de octubre de 2026. **Todavía no contiene el caso jugable ni el movimiento de Sota.** La escena principal actual permite revisar ambos perfiles de Sota en Velvet, su altura y filtrado. La escena técnica anterior se conserva en `verificacion.tscn`.

**Entrega pixel art · 11 de octubre:** el autor aprueba el estilo con píxel intenso y ojos sutiles, y el contraluz acorde al entorno. Se compara el atlas v7 aprobado con una [base sin neón y contraluz separado](../trabajo/arte/revisiones/luz_v2/README.md). La máscara de contorno se calcula desde el alfa; color, intensidad y dirección son parámetros independientes. La variante nueva está entregada, pendiente de valoración. Importación, pruebas, render nativo y exportación correctos. La escena actual se comprueba después en Helium/Chromium; retícula, luces del escenario y otros navegadores pendientes. [Dirección vigente](../trabajo/direccion_artistica.md).

## Instalación comprobada

- Editor estándar **4.7.2.stable.official.ed1daf0bf**, en `/Applications/Godot.app`.
- Plantillas **Web** de la misma versión, en `~/Library/Application Support/Godot/export_templates/4.7.2.stable/`.
- Descarga desde las publicaciones oficiales de [godot-builds](https://github.com/godotengine/godot-builds/releases/tag/4.7.2-stable); SHA-512 de editor y paquete de plantillas contrastados con `SHA512-SUMS.txt`. Firma del editor y evaluación de Gatekeeper correctas.
- Solo se instalaron las plantillas Web. Para distribuir ejecutables de otras plataformas habrá que instalar también sus plantillas.

Abrir Godot e importar `project.godot`, o ejecutar desde la raíz del repositorio de trabajo:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --editor --path godot
```

F5 ejecuta la revisión. Los botones cambian vista, altura, ubicación, filtrado y color del contorno; todavía no hay desplazamiento. Elegir **Galería / Recepción / Personal / Extremo** y alternar **Ambas barandillas / Solo trasera / Solo delantera / Sin barandillas** para comprobar ambos bordes y sus oclusiones. [Centro de pasarela y capas vigentes](../trabajo/arte/revisiones/recorrido_v1/README.md); [comparación de luz](../trabajo/arte/revisiones/luz_v2/README.md). El proyecto usa GDScript y Compatibility; la exportación Web desactiva hilos y extensiones. No necesita .NET ni complementos.

## Repetir la comprobación y exportar

Desde la raíz `el-arrecife/`:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --editor --import
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script tests/verificacion.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script tests/escala.gd
mkdir -p godot/build/web
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --export-release Web
python3 -m http.server 8766 --bind 127.0.0.1 --directory godot/build/web
```

Con ese servidor, abrir `http://127.0.0.1:8766/`. Si el puerto está ocupado, cerrar el servidor de la sesión anterior o escoger otro. No abrir el HTML exportado mediante `file://`: servirlo por HTTP local o HTTPS público. Detener el servidor con Ctrl+C.

Durante la verificación de esta entrega se sirvió la raíz completa del proyecto en el puerto 8766; por eso la pestaña de prueba usa `http://127.0.0.1:8766/godot/build/web/`. La prueba no publica el juego en Internet y el servidor no debe darse por activo en futuras sesiones.

## Resultado registrado

| Prueba | Resultado |
| --- | --- |
| Versión, SHA-512, firma y Gatekeeper | Correctos. |
| Importación del proyecto y apertura del editor gráfico | Correctas; Compatibility en Apple M4. |
| Comprobación automática | Pasa: escena instanciada, textura de ancho 1672, foco del botón y señal que actualiza texto. |
| Exportación Web release | Termina con código 0. Paquete de aproximadamente 40 MiB sin compresión de transporte; no es el peso del futuro juego completo. |
| Safari por HTTP local | Fondo, interfaz, respuesta al clic, recarga y activación con Enter comprobados visualmente. |

No se ha validado aquí guardado, audio, lectores de pantalla, móvil, otros navegadores ni rendimiento del juego completo. El árbol de accesibilidad de Safari expone esta prueba principalmente como un canvas: los controles nativos de Godot no heredan automáticamente la accesibilidad HTML del prototipo. Hay que comprobarla expresamente al migrar la libreta.

Prueba posterior de color de contorno: `tests/escala.gd` incluye los cuatro modos. `tests/iluminacion.gd` conserva la comprobación sobre v7; `tests/contraluz.gd` comprueba la base nueva. Ambos necesitan renderizado gráfico y se ejecutan **sin `--headless`**:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/iluminacion.gd
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/contraluz.gd
```

En Apple M4 comprueba alfa invariante, muestras de cara/ojos/ropa/equipo sin cambios, desaparición del rosa intenso y restauración idéntica del aspecto original. La prueba nueva verifica además intensidad cero idéntica a la base y desplazamiento de la luz al lado opuesto en ambos perfiles al invertir su dirección. No demuestra conexión con lámparas/oclusiones del escenario ni comportamiento en navegador.

Cambio posterior del mismo día: el fondo activo pasa a Velvet. Importación, comprobación automática y exportación Web repetidas con resultado correcto; la prueba visual en Safari de la tabla corresponde a la entrega anterior.

Revisión de escala posterior: cuatro vistas y tres alturas verificadas por prueba automática y capturas nativas. La exportación Web se regenera correctamente. La prueba en Safari de la tabla corresponde a la escena técnica anterior: no se ha observado todavía la revisión nueva en navegador.

Decisión del 10 de octubre: el autor aprueba el aspecto de Sota en escena y elige solo perfiles. Los controles actuales ya no ofrecen frontal ni tres cuartos; el atlas original se conserva. [Revisión histórica de solo perfiles](../trabajo/arte/revisiones/escala_v2/README.md). Respiración, carrera y cambios de dirección animados siguen pendientes.

## Recursos y continuidad

**Suelo horizontal y capas vigentes:** `assets/entornos/velvet/fondo_suelo_recto_v1.png` conserva el recorrido horizontal y el ancho visible de la pasarela. `BACK_EDGE_Y = 675`, `GROUND_Y = 705` y `FRONT_EDGE_Y = 735` distinguen borde trasero, centro transitable y borde delantero. Seis módulos delanteros solapados (z = +5) cubren todo el ancho visible y una barandilla trasera (z = −5) conserva el hueco central, con Sota en z = 0; los botones controlan su visibilidad, sin invertir su orden. [Fondo, intentos y prompts](../trabajo/arte/entornos/velvet/suelo_v1/README.md). Los módulos se unen por postes, separados 754 píxeles del atlas, con remates solapados; ciudad, humo, luces y mobiliario/figurantes restantes siguen aplanados. T07 continúa en curso.

La prueba de oclusión necesita render gráfico:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/capas.gd
```

En Apple M4 comprueba largueros sin huecos en dos filas del ancho completo y oclusión GPU en ocho combinaciones de posición/perfil, incluidas uniones y extremos. Escala, suelas, bases, cobertura y ocultación de todos los módulos correctas; importación, escena técnica y exportación correctas. [Cuatro capturas nativas y cinco Web](../trabajo/arte/revisiones/recorrido_v1/README.md): Helium muestra cuatro ubicaciones, ambos perfiles y retirada conjunta de todas las extensiones por clic, sin errores registrados. El autor valora la perspectiva de T07.3; barandillas de T07.4 aprobadas visualmente, incluida trasera junto a la gente. Acabado/luz repetidos del módulo, resto de capas, Safari/Firefox y movimiento/colisiones pendientes.

**Mostrador por capas T07.5, revisión conservada:** [recursos y prompts](../trabajo/arte/entornos/velvet/mostrador_v1/README.md) y [ocho capturas](../trabajo/arte/revisiones/mostrador_v1/README.md). Parche de fondo x = 1210–1488, y = 532–675 y mostrador independiente en z = −3, base y = 675. Sota pasa por delante en el centro y = 705. Botones Frente al mostrador, Mostrador visible y Ocultar mostrador; variante nueva pendiente de valoración. Sin interacción ni movimiento. Prueba GPU adicional, sin --headless:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/mostrador.gd
```

Confirma alfa/apoyos/orden, Sota por delante en ambos perfiles y render idéntico fuera del parche. Mostrar/ocultar y perfiles comprobados también por clic en Helium, sin errores registrados.

Sota usa `assets/personajes/sota/perfiles_base_v1.png` y su JSON; v7 sigue disponible para comparar. `contraluz.gdshader` calcula el borde alfa de la base; `silueta.gdshader` conserva la solución anterior para v7. La barandilla se recorta con AtlasTexture y `metal_opaco.gdshader` evita residuos/metal semitransparente.

Versiones conservadas: [primera separación y fondo reparado](../trabajo/arte/entornos/velvet/capas_v1/README.md), `assets/fiebre_velvet_pixel_v1.png` idéntico a la referencia del autor, y `assets/fiebre_velvet_v1.png` para la escena técnica histórica. [Procedencia del rótulo](../juego/arte/velvet_v1.md); [prompt](../juego/arte/prompts/velvet_rotulo_v1.txt). No se alteran las capturas anteriores.


La carpeta `build/` y la caché `.godot/` se pueden regenerar y están excluidas del control de versiones. Los archivos de importación y UID junto a recursos/scripts sí forman parte del proyecto reproducible. No distribuir canon, guion de moderación o documentos de proceso como parte del paquete Web.

Siguiente trabajo: [plan de migración y criterios de cierre](../proceso/PLAN_GODOT.md). Estado general: [continuidad](../proceso/ESTADO_DEL_PROYECTO.md).

**Recepción T07.6 vigente:** [tres recursos y prompts](../trabajo/arte/entornos/velvet/recepcion_v1/README.md), [cinco capturas nativas y siete Web](../trabajo/arte/revisiones/recepcion_v1/README.md). Parche actual x = 1210–1488, y = 440–675; figurante z = −4, mostrador z = −3, equipo z = −2, Sota z = 0 y barandilla delantera z = +5. Figurante de perfil, 244 de alto y pies y = 675; base del equipo y = 538. Interruptores Figurante/Equipo independientes. Base sin neón y contraluz manual del entorno; pendientes fuentes espaciales y animación. Pruebas GPU del cuerpo detrás del mostrador y Sota delante en ambos perfiles correctas; visibilidad por clic Web sin errores. Arte nuevo pendiente de valoración.

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/recepcion.gd
```

Añadir `-- --capturas` regenera las cinco capturas nativas; necesita render gráfico, sin `--headless`.
