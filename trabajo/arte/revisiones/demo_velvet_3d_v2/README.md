# La Fiebre · revisión de detalle y vecindario

19 de octubre de 2026. Solicitud del autor: entorno más detallado y cyberpunk, carretera menor, extremos que correspondan al recorrido, Sota un poco más rápida, jefa fiel al retrato y personas caminando/paradas con vestuario e implantes distintos.

## Probar

Abrir `godot_ilustrado/project.godot`, F5. Web local en `http://127.0.0.1:8766/godot_ilustrado/build/web/?revision=barrio-v2` con el servidor local activo.

A/D o flechas, clic para caminar, Espacio para pausa. E para observar/hablar; E/Enter/Espacio avanza, Esc cierra. El diálogo con retratos y los cuatro encuentros existentes se conservan. «Sota · 360°» abre el visor.

## Cambios

- Calzada de servicio de **2,3 m**, delimitada por ambas aceras; pavimento, bordillos, marcas y drenajes. Encuadre elevado para dar más espacio a los edificios.
- Testeros sólidos en −4 y 38 m. La cámara limita su campo según el ancho real del viewport; no ofrece una continuación lateral fuera del tramo jugable.
- Fachadas con equipos de climatización, bandejas de cable, armarios eléctricos, plataformas y escaleras de mantenimiento, máquinas de recarga/dosis, afiches, pequeños herrajes y luces locales. Se mantiene suelo continuo y edificios apoyados.
- Sota: **cadencia ×1,12**, avance de 0,975 a 1,092 m/s. Se acelera el tiempo del clip y se utiliza su root motion; no se multiplica la traslación por separado. No cambia rig, modelo v7 ni zancada. La frenada modal usa la misma cadencia.
- Jefa v2: pelo recogido oscuro con mechones laterales, mandíbula segmentada negra/latón, pendiente largo, pasador, lunar, labios oscuros, cuello alto, solapas granate, corsé/cinchas y herrajes. Referencia observada: retrato original. Sigue siendo una candidata de parecido, no aprobación artística.
- Seis vecinos además de la jefa: tres pasean con pausas y giros y tres permanecen en reposo. Tres propuestas de aspecto, repetidas en distintas posiciones: ropa técnica verde/auricular, chaqueta ocre/visor, ropa oscura/pelo claro/prótesis. Carriles separados del de Sota; sólo la jefa conversa. La pausa detiene también a los vecinos.
- Un atlas de color/normal/rugosidad/metal por modelo secundario: una superficie por personaje, manteniendo rig de 65 huesos. Se reduce geometría de ropa de los vecinos lejanos; Sota no se simplifica.

## Archivos

Escenario y población: `godot_ilustrado/velvet.gd`. Cámara: `recorrido_3d.gd` y `demo_velvet.gd`. Cadencia: `jugadora.gd` y frenada de diálogo. Recursos nuevos: `assets/velvet_3d_v2/`. Fuente Blender y generador: `trabajo/arte/personajes/figuracion/velvet_v2/`.

Pruebas: `tests/barrio.gd`, `tests/demo_velvet.gd`, `tests/recorrido.gd`. Capturas: `tests/capturar_barrio.gd`, `tests/capturar_vecindario.gd`. Diagnóstico de rendimiento existente actualizado para incluir paseantes.

`anterior/` conserva los scripts de escena/control y una vista previa. Modelos y generadores de Velvet v1 intactos. Sota v7 permanece igual. `ensayo_01/` documenta el intento descartado de abertura de prenda sin torso completo; la entrega mantiene el corsé cerrado porque el torso base recortado no permite reproducir aún ese escote sin rehacer su unión con cuello/hombros. No se oculta este fallo bajo las pruebas numéricas. Canon, fuentes y diálogos no cambian.

## Límites

Son seis vecinos con tres diseños y rutas locales, no una simulación de ciudad ni seis identidades narrativas nuevas. Su actividad se limita a caminar, esperar y reposo. La jefa necesita valoración de parecido; no se certifica acabado profesional por el número de polígonos. Sin interiores nuevos, sonido, guardado ni producción de los treinta minutos. No se garantiza 60 FPS ni rendimiento en equipos modestos.

Resultados y cobertura concreta: `validacion.txt`. Capturas nativas `velvet_*.png`, `extremo_*.png`, `jefa_*.png` y `vecin*_cuerpo.png`.

Web comprobada en Helium/WebGL2: carga, figuración en marcha, clic y llegada, conversación y cierre. Capturas `web_*.png`; grabación `paseo_web.webm` y hoja de ocho fotogramas `paseo_contactos.png`. El archivo a 30 FPS es una grabación de revisión, no una garantía de rendimiento del juego.
