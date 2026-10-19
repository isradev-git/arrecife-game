# Pasarela 3D v1 · 19 de octubre de 2026

## Entrega y aprobación

El autor aprobó personajes y escenarios completamente 3D, movimiento izquierda/derecha y una primera experiencia de unos 30 minutos ampliable con canon/lore. Esta entrega implementa **un tramo técnico de 42 m**, no los 30 minutos ni un acabado profesional aprobado.

La pasarela tiene suelo y barreras físicas, fachadas, edificios en profundidad, cableado, luz y cámara de seguimiento en perspectiva estrecha. Sus rótulos son composición provisional; no fijan nuevos hechos del canon. El modelo y los clips de Sota no se han cambiado. El laboratorio anterior y sus fuentes siguen disponibles.

## Probar

Abrir `godot_ilustrado/project.godot` con Godot 4.7.2 y pulsar F5. A/D, flechas o clic en suelo para caminar; Espacio o botón para pausar. Pérdida de foco pausa y cancela destino. Botones Laboratorio/Pasarela 3D cambian entre escenas.

[Web local](http://127.0.0.1:8766/godot_ilustrado/build/web/), con servidor de la raíz del repositorio en 8766. Preset de exportación: **Web 3D**.

## Evidencias

- [Vídeo nativo](recorrido.mp4): 9 segundos, 1280×720, 60 fotogramas/s, derecha, frenada/giro, izquierda y parada. Capturado con Movie Maker de Godot, sin interpolación añadida. La tasa del archivo no certifica rendimiento en juego.
- [Secuencia del vídeo](secuencia.png), instantes 0, 2, 4 y 6 s.
- [Zona inicial](tramo_120.png), [vano de ciudad](tramo_300.png), [segunda fachada e izquierda](tramo_480.png). La captura automática se reposiciona entre estas tres zonas para inspeccionarlas; ese reposicionamiento pertenece a la prueba, no al juego.
- Web: `web_inicio.png`, `web_camara_pausa.png`, `web_laboratorio.png` y `web_regreso.png`.
- [Resultados automatizados](validacion.txt). [Fallo de giro reproducido antes de corregir](fallo_giro_previo.txt).

## Comprobaciones

`tests/recorrido.gd` pasa con física a 60 Hz: suelo, carril lateral sin deriva Z, teclado, parada estable, inversión, interrupción de giro, clic/llegada, seguimiento y límites de cámara, llegada a ambos extremos y obstáculo físico interior. Pérdida de foco detiene la simulación y cancela destino. La detección del obstáculo no depende de los límites numéricos del mapa.

La interrupción de giro fallaba: se comparaba la dirección lógica anterior y se podía reanudar con la malla oblicua. Se compara ahora el ángulo real con el solicitado antes de autorizar la marcha. La prueba falla antes y pasa después del cambio.

Regresiones `locomocion.gd`, `modelo.gd` y `control.gd` pasan: adaptación de 65 huesos sin escalado, pesos, lado del deck y controles del laboratorio. Root motion muestreado de nuevo a 30/60/120 FPS: aproximadamente 3,9 m en 4 s. Esto no equivale a probar el recorrido físico a las tres tasas.

GLB, archivo Blender y generador de Sota cotejados por SHA256 con `sota_ilustrada_3d_v1/recursos_sha256.json`: idénticos. No se repitió la medición GPU del rodado completo; sigue pendiente desde la entrega anterior. Las imágenes muestran un apoyo coherente, no demuestran ausencia completa de deslizamiento.

Godot nativo: Apple M4, Compatibility. Web: Helium/WebGL 2, carga, clic y cámara, pausa por Espacio, navegación al laboratorio y regreso. No se observaron errores de ejecución. Safari/Firefox y rendimiento en equipos modestos no comprobados.

## Límites artísticos y de producto

El escenario usa geometría simple y materiales planos; falta detalle, desgaste, composición y tratamiento de luz para alcanzar el lenguaje de los retratos. Sota conserva el estudio v1: pelo, rostro, prendas y materiales necesitan producción artística. Giro en el sitio y arranque/parada siguen siendo provisionales, sin clips específicos ni bloqueo de pies. No hay aprobación artística nueva.

Faltan conversaciones, objetos examinables, sonido, guardado compatible con ampliaciones y los 30 minutos de contenido. La separación de entorno, cuerpo y recorrido permite producir las siguientes escenas; no es un sistema de episodios o actualizaciones ya implementado.

## Archivos de implementación

Nuevos: `godot_ilustrado/jugadora.gd`, `pasarela.gd`, `recorrido_3d.gd`, `recorrido_3d.tscn`, `tests/recorrido.gd`, `tests/capturar_recorrido.gd` y evidencias de esta carpeta.

Actualizados: `godot_ilustrado/project.godot`, `export_presets.cfg`, `laboratorio.gd` (botón de regreso), `README.md`; README raíz, `task.md`, continuidad, plan, dirección artística y diseño de experiencia. No se toca el proyecto pixel histórico, su controlador ni el canon.

Reproducir las capturas: `Godot --path godot_ilustrado --script res://tests/capturar_recorrido.gd --fixed-fps 60`. Para vídeo: añadir `--write-movie /tmp/pasarela.avi -- --video` y convertir el AVI a MP4 con ffmpeg.
