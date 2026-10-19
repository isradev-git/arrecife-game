# Sota · izquierda reflejada del perfil derecho · Modelo 11

15 de octubre de 2026. El autor valora una mejora clara del Modelo 10, considera más natural y menos defectuosa la derecha y pide copiarla literalmente para mirar y caminar hacia la izquierda.

Se reutilizan en el controlador los mismos fotogramas derechos para ambas orientaciones. `Sprite2D.flip_h` refleja la izquierda; el anclaje horizontal se refleja con el marco para conservar la raíz. Abarca marcha, arranque, parada, reanudación, reposo, respiración y giro. Los PNG, el modelo editable y el antiguo perfil izquierdo permanecen conservados. La revisión estática de referencias sigue mostrando los recursos históricos; el recorrido jugable usa el reflejo nuevo.

Esta decisión sustituye la exigencia anterior de perfiles jugables independientes. El reflejo incluye deliberadamente chaqueta, mecha, bolsillo, deck y luces pintadas; no representa una vista nueva del otro costado físico. No cambia la velocidad 104, el ciclo 128 ni la altura 252. No se generan imágenes ni prompts nuevos.

## Comprobaciones

- `tests/reflejo_sota.gd`: 169 pares GPU (32 fases, cuatro arranques, cuatro respiraciones, reposo y 128 cierres) iguales píxel a píxel tras invertir el izquierdo; datos del derecho idénticos a la fuente. [Hoja de las 32 parejas de marcha](ciclo_ambos_sentidos.png).
- `tests/fluidez_marcha.gd`: apoyos medidos teniendo en cuenta el reflejo; cero congelaciones y cero saltos extra de raíz a 30/60 Hz. Deriva de puntera 2,400–3,467 px.
- `tests/movimiento.gd`: control, aceleración, frenada, inversión, destinos, límites, colisión y foco pasan.
- `tests/movimiento_sota.gd`: paleta, alfa, cabeza, escala, ambos sentidos, parada, movimiento reducido y extremos pasan. Veinte capturas nativas conservadas, incluida [marcha izquierda](izquierda_070.png).
- Importación y exportación Web release completadas. Helium/Chromium carga Modelo 11; marcha izquierda observada en [captura Web](web_izquierda.png), sin errores de página registrados.

Se guarda `controlador_antes.gd.txt` para conservar el Modelo 10 anterior a este cambio. Entrega del asistente; la valoración positiva recibida se refiere a la mejora anterior y a la preferencia por el derecho. El nuevo reflejo queda para valoración del autor. Safari, Firefox y móvil sin comprobar en esta revisión.
