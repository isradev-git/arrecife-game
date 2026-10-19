# El Arrecife · continuidad vigente

Última actualización: **19 de octubre de 2026**. Motor: **Godot 4.7.2**, GDScript, Compatibility. [Historial completo de la etapa anterior](ESTADO_ETAPA_PIXEL_20261018.md).

## 1. Decisiones vigentes del autor

- Experiencia de **aproximadamente 30 minutos** para conocer el lore/canon de El Arrecife de forma interactiva.
- **Sota protagonista**: conocerla durante el juego y conocer a personas del Arrecife.
- Hablar con algunas personas e interactuar con objetos; no toda la figuración ofrece diálogo.
- **Retirados el caso/crimen central, encargos, deducciones y objetivos obligatorios** como estructura del juego. No migrar sus estados ni sus condiciones de victoria.
- **Abandonado el pixel art.** Personajes y escenarios seguirán el lenguaje ilustrado de los retratos originales de Sota/Jefa.
- **19 oct: aprobado el juego completamente 3D**, personajes y entornos, con movimiento sólo izquierda/derecha. Escenarios más largos y objetivo de gráficos profesionales de juego indie. La primera entrega de unos 30 minutos podrá crecer con nuevos espacios y contenido de canon/lore. No equivale a una entrega ya terminada ni fija una fecha de lanzamiento comprobada.
- **Movimiento convincente y modelo fiel al retrato siguen siendo requisitos.** Libertad creativa autorizada. Actualización del autor: **encuadre lejano y protagonismo visual del entorno**. Rechaza el aspecto poligonal/genérico del modelo actual y el deck desconectado de las correas. **Última revisión: el autor considera que el movimiento actual está muy bien; se conserva como movimiento aprobado para continuar.** El modelo sigue pendiente de parecido y pulido. Solicita cámara algo más alejada y pregunta si el entorno es sólo una prueba.

**Referencia de parecido señalada por el autor:** `trabajo/arte/revisiones/sota_retrato_3d_v4/ensayo_01/v4_cabeza.png`. Dice que se acerca bastante a Sota y pide que el vestuario deje de parecer articulaciones pintadas: prendas por encima del cuerpo, con construcción, texturas y materiales propios. Esa elección concreta no equivale a aprobar todo el modelo ni las prendas.

**Corrección posterior del autor:** la piel de v5 es demasiado morena. Sota es sólo un poco morena; usar tono cálido claro, guiado por el retrato. La referencia de parecido anterior no aprueba ese tono oscuro.

## 2. Archivo y recuperación

[Respaldo de la etapa anterior](ARCHIVO_ETAPA_PIXEL_20261018.md): archivo local de 2,6 GB, **2320 archivos cotejados por SHA256 dentro del tar**, con código, arte, prompts, guiones, versiones, pruebas, historial Git y cambios sin confirmar. Se excluyen cachés, exportaciones regenerables y credenciales. Copia en el mismo equipo, no respaldo externo.

`godot/`, `juego/` y las pruebas de mesa permanecen accesibles como históricos, sin borrar ni renombrar sus recursos. Documentos previos congelados junto a los originales para conservar enlaces relativos. La candidata 23 fue rechazada visualmente; sus cifras técnicas no cambian esa valoración. La derecha 17 y Sota 0.1 stable quedan como aprobaciones históricas de esa etapa, no arte obligatorio para la nueva.

## 3. Diseño y documentación actuales

- [Experiencia ilustrada](../trabajo/diseno/EXPERIENCIA_ILUSTRADA.md).
- [Dirección artística](../trabajo/direccion_artistica.md): retratos como referencia, contornos definidos, sombras amplias, volúmenes legibles, ambiente cyberpunk social.
- [Plan Godot nuevo](PLAN_GODOT.md) y [tareas I00–I05](../task.md). I00 completada; movimiento de I01 aprobado por el autor; I02 en curso.
- Canon y `sources/` sólo consulta. Antes de escribir contenido nuevo, cotejar canon y distinguir hecho, opinión del personaje y propuesta. No se ha reescrito el guion ni fijado una ruta nueva.

## 4. Proyecto activo y prueba de locomoción

**`godot_ilustrado/project.godot`**, separado del histórico. **F5 abre ahora `demo_velvet.tscn`**, demo descrita más abajo. La anterior `recorrido_3d.tscn` conserva la pasarela técnica de 42 m con geometría de ciudad/fachadas, luz, cámara en perspectiva estrecha y seguimiento. `jugadora.gd` aplica el root motion a `CharacterBody3D`: suelo y barreras tienen colisión física y se anticipa la frenada. Teclado A/D o flechas, clic al suelo y pausa con Espacio/botón. Pérdida de foco pausa y cancela destino. Es una muestra de composición, no una localización canónica confirmada.

El botón Laboratorio conserva la prueba neutra con retrato y marcha continua, lenta, pausa y paso; el botón Pasarela 3D permite volver. La base humana neutra anterior se conserva abriendo `laboratorio.tscn` con `-- --base`. En el paso de pasarela se conservaron modelo, clips, rig y adaptación; SHA256 de GLB, `.blend` y generador cotejados con el registro anterior. Después se corrigió exclusivamente el equipo en la v2 indicada abajo.

Fuente: Quaternius Universal Base Characters Standard y Universal Animation Library Standard, CC0, [originales/licencias/SHA256](../trabajo/arte/terceros/quaternius_20261018/README.md). Se usa sólo reposo y marcha, con root motion y adaptación nativa `RetargetModifier3D`; sin plugin ni nuevo IK propio. Se ha construido un [estudio de Sota con 26 piezas, 13908 vértices ponderados y 65 huesos](../trabajo/arte/personajes/sota/ilustrada_3d_v1/README.md): chaqueta, pantalón cargo, botas, pelo, correa, implantes y deck derecho; no es arte final ni tiene sus proporciones aprobadas. Fuentes `.blend`, generador y primeros intentos conservados. Blender 4.5.3 se ejecutó desde una imagen temporal con SHA256 oficial comprobado, sin plugin ni dependencia de ejecución. Preparación reproducible mediante `godot_ilustrado/preparar_fuentes.py`.

Resultados iniciales:

- Importación y ejecución nativa correctas, Apple M4 / Compatibility.
- A 30/60/120 FPS: 3,900002 / 3,899998 / 3,900009 m de root motion en 4 s. Velocidad del clip: 0,975 m/s; ciclo 1,3 m en 1,333 s.
- 65 huesos: transformaciones finitas, sin escalado y error máximo medido de longitud local 0 m tras retarget.
- Mezcla hacia reposo llega a cero; root motion nulo en reposo. Recorrido lateral y pérdida de foco comprobados.
- GPU: superficie deformada de la malla, 80 muestras de marcha estable, borde inferior −0,004972..+0,007619 m respecto al suelo. Margen inicial, **no contacto perfecto ni ausencia de deslizamiento horizontal**. El intento de leer la malla en headless no funciona con el renderizador dummy; la prueba válida es `tests/contacto.gd` con GPU.
- Captura nativa de 360 fotogramas a 60 FPS: vídeo de 6 s, ambos sentidos y paso hacia reposo; cinco capturas y secuencia inspeccionadas. [Evidencias](../trabajo/arte/revisiones/locomocion_ilustrada_v1/README.md).

Pruebas del estudio vestido: modelo/26 piezas/pesos/deck y retarget activo pasan; control mediante eventos Godot (teclado, parada, inversión e interrupción de giro, clic/llegada, frenada en borde, foco) pasa. Botas: borde inferior −4,952..+7,477 mm en 160 muestras estables. Excursión horizontal de marcadores en ventanas planas: 1,425 / 6,052 mm, 4 / 26 muestras; no valida todo el rodado ni transiciones. Primera suela rígida falló con −39,49 mm y fue retirada, sin relajar umbral. [Evidencias nuevas de Sota](../trabajo/arte/revisiones/sota_ilustrada_3d_v1/README.md). No hay aprobación artística nueva.

### Validación del tramo 3D · 19 oct

- Nueva prueba `tests/recorrido.gd`, simulación física a 60 Hz: suelo, carril lateral, teclado, parada estable, inversión, giro interrumpido, clic/llegada, cámara, recorrido hasta la barrera derecha, barrera izquierda y obstáculo interior. Foco pausa y cancela destino. Pasa.
- Se reprodujo un fallo nuevo al cancelar un giro: el cuerpo podía quedar oblicuo mientras caminaba. Corregido comparando la orientación real con la orientación solicitada; prueba fallida previa conservada entre las evidencias.
- Regresiones `locomocion.gd`, `modelo.gd` y `control.gd` pasan. La primera vuelve a medir 30/60/120 FPS; el recorrido físico nuevo se prueba a 60 Hz. No confundir ambas coberturas.
- Capturas nativas de tres zonas y vídeo de 9 s con derecha, izquierda, giro y parada; secuencia inspeccionada. Geometría, materiales y silueta siguen siendo un estudio inicial, todavía demasiado simples para declarar el acabado profesional. [Evidencias del tramo](../trabajo/arte/revisiones/pasarela_3d_v1/README.md).

### Corrección de equipo · Sota 3D v2

El autor señaló que el cyberdeck tapaba la mano. Se confirmó invasión del recorrido mano/antebrazo. [V2 anterior, rechazada visualmente](../trabajo/arte/personajes/sota/ilustrada_3d_v2/README.md), `assets/sota_3d_v2/sota.glb` conservada: carcasa de 8,5 a 5,5 cm, ceñida y retrasada en la cintura derecha. Sólo cambian las tres mallas del equipo; las otras 23 mantienen vértices/normales/índices/pesos/huesos idénticos. Fuente v1 y sus recursos intactos; dos ensayos intermedios preservados. No cambia la marcha.

Nueva prueba GPU `tests/equipo.gd`: 1.920 poses a 120 Hz en ambos sentidos, reposo/arranque/marcha/parada; sin cruces de aristas de mano/antebrazo distal con caja del equipo ampliada 3 mm. Volumen anterior sobre las mismas poses: 1.727 cruces. Regresiones modelo/control/recorrido pasan. Capturas cercanas antes/después en ambos sentidos inspeccionadas. Web regenerada, carga y render en Helium sin errores registrados. SHA256 confirma que la fuente, generador y GLB de v1 siguen intactos. [Evidencias](../trabajo/arte/revisiones/sota_equipo_3d_v2/README.md). El test no cubre futuras animaciones de interacción; no hay aprobación artística nueva.

### Candidata v3 y plano de entorno · corrección del autor

El autor rechazó el modelo v2 por parecido insuficiente, aspecto poligonal/PS1 y cyberdeck separado de las correas. Pidió plano lejano y protagonismo del entorno, manteniendo cuidado de los personajes. La aprobación del 3D completo sigue vigente; no se ha aprobado ninguna nueva Sota.

**Recurso de esta entrega histórica:** `godot_ilustrado/assets/sota_3d_v3/sota.glb`, desde `cuerpo.gd`; el laboratorio también usa v3 y permite seleccionar `modelo_sota` para comparación. [Fuente Blender/generador](../trabajo/arte/personajes/sota/ilustrada_3d_v3/README.md), sin cambios en clips, rig, velocidad ni controlador. V1/v2 y sus fuentes intactas. V2 conserva además una copia del render anterior. Los ensayos fallidos de hombro/pelo/material de esta iteración están identificados como tales, sin presentarlos como resultado aprobado.

La v3 trabaja superficies continuas de chaqueta/mangas, cuello/solapas/puños, transferencia baricéntrica de pesos, pantalón y botas, pelo por mechones, detalles faciales e implantes adheridos a piel. Arnés cerrado y ajustado a la chaqueta, con anclaje de pelvis común al deck. La chaqueta usa color continuo por vértice y el render lo activa explícitamente; se retiró el pase de contorno que acentuaba facetas e intersecciones. **41 piezas, 29173 vértices ponderados y 65 huesos** en esta candidata; cantidad de geometría no equivale a calidad artística.

Cámara de juego a 22 m con FOV 29°, sin reescalar a Sota: altura proyectada inicial **15,59 %**. El plano muestra más ciudad, estructura inferior y un paso elevado. Materiales con desgaste discreto. Geometría estática agrupada en `MultiMesh`, sin alterar las colisiones: muestra central de 1991 a 314 llamadas de dibujo durante la iteración; no es un benchmark de FPS.

Validación de esta entrega: seis pruebas nativas con GPU pasan sin errores registrados (modelo, locomoción, equipo/arnés, contacto, control y recorrido). `equipo.gd`: 1.920 poses a 120 Hz con correa unida al anclaje y sin cruce de mano/antebrazo con el aparato +3 mm. `contacto.gd`: todas las superficies de bota, −4,952..+7,477 mm; marcadores de apoyo parcial 1,425/6,052 mm. Longitud de huesos sin cambios, avance de 3,9 m/4 s a 30/60/120 FPS. El test nativo de recorrido controla el foco durante la simulación automática y lo libera para comprobar la pausa; no se ha cambiado la política de foco del juego. Dummy/headless emite un aviso de material al liberar el modelo; queda registrado, sin confundir las aserciones con un cierre limpio. No se reproduce con GPU.

[Capturas cercanas, entorno, vídeo y resultados](../trabajo/arte/revisiones/sota_entorno_3d_v3/README.md). Web v3 regenerada y comprobada en Helium/WebGL 2: carga, clic, seguimiento lejano y pausa por Espacio sin errores. La candidata sigue pendiente de valoración artística sobre parecido, pelo, materiales y prendas. La cámara lejana no certifica ni sustituye esa revisión.

### Revisión de identidad v4 · movimiento aprobado por el autor

El autor indica que «el movimiento está muy bien» y pide concentrar el trabajo en definición, parecido al retrato y cámara algo más alejada. La pasarela actual se identifica expresamente como **entorno de pruebas de movimiento, cámara y colisiones**, no como escenario narrativo definitivo.

**Recurso de la revisión v4:** `godot_ilustrado/assets/sota_3d_v4/sota.glb`, en cuerpo y laboratorio. [Fuente editable](../trabajo/arte/personajes/sota/ilustrada_3d_v4/README.md): revisión sobre el `.blend` v3, sin regenerar locomoción. Pelo por capas con sien/oreja descubiertas, mecha gris lateral aplanada, párpados y marcas faciales, ajustes discretos de mandíbula/nariz, implantes con marco y placas, cuello/solapas, bolsillos, parche de manga y correa más continua. No se ha generado arte con IA ni cambiado el diseño a otro personaje.

Cámara de 22 a **24 m**, FOV 29°, Sota al **14,30 %** de altura proyectada inicial; altura ajustada para mantener el ángulo. No se reescala Sota. V3 y anteriores conservadas; la cantidad de detalle no certifica parecido ni acabado profesional. Los primeros renders de v4 con flequillo que ocultaba el ojo y color de piel incorrecto quedan identificados como ensayos, no como entrega.

Validación v4: cinco pruebas nativas con GPU pasan (modelo, locomoción, equipo, contacto y recorrido), sin errores registrados. 59 piezas, 33532 vértices ponderados, 65 huesos; rig y arrays de botas coinciden con v3. Mano/antebrazo libre y arnés unido en 1920 poses; avance y márgenes de contacto estables iguales a v3. Web regenerada y comprobada en Helium/WebGL 2 (carga, clic, seguimiento y pausa), sin errores registrados. SHA256 confirma GLB/fuentes/generadores v1–v3 intactos; cuerpo.gd sólo cambia el recurso y recorrido_3d.gd sólo la posición de cámara. No se repite control.gd porque su lógica no cambia; sí se repite el recorrido físico.

[Capturas cercanas, escala de juego y validación](../trabajo/arte/revisiones/sota_retrato_3d_v4/README.md). La entrega de v4 sigue siendo una candidata de aspecto; la aprobación del movimiento no se extiende al modelo.

### Construcción de prendas v5 · referencia concreta elegida por el autor

El autor identifica `sota_retrato_3d_v4/ensayo_01/v4_cabeza.png` como parecido cercano y pide que chaqueta, pantalón y botas se lean como prendas sobre el cuerpo, con texturas y volumen. Se recupera esa configuración de rostro/pelo, sin confundirla con aprobación completa del modelo.

**Recurso de la revisión v5:** `godot_ilustrado/assets/sota_3d_v5/sota.glb`, en cuerpo/laboratorio. [Fuente y generadores](../trabajo/arte/personajes/sota/ilustrada_3d_v5/README.md). La chaqueta deja de simular camiseta mediante color en su exterior: abertura frontal real y prenda interior independiente, grosor 4 mm, solapas/paneles, cantos y pliegues. Pantalón con holgura, caída, espesor y bajo ajustado a botas. Cubiertas de calzado con más volumen, lengüeta/cordones y suela construida con curvatura de puntera. La base articulada de apoyo anterior queda dentro del calzado; se verifica también toda la geometría añadida.

Seis materiales con mapas UV de color, rugosidad y normal tangente: cuero de chaqueta, sarga, cuero de botas, goma, lona y tejido interior. Mapas propios generados con NumPy incluido en Blender y exportados como PNG/GLB, sin IA, plugins ni dependencias nuevas de ejecución. Cámara a 24 m, clips, rig, velocidad, mezcla/control y retarget conservados. Fuentes v1–v4 intactas.

Los primeros renders mostraron trama demasiado regular, picos en bordes y suela con penetración de 14,70 mm. Se conservan como ensayos. Se corrigen material, espesor y forma de puntera; no se modifica el ciclo ni se relaja el umbral de contacto. Contacto final del conjunto de calzado: −9,168..+6,916 mm en marcha estable; marcadores originales de apoyo parcial conservan 1,425/6,052 mm. Cuatro pruebas nativas GPU pasan: modelo/materiales/UV, locomoción, equipo/arnés y contacto. 63 piezas, 52747 vértices ponderados y 65 huesos; avance 3,9 m en 4 s a 30/60/120 FPS. Equipo libre y arnés unido en 1920 poses. Web regenerada y comprobada en Helium/WebGL 2: carga, clic/seguimiento y pausa, sin errores registrados. Capturas de detalle, marcha en ambos sentidos y tres zonas inspeccionadas. No se repiten pruebas completas de controlador/recorrido porque su código no cambia.

[Capturas cercanas y resultados](../trabajo/arte/revisiones/sota_prendas_3d_v5/README.md). La entrega sigue siendo una candidata artística, sin certificar acabado profesional ni aprobación del vestuario.

### Piel v6 · moreno suave

El autor corrige que v5 era demasiado morena: Sota es sólo un poco morena. **Recurso de esta revisión histórica:** `godot_ilustrado/assets/sota_3d_v6/sota.glb`, cuerpo y laboratorio. Material de piel cálido `#c8a17e`, sin color de vértices en la piel; se elimina el oscurecimiento observado en Compatibility. La primera hipótesis de doble pigmento se descartó al inspeccionar el GLB: ya exportaba factor base blanco. Se opta por material uniforme, con sombras de iluminación, sin cambiar luces para disimular el tono.

V5 y fuentes intactas por SHA256. Geometría, ropa, pelo, rig, clips, controlador y cámara conservados. Prueba nativa de modelo pasa y capturas con luz/pose idénticas inspeccionadas. Web regenerada; carga/render en Helium/WebGL 2 sin errores registrados. [Comparación y resultados](../trabajo/arte/revisiones/sota_piel_3d_v6/README.md). Tono propuesto pendiente de valoración del autor; no se repiten pruebas físicas completas por un cambio de material.

### Demo de Velvet y revisión 360 · solicitud del autor

El autor autoriza una demo con libertad creativa: pulir Sota desde todos los ángulos y trabajar el primer nivel de la etapa pixel, con luces, niebla, humo y atmósfera cyberpunk. Esta solicitud amplía el trabajo a I02/I03 en conjunto. No aprueba automáticamente la candidata ni modifica la dirección narrativa sin caso.

**Primera entrega de esta iteración, sustituida por la corrección de calle descrita debajo:** `godot_ilustrado/demo_velvet.tscn`. `velvet.gd` reconstruye en geometría 3D la composición de `godot/assets/entornos/velvet/fondo_suelo_recto_v1.png`: cabina, vacío urbano, recepción y escaleras. 42 m, mismo controlador lateral y cámara. Materiales de metal/óxido/ladrillo/suelo húmedo, luces locales, sombras, reflexión local, niebla de profundidad, siete emisores de vapor y cuatro ventiladores. La pasarela técnica y el laboratorio permanecen accesibles.

**Sota activa v7:** cintura de pantalón con solape y pesos de pelvis corregidos, arnés ceñido al hombro, confección posterior, bolsillos, cuello/puños texturizados y herrajes. Piel v6, rostro/pelo elegidos y locomoción aprobada conservados. Fuente `.blend` y generador nuevos; v6 verificada intacta por SHA256. Visor `sota_360.tscn` con giro, zoom, elevación, reposo y marcha, más ocho capturas y detalles cercanos.

En aquella primera entrega: cuatro encuentros breves opcionales, salida, ciudad, recepción y reparación. Canon §5 consultado; guion histórico consultado sin trasladar el encargo. La persona del mostrador es figuración anónima provisional, **no la jefa**. Texto nuevo de observación/conversación documentado como propuesta. No hay objetivos ni regreso del crimen. [Entrega, fuentes y pruebas](../trabajo/arte/revisiones/demo_velvet_3d_v1/README.md).

La demo no contiene treinta minutos, guardado, sonido ni interpretación facial de diálogos. La figura secundaria comparte base y necesita diseño propio antes de convertirse en recurrente. El acabado de Sota y la arquitectura requieren valoración del autor; la revisión 360 no equivale a certificar todas las futuras poses.

### Corrección del autor: cada cota como ciudad y diálogo con retratos

El autor considera muy verde la demo y **rechaza que la Fiebre se presente como un puente con edificios flotantes**. Fija que cada cota debe vivirse como una ciudad con ciudadanos, estructura y actividad propios. La Fiebre concentra bares, locales sexuales, cyberputiclubs, drogas y sexo. Esta decisión de presentación convive con las cotas como franjas que atraviesan torres del canon; no se edita el canon.

Revisión aplicada: suelo urbano continuo bajo la calle y fachadas, acceso lateral a bar, bordillos, drenajes, bolardos y comercio de químicos/cabinas. Las estructuras inferiores de la candidata de puente se retiran de la vista; el suelo llega hasta el primer plano y conecta las manzanas. La versión de puente queda en `trabajo/arte/revisiones/demo_velvet_3d_v1/ensayo_puente/`.

**Formato de interacción solicitado e implementado:** fondo de juego oscurecido; retrato original de Sota a la izquierda y del interlocutor a la derecha; texto entre ambos; sólo quien habla queda iluminado. En observaciones y monólogos se oculta el segundo retrato. Avance por intervenciones con E/Enter/Espacio o botón; Esc permite salir. El modal bloquea el clic sobre el escenario y Sota completa la frenada antes de quedarse en reposo.

Se prueba la conversación con los retratos originales de Sota y la jefa. La jefa está de visita al lado del mostrador, no es recepcionista. Su modelo 3D es un estudio provisional nuevo y no tiene aprobación. La recepcionista anónima anterior se conserva como recurso histórico. La conversación sobre la Nómina se apoya en canon §11, D31; su formulación y el encuentro son propuestas de demo, no hechos aprobados de la historia.

La agrupación de detalles de Sota/figuración mantiene geometría y reduce costes: prueba local comparativa anterior de 60,48 a 26,70 ms por fotograma en la recepción (mismo equipo ocupado, sin garantía de 60 FPS ni benchmark de otros equipos). También se corrige que el agrupador estático perdía la bandera de sombras. La demo sigue requiriendo valoración artística, densidad de vida urbana, sonido, variedad de interiores y producción narrativa.

**Comprobación final de la revisión:** modelo/materiales (32 mallas, 56.336 vértices, 65 huesos), locomoción a 30/60/120 FPS, equipo en 1.920 poses, contacto parcial, recorrido físico y nuevo modal pasan. El recorrido físico automatizado usa `--disable-render-loop`; render y deformación se inspeccionan por separado con GPU. Tres encuadres nativos, ocho ángulos de Sota y capturas de ambos hablantes/monólogo guardados. Web regenerada y comprobada en Helium/WebGL 2: clic, lectura, alternancia, cierre, visor y regreso, sin errores de consola capturados. Última posición de la jefa separada de Sota y nueva captura/exportación. [Resultados y límites](../trabajo/arte/revisiones/demo_velvet_3d_v1/validacion.txt). No es aprobación artística, garantía de 60 FPS ni experiencia de treinta minutos.

### Detalle urbano, límites y vecindario · nueva solicitud del autor

El autor considera que la demo va tomando forma y pide más detalle/cyberpunk, carretera mucho menor, no ver continuación lateral donde no se puede avanzar, Sota ligeramente más rápida, jefa más parecida y personas paradas/caminando con ropa e implantes distintos. No constituye aprobación final del arte.

Implementado: calzada de 2,3 m con acera opuesta, testeros sólidos y campo horizontal de cámara limitado a −4..38 m, encuadre más alto. Equipamiento de fachadas, escaleras/plataformas, cableado, cuadros eléctricos, máquinas, carteles y luces. Cadencia de Sota ×1,12: 1,092 m/s mediante tiempo del clip y root motion sincronizados; modelo y rig v7 sin cambios. La frenada de diálogo comparte cadencia.

Jefa v2 y tres modelos de vecinos en `assets/velvet_3d_v2/`, fuentes editables propias. La jefa recupera recogido, mandíbula de latón/negro, cuello, solapas granate, corsé y herrajes del retrato; parecido pendiente de valoración. Seis vecinos, tres andando con pausas/giros y tres parados, además de la jefa. Tres diseños repetidos, sin nuevos diálogos ni canon. Atlas por personaje con una superficie para contener el coste de dibujo. Versiones previas conservadas; [entrega y límites](../trabajo/arte/revisiones/demo_velvet_3d_v2/README.md).

Web v2 regenerada y comprobada en Helium/WebGL2: render, paseo de vecinos, clic y llegada, apertura de conversación con retratos; sin errores capturados.

**Validación v2:** recursos/rig/atlas y pesos, rutas durante 120 s con 34 inversiones, extremos de cámara y calzada comprobados. Cadencia: 4,368 m/4 s a 30/60/120 FPS. Recorrido físico y modal pasan; capturas nativas de calle, extremos y personajes inspeccionadas. Un ensayo de escote se rechaza por intersecciones: la jefa entregada conserva corsé cerrado y ese detalle sigue pendiente. Atlas reducen la captura de 45,33 a 18,23 s para 590 pasos; muestra de recepción 26,30 ms/fotograma, sin garantizar 60 FPS. [Logs, cobertura y límites](../trabajo/arte/revisiones/demo_velvet_3d_v2/validacion.txt).

## 5. Pendientes inmediatos

Revisar artísticamente la Sota v7 en 360°, las prendas/materiales y el parecido señalado por el autor: parecido facial, pelo, prendas y materiales. El autor aprobó el movimiento actual; esta revisión conserva clips, retarget, velocidad y controlador. El modelo no tiene aprobación artística. La cobertura numérica del rodado completo sigue siendo parcial; parada/giro usan mezclas y rotación en el sitio, sin animación específica ni bloqueo de pies. No reabrir la locomoción aprobada sin un fallo concreto.

La pasarela tiene colisión física; el laboratorio mantiene sus límites numéricos. La demo de Velvet incorpora cuatro encuentros breves opcionales; todavía no hay guardado ni recorrido narrativo completo. No están producidos los 30 minutos ni el sistema de ampliaciones/compatibilidad de partidas. La estructura actual separa entorno, cuerpo y recorrido, sin introducir un framework nuevo.

Exportación Web del tramo mediante preset **Web 3D**, comprobada en Helium/WebGL 2.0: carga, clic, seguimiento y pausa con Espacio, acceso al laboratorio y regreso; capturas conservadas. El laboratorio anterior tenía además pruebas de marcha continua, lenta, paso y clic izquierdo. Safari/Firefox, rendimiento en equipos modestos y experiencia completa pendientes. La etapa anterior no se borra; no se hizo commit/push ni publicación.

## 6. Historial de esta etapa

| Fecha | Hito | Estado real |
| --- | --- | --- |
| 18 oct 2026 | Autor autoriza abandonar pixel art y el caso para una experiencia ilustrada de canon de unos 30 min | Dirección aprobada; modelos, guion y juego nuevo por producir. |
| 18 oct 2026 | Archivo completo y documentación nueva | 2320 archivos verificados; originales y documentos históricos conservados. |
| 18 oct 2026 | Primer laboratorio con cuerpo completo, animación y retarget nativos | Pruebas técnicas y render inicial disponibles; no aprobación artística ni Sota final. |
| 18 oct 2026 | Estudio Sota 3D v1 vestido, fuente editable y Web | 26 piezas, 65 huesos, pesos/retarget/temporización/control y contacto parcial comprobados. Primera suela rígida rechazada y sustituida por pie articulado. Arte, rodado completo y transiciones siguen pendientes; sin aprobación artística. |
| 19 oct 2026 | Autor aprueba juego íntegramente 3D y movimiento lateral, primera experiencia de unos 30 min ampliable con lore | Dirección de producción aprobada; arte concreto y contenido pendientes. |
| 19 oct 2026 | Pasarela técnica de 42 m, seguimiento, colisiones y acceso al laboratorio | Prueba física/regresiones, capturas nativas y Web comprobadas; giro interrumpido corregido. No es acabado profesional ni experiencia narrativa terminada. |
| 19 oct 2026 | Corrección del cyberdeck señalado sobre la mano | Sota 3D v2 activa, 23 mallas idénticas y tres piezas del equipo ajustadas; prueba GPU de 1.920 poses, regresiones y comparación visual correctas. Sin aprobación artística nueva. |
| 19 oct 2026 | Autor rechaza la v2 y fija protagonismo del entorno con plano lejano | Decisión artística registrada. Se entrega v3 para revisión, arnés continuo, superficies/pelo/materiales nuevos, escala de pantalla del 15,59 % y geometría estática agrupada. Sin aprobación artística nueva. |

| 19 oct 2026 | Autor aprueba el movimiento actual y solicita más definición/parecido y cámara un poco más lejana | Revisión de aspecto v4 sobre rig v3, cámara a 24 m/14,30 %, cinco pruebas GPU y Web comprobadas. Fuentes anteriores intactas; entorno técnico. Modelo pendiente de valoración artística. |
| 19 oct 2026 | Autor elige parecido del ensayo 01 de v4 y pide prendas construidas/texturizadas | Candidata v5: abertura real de chaqueta, volumen/espesor, holgura, calzado construido y seis materiales UV. Movimiento aprobado conservado; cuatro pruebas GPU y Web pasan, capturas disponibles. Aspecto pendiente de valoración. |
| 19 oct 2026 | Autor aclara que Sota es sólo un poco morena | V6 aclara material de piel hacia tono cálido suave; modelo/ropas/movimiento conservados. Capturas nativas y modelo comprobados; tono pendiente de valoración. |

| 19 oct 2026 | Autor pide demo, acabado 360 de Sota y recuperar Velvet en 3D | Candidata Sota v7, visor 360 y primer tramo de Velvet con materiales, luces, vapor y cuatro encuentros. Conserva movimiento aprobado; arte y texto nuevos pendientes de valoración. |

| 19 oct 2026 | Autor rechaza el puente y precisa cada cota como ciudad; exige interacción con retratos | Calle continua de la Fiebre y diálogo modal con retratos originales, hablante iluminado y monólogo de Sota. Candidata comprobada; escenario, modelo secundario y textos pendientes de valoración. |

| 19 oct 2026 | Autor pide más detalle urbano, carretera estrecha, límites visuales coherentes, más cadencia y vecindario | Revisión v2, jefa y tres diseños secundarios, seis vecinos y cadencia +12 %. Pruebas y capturas documentadas; sin aprobación artística nueva. |

### Punto de control Git · solicitud del autor

El autor solicita guardar todo el estado actual y actualizar `origin/main` antes de continuar. El punto de control incluye la etapa pixel conservada, proyecto 3D, fuentes/modelos, candidatos, capturas, pruebas y documentación. Cachés de Godot, exportaciones regenerables y credenciales siguen excluidas por `.gitignore`. El ZIP original `trabajo/arte/terceros/quaternius_20261018/universal-base-characters.zip` usa Git LFS por superar 100 MiB; un clon necesita `git lfs pull` para recuperarlo. La verificación del push se comunica tras comparar HEAD con el remoto; este registro no concede aprobación artística nueva.

| 19 oct 2026 | Autor pide commit de todo el estado y push antes de continuar | Punto de control de las etapas pixel/3D, arte, fuentes y pruebas; recurso ZIP grande conservado con Git LFS. |
