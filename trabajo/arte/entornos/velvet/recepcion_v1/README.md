# Velvet · Figurante y equipo independientes T07.6

11 de octubre de 2026. El autor autoriza continuar con la separación de la figurante y el equipo de recepción. Entrega del asistente, pendiente de valoración visual; no supone aprobación nueva de T07.5 ni de toda T07.

## Recursos y procedencia

Tres ediciones con la herramienta integrada imagegen, desde el [fondo de suelo horizontal](../../../../../godot/assets/entornos/velvet/fondo_suelo_recto_v1.png). Se observaron las referencias aprobadas de [Velvet](../../../referencias/pixel_art_v1/velvet_estilo.png) y [personajes](../../../referencias/pixel_art_v1/personajes_estilo.png); la segunda se suministró también para el tratamiento de la figurante. PNG generados copiados sin retoque, con alfa original. Versiones y prompts anteriores conservados.

| Recurso | PNG y región de atlas, alfa ≥ 10 % | Prompt exacto |
| --- | --- | --- |
| [Figurante](../../../../../godot/assets/entornos/velvet/figurante_recepcion_v1.png) | 1024 × 1536; x = 233, y = 142, ancho 557, alto 1318; RGBA transparente | [Figurante](prompt_figurante.txt) |
| [Equipo](../../../../../godot/assets/entornos/velvet/equipo_recepcion_v1.png) | 1774 × 887; x = 208, y = 121, ancho 1374, alto 654; RGBA transparente | [Equipo](prompt_equipo.txt) |
| [Interior vacío](../../../../../godot/assets/entornos/velvet/fondo_recepcion_reparado_v1.png) | 1672 × 941; opaco, sin figurante, mostrador ni equipo de superficie | [Fondo](prompt_fondo.txt) |

La figurante es la persona anónima del entorno de referencia, sin asignarle nombre, diálogos ni papel narrativo nuevo. Se completa el cuerpo que estaba oculto: moño, chaqueta ciruela, delantal/falda oscura, botas y pose de trabajo orientada a la izquierda. Píxel grueso, rostro en masas y ojos mínimos. Base sin contorno rosa pintado; el shader existente añade el contraluz de recepción (ámbar desde izquierda, rojo/rosa desde derecha), ajustable en el material. Fuentes espaciales pendientes.

El equipo reúne lámpara, terminal, papeles y taza en un único sprite. No se han separado sus piezas individualmente ni convertido la lámpara en una fuente dinámica. El mostrador de T07.5 se conserva; mantiene sus detalles pintados, incluidos pequeños papeles de acabado. Edición generativa: cambian detalles y proporciones; no se presenta como extracción idéntica píxel a píxel.

## Integración

`godot/revision_escala.gd` usa AtlasTexture y filtrado nearest. Figurante a escala uniforme 244 / 1318, en x = 1328, y = 431; pies en y = 675. Equipo a escala uniforme 59 / 654, en x = 1218, y = 479; base y = 538, superficie del mostrador. Se reutiliza el shader de metal opaco para equipo y mostrador.

Solo se toma del nuevo fondo el parche x = 1210–1488, y = 440–675 (278 × 235), sustituyendo el parche menor de T07.5. Fuera del parche sigue el fondo horizontal anterior. El cuerpo independiente puede sobresalir por encima del parche; no se afirma que toda la composición nueva sea idéntica a la anterior.

| Plano | Orden z |
| --- | --- |
| Fondo original / interior reparado | −20 / −19 |
| Barandilla trasera | −5 |
| Figurante | −4 |
| Mostrador | −3 |
| Equipo de superficie | −2 |
| Sota, pies en centro y = 705 | 0 |
| Barandilla delantera, base y = 735 | +5 |

Controles Figurante y Equipo independientes de Mostrador visible/Ocultar mostrador. Es una revisión técnica: ocultar el mostrador con equipo visible deja los props suspendidos deliberadamente para inspeccionar planos; no es comportamiento del juego final.

[Capturas nativas/Web y pruebas](../../../revisiones/recepcion_v1/README.md). Quedan restantes figurantes y objetos, arquitectura/ciudad, retícula definitiva, luces espaciales, atmósfera, animación y movimiento/colisiones.

**Continuación T07.7:** [figura del acceso](../acceso_v1/README.md). Recursos de recepción conservados e integrados sin modificaciones. El autor valora positivamente el progreso general y pide seguir con calma; no consta aprobación individual nueva de cada recurso.
