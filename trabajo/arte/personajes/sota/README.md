# Sota · Referencia de producción

**Entrega vigente · 11 de octubre:** el autor rechaza el primer pase pixel art por cara demasiado definida y píxel fino. [Nueva propuesta de píxel intenso](pixel_v2/README.md), integrada en la [comparación Godot](../../revisiones/escala_v4/README.md). Dos perfiles propios, transparencia y apoyos comprobados; pendiente valoración del autor. Las aprobaciones descritas debajo corresponden al diseño y a la iteración anterior.

**Decisión vigente · 10 de octubre:** el autor aprueba cómo queda en Velvet y elige solo los perfiles derecho e izquierdo. Frontal y tres cuartos se conservan en el atlas por historial, pero no se muestran en Godot ni se producirán sus animaciones. El reposo, la respiración y las conversaciones serán de perfil. [Revisión vigente](../../revisiones/escala_v2/README.md). Las secciones siguientes documentan la entrega original.

**Cambio de acabado · 10 de octubre:** el autor pide recursos más pixel art y cercanos a REPLACED. T03 debe producir nuevas versiones de ambos perfiles, conservando identidad, vestuario y lado físico del equipo, para revisarlas en T02. La referencia v3 y las capturas actuales son la base anterior, no el acabado final de este pase. Conservar imágenes y prompts; aplicar la [dirección artística vigente](../../../direccion_artistica.md).

9 de octubre de 2026. Primera entrega de T03, adelantada por la petición del autor de continuar generando recursos. **Entregada, pendiente de revisión estética, bordes y comprobación de escala T02.** No sustituye las animaciones del prototipo.

Referencia entregada: [referencia_v3.png](../../../../godot/assets/personajes/sota/referencia_v3.png), importable en Godot. Cuatro vistas: perfil derecho, perfil izquierdo, frente y tres cuartos derecho. La izquierda es una vista propia: el deck queda en la cadera derecha, al otro lado del cuerpo. El parche de la manga y la mecha gris siguen el lado físico del personaje.

Autoridad visual: [Fiebre v8 aprobada](../../conceptos/fiebre_v8/fiebre_escena_v8.png) y [reposo anterior](../../../../juego/assets/sota_reposo_v2.png). Se utilizó imagegen integrado, con fondo transparente. No cambia la identidad aprobada de Sota ni el canon.

## Versiones conservadas

| Versión | Imagen y prompt | Resultado |
| --- | --- | --- |
| v1 | [Imagen](referencia_v1.png), [prompt](prompt_referencia_v1.txt) | Cuatro vistas; mecha y pieza plateada repetidas indebidamente en perfil izquierdo. |
| v2 | [Imagen](referencia_v2.png), [prompt](prompt_referencia_v2.txt) | Corrige la izquierda, pero elimina también el detalle de tres cuartos. |
| v3 | [Imagen entregada](../../../../godot/assets/personajes/sota/referencia_v3.png), [prompt](prompt_referencia_v3.txt) | Recupera el detalle en tres cuartos. Revisión visual del asistente; sin aprobación del autor todavía. |

Originales en `/Users/glitchbane/.codex/generated_images/01a12073-55ef-7ed1-8a16-ad74d5324000/`: v1 `exec-8fd62f68-28f0-4203-83a8-fa7e6758f3e5.png`, v2 `exec-f9bae43d-9fc1-4eed-948f-5f78a10ee0b4.png`, v3 `exec-80fa19b3-45a3-4c77-8ce9-9fc0d7dd2c6c.png`.

## Medidas y límites reales

El resultado mide **1254 × 1254**, aunque el primer prompt solicitaba 2048 × 2048. Cuadrícula 2 × 2, celdas de 627 × 627. [Regiones, límites y pivotes provisionales](../../../../godot/assets/personajes/sota/referencia_v3.json) medidos con `Image` de Godot.

La transparencia es real. La comprobación de las cuatro siluetas al umbral alfa 0,1 pasa, sin cortes. Una comprobación inicial del alfa bruto detectó píxeles de transparencia residual extendidos fuera de las siluetas; no se oculta ese resultado. Hay que revisar y limpiar los bordes a escala de juego antes de tratarla como sprite final.

Las alturas medidas son 580, 581, 594 y 590 píxeles; las bases locales son 613, 613, 601 y 601. No utilizar una base idéntica para todas las celdas ni reproducirlas como ciclo de animación. Los pivotes del JSON son centros iniciales de la silueta, no un ajuste final de locomoción.

Pendiente: revisar escala junto a personas y mobiliario de Velvet, ajustar apoyo al suelo, acabado de bordes y coherencia fina de cara/manos/ropa entre vistas. Las ediciones generativas introducen pequeñas variaciones; no se afirma conservación píxel a píxel. La referencia es estática y no acredita caminar, correr o giros terminados.

## Integración posterior en T02

[Revisión en Velvet](../../revisiones/escala_v1/README.md): recortes y altura normalizados por vista, apoyo estable a y = 710 y shader que descarta alfa residual menor que 0,1 al dibujar. El PNG no se modifica. Esto reduce el ruido periférico en la escena; la revisión fina de bordes, rostro y ropa sigue pendiente, igual que la valoración del autor.
