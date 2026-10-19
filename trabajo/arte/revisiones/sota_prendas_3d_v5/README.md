# Sota v5 · revisión de vestuario

19 octubre 2026. Referencia de parecido elegida por el autor: [cabeza del ensayo 01 de v4](../sota_retrato_3d_v4/ensayo_01/v4_cabeza.png). La v5 mantiene esa configuración de pelo/rostro y revisa la construcción de las prendas. El movimiento actual sigue aprobado; el acabado de v5 queda pendiente de valoración artística.

## Capturas de Godot

- [Rostro](v5_cabeza.png).
- [Chaqueta y capas](v5_chaqueta.png), [pantalón](v5_pantalon.png), [botas](v5_botas.png).
- Marcha derecha: [fase 40](v5_perfil_040.png), [fase 60](v5_perfil_060.png).
- Marcha izquierda: [fase 120](v5_perfil_120.png), [fase 140](v5_perfil_140.png).
- `v4_*.png`: comparación anterior, misma luz, escala y fases. El aspecto de cabeza anterior corresponde a la v4 entregada, no al ensayo que el autor prefiere.
- [Escala de juego](tramo_300.png), cámara a 24 m. El escenario sigue siendo una pasarela de pruebas, sin contenido narrativo definitivo.
- [Web](web.png), GLB y texturas exportados.

Capturar con `tests/capturar_prendas_v5.gd`; `-- --anterior` selecciona v4. Las vistas de detalles están en reposo a tres cuartos para inspección; el juego conserva sólo movimiento lateral. Los saltos entre zonas de `capturar_recorrido.gd` son sólo para fotografiar el encuadre.

## Cambios

La abertura de camiseta que se simulaba con color sobre la chaqueta se reemplaza por un hueco real, con prenda interior detrás y grosor en los bordes. Pliegues y holgura en prendas; solapas/paneles con espesor. Botas con cubierta, lengüeta, cordones y suela de goma construida. Seis materiales UV con mapas de color/rugosidad/normal exportables, sin shaders personalizados ni efectos borrosos.

[Fuente editable y generación](../../personajes/sota/ilustrada_3d_v5/README.md). V1–v4 permanecen recuperables. No cambian los clips, rig, controlador, root motion ni cámara. El modelo sigue siendo una candidata; no se da por alcanzada calidad profesional.

## Pruebas

[Resultados completos](validacion.txt) y [preservación de fuentes](preservacion.txt). GPU nativa, Godot 4.7.2 Compatibility, Apple M4. Se revisan pesos/rig/materiales y UV, locomoción 30/60/120 FPS, equipo/arnés y contacto de todas las superficies originales y añadidas de calzado. La comparación de soporte original admite que las UV dividan vértices al importar: se comprueba igualdad de posiciones únicas, pesos válidos y contacto dinámico, sin exigir igualdad de todos los arrays del calzado que ahora tiene cubiertas distintas. Las ventanas de marcadores siguen siendo parciales; no certifican ausencia total de deslizamiento ni todas las transiciones.

`ensayo_01/` conserva el primer render con trama regular demasiado visible y picos, además del diagnóstico de suela que invadía el suelo. No son imágenes de entrega. La corrección de suela se hace en geometría, sin relajar el umbral de contacto ni cambiar la marcha.

## Probar

Abrir `godot_ilustrado/project.godot`, F5. Botón Laboratorio para ver el personaje con el retrato, marcha continua, cámara lenta y paso. [Web local](http://127.0.0.1:8766/godot_ilustrado/build/web/). No se ha publicado ni hecho commit/push.

Pendientes: aprobación artística de ajuste/materiales, otros navegadores y rendimiento en equipos modestos. La textura de tejido es discreta a escala de juego; la legibilidad principal sigue dependiendo de silueta, iluminación y volumen.
