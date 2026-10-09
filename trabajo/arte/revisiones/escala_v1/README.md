# Velvet · Escala y apoyo de Sota v1

**Versión histórica:** el 10 de octubre el autor aprueba el aspecto en escena y descarta frontal/tres cuartos. La escena actual ofrece solo perfiles; [revisión vigente](../escala_v2/README.md). Se conservan estas capturas y comprobaciones de la primera entrega.

9 de octubre de 2026. Entrega T02 para revisión del autor. Se utiliza [Velvet aprobado](../../../../godot/assets/fiebre_velvet_v1.png) y la [referencia de Sota v3](../../personajes/sota/README.md), sin alterar esos PNG.

## Propuesta del asistente

- Resolución de composición: **1672 × 941**, igual al fondo original. Ventana inicial 1280 × 720 con aspecto conservado; el reescalado no deforma el escenario.
- Sota: **252 píxeles de altura** dentro de esa composición. Coincide aproximadamente con la extensión vertical de Sota en Fiebre v8. Las alternativas de 232 y 272 quedan disponibles para comparar; la cifra propuesta aún no es una aprobación del autor.
- Suelo: base en **y = 710**, centro inicial en x = 780; prueba junto a la recepción en x = 1160. Es la franja del primer tramo; no es un mapa de colisiones ni resuelve otras cotas.
- Filtrado inicial lineal («Suave») para conservar el acabado fino; opción nearest («Nítido») disponible en la revisión.
- Las cuatro vistas se recortan usando los límites medidos y se normalizan a la misma altura. Cada recorte tiene su base en el origen de apoyo. No se refleja ninguna vista.
- Un shader de dibujo descarta alfa menor que 0,1 para evitar el residuo transparente periférico; el archivo original sigue intacto. Esto resuelve ese ruido al renderizar, no sustituye una revisión fina del color de los bordes.

## Abrir y comparar

Desde la raíz del proyecto:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot
```

La escena principal ahora es [revision_escala.tscn](../../../../godot/revision_escala.tscn). Los botones permiten elegir las cuatro vistas, tres alturas, galería/recepción y filtro; foco inicial en Perfil derecho y navegación mediante Tab/Enter. Es una escena de revisión estática, sin desplazamiento ni diálogos. La antigua escena técnica se conserva como `verificacion.tscn`.

Exportación local de esta sesión: `http://127.0.0.1:8766/godot/build/web/`. No es un enlace público ni se garantiza que el servidor siga activo al retomar. Para regenerarla, seguir [godot/README.md](../../../../godot/README.md).

## Evidencia

Capturas obtenidas del viewport nativo de Godot Compatibility en Apple M4, no composiciones del generador:

| Comparación | Captura |
| --- | --- |
| Perfil derecho, 252 | [vista_0.png](vista_0.png) |
| Perfil izquierdo, 252 | [vista_1.png](vista_1.png) |
| Frente, 252 | [vista_2.png](vista_2.png) |
| Tres cuartos, 252 | [vista_3.png](vista_3.png) |
| Altura 232 | [altura_0.png](altura_0.png) |
| Altura 252 | [altura_1.png](altura_1.png) |
| Altura 272 | [altura_2.png](altura_2.png) |

Revisión visual del asistente: misma franja de suelo en las cuatro orientaciones; el deck queda visible a la derecha anatómica y oculto en el perfil contrario; el tamaño propuesto mantiene una presencia próxima a la referencia v8. Las alturas pequeñas reducen su presencia y la grande la aumenta; no se elige un nuevo tamaño para toda la figuración.

Comprobaciones: importación correcta; `tests/escala.gd` pasa las cuatro vistas y las tres alturas, recortes dentro del atlas, apoyo estable, ausencia de reflejo horizontal y cambio de filtros. `tests/verificacion.gd` sigue pasando. Exportación Web termina con código 0 y servidor HTTP devuelve 200. El paquete excluye `build/*` para evitar incorporar sus propias salidas.

**Límite:** no se ha probado visualmente esta exportación en navegador: el control nativo de Safari y Helium devolvió `cgWindowNotFound` (-10005). No es un fallo observado del juego. Pendientes valoración del autor, navegador, revisión fina de bordes/luz y cámara en diferentes tamaños. El fondo sigue aplanado; capas, oclusiones, sombra de contacto definitiva, animaciones y control corresponden a las tareas siguientes. T02 queda Entregada.
