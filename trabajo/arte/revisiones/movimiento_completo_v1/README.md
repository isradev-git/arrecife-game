# T05/T06 · Movimiento completo de Sota

13 de octubre de 2026. Entrega funcional integrada en Godot y Web, pendiente de valoración visual del autor. Caminar en ambos sentidos con **16 dibujos propios por perfil**, arranque, frenada/cierre del paso A o B, cambio de sentido sin frontal, reposo original y una respiración sutil; control Movimiento reducido. [PNG y prompts de imagegen integrado](../../personajes/sota/movimiento_v3/README.md). No correr.

[Demo real de navegador, 14,466 s](demostracion.webm), [derecha](web_derecha.png), [izquierda](web_izquierda.png), [teclado](web_teclado.png), [movimiento reducido](web_reducido.png), [recarga](web_recarga.png), [extremo derecho x = 1536](web_extremo.png). Canvas 1672 × 941; el vídeo añade una fila para codificación (1672 × 942), 30 fps de grabación, no medición de rendimiento. Las 20 capturas nativas cubren fases, preparación, parada y reposo de ambos perfiles; primeras capturas exploratorias conservadas en borrador/. La demo se grabó con respiración reducida activada; respiración normal comprobada en Godot y el modo de reposo web inicial.

Motor Godot 4.7.2 Compatibility / Apple M4; navegador Helium/Chromium, WebGL 2.0. Importación y exportación final correctas. URL local: http://127.0.0.1:8766/godot/build/web/ (servidor activo al comprobar; arrancar desde raíz con python3 -m http.server 8766 si se retoma sin él).

**Comprobaciones:**

- 32 fases seleccionadas, dos perfiles diferentes, sin flip_h/flip_v, marco común 836 × 1024 y una escala por perfil. Reposo v7 mantiene 252 de altura opaca; referencia de máscara 869/865, escalas 252/869 y 252/865. No se normaliza cada fase: se conserva oscilación del dibujo.
- Alfa de render 0,95 para eliminar halos/residuos semitransparentes sin cambiar los RGB de las figuras. La revisión artística histórica mantiene su umbral 0,1. Todas las fases/transiciones pasan margen tonal existente 0,8–1,15 frente al reposo de su perfil. El nuevo enlace derecho v8 resuelve la alerta de la serie anterior; archivo y alerta anteriores no se alteran.
- Cadera y apoyo calibrados sobre el alfa de render. Se distingue bota adelantada del talón/toe trasero; se sigue puntera proyectada dentro de la banda de suelo para evitar tomar la bota elevada. Suelo y = 705; punto de apoyo horizontal conservado durante cada medio paso con error <0,05 en la prueba. Es calibración geométrica, no evaluación biomecánica exhaustiva de cada píxel.
- Ciclo por distancia real de 196 px, velocidad 156 px/s; aceleración/frenada y controles conservados. Preparación por distancia, cierre de paso 0,24 s, giro de perfil 0,12 s y respiración de ciclo 4 s. Cambio de sentido durante marcha, repetición, parada e inicio comprobados.
- Límites 128–1536: 32 aproximaciones desde distintas fases comprueban contorno completo dentro de 0–1672, incluidas botas adelantadas. Colisiones, destinos Jefa/guardia, liberación de teclas, Mayús sin carrera, Esc y foco siguen pasando.
- 36 copias PNG idénticas a sus fuentes, [SHA-256/medidas](recursos_verificados.json); reposo v7 y todos los intentos/prompts anteriores intactos. Prueba histórica de 16 poses rechazadas conservada e independiente de la animación vigente.
- Godot: movimiento_sota, movimiento, marcha histórica y escala pasan; render GPU de fases/transiciones en ambos perfiles pasa. Web: carga/recarga, clic a ambos lados, tecla D simulada por eventos DOM, reversión, Esc y checkbox comprobados visualmente, sin errores de página/consola. Cambio real a pestaña about:blank detiene entrada: [dos capturas](web_foco_1.png) / [segunda](web_foco_2.png) mantienen x = 926 al volver.

Pruebas reproducibles:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script tests/movimiento_sota.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script tests/movimiento.gd
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/movimiento_sota.gd -- --capturas
```

Preparación/copia de fuentes y metadatos: tests/preparar_movimiento.gd; después --headless --editor --path godot --import antes de exportar. Scripts de prueba excluidos de Web. Recursos dinámicos incluidos por export_filter=all_resources.

**Límites:** entrega del asistente y comprobaciones técnicas, sin aprobación artística nueva. Hay variaciones generativas de sombra/volumen/cabeza que se podrán afinar tras valoración, no se afirma conservación exacta del master por el generador. La medición de apoyo y el rango tonal no prueban naturalidad perfecta. Safari/Firefox, móvil, rendimiento/memoria en dispositivos modestos y luz espacial siguen sin comprobar; PCK de revisión ~69 MiB. No se migra el caso narrativo ni se anima el resto de personas/entorno en esta tarea.
