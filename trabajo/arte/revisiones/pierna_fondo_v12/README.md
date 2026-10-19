# Sota · flexión de la pierna del fondo · Modelo 12

15 de octubre de 2026. El autor acepta continuar con la izquierda reflejada y aporta tres capturas: la pierna del fondo se ve demasiado recta, se distingue poco de la cercana y no dobla correctamente. Se conservan como `autor_reposo.png`, `autor_derecha.png` y `autor_izquierda.png`. Posteriormente pide continuar la corrección.

## Causa y cambio

La cadena de la pierna lejana derecha estaba configurada con dos tramos efectivos de 56 px, igual que la cercana. Sin embargo, la posición de su cadera y la caña más corta de su bota exigen alcances de hasta 117 px. El cálculo saturaba en 111,9 px y dejaba la rodilla casi recta en 24 de las 32 fases; la cercana solo lo hacía en cuatro.

Se calibran los dos tramos efectivos de esa pierna a 60 px. El cálculo de rodilla ahora puede alcanzar los mismos apoyos con flexión. No se desplazan ni se separan artificialmente las botas: la separación visible mejora al avanzar la rodilla y formar la curva del pantalón. La pierna cercana, cabeza, cuerpo, brazos, manos y las trayectorias/rotaciones de ambas botas conservan sus transformaciones. Reposo sigue idéntico porque el ajuste se mezcla progresivamente con la pose neutral.

El cambio se hace en `sota_articulada.gd`; todos los fotogramas se vuelven a preparar en **`articulada_v8`**. El controlador conserva la izquierda reflejada del derecho, de modo que la corrección aparece en ambos sentidos. Modelo 11/atlas v7, fuentes y prompts anteriores intactos; código anterior guardado en `articulacion_antes.gd.txt`. No se generan imágenes con IA ni prompts nuevos.

## Evidencia

[Comparación antes/después](comparacion.png): primera fila cuerpo anterior, segunda cuerpo corregido; tercera pierna del fondo anterior aislada, cuarta corregida. Ocho fases equidistantes, mismo tamaño y posiciones de pies. `medir.gd` conserva el diagnóstico numérico.

| Prueba | Resultado |
| --- | --- |
| `flexion_sota.gd -- --antes` | Código 1: 24/32 fases con rodilla del fondo <5°; flexión máxima 40,86° |
| `flexion_sota.gd` | Código 0: 0/32 fases <5°; máximo 58,00° frente a 56,33° de la cercana; botas y rodilla cercana sin cambios |
| Cobertura del modelo | 328 renders pasan cintura, rodillas y unión con botas; sin piel en ropa |
| Integridad de atlas | 338 poses sin fragmentos separados ≥8 px; mayor fragmento 1 px |
| Reflejo | 169 parejas GPU exactas píxel a píxel |
| Marcha | 0 congelaciones / 0 salto extra de raíz a 30/60 Hz; deriva de puntera 2,400–3,467 px |
| Atlas y control de animación | Paleta v7 exacta, alfa binaria, cabeza estable, escala fija, cierre, movimiento reducido y límites pasan |
| Importación/exportación | Release Web completada; rótulo Modelo 12 |

Helium/Chromium carga Modelo 12 y muestra marcha a derecha e izquierda; capturas `web_derecha.png` / `web_izquierda.png` y consola conservadas, sin errores de página registrados.

Capturas nativas `derecha_*` y `izquierda_*` muestran marcha y parada; hojas de cobertura y logs conservados. Las medidas de flexión evalúan el esqueleto, y las comprobaciones de cobertura/conectividad evalúan defectos concretos: no certifican toda la calidad artística. La valoración de naturalidad del nuevo resultado sigue pendiente del autor.

No se han repetido Safari, Firefox, móvil ni rendimiento sostenido. T05 permanece como prioridad; no se avanza en diálogos ni se cambia el canon.
