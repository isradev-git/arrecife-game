# T05 · Corrección de paleta y marcha v4

13 de octubre de 2026. El autor reconoce mejora de v1, pero sigue viendo movimiento robótico y cambios de color al andar. Esta es una corrección integrada para valoración, no aprobación artística ni cierre de T05.

**Valoración posterior del autor:** aprueba expresamente la naturalidad de v4 («el movimiento está perfecto»), lo nota algo lento y pide pulir huecos/manos/restos de piezas. [Pulido posterior y pruebas](../modelo_marcha_v5/README.md); la aprobación del movimiento no equivale a aprobación del nuevo acabado.

## Resultado

El recorrido usa cuatro atlas de [articulada_v1](../../../../godot/assets/personajes/sota/articulada_v1/). Se renderizan en Godot desde las dos vistas originales de Sota v7, conservadas intactas. Cada perfil tiene 32 posturas de marcha, cuatro de arranque, cuatro enlaces de cierre para cada postura, reposo y cuatro fases de respiración. No se refleja la figura. Son sprites completos preparados mediante articulación de piezas con UV del original; no son 32 dibujos nuevos realizados a mano. La propuesta busca resolver continuidad y mecánica; los contornos/uniones y pliegues de las articulaciones necesitan valoración artística, sin dar por satisfecho automáticamente el criterio de dibujos completos del autor.

La textura fuente compartida evita redibujar cara, ropa y colores por pose. Nearest, máscara alfa 0,95 y opacidad binaria al preparar los atlas evitan nuevas mezclas de color con el fondo o entre piezas. No hay ajustes de brillo ni recoloración entre fotogramas. El shader tiene la nueva opción desactivada por defecto: la revisión histórica conserva su render.

Trayectoria de pie con apoyo durante el 60 % del ciclo, elevación y flexión durante el avance, balanceo de brazos opuesto a las piernas, oscilación vertical pequeña y contrarrotación del torso. Ciclo de dos pasos: 128 px; velocidad 104 px/s, aceleración 650 y frenada 750 px/s². Son valores calibrados por el asistente, no decisiones nuevas del autor. Altura de reposo 252, centro y = 705, límites 128–1536 y orden de planos conservados. El juego reproduce los atlas; no calcula la articulación durante la partida.

## Evidencia

- [Vídeo del navegador](marcha_web.webm): 30,033 s, D/A tres segundos por sentido, parada entre ambos. La primera parte muestra reposo mientras se prepara la grabación.
- [Reposo derecho](web_reposo.png), [reposo izquierdo](web_izquierda_reposo.png), [llegada por botón a la Jefa](web_jefa_llegada.png).
- Veinte capturas nativas: siete momentos de marcha y tres de parada por perfil, incluidas en esta carpeta.
- [Prueba GPU](comprobacion_gpu.txt): 338 poses; todos los 3.613.251 píxeles opacos de los cuatro PNG tienen RGB presente en v7 y alfa 255, sin transparencia parcial. Región de cabeza de 110 × 48 px idéntica al reposo rasterizado, compensando el pequeño movimiento vertical. Esto no demuestra identidad de todo el dibujo ni brillo promedio idéntico cuando cambian las superficies visibles.
- [Fluidez](fluidez.txt): 32 fases por perfil, 30/60 Hz sin congelación ni salto extra de raíz; máxima desviación de puntera proyectada 3,467 px a 30 Hz y 2,401/2,400 px a 60 Hz, frente a ~23 px de v1. Se mide el extremo del contorno de la bota del modelo usado al preparar sprites, durante el interior del apoyo; no todos los píxeles de la suela ni los instantes de contacto/despegue. Persiste cuantización de 4 px entre posturas.
- [Controlador](controlador.txt): destinos, límites, colisiones, inversión, frenada, foco y controles sin carrera. [Escala histórica](escala.txt) y [shader histórico GPU](iluminacion.txt) pasan.
- Exportación release terminada con código 0. Helium/Chromium, canvas 1672 × 941 y WebGL 2: ambos sentidos, paradas y botón Jefa x = 1260 observados. Sin errores de página ni errores en consola durante la prueba.

## Reproducir

Desde la raíz del proyecto, el preparador requiere render GPU y escribe únicamente los atlas nuevos y sus metadatos:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script res://tests/preparar_sota_articulada.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --editor --import
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/fluidez_marcha.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/movimiento.gd
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script res://tests/movimiento_sota.gd -- --capturas
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --export-release Web
```

[Preparador](../../../../godot/tests/preparar_sota_articulada.gd), [articulación](../../../../godot/sota_articulada.gd) y [reproductor](../../../../godot/movimiento_sota.gd). `borrador_atlas/` conserva el primer render con solapamiento de cuello; `borrador_alfa/` conserva la variante anterior al alfa binario. `prototipo/` conserva la prueba continua de articulación y su escena; su vídeo no representa el recorrido final. [Intentos generativos y prompts descartados](../../personajes/sota/marcha_v4/README.md) conservados. [Hashes](hashes.sha256) de fuente y recursos finales.

Pendiente: valoración del andar y transición entre figura articulada/reposo, pulir contornos y pliegues si procede, luz espacial adaptable y otras tareas ya abiertas. Safari, Firefox, móvil y rendimiento en equipos modestos no comprobados en esta corrección. No hay cambios de historia, diálogos, NPC ni capas.
