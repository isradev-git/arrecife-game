# Sota · corrección integral del modelo y las transiciones

15 de octubre de 2026. El autor pide analizar el desarrollo y resolver como prioridad el movimiento de Sota, con libertad creativa y técnica. Se revisan continuidad, referencia v7, claves aisladas, código, pruebas y capturas del Modelo 8 activo. La nueva entrega se integra como **Modelo 10**, atlas `articulada_v7`. Es una entrega del asistente comprobada técnicamente y revisada en imágenes; **no una aprobación artística del autor ni una certificación de acabado profesional**.

## Diagnóstico y solución

1. Las mallas recortadas de la hoja aplanada solo contenían la parte visible de algunas piernas. Al separarlas, faltaba tela; no bastaba con comprobar el centro de las uniones. Se construyen superficies completas por filas, con anchura definida para muslo, pantorrilla y puño, conservando la deformación continua y los apoyos existentes.
2. La pelvis dependía del solapamiento de los muslos y del torso. Ahora tiene una superficie común, cubierta por la pierna cercana y el equipo. Se reconstruye con tela de v7; no hay una imagen nueva por fotograma.
3. La interpolación de textura entre cintura y bolsillo atravesaba las manos pintadas en v7. Se separan las islas UV de cintura y muslo, y se escoge tela opaca para la pierna izquierda. Los primeros renders detectaron piel y un hueco de rodilla; se corrigieron antes de preparar el atlas integrado.
4. El controlador reiniciaba fase y distancia al reanudar una parada. Ahora conserva fase y amplitud, y comparte los niveles de transición para arrancar, parar y retomar. El fotograma consultado corresponde al que realmente se muestra, también durante respiración.

Se conservan cabeza, tronco, brazos, manos, equipo, perfiles propios, colores de v7, altura 252, velocidad 104, ciclo 128 y geometría/raíces de botas. Los antiguos atlas y prompts permanecen intactos. `articulacion_antes.gd.txt` y `controlador_antes.gd.txt` permiten reproducir el estado previo. No se generó arte con IA en esta revisión.

La libertad técnica de la petición actual permite integrar la corrección completa de ambos perfiles. El intento anterior de cuatro claves aisladas queda conservado como alternativa histórica; no se presenta como terminado ni aprobado.

## Comparación y reproducción

- [Antes: reposo y cuatro claves por perfil](antes.png).
- [Después: misma comparación a escala 1×](despues.png).
- [Modelo 10 en Web, reposo](web_reposo.png), [marcha izquierda capturada de la grabación](web_marcha_20.png), [parada izquierda](web_izquierda.png).
- [Grabación real de la prueba Web](prueba_web.webm): 26,667 s, incluye espera inicial y secuencia D/pausa/D/parada/A/pausa/A/parada. La grabación está codificada a 60 fps; no es un benchmark del navegador.
- Veinte capturas nativas `derecha_*` / `izquierda_*`; seis hojas de cobertura y seis de planos. `inspeccionar_uv.gd` es un diagnóstico de las zonas opacas de la fuente.

Desde la raíz del proyecto, con el ejecutable instalado en este equipo:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path godot --script res://tests/silueta_sota.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/integridad_sota.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script res://tests/reanudar_sota.gd
```

Los tres admiten `-- --antes` para reproducir los fallos anteriores. `silueta_sota.gd` necesita GPU; los otros dos pueden ejecutarse sin ventana. Las láminas antes/después se vuelven a escribir al ejecutar esa prueba.

| Comprobación | Modelo 8 anterior | Modelo 10 |
| --- | --- | --- |
| Secciones de pierna por debajo del mínimo 18 px muslo / 14 px pantorrilla | 95 / 768 | 0 / 768 |
| Poses con un fragmento separado de al menos 8 píxeles | 56 / 338; fragmento máximo 94 px | 0 / 338; fragmento máximo 1 px |
| Reinicios de fase al interrumpir una parada | 192 / 192 | 0 / 192 |
| Cobertura de cintura, rodillas y botas; piel incrustada | — | 328 renders pasan |
| Paleta, alfa y cabeza | — | 3.720.213 píxeles opacos con colores exactos de v7; alfa binaria y cabeza estable |
| Orden de piernas y botas | — | 76.874 cruces opacos GPU correctos |
| Fin de cierre → reposo | — | 0 cambios de dibujo en 64 cierres |
| Marcha a 30/60 Hz | — | 0 congelaciones / 0 salto añadido de raíz; deriva de puntera 2,400–3,467 px |

También pasan controles, frenada, inversión, siete destinos, límites, colisión física, pérdida de foco, movimiento reducido y pruebas de recortes. Importación y exportación Web release completadas. Helium/Chromium WebGL 2.0 carga Modelo 10; se envía la secuencia de teclado al canvas, se comprueba cambio de posición/perfil y retorno a reposo. Consola sin errores de página registrados. Logs conservados en esta carpeta.

## Estado del juego y pendientes

El caso de investigación completo sigue en el prototipo JavaScript v0.2.0. Godot tiene el recorrido de Velvet, escala, capas, personajes y control; la migración narrativa, diálogos, viaje entre cotas, guardado, audio y publicación siguen pendientes. T10 no se abre durante esta revisión.

T05 permanece abierta para valoración visual del Modelo 10. La reconstrucción reutiliza tela de v7: puede requerir ajustar pliegues, bolsillo y contorno de pelvis al revisar la animación. Los controles de anchura/conectividad no evalúan toda la anatomía ni garantizan por sí solos un acabado profesional. Persisten la cuantización a 32 fases y cuatro niveles intermedios; la deriva de apoyo medida no es cero. Safari, Firefox, móvil y rendimiento sostenido no se han probado en esta entrega.
