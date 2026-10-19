# Sota · cambiar el método de animación

17 de octubre de 2026. **El autor rechaza el resultado de IK 15:** el movimiento continúa robótico y antinatural. La corrección matemática no ha cumplido el objetivo visual. Esta entrega investiga alternativas y deja una prueba reproducible con referencia humana; **no contiene una nueva Sota terminada**.

## Decisión de trabajo propuesta

**Animación por poses completas, guiada por movimiento humano y terminada manualmente en pixel art.** Conservar v7 como diseño, no como un conjunto de piezas que deban soportar cualquier postura mediante deformación.

No seguir produciendo atlas completos a partir de nuevas curvas de rodilla. No generar imágenes independientes de cada fase. La aprobación pendiente debe valorar el gesto completo y después el acabado de Sota; medir segmentos y cobertura solo sirve para detectar errores concretos.

La candidata IK 15 no generaba nuevos personajes mediante IA: usaba el dibujo existente con deformación geométrica. Por tanto, quitar la generación de imágenes por sí solo no resuelve el problema. Mi valoración es que el método actual da demasiado control a las fórmulas y demasiado poco al diseño del gesto, al ritmo y al redibujo de las zonas que cambian de forma.

## Opciones investigadas

| Opción | Qué aporta | Qué falta / coste | Valoración para Sota |
|---|---|---|---|
| Referencia humana + dibujo por fotogramas | Peso, coordinación y ritmo observables; control directo de silueta, pliegues y píxel | Elegir el gesto, adaptar proporciones/cadencia y dibujar las poses e intermedios | **Ruta recomendada** para mantener el acabado aprobado |
| Modelo 3D de Sota + animación + render lateral y limpieza pixel art | Anatomía volumétrica y ocultaciones coherentes; dos lados físicos del deck | Modelar/vestir/riggear a Sota y resolver materiales, iluminación y limpieza; un filtro pixelado no reproduce v7 automáticamente | Alternativa sólida si el dibujo por poses resulta demasiado costoso |
| Rig 2D con piezas redibujadas, deformaciones y reemplazos por pose | Reutilización y edición de curvas; sustitución de rodillas/manos/ropa en poses difíciles | Crear superficies ocultas, deformaciones correctivas y claves de animador; cambiar de herramienta no garantiza naturalidad | Útil, pero no elegiría otra ronda del mismo recorte deformable como solución inmediata |

Fuentes primarias de las herramientas: [Aseprite, animación](https://www.aseprite.org/docs/animation/), [onion skin](https://www.aseprite.org/docs/onion-skinning/), [Blender, animación y rigging](https://www.blender.org/features/animation/), [Spine, claves y deformación](https://eu.esotericsoftware.com/spine-keys), [Spine, pesos](https://eu.esotericsoftware.com/spine-weights). Las preferencias de la tabla son juicio de producción para este proyecto; no una garantía del resultado ni una afirmación sobre cómo se produjo REPLACED.

En `/Applications` se ha encontrado Godot; no Blender, Aseprite ni Spine. No se ha comprado ni instalado ninguna herramienta o dependencia. La prueba utiliza Python estándar y Canvas del navegador.

## Prueba disponible ahora

[Abrir comparación animada local](http://127.0.0.1:8766/trabajo/arte/revisiones/ruta_animacion_humana_v1/).

Tres paneles:

1. Sota v7 original, estática, como objetivo visual.
2. IK 15 real, etiquetada como rechazada.
3. Maniquí de referencia con una captura humana normal o lenta.

Se puede pausar, ralentizar, avanzar una muestra y mostrar articulaciones. El maniquí es una guía de movimiento, no un rediseño del personaje. El vestuario final no se ha aplicado. La referencia conserva el tiempo y las proporciones de la persona capturada; no se ha forzado al ciclo de 128 px. **No es una comparación a velocidad idéntica ni un candidato listo para integrar.** El reinicio de la toma está marcado porque todavía no se ha montado un bucle.

La referencia se proyecta lateralmente según la dirección de avance. Se elimina el desplazamiento horizontal global de la figura y se representa con las marcas del suelo; la altura y las rotaciones proceden de la captura. Una escala constante por toma aproxima la figura a 252 px. No hay IK nuevo, suavizado de poses, espejado del personaje, corrección artificial de apoyos ni síntesis de movimiento.

## Fuente humana y trazabilidad

[CMU Graphics Lab Motion Capture Database](http://mocap.cs.cmu.edu/), sujeto 07:

- [Esqueleto 07.asf](http://mocap.cs.cmu.edu/subjects/07/07.asf).
- [07_01.amc, caminar](http://mocap.cs.cmu.edu/subjects/07/07_01.amc): 316 muestras, 120 Hz, 2,633 s.
- [07_04.amc, caminar despacio](http://mocap.cs.cmu.edu/subjects/07/07_04.amc): 449 muestras, 120 Hz, 3,742 s.
- [Índice oficial](http://mocap.cs.cmu.edu/search.php?subjectnumber=7).

Copias originales en `referencia_cmu/`, junto al índice y las condiciones consultadas el 17 de octubre. La página del proveedor permite incorporar los datos a productos comerciales y prohíbe revender directamente la captura, incluso convertida. Aquí se utiliza como referencia de producción, fuera de los recursos exportados del juego.

Crédito: datos obtenidos de mocap.cs.cmu.edu; base creada con financiación NSF EIA-0196217.

`preparar_referencia.py` convierte las rotaciones locales ASF/AMC mediante cinemática directa y proyecta los puntos. No modifica los originales. Reproducir:

```sh
python3 trabajo/arte/revisiones/ruta_animacion_humana_v1/preparar_referencia.py
```

`captura.js` es el resultado; `index.html` reproduce la prueba y consulta el atlas existente en modo lectura. Si no está activo el servidor, desde la raíz del repositorio:

```sh
python3 -m http.server 8766
```

## Comprobaciones y alcance real

- 30 huesos y jerarquía completa; valores finitos en las 765 muestras.
- Longitudes 3D constantes, error máximo de conversión 0,00000228 unidades ASF. No equivale a una medida de anatomía ideal ni de calidad de animación.
- Referencias originales conservadas, sin modificar atlas, rig, controladores o escenas Godot.
- Comparación abierta en Helium: carga de v7, atlas y las dos capturas; pausa, paso, cámara lenta y articulaciones comprobados. Capturas locales guardadas.
- La figura de referencia no tiene el volumen de ropa de Sota. Sus extremos son marcadores/huesos, no una suela gráfica calibrada. No se certifica contacto de botas ni integración de esta captura en el juego.

## Continuación · ocho claves, 17 de octubre

El autor valora la nueva dirección como «muchísimo mejor». Se registra como valoración favorable de la referencia y del enfoque, **no como aprobación de un sprite de Sota nuevo**.

[Ver el ciclo seleccionado y ocho claves](http://127.0.0.1:8766/trabajo/arte/revisiones/ruta_animacion_humana_v1/claves.html). [Lámina](ocho_claves.png). [Coordenadas y trazabilidad](ocho_claves.json).

Se selecciona la toma lenta CMU 07_04, muestras 212–381, 170 muestras a 120 Hz. Las claves son 212, 233, 254, 276, 297, 318, 340 y 361; están espaciadas en octavos del ciclo y conservan posiciones capturadas, sin interpolación ni corrección del gesto. Son guías anatómicas completas; todavía no son dibujos de Sota. Se evita asignar nombres de contacto/apoyo precisos a muestras elegidas solo por porcentaje temporal.

Duración 1,417 s y avance de referencia 201,105 px a esta escala. Es una zancada mayor que el ciclo anterior de 128 px. La adaptación necesita decidir longitud de paso y cadencia conjuntamente, conservando la velocidad jugable mientras se evalúa el gesto. No se cambia ahora ninguna constante del juego ni se aprueba automáticamente una zancada de 201 px para Sota.

El cierre de la captura conserva diferencias entre pasos: error máximo de pose equivalente 5,621 px, salto entre última/primera muestra 5,615 px en las 15 articulaciones principales medidas. **No es un bucle final limpio.** La selección prioriza una referencia útil y trazable para dibujar; la captura original sigue disponible. El generador reproduce los ocho puntos de muestreo y comprueba orden y valores finitos.

La página y su pausa/cámara lenta se han comprobado en Helium; la lámina se ha inspeccionado. El juego y sus atlas siguen intactos. Pendiente: adaptación anatómica al diseño v7, dibujo del vestuario y preparación del bucle de Sota.

## Producción siguiente, con esta ruta

1. Seleccionar un ciclo de referencia y adaptar su ritmo al desplazamiento previsto. Comparar el resultado a escala de escena; decidir la relación entre longitud de paso y velocidad antes de retocar ropa.
2. Construir ocho poses clave completas de Sota sobre esa referencia: contacto, carga, cruce y elevación para cada paso. Revisar una animación de siluetas, no solo láminas estáticas.
3. Redibujar entrepierna/glúteo, rodillas, caña de botas, mangas, manos y bolsillo cuando cambie su forma. Conservar pelo, rostro mínimo, chaqueta, correa, deck, paleta y densidad de píxel de v7.
4. Añadir los intermedios que necesite el gesto y trabajar los dos perfiles propios. La cantidad de dibujos será consecuencia del movimiento, no un objetivo que sustituya su calidad.
5. Probar marcha, arranque, parada e inversión en Velvet. Mantener la versión anterior recuperable y no sustituirla hasta revisión del autor.

**Pendiente:** selección/adaptación del ciclo y dibujo de Sota. Esta prueba permite elegir una base de movimiento con evidencia, pero no resuelve todavía el acabado del personaje. No hay nueva aprobación artística.
