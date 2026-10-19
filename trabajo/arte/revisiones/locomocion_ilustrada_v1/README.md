# Locomoción ilustrada · primera base técnica

18 de octubre de 2026. [Nuevo proyecto y controles](../../../../godot_ilustrado/README.md). [Dirección aprobada](../../../direccion_artistica.md).

- [Vídeo nativo, 6 s a 60 FPS](locomocion.mp4).
- [Secuencia de marcha, inversión y parada](secuencia.png).
- [Fase derecha](fase_100.png), [fase izquierda](fase_250.png), [reposo tras parar](fase_350.png).
- [Registro de pruebas](validacion.txt).

La malla femenina genérica conserva 65 huesos y superficies completas. Las animaciones de Quaternius se adaptan con `RetargetModifier3D` nativo; `AnimationTree` extrae el root motion para mover el cuerpo. El avance del clip determina el movimiento, sin atlas ni separación en recortes. No se presenta como Sota final ni como estilo artístico terminado.

## Resultados iniciales

Root motion en 4 s: 3,900002 m a 30 FPS, 3,899998 m a 60 FPS, 3,900009 m a 120 FPS. Retarget conserva longitudes locales (error máximo medido 0 m), transformaciones finitas y escala unitaria. Mezcla a reposo termina con desplazamiento cero; recorrido lateral y pérdida de foco comprobados.

Malla deformada leída con GPU, 80 muestras de marcha estable: borde inferior −4,972..+7,619 mm respecto al suelo. Se tolera este margen en la prueba inicial; **no es contacto perfecto**, ni una medida de deslizamiento horizontal o de transición. El renderizador headless no permite hornear esa malla; la prueba de contacto debe ejecutarse con GPU.

Vídeo producido con el Movie Maker nativo de Godot, 360 fotogramas/60 FPS, convertido a MP4. Se inspeccionaron capturas de ambos sentidos y secuencia temporal. La calidad visual de arranque, parada y giro sigue pendiente: se mezclan marcha/reposo y se gira en el sitio, sin clips específicos ni bloqueo de pies. Tampoco hay colisión de escenario o juego narrativo.

El siguiente trabajo es Sota con su cuerpo/ropa/pelo/equipo y acabado del retrato; después se repite la revisión sobre el personaje vestido. La forma de este maniquí no se aprueba automáticamente como sus proporciones. No hay aprobación artística nueva ni exportación Web del proyecto.
