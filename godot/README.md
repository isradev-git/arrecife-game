# PASE PENDIENTE · Base Godot

Base técnica del 9 de octubre, actualizada el **13 de octubre de 2026**. **Todavía no contiene el caso completo.** La escena principal `recorrido.tscn` permite caminar por Velvet con el sprite v7 provisional y altura 252 aprobada por el autor. `revision_escala.tscn` conserva la revisión de arte; `verificacion.tscn` la escena técnica original.

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

F5 ejecuta el recorrido. **Flechas o A/D:** caminar; **clic en suelo:** destino caminando; **Esc:** parar. También hay botones de acercamiento. La carrera se retira por decisión del autor el 13 de octubre; Mayús y doble clic no aumentan la velocidad. Clic en mostrador, cabina o personas del acceso selecciona su punto de llegada; no abre todavía diálogos ni viajes. Revisión visual permite comparar perfiles, alturas, lugares, planos y luz; Probar recorrido vuelve al controlador.

El centro transitable permanece en y = 705, con límites x = 128–1632 y colisión física de pies. Se conserva el orden de capas. [Registro T04](../trabajo/arte/revisiones/recorrido_jugable_v1/README.md). El sprite aún no anima los pasos. GDScript y Compatibility; Web sin hilos ni extensiones, sin .NET ni complementos.

## Repetir la comprobación y exportar

Desde la raíz `el-arrecife/`:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --editor --import
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script tests/verificacion.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script tests/escala.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script tests/movimiento.gd
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

Decisión del 10 de octubre: el autor aprueba el aspecto de Sota en escena y elige solo perfiles. Los controles actuales ya no ofrecen frontal ni tres cuartos; el atlas original se conserva. [Revisión histórica de solo perfiles](../trabajo/arte/revisiones/escala_v2/README.md). Respiración y cambios de dirección animados siguen pendientes; la carrera se descarta después por decisión del autor.

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

Sota usa v7 como predeterminada; `assets/personajes/sota/perfiles_base_v1.png` y su JSON se conservan como alternativa para comparar. `contraluz.gdshader` calcula el borde alfa de la base; `silueta.gdshader` conserva la solución anterior para v7. La barandilla se recorta con AtlasTexture y `metal_opaco.gdshader` evita residuos/metal semitransparente.

Versiones conservadas: [primera separación y fondo reparado](../trabajo/arte/entornos/velvet/capas_v1/README.md), `assets/fiebre_velvet_pixel_v1.png` idéntico a la referencia del autor, y `assets/fiebre_velvet_v1.png` para la escena técnica histórica. [Procedencia del rótulo](../juego/arte/velvet_v1.md); [prompt](../juego/arte/prompts/velvet_rotulo_v1.txt). No se alteran las capturas anteriores.


La carpeta `build/` y la caché `.godot/` se pueden regenerar y están excluidas del control de versiones. Los archivos de importación y UID junto a recursos/scripts sí forman parte del proyecto reproducible. No distribuir canon, guion de moderación o documentos de proceso como parte del paquete Web.

Siguiente trabajo: [plan de migración y criterios de cierre](../proceso/PLAN_GODOT.md). Estado general: [continuidad](../proceso/ESTADO_DEL_PROYECTO.md).

**Recepción T07.6, base conservada:** [tres recursos y prompts](../trabajo/arte/entornos/velvet/recepcion_v1/README.md), [cinco capturas nativas y siete Web](../trabajo/arte/revisiones/recepcion_v1/README.md). Parche actual x = 1210–1488, y = 440–675; figurante z = −4, mostrador z = −3, equipo z = −2, Sota z = 0 y barandilla delantera z = +5. Figurante de perfil, 244 de alto y pies y = 675; base del equipo y = 538. Interruptores Figurante/Equipo independientes. Base sin neón y contraluz manual del entorno; pendientes fuentes espaciales y animación. Pruebas GPU del cuerpo detrás del mostrador y Sota delante en ambos perfiles correctas; visibilidad por clic Web sin errores. Arte nuevo pendiente de valoración.

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/recepcion.gd
```

Añadir `-- --capturas` regenera las cinco capturas nativas; necesita render gráfico, sin `--headless`.

**Acceso T07.7, revisión conservada:** [recursos, corrección y prompts](../trabajo/arte/entornos/velvet/acceso_v1/README.md), [diez capturas nativas/Web](../trabajo/arte/revisiones/acceso_v1/README.md). Persona con mochila de perfil derecho, altura 236, apoyo y = 675 y z = −4; Sota z = 0 y barandilla delantera z = +5. Parche x = 1510–1606, y = 430–675. Controles Acceso/Junto al acceso (Sota x = 1560). Material propio con contraluz manual del entorno; sin animación ni luces espaciales. Alfa/apoyo, parche fuera idéntico y oclusiones GPU correctos; pruebas anteriores y clic Web sin errores. Recurso nuevo pendiente de valoración. Persona contigua del acceso sigue en el fondo.

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/acceso.gd
```

Las cinco capturas originales se conservan; el modo de capturas actual guarda en la revisión T07.8 siguiente.

**Acompañante T07.8, base conservada:** [dos recursos y prompts](../trabajo/arte/entornos/velvet/acompanante_v1/README.md), [catorce capturas](../trabajo/arte/revisiones/acompanante_v1/README.md). Perfil izquierdo, altura 248, x = 1594, apoyo y = 675 y z = −4. Ambas personas del acceso independientes; parche común actual x = 1510–1664, y = 414–675. Materiales propios, controles Acompañante/Junto al acompañante (Sota x = 1625). Dos modos de la prueba de acceso y regresiones anteriores correctos; clic Web sin errores. Posibilidad de diálogos anotada en T11; sin conversaciones ni animación todavía.

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/acceso.gd -- --acompanante
```

Añadir `--capturas` tras `--` guarda siete capturas actuales en `acompanante_v1`, sin sobrescribir T07.7. La prueba GPU requiere render gráfico, sin `--headless`; sin `--acompanante` prueba la figura de mochila.

**Guardia y cabina T07.9 vigentes:** [tres PNG originales y prompts](../trabajo/arte/entornos/velvet/cabina_v1/README.md), [catorce capturas Godot/Web](../trabajo/arte/revisiones/cabina_v1/README.md). Interior reconstruido en x = 149–278, y = 389–675; guardia de perfil derecho, 260 de alto y apoyo y = 675, z = −8; frontal con ventanilla transparente, base y = 675, z = −7. Sota pasa delante en z = 0, centro y = 705; barandillas/recepción/acceso conservados. Controles Guardia/Cabina independientes y Frente al guardia (Sota x = 300). El panel se aparta a x = 480 para posiciones x ≤ 340 y retorna a x = 24 en el resto.

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/cabina.gd
```

Prueba GPU sin `--headless`; añadir `-- --capturas` guarda siete renders en `cabina_v1`. Pasan ventanilla/frontal/cuerpo, terminal azul visible, Sota delante en ambos perfiles, fondo fuera del parche idéntico, controles/panel, regresiones, importación y exportación. Helium: perfiles/visibilidad/posición/retorno por clic sin errores. Funciones decididas por el autor: hablar con el guardia (T11) y viajar a otra cota (T19). Todavía sin diálogo, viajes, animación ni luz espacial; señalización por revisar al integrar el recorrido.


**Jefa del mostrador T08.1 vigente:** el autor identifica a la persona del mostrador como Jefa de la Nómina y aporta su retrato para adaptar la figura. [Sprite, prompt y procedencia](../trabajo/arte/personajes/jefa/pixel_v1/README.md), [doce capturas Godot/Web](../trabajo/arte/revisiones/jefa_v1/README.md). Perfil izquierdo, altura 244 y apoyo y = 675; sustituye la figurante provisional, conservada como versión anterior. Burdeos/negro/dorado, pelo recogido y hardware de mandíbula/cuello; rostro apenas definido. Control **Jefa** sustituye a Figurante. Planos, mobiliario, parche y contraluz manual conservados. `tests/recepcion.gd` comprueba el nuevo ancho y sus oclusiones; `-- --capturas` guarda ahora seis renders en `jefa_v1`, sin sobrescribir T07.6.

[Retratos de Sota y Jefa](../trabajo/arte/personajes/retratos_v1/README.md) guardados sin editar bajo `assets/personajes/sota/` y `assets/personajes/jefa/`. Decisión de interfaz: oscurecer escena, Sota a izquierda, interlocutor a derecha y diálogo entre ambos; implementación posterior T10/T11. Pasan recepción, escala, escena técnica, capas, mostrador, cabina, importación/exportación y clic en Helium sin errores. T08 sigue abierta para animación y libro propio; no hay diálogo todavía.


**Libro propio T08.2 vigente:** el autor aprueba el sprite pixel art de la Jefa; su PNG se conserva intacto. [Libro abierto, original y prompt](../trabajo/arte/personajes/jefa/libro_v1/README.md), [catorce capturas](../trabajo/arte/revisiones/libro_v1/README.md). Objeto de 56 × 18, x = 1318, apoyo de tapa y = 538 y z = −5, detrás de las manos z = −4; equipo de recepción separado. Control Libro independiente. `tests/recepcion.gd` comprueba apoyo/orden/alfa y GPU de manos/páginas y Sota; `-- --capturas` guarda ahora siete renders en `libro_v1`, preservando las revisiones anteriores. Pasan recepción, escala, capas, mostrador, importación/exportación y clic en Helium sin errores. Libro nuevo pendiente de valoración; todavía sin animación, acción de consulta/anotación o diálogo.


**Sota predeterminada · 12 de octubre:** el autor prefiere el modelo **Referencia aprobada (v7)** tras comparar en navegador. La escena arranca con ese atlas y `silueta.gdshader`; Base e iluminación sigue disponible. PNG intactos. [Tres capturas y pruebas](../trabajo/arte/revisiones/preferencia_sota_v1/README.md): escala comprueba selección inicial y ambas variantes; GPU de capas/recepción, exportación y clic Web correctos. La adaptación de luz por entorno debe conservar el dibujo de v7; fuentes espaciales y animación pendientes.


**Comparación T02.1:** [lámina y pruebas](../trabajo/arte/revisiones/escala_produccion_v1/README.md). Control Comparar Jefa (Sota x = 1260), tres alturas 232/252/272 y ambos perfiles frente a Jefa/cabina. `tests/escala_produccion.gd` necesita GPU; `-- --capturas` guarda doce renders normales y uno a 836 × 471, sin alterar la configuración principal 1672 × 941/canvas_items. [Comparación HTML](../trabajo/arte/revisiones/escala_produccion_v1/comparacion.html): recortes a tamaño real y raster alternativo ampliado 2× con nearest. Propuesta 252/244 y render actual; el autor aprueba Sota 252 el 13 de octubre, no cierra retícula artística de originales ni escalado final a toda ventana. Pruebas de escala, render GPU, exportación y clic Web correctos; arte aprobado intacto, sin animación/movimiento.

**T04 · 13 de octubre:** controlador y pruebas en `movimiento.gd`, `recorrido.gd` y `tests/movimiento.gd`. Las capturas nativas se regeneran con:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/movimiento.gd -- --capturas
```

Helium/Chromium: teclado/clic, Mayús, aceleración/frenada, extremos, acercamientos, pérdida/recuperación de foco y retorno a revisión visual comprobados. No acredita Safari/Firefox/móvil ni acabado de animación.

**Solo caminar · decisión del autor, 13 de octubre:** retirada completa de carrera en el controlador y panel Godot. Prueba adaptada: siete llegadas, frenada/inversión, límites, colisión, foco y Mayús sin acelerar. Las capturas anteriores de T04 se conservan como historial; el modo `--capturas` guarda ahora en [solo_caminar_v1](../trabajo/arte/revisiones/solo_caminar_v1/README.md). T05 producirá sprites propios por fotograma, con ciclo de dos pasos en ambos perfiles; T06 cubre arranque/parada, giro y reposo, sin carrera.

**T05.1 · corrección del 13 de octubre:** el autor rechaza las poses por diferencia de dibujo y oscuridad frente a v7. Se retira Pasos en prueba del recorrido; los recursos y la prueba histórica se conservan. [Comparación de una pose nueva](../trabajo/arte/revisiones/marcha_identidad_v2/README.md), sin incorporar al juego. `tests/identidad_marcha.gd -- --capturas` necesita GPU y archivos del repositorio, no es una escena exportable ni una animación. `tests/marcha.gd` verifica datos históricos y que el recorrido use únicamente v7 al moverse.

**Continuación T05.1:** [contacto, apoyo, cruce e impulso oscuros](../trabajo/arte/revisiones/marcha_poses_oscuras_v1/README.md), primer medio paso derecho todavía sin integrar. `tests/poses_oscuras.gd` comprueba alfa/márgenes/altura y rango tonal frente al original; sin `--headless` y con `-- --capturas` genera las dos láminas estáticas. Misma escala y shader, pivote de locomoción pendiente. La serie no es un ciclo ni está aprobada por el autor; no se modifica la exportación Web.

**Más posturas T05:** el autor pide un andar más natural y se añaden [tres intermedios, siete posturas en total](../trabajo/arte/revisiones/marcha_intermedios_v1/README.md). `tests/poses_oscuras.gd -- --intermedios` mide la nueva serie; añadir `--capturas` y ejecutar con GPU genera las dos láminas nuevas sin sobrescribir las anteriores. Sigue sin integrarse en el recorrido: faltan el otro paso/perfil y la prueba del bucle con apoyos sincronizados.

**Mangas T05 corregidas:** el autor detecta la manga adelantada demasiado corta en extensión/impulso. [Antes/después y serie corregida](../trabajo/arte/revisiones/marcha_mangas_v1/README.md); `tests/poses_oscuras.gd -- --mangas` mide estas variantes y `--capturas` con GPU genera cuatro láminas nuevas. Preserva modos/capturas anteriores y recorrido v7. Ambas mangas deben conservar largo, puño remangado bajo el codo y diseño en todos los fotogramas; continuidad animada todavía pendiente.

**Segundo paso T05:** [cuatro claves de la pierna contraria, v7 real y pares A/B](../trabajo/arte/revisiones/marcha_segundo_paso_v1/README.md). `tests/poses_oscuras.gd -- --segundo-paso` mide las nuevas propuestas; con GPU y `--capturas` genera cuatro láminas nuevas. Once dibujos de perfil derecho, sin bucle ni perfil izquierdo nuevos; cinco intermedios, continuidad visual y pivotes/apoyos/límites pendientes antes de integrar. Recorrido y Web conservan v7.

**Serie derecha T05 · 16 propuestas:** [cinco enlaces nuevos y cuatro láminas ordenadas](../trabajo/arte/revisiones/marcha_ciclo_derecho_v1/README.md). `tests/poses_oscuras.gd -- --ciclo-derecho` mide la serie completa contra v7 real; con GPU y `--capturas` genera láminas de ambos pasos. Dimensiones/esquinas/márgenes/altura pasan, pero devuelve **código 1** por alerta tonal de llegada B v3 (+15,98 %, límite +15 %). El límite se conserva: el script guarda evidencia antes de fallar. Cuatro modos anteriores y recorrido v7 comprobados. Bucle/pivotes/apoyos/ritmo, continuidad visual y perfil izquierdo pendientes; no integrado ni exportado.

**Entrega anterior T05/T06 (naturalidad rechazada):** [Sota completa en ambos sentidos, transiciones y demo Web](../trabajo/arte/revisiones/movimiento_completo_v1/README.md), [fuentes/prompts](../trabajo/arte/personajes/sota/movimiento_v3/README.md). Recorrido integra movimiento_sota.gd con 16 fases propias por perfil, preparación/cierre A-B, giro de perfil y reposo v7/respiración; Movimiento reducido desactiva respiración. Ciclo por distancia 196 px, caminar 156 px/s, apoyo proyectado en y = 705 y límites 128–1536. Marco AtlasTexture 836 × 1024 y una escala por perfil desde reposo 252; máscara alfa 0,95 limpia residuos sin tocar RGB. tests/movimiento_sota.gd comprueba fases/paleta/escala/apoyos/inversión/reducción/extremos; --capturas necesita GPU. Preparación de copias/metadatos con tests/preparar_movimiento.gd, importación antes de exportar. Godot/controlador/escala/archivo histórico/Web comprobados; valoración visual del autor, otras plataformas y rendimiento pendientes. Los apartados anteriores de marcha estática/rechazada son historial.

**Corrección vigente de fluidez T05:** [Diagnóstico y vídeos antes/después](../trabajo/arte/revisiones/marcha_fluidez_v1/README.md). El pie fijaba todo el sprite, congelando la cadera entre poses. Se elimina esa compensación; cuerpo visual y físico avanzan juntos. Cadencia por `avance_poses` de cada perfil, ciclo 224 px a 156 px/s, no reparto uniforme. PNG, escala 252, suelo 705, planos y controles intactos. Nueva prueba: `Godot --headless --path godot --script res://tests/fluidez_marcha.gd`; ambos perfiles/16 fases a 30/60 Hz, sin congelaciones/saltos extra y apoyo proyectado con desviación máxima ~23 px. Marcha/controlador/GPU/importación/exportación/Web comprobados. Corrección entregada, valoración y acabado artístico pendientes; no se afirma pie inmóvil ni naturalidad perfecta.
