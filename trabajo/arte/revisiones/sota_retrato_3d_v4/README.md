# Revisión v4 · Sota y cámara

19 octubre 2026 · Godot 4.7.2 Compatibility, Apple M4. **Movimiento actual aprobado por el autor; aspecto todavía en revisión.** La pasarela de 42 m es un entorno técnico de movimiento/cámara/colisiones, sin escenario narrativo definitivo ni conversaciones implementadas.

## Imágenes nativas

- [Rostro v4](v4_cabeza.png) / [v3 con la misma luz y pose](v3_cabeza.png).
- Marcha a la derecha: [v4 fase 40](v4_perfil_040.png), [fase 60](v4_perfil_060.png).
- Marcha a la izquierda: [v4 fase 120](v4_perfil_120.png), [fase 140](v4_perfil_140.png).
- Comparación anterior: `v3_perfil_*.png`, mismo estudio, escala y fases.
- Escala de juego: [inicio](tramo_120.png), [zona central](tramo_300.png), [izquierda en zona final](tramo_480.png).
- [Web](web.png), cámara a 24 m; imagen del juego exportado.

`capturar_retrato_v4.gd` produce perfiles/cabeza; `-- --anterior` carga explícitamente v3. Vista de cabeza a tres cuartos sólo para inspección estática, no nueva dirección de marcha. `capturar_recorrido.gd` salta entre tres zonas para fotografiar la composición; esos saltos no forman parte del control del juego.

## Cambios revisados

Pelo con sien despejada y mecha lateral, rasgos/implantes más definidos, solapas/bordes/bolsillos/parche y continuidad de correa. La cámara se aleja de 22 a 24 m manteniendo FOV y ángulo aproximado. No hay cambios de clips, mezcla, retarget, root motion, velocidad ni control. [Fuente y generador](../../personajes/sota/ilustrada_3d_v4/README.md).

`ensayo_01/` y `ensayo_02/` guardan renders y scripts intermedios: flequillo que oculta el ojo y primer ensayo de color de piel. No son resultados aprobados ni el recurso activo.

## Comprobación

Resultados completos en [validacion.txt](validacion.txt). Pruebas nativas con GPU; no se confunden con la advertencia de cierre del renderizador dummy registrada en la v3. Cinco pruebas pasan: modelo, locomoción, equipo, contacto y recorrido físico. Sota proyecta un **14,30 %** de la altura inicial de pantalla. Modelo final: **59 piezas, 33532 vértices ponderados, 65 huesos**. `modelo.gd` verifica pesos/finitud, lado del deck, color de chaqueta, retarget y coincidencia de rig/botas con v3.

Locomoción: 3,900002 / 3,899998 / 3,900009 m en 4 s a 30/60/120 FPS; sin escala ni error de longitud local. Equipo: 1920 poses a 120 Hz, sin cruce de mano/antebrazo distal con volumen del deck +3 mm; correa unida al anclaje en todas las muestras.

La comprobación de contacto cubre marcha estable y ventanas planas parciales: no certifica ausencia total de deslizamiento en rodado, parada o giro. El parecido facial, acabado de pelo/prendas y calidad profesional siguen sin aprobación. Web comprobada en Helium/WebGL 2; otros navegadores y rendimiento de equipos modestos pendientes.

## Probar

Abrir `godot_ilustrado/project.godot` y F5. A/D, flechas o clic al suelo; Espacio pausa. Botón Laboratorio: inspección cercana con retrato, marcha continua, lenta y paso. [Web local](http://127.0.0.1:8766/godot_ilustrado/build/web/).

[SHA256 de recursos anteriores y comprobación de cambios acotados](preservacion.txt). Las versiones anteriores permanecen intactas. Para comparar el modelo anterior, asignar `assets/sota_3d_v3/sota.glb` a `modelo_sota` del laboratorio; su fuente no ha sido sobrescrita. No se ha publicado ni hecho commit/push.
