# Velvet · Mostrador independiente T07.5

11 de octubre de 2026. Tras aprobar el montaje de barandillas y destacar que la trasera queda bien junto a la gente, el autor autoriza continuar. Se separa el mostrador de recepción como objeto situado detrás del recorrido de Sota.

## Recursos y prompts

Herramienta integrada imagegen, dos ediciones desde el [fondo de suelo horizontal](../../../../../godot/assets/entornos/velvet/fondo_suelo_recto_v1.png), observando también la [referencia aprobada](../../../referencias/pixel_art_v1/velvet_estilo.png). PNG originales generados copiados sin retoque; versiones anteriores conservadas.

| Recurso guardado | Medidas | Prompt |
| --- | --- | --- |
| [mostrador_v1.png](../../../../../godot/assets/entornos/velvet/mostrador_v1.png) | 1671 × 941, transparencia RGBA; límites alfa ≥ 10 %: x = 575, y = 323, ancho 990, alto 445 | [Extracción](prompt_mostrador.txt) |
| [fondo_mostrador_reparado_v1.png](../../../../../godot/assets/entornos/velvet/fondo_mostrador_reparado_v1.png) | 1672 × 941, fondo sin mostrador, interior y ropa inferior reconstruidos | [Reconstrucción](prompt_fondo.txt) |

La herramienta genera el objeto ampliado en vez de mantener su posición solicitada. Godot recorta con AtlasTexture y lo coloca en x = 1210, y = 538, ancho 278, alto 137; base y = 675, borde trasero de pasarela. Filtrado nearest y el shader existente de metal opaco descartan residuos de alfa.

Solo se integra el parche reparado x = 1210–1488, y = 532–675. El margen superior cubre también el remate antiguo del mostrador. La escena restante usa el fondo anterior intacto. Edición generativa: el desgaste, paneles y papeles cambian; no es una extracción idéntica píxel a píxel. El fragmento de ropa de la figurante y los muebles interiores reconstruidos siguen aplanados.

## Planos y revisión

| Plano | Orden z |
| --- | --- |
| Fondo original | −20 |
| Parche de interior sin mostrador | −19 |
| Barandilla trasera | −5 |
| Mostrador independiente | −3 |
| Sota, pies y = 705 | 0 |
| Barandilla delantera, base y = 735 | +5 |

El mostrador queda detrás de Sota, pegado al borde posterior, sin invadir su línea central. Mostrarlo y ocultarlo no altera las barandillas ni el apoyo. Botón Frente al mostrador coloca a Sota en x = 1345 para revisar el solapamiento. No se implementa caminar, cambiar de plano ni interacción narrativa.

[Ocho capturas Godot/Web y comprobaciones](../../../revisiones/mostrador_v1/README.md). Recurso nuevo entregado por el asistente, pendiente de valoración del autor. Barandillas previas aprobadas visualmente; resto de objetos/figurantes, arquitectura, atmósfera, iluminación espacial y movimiento pendientes en T07 y tareas relacionadas.
