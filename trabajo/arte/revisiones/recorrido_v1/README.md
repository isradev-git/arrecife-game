# Velvet · Barandillas del recorrido T07.4

11 de octubre de 2026. Se extiende el borde delantero a todo el ancho visible de la escena, conservando la geometría de [T07.3 valorada positivamente](../profundidad_v1/README.md): pies de Sota y = 705, borde trasero y = 675 y delantero y = 735. Orden fijo z = −5 / 0 / +5.

## Montaje

Se reutilizan [barandilla y prompt](../../entornos/velvet/capas_v1/README.md) y [fondo horizontal y variantes](../../entornos/velvet/suelo_v1/README.md), sin editar ni generar PNG de arte. El tramo central delantero conserva posición/escala; cinco sprites hijos extienden sus lados, heredando escala, filtro, orden y visibilidad. Paso entre módulos: 754 píxeles del atlas, distancia entre postes extremos medida en el alfa del recurso. Los remates sobresalientes se solapan para cerrar también los largueros intermedios e inferiores. La cámara recorta lo que queda fuera de x = 0–1672.

La barandilla trasera conserva el tramo central x = 450–935 sobre el hueco de ciudad. No se coloca otra delante de las fachadas o el mostrador: esos planos quedan al fondo y los accesos se mantienen despejados. La barandilla delantera protege el borde abierto de toda la pasarela; no cruza el centro donde se coloca Sota.

Botones de revisión: Galería (x = 780), Recepción (1160), Personal (160) y Extremo (1500). No son desplazamiento ni navegación jugable.

## Capturas sin edición

Godot 4.7.2 Compatibility, Apple M4; todas 1672 × 941. Nativas sin interfaz para revisar composición; Web con controles visibles.

| Ubicación | Godot nativo | Navegador |
| --- | --- | --- |
| Galería, perfil derecho | [Captura](godot_galeria.png) | [Captura](web_galeria.png) |
| Recepción, perfil izquierdo | [Captura](godot_recepcion.png) | [Captura](web_recepcion.png) |
| Personal, perfil derecho | [Captura](godot_personal.png) | [Captura](web_personal.png) |
| Extremo, perfil izquierdo | [Captura](godot_extremo.png) | [Captura](web_extremo.png) |

[Solo trasera desde el extremo](web_trasera_extremo.png): ocultar la delantera retira todos sus módulos.

## Comprobaciones

- Importación y exportación Web terminan con código 0; escena técnica correcta.
- Escala/materiales, centro equidistante y suelas estables en seis x; bases de todos los módulos en y = 735, cobertura de todo el ancho y visibilidad conjunta correctas.
- Máscara de metal continua en los 1672 píxeles de dos filas de larguero, y = 649 y 703.
- Render GPU de ocho combinaciones de posición/perfil, incluidas uniones y extremos: metal delantero opaco, aberturas visibles y orden trasero correcto donde se solapa con Sota.

| x | Perfil | Píxeles cubiertos por metal | Visibles en aberturas |
| --- | --- | --- | --- |
| 160 | Derecho | 1168 | 3032 |
| 450 | Izquierdo | 1040 | 2781 |
| 780 | Derecho | 1167 | 3036 |
| 780 | Izquierdo | 1045 | 2778 |
| 935 | Derecho | 1303 | 2901 |
| 1160 | Izquierdo | 1044 | 2779 |
| 1254 | Derecho | 1163 | 3038 |
| 1500 | Izquierdo | 2069 | 1754 |

Web por HTTP local: http://127.0.0.1:8766/godot/build/web/. agent-browser 0.39.0 y Helium/Chromium 154 en sesión headless aislada, WebGL 2.0. Cuatro ubicaciones, ambos perfiles y ocultación de todas las extensiones observados mediante clic; sin errores de página/consola registrados. Se cierra la sesión automatizada y se abre la URL en Helium visible. Servidor local activo al comprobar; verificarlo al retomar. Godot nativo actualizado queda abierto.

Entrega revisada por el asistente y **aprobada visualmente después por el autor**: «me encanta como está quedando» y «la trasera queda bien junto a la gente». T07 sigue en curso. Se repite el desgaste y contraluz del recurso actual: variar acabados y responder a luces espaciales sigue pendiente. Fachadas, mostrador, figurantes, ciudad y humo permanecen aplanados; no hay colisiones, movimiento ni caso migrado. Safari/Firefox, accesibilidad y rendimiento no comprobados en esta entrega. Versiones y prompts anteriores conservados.

Continuación: [mostrador independiente T07.5](../mostrador_v1/README.md), conservando la geometría de estas barandillas.
