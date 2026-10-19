# Plan Godot · experiencia ilustrada

**19 de octubre de 2026.** Sustituye al [plan archivado](PLAN_GODOT_ETAPA_PIXEL_20261018.md) por decisión del autor. No hay migración pendiente del caso anterior.

## Objetivo

Juego lateral de unos 30 minutos, con Sota, conversaciones selectivas y objetos para conocer el canon. Estilo de los retratos; pixel art retirado. Sin crimen que resolver, encargos o deducciones obligatorias. [Diseño activo](../trabajo/diseno/EXPERIENCIA_ILUSTRADA.md).

## Base y separación

Godot 4.7.2, GDScript, Compatibility. Nuevo proyecto `godot_ilustrado/`; `godot/` y `juego/` quedan históricos. No copiar módulos de caso, objetivos, deducciones o sus estados al proyecto nuevo. Reutilizar código previo sólo si cumple una necesidad concreta del nuevo diseño.

Primera prueba: malla humana completa y animación de locomoción preparada, con `AnimationTree`, root motion y `RetargetModifier3D` nativos. No más soluciones basadas en deformar recortes de v7 ni otra implementación de IK a medida. El laboratorio no requiere Blender ni paquetes de terceros en ejecución: usa recursos glTF/GLB y nodos Godot.

El autor aprobó el 19 de octubre **personajes y escenarios completamente 3D**, con movimiento exclusivamente lateral y acabado ilustrado guiado por los retratos. Cámara lejana de perspectiva estrecha con seguimiento (v4: 14,3 % de altura de pantalla para Sota): profundidad y paralaje proceden de geometría real. El laboratorio neutro permanece disponible; F5 abre ahora un tramo técnico de 42 m. Esta aprobación de técnica no aprueba el modelo actual ni su acabado. El autor rechazó la v2 por parecido insuficiente, aspecto poligonal y equipo sin conexión con el arnés. El autor aprueba el movimiento actual. La revisión v5 desarrolla prendas con construcción y materiales UV, tomando como parecido la captura concreta señalada por el autor; cámara a 24 m por su petición de alejarla un poco más. La pasarela es una prueba técnica; el entorno protagoniza la puesta en escena.

La primera entrega apunta a unos 30 minutos de lectura y exploración. Podrá crecer con nuevas escenas, conversaciones y objetos, sin convertir el lore en misiones. Separar entorno, locomoción y contenido; usar escenas/recursos Godot existentes. No crear ahora un sistema de mundo abierto, generación de ciudad o distribución de episodios. Guardado compatible y contenidos identificables se concretarán al implementar las primeras interacciones.

## Hitos

1. **Locomoción:** reposo, marcha, arranque/parada, inversión, controles y apoyos. Comprobar cuerpo completo y animación visible, no sólo articulaciones. No dar por profesional la base genérica.
2. **Sota:** desarrollar malla, pelo, ropa, correa, implantes y deck a partir del retrato; no presentar un maniquí recoloreado como personaje final. Trabajar superficies ocultas y volumen desde el modelo.
3. **Muestra de juego:** un fragmento ilustrado con una conversación y un objeto. El movimiento debe seguir funcionando al llegar, detenerse, leer y reanudar. No contenido narrativo de relleno.
4. **Contenido:** seleccionar recorrido y personas; escribir con fuentes canónicas y distinguir hechos de opiniones. Preparar conversaciones opcionales y objetos que cuenten vida cotidiana. Conocer a Sota por sus intervenciones y relaciones.
5. **Entrega:** medir alrededor de 30 minutos con lectura natural, pulir ambiente/sonido, guardado y accesibilidad. Exportar y comprobar Web; la exportación histórica no valida esta versión.

## Validación

Mantener fuentes/licencias de recursos externos. Usar únicamente reposo/marcha en el laboratorio; no importar combate/carrera como nuevas funciones del juego. Comparar avance a 30/60/120 FPS y verificar que el retarget no estire huesos. Evaluar apoyo renderizado y contacto real antes de afirmar que no hay deslizamiento. Las transiciones mezcladas hacia reposo son una primera prueba, no sustituyen automáticamente animaciones específicas de parada/giro.

Canon, fuentes y proyectos históricos quedan intactos. No se publica ni se cambia el remoto en esta transición.

## Demo de Velvet · actualización del autor

Autorizado trabajar Sota y primer nivel conjuntamente. `demo_velvet.tscn` pasa a ser la entrada: 42 m, recuperación 3D de la composición de Velvet, cuatro encuentros opcionales y visor 360. La pasarela anterior permanece separada. Se conservan movimiento aprobado y cámara; Sota v7 revisa cintura, arnés y confección posterior. Es una candidata visual y de interacción, no la experiencia completa. Fuentes, alcance y pruebas: `trabajo/arte/revisiones/demo_velvet_3d_v1/README.md`.
