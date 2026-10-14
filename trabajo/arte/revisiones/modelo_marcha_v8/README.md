# Modelo 8 · cadera, volumen y reposo

14 de octubre de 2026. El autor rechaza Modelo 7: cadera extraña, pierna fina y gesto incorrecto al quedar en reposo. Capturas originales conservadas en `autor_derecha.png` y `autor_izquierda.png`. **Nueva entrega del asistente para valorar, no aprobación del autor. T05 sigue abierta.**

Se redondea el relleno de la cadera izquierda y se ancla la cintura antes de introducir gradualmente el giro del muslo. La pierna cercana izquierda recibe una superficie completa con UV de tela limpia de v7, evitando ampliar su zona parcialmente oculta en el original. El volumen se distribuye por el muslo, en lugar de abultar solo la rodilla. Sin generación ni edición de PNG fuente; geometría nativa Godot, original y prompts anteriores intactos.

El hombro lejano conserva su anclaje durante la parada. Antes volvía a adelantarse al bajar la amplitud. **Reposo y respiración del recorrido ahora se rasterizan desde el mismo modelo articulado que la marcha**, en vez de sustituirlo por el dibujo completo de v7. Cambian por ello pequeños detalles del pantalón y del brazo lejano en reposo; la referencia v7 permanece intacta y disponible en la revisión visual. El último cierre comparte exactamente la celda de reposo. Velocidad 104, ciclo 128, arranque, duración de cierre, trayectoria de pies, escala 252 y planos sin cambios.

Recursos: `godot/assets/personajes/sota/articulada_v5/`; v1–v4 conservados. Código anterior en `articulacion_antes.gd.txt`.

- [Marcha ampliada](despues.png), [cierre anterior](cierre_antes.png), [cierre nuevo](cierre_despues.png).
- [Vídeo Web](web_marcha.webm), [reposo izquierdo Web](web_izquierda.png), capturas nativas y hojas de cobertura/planos.
- `volumen_reposo_sota.gd -- --antes`: código 1, 64 cambios cierre/reposo, 256 anclajes de hombro adelantados, anchura mínima del muslo cercano izquierdo 19 px y 32 fases bajo 22 px. Sin argumento: código 0, cero cambios/anclajes erróneos, mínimo 24 px. Se mide transversalmente al 65 % del muslo en 32 fases, no toda la anatomía.
- `modelo_sota`: 328 estados conservan cuerpo/cabeza/brazo cercano/raíces de botas/apoyos; cobertura de torso/cintura/rodilla/caña sin piel incrustada. La región de cintura izquierda se desplaza hacia el interior del contorno nuevo: la prueba antigua exigía rellenar el saliente cuadrado que se acaba de quitar.
- `recortes_sota`: UV de mano/puño cero; 5327 cruces brazo/bolsa, cero ocultaciones incorrectas. `montaje_sota`: 46241 cruces GPU de piernas con orden correcto.
- Marcha, cabeza, paleta exacta en 3527191 píxeles opacos y alfa binaria; controlador y fluidez 30/60 Hz pasan. Desviación de puntera conservada: 2,4–3,5 px.
- Importación y exportación Web correctas. Helium/WebGL 2: Modelo 8, D/A, ambos sentidos y paradas comprobados, sin errores de página/consola. Vídeo conservado.

La comparación visual muestra más volumen y elimina el saliente rectangular y el cambio final de figura; las métricas no certifican el acabado artístico. Falta valoración del autor del pantalón y nuevo reposo. Safari/Firefox/móvil no comprobados en esta entrega. No iniciar otra tarea ni ajustar velocidad todavía.
