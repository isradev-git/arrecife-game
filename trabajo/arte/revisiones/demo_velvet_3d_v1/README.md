# Demo de Velvet 3D · Sota v7

19 de octubre de 2026. Entrega de una candidata jugable solicitada por el autor, con libertad creativa para desarrollar Sota alrededor del cuerpo y recuperar el primer escenario. No es aprobación artística ni la experiencia completa de treinta minutos.

## Probar

Abrir `godot_ilustrado/project.godot` con Godot 4.7.2 y pulsar F5. La escena principal es `demo_velvet.tscn`.

- A/D o flechas: caminar. Clic en el suelo: destino. Espacio/botón: pausa.
- E o el botón que aparece al acercarse: observar o hablar. E/Enter/Espacio o botón: avanzar por intervenciones. Esc/botón: cerrar la lectura. Fondo oscurecido, retratos originales a ambos lados del texto, sólo el hablante iluminado. En monólogos sólo Sota.
- «Sota · 360°»: inspección individual. Arrastrar con botón izquierdo gira, rueda acerca, arrastrar con botón derecho sube/baja la vista. Botones de giro automático y reposo/marcha. Volver a Velvet conserva acceso a la demo, sin guardar la posición.
- Laboratorio: prueba anterior de locomoción. La pasarela técnica sigue en `recorrido_3d.tscn`.
- Web local: `http://127.0.0.1:8766/godot_ilustrado/build/web/`, con el servidor de la raíz del repo activo. También se puede servir `build/web/` directamente con un servidor HTTP local.

## Composición y materiales

Referencia observada: `godot/assets/entornos/velvet/fondo_suelo_recto_v1.png`, junto con las piezas y el guion de la etapa anterior. La cabina de personal a la izquierda, la calle lateral con bar, la recepción de Velvet y las escaleras reaparecen como geometría 3D. El recorrido tiene 42 m y conserva cámara a 24 m, FOV 29° y movimiento lateral.

Ladrillo con juntas, metal con variación de óxido, suelo de rugosidad irregular, ventanales con cortinas, lona modelada, tuberías con abrazaderas, rejillas, ventiladores giratorios, papel en el mostrador y barandillas. Luz fría exterior y luz cálida de recepción, acentos rosa/cian, sombras y sonda de reflexión local. Niebla de profundidad y siete emisores de vapor con transparencia gradual. No se usa el fondo pixel como textura ni se han generado imágenes con IA.

El humo usa partículas 3D con pequeños planos orientados a cámara; no es una simulación volumétrica. La sonda recoge una aproximación local de reflejos, no reflejos exactos de todos los objetos. Se mantienen Compatibility y WebGL. Referencias técnicas: [renderizadores Godot](https://docs.godotengine.org/en/stable/tutorials/rendering/renderers.html), [CPUParticles3D 4.7](https://docs.godotengine.org/en/4.7/classes/class_cpuparticles3d.html).

## Sota

V7 conserva el parecido indicado, piel v6, altura y locomoción aprobada. Corrige solape y pesos de cintura, ajusta el arnés al hombro y desarrolla confección posterior, cuello/puños y herrajes. [Fuente y detalles](../../personajes/sota/ilustrada_3d_v7/README.md). Las ocho capturas v6 son la referencia anterior; las ocho v7 y detalles son la revisión. La luz del visor es fija para que girar revele realmente los materiales y el relieve.

## Contenido y trazabilidad

Cuatro encuentros opcionales, sin tareas, pruebas, recompensas ni misión:

| Encuentro | Fuente y condición |
| --- | --- |
| Salida de personal | Cabina de la composición histórica. «Bajar es fácil; subir exige permiso»: canon §5, movimiento vertical. Observación concreta de Sota: propuesta de demo. |
| Mirar la ciudad | Canon §5: cotas como franjas que atraviesan torres; Fiebre cota 4 dentro de Penumbra, bajo humo. Formulación de Sota: propuesta. |
| Recepción | Conversación propuesta sobre la Nómina. Sustituida en la revisión por un encuentro con la jefa como visitante, al lado del mostrador. Retrato original; modelo 3D provisional. Canon §11 D31 para las cuotas y cobertura; frases/encuentro propuestos. |
| Reparación | Canon §5: capas acumuladas y reparaciones. Abrazadera y comentario de Sota: propuesta ambiental. |

Canon y `sources/` no se han editado. El guion del caso anterior sigue archivado y no aporta objetivos a esta demo.

## Evidencia

`velvet_120.png`, `velvet_240.png`, `velvet_360.png`: tres encuadres nativos. `v7_000.png` a `v7_315.png`: ocho ángulos. `v7_cabeza.png`, `v7_ropa.png`, `v7_espalda.png`: detalles. `ensayo_01/`: primer ajuste de iluminación, conservado. Resultados de pruebas y límites en `validacion.txt`.

## Límites reales

La demo es un fragmento del primer nivel; no contiene los treinta minutos, guardado de descubrimientos ni una ruta narrativa completa. Modelo secundario, expresiones/gestos de conversación, sonido y composición final de decorados siguen pendientes. La arquitectura parte de módulos y necesita valoración artística del autor; no se declara acabado profesional por haber pasado pruebas. Las pruebas de apoyo de pie mantienen su cobertura parcial, y no incluyen todas las poses futuras de interacción.

## Revisión tras las capturas del autor

El autor rechaza la lectura de puente y edificios flotantes: cada cota debe sentirse como ciudad. La calle se apoya ahora en suelo continuo, con manzanas y acceso lateral a bar; bordillos, alcantarillas, bolardos, cabinas sensoriales y local de químicos. `ensayo_puente/` conserva scripts y capturas anteriores. El nuevo suelo tiene colisión y se prueba también fuera del carril de Sota. La geometría sigue siendo una candidata; falta vida urbana y variedad de interiores.

`dialogo_jefa.png`, `dialogo_sota.png` y `monologo.png` muestran el formato solicitado, con alternancia real de hablante. La jefa se presenta como visitante, no como personal de Velvet. `crear_jefa.py` produce su estudio 3D provisional; el retrato mostrado en diálogo es el original. La figura anónima anterior permanece conservada.

Agrupación de detalles: se mantienen vértices, pesos y materiales, reduciendo envíos de mallas articuladas. La comparación local de recepción pasó de 60,48 a 26,70 ms/fotograma, con otras aplicaciones activas. No se certifican 60 FPS ni rendimiento en equipos modestos. El recorrido físico automático se ejecuta con render desactivado para comprobar controles/colisiones sin gastar cada paso en dibujar la ciudad; capturas, mallas deformadas y diálogo sí se verifican con GPU.
