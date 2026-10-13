# T05 · Corrección de fluidez de Sota

13 de octubre de 2026. El autor prueba la entrega anterior y señala: «se mueve, PERO, parece un robot». La marcha anterior queda rechazada en naturalidad; esta corrección es entrega del asistente, pendiente de valoración nueva.

## Causa y corrección

El anclaje horizontal del pie desplazaba el sprite completo en sentido contrario a la física. La cadera quedaba inmóvil entre dibujos y saltaba al siguiente: 129/164 ticks congelados por perfil a 60 Hz, con saltos extra de 41,913 px a derecha y 30,029 px a izquierda. Fijar matemáticamente la puntera no demostraba una marcha natural.

Se elimina ese desplazamiento del sprite: cadera y cuerpo físico avanzan juntos. Se conserva el plano y = 705, escala 252, perfiles propios, ropa, PNG, material, capas, controles y colisiones. Ningún PNG ni prompt se modifica.

La cadencia uniforme también era incompatible con los dibujos: tras corregir solo la cadera, la desviación de la puntera durante el apoyo era 39,808/41,916 px. Se calibran distancias centrales por postura en `avance_poses`, independientes para cada perfil; `frame_at` elige por los puntos medios de esas distancias y envuelve el ciclo. Dos pasos de 112 px, ciclo 224 px, velocidad 156 px/s: unos 1,44 s por ciclo. Preparación, parada, giro y respiración conservan su lógica, sin compensación que deslice el cuerpo al parar.

## Comprobación

- `Godot --headless --path godot --script res://tests/fluidez_marcha.gd`: reprodujo el fallo antes de corregir; ahora pasa ambos perfiles a 30/60 Hz, muestra las 16 poses y detecta congelaciones/saltos de cadera y desviación del apoyo >25 px. [Salida final](comprobacion.txt).
- Resultado: cero congelaciones y cero salto horizontal extra de cadera; desviación máxima de puntera 23,411/23,369 px a 30 Hz y 23,410/23,368 px a 60 Hz. Son medidas de la puntera proyectada, no de todos los píxeles de la suela.
- Pasan `tests/movimiento_sota.gd` (recursos, escala, paleta, ciclo, inversión, reposo, reducción y extremos) y `tests/movimiento.gd` (controles, llegadas, colisiones, foco y 30/60 Hz). Prueba de fluidez también con GPU Apple M4/OpenGL Compatibility.
- Metadatos regenerados con `tests/preparar_movimiento.gd`; importación y exportación Web sin errores. Browser agent-browser/Helium, canvas 1672 × 941, WebGL 2.0: teclado D/A, marcha en ambos sentidos, parada, recarga y clic Junto a Jefa (llega a x = 1260 y reposo) observados; sin errores registrados.

## Evidencia conservada

[Antes](antes.webm): exportación anterior, D durante 3 s desde x = 780. [Después](despues.webm): misma salida hacia la derecha, parada, regreso a izquierda y parada; 8,866 s a 30 fps. [Inicio](web_inicio.png), [parada](web_parada.png), [llegada a Jefa por clic](web_jefa.png). Las grabaciones son captura en vivo, no una animación simulada para la entrega. La revisión anterior completa permanece en `movimiento_completo_v1`.

**Límites:** la cuantización de los 16 dibujos sigue produciendo deslizamiento residual y cambios de volumen/cabeza/sombra; 23 px es una mejora medida, no un pie perfectamente plantado ni aprobación estética. El acabado de la marcha queda abierto a valoración del autor; si persiste rigidez, revisar esos dibujos concretos. Safari/Firefox, móvil y equipos modestos no comprobados. No se añaden carrera, frontal, deformación, interpolación de imágenes ni animaciones ajenas a esta corrección.
