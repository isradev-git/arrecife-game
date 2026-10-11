# Velvet · Revisión del mostrador por capas

11 de octubre de 2026 · T07.5. [Recursos, procedencia y prompts](../../entornos/velvet/mostrador_v1/README.md). Sota frente al mostrador, x = 1345, pies y = 705, altura 252; mostrador en el borde trasero y = 675 y z = −3, detrás de Sota. Las barandillas mantienen su geometría y orden.

## Capturas sin edición

Godot 4.7.2 Compatibility, Apple M4; ocho PNG 1672 × 941. Nativas sin interfaz; Web con controles.

| Estado | Perfil derecho | Perfil izquierdo |
| --- | --- | --- |
| Godot, mostrador visible | [Captura](godot_visible_0.png) | [Captura](godot_visible_1.png) |
| Godot, mostrador oculto | [Captura](godot_oculto_0.png) | [Captura](godot_oculto_1.png) |
| Web, mostrador visible | [Captura](web_visible_0.png) | [Captura](web_visible_1.png) |
| Web, mostrador oculto | [Captura](web_oculto_0.png) | [Captura](web_oculto_1.png) |

Ocultarlo revela el interior reconstruido, con la ropa inferior de la figurante; no queda el panel antiguo duplicado. Se conserva el resto del fondo mediante un parche limitado a 278 × 143.

## Comprobaciones y límites

tests/mostrador.gd necesita render gráfico: alfa presente, base y = 675 y orden correcto; el parche cambia 39 406 píxeles y conserva exactamente el render fuera del rectángulo. El recurso visible modifica más de 20 000 píxeles respecto al interior descubierto. Sota permanece por delante: 5919/5403 muestras en ambos perfiles, respetando el alfa casi opaco del atlas.

Pasan importación, escala/materiales/apoyos, escena técnica, oclusión GPU de barandillas en ocho combinaciones y exportación Web. La muestra x = 1254 se actualiza a 1162 píxeles tapados y 3031 visibles al cambiar el fondo de recepción; las demás conservan sus resultados.

Web por HTTP local: http://127.0.0.1:8766/godot/build/web/. agent-browser 0.39.0 y Helium/Chromium 154 en sesión headless aislada, WebGL 2.0. Ambos perfiles, botón Frente al mostrador y ocultar/mostrar comprobados por clic, sin errores de página/consola registrados. Se cierra la sesión automatizada y se abre la URL en Helium visible. Servidor activo al comprobar; verificarlo al retomar. Godot actualizado queda abierto.

El autor aprueba visualmente [T07.4](../recorrido_v1/README.md), destacando la trasera junto a la gente. Esta entrega nueva está pendiente de su valoración. Mostrador reconstruido con variaciones generativas; figurantes/equipo/interior aún aplanados. Sin movimiento, colisiones ni caso migrado; Safari/Firefox, accesibilidad y rendimiento no comprobados aquí. T07 continúa en curso; versiones y prompts anteriores conservados.

**Revisión actual:** [T07.6, recepción independiente](../recepcion_v1/README.md). Estas ocho capturas conservan T07.5; el mostrador sigue integrado con figurante/equipo separados y nuevo parche de interior.
