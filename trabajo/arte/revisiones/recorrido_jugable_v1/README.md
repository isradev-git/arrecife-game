# T04 · Recorrido provisional en Velvet

Entrega del asistente · **13 de octubre de 2026**. El autor aprueba **Sota a 252 de altura**; la sensación del controlador queda para su valoración. V7, Jefa y todos los PNG/JSON/prompts anteriores conservados sin editar. No cambia historia.

F5 abre `godot/recorrido.tscn`. También se puede probar la exportación local en `http://127.0.0.1:8766/godot/build/web/` mientras siga activo el servidor de esta sesión. [Instrucciones reproducibles](../../../../godot/README.md).

- Flechas o A/D para caminar; Mayús para correr. La casilla Correr evita mantener Mayús.
- Clic en el suelo para caminar al punto; doble clic para correr. Esc cancela inmediatamente.
- Clic en cabina, mostrador o personas del acceso para acercarse. Botones de prueba para Jefa/guardia/acceso. No abre conversación ni viaje todavía.
- Revisión visual conserva las comparaciones de arte anteriores; Probar recorrido vuelve a la prueba.

## Implementación

`recorrido.gd` reutiliza `revision_escala.gd`; no duplica el montaje. `movimiento.gd` adapta el criterio de aceleración/frenada y destino del prototipo JavaScript, que permanece intacto. Valores provisionales: caminar 220 px/s, correr 430, aceleración 1600 y frenada 2200 px/s². El giro cambia entre perfiles propios, sin reflejar el sprite ni mostrar frontal.

CharacterBody2D con huella rectangular 24 × 14 y paredes de límite. Centro transitable y = 705; rango x = 128–1632. Guardia x = 300, Jefa 1260, persona de mochila 1480 y acompañante 1580. Al llegar se orienta hacia la persona. La pérdida de foco cancela teclas, carrera seleccionada y destino; requiere nueva pulsación para volver a caminar.

Sota z = 0, trasera −5 y delantera +5; NPC/muebles del plano trasero conservan sus apoyos y no bloquean el centro de la pasarela. La colisión física con un obstáculo en el plano transitable se comprueba con un cuerpo añadido solo en la prueba, sin inventar obstáculos en Velvet.

## Comprobaciones realizadas

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script tests/movimiento.gd
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/movimiento.gd -- --capturas
```

Pasan aceleración, dos velocidades, frenada/inversión, 14 llegadas caminando/corriendo sin sobrepasar, destinos no finitos rechazados, límites y pasos a 30/60 Hz. La escena comprueba 252/v7, apoyo y planos, llegadas Jefa/guardia, colisión con obstáculo físico, foco, liberación de teclas, Mayús y Esc con repetición de tecla. GPU Compatibility Apple M4: prueba y dos capturas nativas correctas. También pasan arranque principal, escala, regresiones GPU de barandillas/recepción, importación y exportación Web sin errores registrados.

Helium/Chromium y WebGL 2.0: caminar y soltar tecla, carrera con Mayús, límites de ambos lados, clic en mostrador, llegada a guardia/Jefa, doble clic hasta acompañante, suelo a 1280 × 720 y retorno entre revisión/recorrido. Mayús y flechas se enviaron al canvas con eventos DOM completos: el comando `keydown` del automatizador omite códigos/modificadores, por lo que se descartó esa entrada incompleta. No es una prueba manual de teclado físico.

Cambio real de pestaña durante un destino y durante una tecla mantenida: detenido al volver, sin reanudar. Capturas separadas por 700 ms idénticas byte a byte en ambos casos; la segunda del teclado queda como comprobación temporal, no como otra copia en el repositorio. Consola y errores Web sin fallos de la aplicación.

## Capturas

| Archivos | Contenido |
| --- | --- |
| [web_inicio.png](web_inicio.png) | Arranque, Sota 252 y planos. |
| [web_caminar.png](web_caminar.png), [web_frenada.png](web_frenada.png), [web_correr.png](web_correr.png) | Caminar, parada al soltar y carrera con Mayús. |
| [web_jefa.png](web_jefa.png), [web_guardia.png](web_guardia.png), [web_clic_mostrador.png](web_clic_mostrador.png) | Puntos de llegada y orientación. |
| [web_doble_clic.png](web_doble_clic.png), [web_acompanante.png](web_acompanante.png) | Carrera por destino y parada a x = 1580. |
| [web_limite_derecho.png](web_limite_derecho.png), [web_limite_izquierdo.png](web_limite_izquierdo.png) | Extremos x = 1632 y 128. |
| [web_foco_regreso.png](web_foco_regreso.png), [web_foco_estable.png](web_foco_estable.png), [web_foco_teclado.png](web_foco_teclado.png) | Cancelación de destino/tecla y estabilidad. |
| [web_1280.png](web_1280.png) | Clic de suelo transformado correctamente a x = 914 con ventana 1280 × 720. |
| [nativo_jefa.png](nativo_jefa.png), [nativo_guardia.png](nativo_guardia.png) | Render nativo del controlador: 1080 × 607, tamaño efectivo de la ventana de prueba. |

Las otras capturas Web son de 1672 × 941; teclado/foco también tiene una captura a 1280 × 720. Son PNG de prueba sin edición, no nuevos recursos artísticos.

## Pendientes

El sprite todavía se desliza de pie: **T05 añadirá el ciclo de caminar sincronizado con la distancia**; T06 carrera, parada y reposo. No se presenta esto como acabado final. Falta valoración del autor sobre control/velocidades, fuentes de luz espaciales, diálogos/viajes, caso completo y Safari/Firefox/móvil. La interfaz superior es un panel de prueba. La altura 252 aprobada no cierra la retícula artística común de T02.
