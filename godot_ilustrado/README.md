# El Arrecife · 3D lateral con acabado ilustrado

Nuevo proyecto de Godot 4.7.2. Abrir `project.godot` y pulsar **F5**. Desde la raíz del repositorio:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot_ilustrado
```

## Tramo 3D y laboratorio

**F5 abre `recorrido_3d.tscn`:** pasarela de 42 m con suelo y barreras físicas, profundidad geométrica, fachadas, luz y cámara lejana de seguimiento en perspectiva estrecha. Todos los elementos del espacio son 3D; el desplazamiento de Sota queda en un carril horizontal. A/D, flechas o clic para caminar; Espacio o botón para pausar. Al perder foco se pausa y se cancela el destino. Es un estudio de composición, sin localización canónica nueva ni contenido narrativo todavía.

`pasarela.gd` construye el entorno de esta muestra; `jugadora.gd` aplica el root motion a `CharacterBody3D` y frena antes del contacto; `recorrido_3d.gd` reúne cámara, controles e interfaz. No se modifican animación ni retarget. Este tramo técnico no equivale a la experiencia de 30 minutos.

El botón **Laboratorio** abre la prueba neutra anterior; **Pasarela 3D** permite volver. También se puede abrir `laboratorio.tscn` y pulsar F6. Para el cuerpo neutro: ejecutar esa escena con `-- --base`.

## Cuerpo y animación

Un primer estudio de Sota con cuerpo y ropa completos, 63 piezas, 65 huesos y animaciones preparadas de reposo y marcha, adaptación mediante `RetargetModifier3D` nativo y desplazamiento mediante root motion de `AnimationTree`. La velocidad se deriva del clip: 1,3 m por ciclo de 1,333 s, aproximadamente 0,975 m/s. No se fuerza la velocidad de la etapa pixel ni se anima por fotogramas de un atlas.

Cámara lateral, suelo con referencias, teclado, clic para acercarse a un punto, marcha continua, pausa, cámara lenta y paso de muestra. Giro provisional con frenada, rotación y reanudación. Al perder foco se cancela el destino y se pausa.

**No es Sota terminada.** Ya hay pelo, chaqueta, pantalón, botas, correa, implantes y deck; faltan parecido, ajuste de vestuario y acabado ilustrado. Las proporciones de la base tampoco están aprobadas. [Fuente editable y límites](../trabajo/arte/personajes/sota/ilustrada_3d_v5/README.md). El maniquí inicial sigue accesible con `Godot --path godot_ilustrado res://laboratorio.tscn -- --base`.

## Controles del laboratorio

- Flechas o A/D: caminar.
- Clic en el suelo: acercarse a esa posición, dentro del tramo de prueba.
- Espacio: pausa/reanudar; R: reiniciar posición.
- Botones: marcha continua en ambos sentidos, pausa, 0,25× y paso de 1/60 s.
- Pérdida de foco: pausa y cancelación del destino. Reanudar explícitamente después.

## Pruebas y evidencia

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot_ilustrado --script res://tests/locomocion.gd
/Applications/Godot.app/Contents/MacOS/Godot --path godot_ilustrado --script res://tests/contacto.gd -- --sota
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot_ilustrado --script res://tests/modelo.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot_ilustrado --script res://tests/control.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot_ilustrado --fixed-fps 60 --script res://tests/recorrido.gd
```

La segunda prueba necesita GPU. `tests/capturar.gd` recorre automáticamente 6 s y guarda cinco capturas; puede ejecutarse con `--write-movie /tmp/locomocion.avi --fixed-fps 60`.

[Vídeo y resultados de Sota](../trabajo/arte/revisiones/sota_ilustrada_3d_v1/README.md). [Recorrido 3D Web interactivo](http://127.0.0.1:8766/godot_ilustrado/build/web/), exportado y probado en Helium. Regenerar mediante preset **Web 3D**; servir la raíz con `python3 -m http.server 8766`. La [prueba inicial con maniquí](../trabajo/arte/revisiones/locomocion_ilustrada_v1/README.md) se conserva.

## Fuentes

Quaternius: Universal Base Characters Standard y Universal Animation Library Standard, licencia CC0. [Trazabilidad, licencias y fuentes originales](../trabajo/arte/terceros/quaternius_20261018/README.md).

`preparar_fuentes.py` reproduce los recursos desde los ZIP preservados. Sólo conserva reposo y marcha en el GLB utilizado; no se añaden combate, carrera u otras funciones al juego. El cuerpo femenino conserva geometría, pesos y esqueleto originales; sólo se sustituyen sus materiales por uno neutro para la prueba, sin texturas externas. Retarget nativo entre posturas de reposo diferentes; sin retarget/IK propio.

## Límites actuales

Arranque/parada mediante mezcla con reposo; giro en el sitio sin clip específico ni bloqueo de pies. Se ha medido deriva horizontal parcial en ventanas de apoyo plano; falta cubrir el rodado completo y afinar las transiciones sobre el personaje vestido. Se ha comprobado un margen vertical pequeño en la malla de marcha estable, no contacto perfecto. La pasarela nueva tiene suelo, barreras y detección de obstáculos físicos. El laboratorio conserva sus límites numéricos. La geometría del entorno es un estudio de volumen/composición: necesita recursos artísticos más elaborados para alcanzar el acabado profesional. No contiene conversaciones, objetos narrativos ni guardado. Esos sistemas se producirán después de validar locomoción y Sota.

[Capturas y validación del tramo 3D](../trabajo/arte/revisiones/pasarela_3d_v1/README.md). La aprobación del 3D completo es una decisión de producción; El autor aprueba el movimiento actual; Sota y el escenario siguen pendientes de revisión artística.

## Corrección del equipo · v2

Cyberdeck más ceñido y retrasado en la cintura derecha, con paso libre de la mano. [Comparación y prueba GPU de 1.920 poses](../trabajo/arte/revisiones/sota_equipo_3d_v2/README.md). La v1 conserva sus recursos y capturas originales. Ejecutar la prueba con GPU: `Godot --path godot_ilustrado --script res://tests/equipo.gd`.

## Candidata v3 anterior y encuadre de entorno

El autor rechazó visualmente la v2. En la entrega v3 se probó el plano con Sota al 15,6 % de la altura de pantalla; las revisiones indicadas abajo la sustituyen. La v3 es una candidata con superficies continuas, pelo y equipo reconstruidos y arnés conectado. No tiene aprobación artística. [Renders, vídeo y resultados](../trabajo/arte/revisiones/sota_entorno_3d_v3/README.md). El laboratorio conserva inspección cercana y el recurso `modelo_sota` permite comparar las versiones anteriores.

## Revisión v4 · movimiento aprobado

El autor considera que el movimiento actual está muy bien. Esta revisión conserva rig, clips, velocidad y controlador; trabaja pelo/mecha, rasgos, implantes y definición de la chaqueta. Cámara a 24 m, FOV 29°, altura proyectada inicial del 14,30 %. [Comparación cercana, escenario y pruebas](../trabajo/arte/revisiones/sota_retrato_3d_v4/README.md). V3 y anteriores recuperables. El aspecto de v4 sigue pendiente de aprobación; la pasarela es exclusivamente un entorno de pruebas.

## V5 · prendas y materiales

Referencia de parecido: captura del ensayo 01 de v4 elegida por el autor. La v5 abre físicamente la chaqueta, separa camiseta y exterior, añade grosor, holgura/pliegues y reconstruye las capas de calzado. Seis materiales con mapas UV de color, rugosidad y normal: cuero, cargo, lona, goma y tejido interior. Movimiento y cámara de 24 m conservados. [Detalles, comparación y pruebas](../trabajo/arte/revisiones/sota_prendas_3d_v5/README.md). La v4 permanece recuperable. El acabado de v5 todavía necesita valoración artística.

## V6 · tono de piel

El autor precisa que Sota es sólo ligeramente morena. La v6 aclara la piel mediante su material, conservando vestuario, modelo y movimiento. [Captura cercana y comprobación](../trabajo/arte/revisiones/sota_piel_3d_v6/README.md). V5 intacta; tono pendiente de valoración.

## Demo de Velvet · 19 octubre

F5 abre `demo_velvet.tscn`: primer escenario reconstruido en 3D, 42 m, cuatro encuentros opcionales con E y visor «Sota · 360°». Sota activa v7; movimiento aprobado y anteriores conservados. [Instrucciones, capturas, fuentes y límites](../trabajo/arte/revisiones/demo_velvet_3d_v1/README.md). La pasarela técnica sigue en `recorrido_3d.tscn`. No es la experiencia completa de treinta minutos ni arte aprobado.

### Barrio v2

Demo actual: calzada estrecha, cierres laterales, más detalle de instalaciones, jefa v2 y seis vecinos, cadencia de Sota +12 %. [Evidencias](../trabajo/arte/revisiones/demo_velvet_3d_v2/README.md). F5 y controles anteriores.
