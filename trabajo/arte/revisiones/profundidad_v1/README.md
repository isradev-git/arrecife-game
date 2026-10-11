# Velvet · Centro de pasarela y dos barandillas

11 de octubre de 2026 · T07.3. El autor corrige el montaje anterior: Sota estaba en el borde trasero y la barandilla la tapaba; faltaba otra en el borde delantero. El recorrido horizontal conserva la profundidad visible de la pasarela.

Se reutilizan el [fondo de suelo horizontal](../../entornos/velvet/suelo_v1/README.md) y la [barandilla independiente](../../entornos/velvet/capas_v1/README.md), sin editar sus PNG ni generar arte nuevo. Dos instancias centrales del mismo recurso, x = 450–935, con altura 126 y orden fijo:

| Plano | Apoyo y | Inicio de barandilla y | Orden z |
| --- | --- | --- | --- |
| Borde trasero | 675 | 549 | −5 |
| Centro transitable, pies de Sota | 705 | — | 0 |
| Borde delantero | 735 | 609 | +5 |

Sota queda a 30 píxeles de cada borde, altura propuesta 252. La barandilla trasera pasa detrás del cuerpo; la delantera lo oculta solo donde cruza el metal. Los botones muestran ambas, solo trasera, solo delantera o ninguna; no invierten su orden espacial.

| Captura | Perfil derecho | Perfil izquierdo |
| --- | --- | --- |
| Godot nativo, ambas barandillas | [Captura](godot_ambas_0.png) | [Captura](godot_ambas_1.png) |
| Godot nativo, solo trasera | [Captura](godot_trasera_0.png) | [Captura](godot_trasera_1.png) |
| Navegador, ambas barandillas | [Captura](web_ambas_0.png) | [Captura](web_ambas_1.png) |
| Navegador, solo trasera | — | [Captura](web_trasera_1.png) |

Los siete PNG son capturas sin edición, 1672 × 941. Godot 4.7.2 Compatibility, Apple M4. Web exportada y servida por HTTP local en http://127.0.0.1:8766/godot/build/web/: agent-browser 0.39.0, sesión aislada, ejecutable Helium en modo headless, Chromium 154/WebGL 2.0. Se observan ambos perfiles y paso a solo trasera mediante clic, sin errores de página/consola registrados. URL abierta también en Helium visible; sesión automatizada cerrada. El servidor local estaba activo al comprobar, debe verificarse al retomar.

tests/escala.gd comprueba centro equidistante, suelas en seis posiciones, bases de ambos bordes, orden y visibilidad inicial. tests/capas.gd renderiza ambos perfiles: 1167/1045 píxeles cubiertos por metal delantero, 3036/2778 conservados en aberturas y 1462/1312 muestras de cuerpo por delante de la trasera. Estas últimas respetan el alfa casi opaco del atlas. Importación, escena técnica y exportación Web correctas.

Entrega revisada por el asistente. **Valoración posterior del autor:** «vamos mejorando mucho»; destaca la perspectiva como «IMPORTANTÍSIMO». Se registra valoración positiva del montaje espacial y criterio obligatorio para las siguientes escenas; no es un cierre de toda T07. Solo se cubre el tramo central; resto del recorrido, objetos/figurantes independientes, movimiento/colisiones, retícula y luz espacial siguen pendientes en T07 y sus tareas relacionadas. Safari/Firefox, teclado/accesibilidad y rendimiento no comprobados en esta corrección. No se publica el juego.

Se conservan las capturas anteriores de [T07.2 nativa](../suelo_v1/README.md) y [T07.2 Web](../suelo_web_v1/README.md); sus apoyos y alternancia de una sola barandilla quedan superados por este montaje.
