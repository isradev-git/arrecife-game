# Los Puntales · renovación de las seis vistas

El autor aprobó la v3 de `puntales_acceso` como dirección visual y pidió continuar cota por cota. La cota 2 se rehace conforme a D225 y al lenguaje de `art/originals/sota.png` y `jefa.png`: contorno firme, masas de color, sombras angulares y detalle selectivo. La luz toma la v2/v3 como referencia: cielo proyectado azul grisáceo entre estructuras, sombra bajo vigas y luminarias de trabajo localizadas. Los originales no se alteran.

## Enfoques

- Recolorear los cinco fondos antiguos: conserva la plantilla ámbar y los dos acabados fotográficos.
- Generar vistas nuevas sin referencia espacial: puede perder rutas y objetos que ya usa el juego.
- **Elegido:** una ilustración nueva por vista, con `puntales_acceso_canon_v3.png` y retratos como referencias de estilo, y cada PNG antiguo sólo como guía de rutas y objetos. Conservar los seis fondos anteriores y todos los prompts. Integrar los candidatos en las mismas vistas para revisión técnica; la aprobación artística de las cinco imágenes nuevas queda pendiente del autor.

## Geografía y lectura por vista

| Vista | Composición propia | Rutas y objeto que deben quedar visibles |
| --- | --- | --- |
| `puntales_acceso` | Llegada habitada entre grandes refuerzos y taller, según la v3 aprobada | Escalera a El Nudo izquierda; taller centro; verificación derecha; soporte observable en centro. |
| `puntales_taller` | Taller de conducción bajo vigas, bancos y tramos desmontados, pocos trabajadores cercanos, calle habitada detrás | Regreso al acceso izquierda; frente de trabajo derecha; banco observable en centro. |
| `puntales_observatorio` | Frente de intervención en una unión entre moles: estructura que soporta la ciudad, cuadrilla adulta y conducción grande | Taller izquierda; galería de soportes derecha; intervención observable en centro. Mantener el ID interno `observatorio`. |
| `puntales_soportes` | Galería más cerrada de pilares, cartelas, tirantes y reparaciones superpuestas | Frente izquierda; cámara de presión derecha; soporte observable centro; marca pintada sobre metal hacia la derecha y arriba. |
| `puntales_presion` | Cámara técnica de agua con depósito y manómetros ilustrados, distinta del vestíbulo público | Soportes izquierda; verificación derecha; conducción observable centro; medidor actual distinguible hacia la derecha y arriba. No poner números legibles en el PNG. |
| `puntales_verificacion` | Puesto modesto de inspección, mesa y registro físico, con salida a dos corredores | Presión izquierda; acceso derecha; puesto observable centro; registro distinguible hacia la derecha y arriba, sin texto legible. |

La densidad de residentes corresponde a las vistas públicas, no a cada sala técnica. Evitar que todas repitan el mismo atrio, las mismas lámparas o el suelo brillante. Gremio y cuadrillas independientes son parte del canon; pueden reconocerse por equipo y marcas, pero no se añade una interacción ni se inventa un nuevo conflicto. Ninguna imagen fija el resultado de los contratos.

## Integración y comprobación

Cada vista conserva su ID, conexiones, condiciones, diálogos, documentos y guardado. Los PNG nuevos tienen nombres versionados; `world.json` cambia sólo los valores `art` de las seis vistas. Los hotspots se ajustan **sólo si el objeto o salida real cambia de posición** y se revisan dentro de Godot a 1280×720 y 844×390. El nombre `puntales_observatorio` no se renombra para no afectar partidas.

Comprobar importación, recorrido y pruebas headless/nativas del README, regreso entre cotas, recortes, indicadores y rutas, preservación de retratos/fondos anteriores y exportación Web local. La prueba de preservación del canon puede fallar por cambios locales anteriores al hito; no se modificará el canon para forzar ese test. Los nuevos PNG son candidatos aplanados sin capas finales: se requerirá valoración artística individual antes de darlos por finales.
