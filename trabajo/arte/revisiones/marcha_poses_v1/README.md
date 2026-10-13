# T05.1 · Revisión de poses de marcha

**RECHAZADA por el autor el 13 de octubre:** movimiento y reposo no se parecen; la marcha es más clara que v7. Se retira Pasos en prueba del juego. Este documento y sus capturas/prompts se conservan como archivo de la propuesta, no instrucciones vigentes. La corrección está en `caminar_v2` / `marcha_identidad_v2`.

13 de octubre de 2026. Entrega del asistente: **16 poses clave**, ocho por perfil, con prueba opcional de marcha en Godot/Web. Autor ha aprobado v7 y altura de reposo 252; estos nuevos dibujos y la animación quedan pendientes de su valoración. [Originales, ocho prompts e intentos](../../personajes/sota/caminar_v1/README.md).

## Cómo probar

Abrir [recorrido local](http://127.0.0.1:8766/godot/build/web/) mientras esté activo el servidor de esta sesión, recargar y activar **Pasos en prueba**. Caminar con A/D, flechas o clic. La secuencia avanza con la distancia recorrida; al parar vuelve a v7. Desactivar la casilla restaura el recorrido con referencia estática. F5 en Godot abre la misma prueba. Revisión visual conserva los controles de arte anteriores.

| Captura | Contenido |
| --- | --- |
| [Lámina derecha](lamina_derecha.png) | Ocho poses a escala común y referencia de reposo v7 a 252. |
| [Lámina izquierda](lamina_izquierda.png) | Selección real de siete poses v3 más cruce B v4, y reposo v7. |
| [Velvet derecha](velvet_derecha.png), [Velvet izquierda](velvet_izquierda.png) | Cruce A en escena, pies y = 705, planos/barandillas conservados. |

Láminas renderizadas en Godot a 1672 × 984; escenas a 1672 × 941. Los PNG de arte permanecen intactos; las láminas son capturas del montaje mediante AtlasTexture.

## Comprobaciones

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script tests/marcha.gd
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script tests/marcha.gd -- --capturas
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script tests/movimiento.gd
```

Pasan 16 poses/marcos/pivote/escala comunes, alfa, recortes de atlas sin amputar botas, margen completo, ocho fases por distancia, ambos sentidos sin reflejos, y retorno al atlas/shader v7 al detenerse/desactivar prueba. GPU Compatibility Apple M4 renderiza láminas y escenas. El controlador anterior sigue pasando aceleración/frenada, siete llegadas, límites, colisión, foco y Mayús sin correr. Importación/exportación Web correctas. La prueba no acredita perfección de anatomía ni pies sin deslizamiento.

**Pendiente:** intermedios, tiempos/zancada y apoyos del ciclo, pequeñas variaciones generativas, cierre caminar-parar e iluminación espacial. Ocho poses clave son un primer pase, no la marcha final. La prueba arranca desactivada para conservar la referencia aprobada. Safari/Firefox/móvil no validados en esta entrega.

**Web comprobada:** Helium/Chromium WebGL 2.0, canvas 1672 × 941. Arranque con v7 y opción desactivada, activación por clic, dos poses derechas sucesivas, movimiento izquierdo, vuelta a v7 al soltar tecla y consola sin errores. [Derecha A](web_derecha_a.png), [derecha B](web_derecha_b.png), [reposo](web_reposo.png), [izquierda](web_izquierda.png). No se grabó vídeo ni se validó fluidez final.

**Encuadre pendiente de T05.2:** la zancada propuesta ocupa más ancho que el reposo; cerca del límite derecho del recorrido una bota puede salir del encuadre. El margen común evita cortes en el atlas, no resuelve este límite de escena. Revisar zancada, llegada/extremos y dibujo antes de activar la propuesta por defecto.
