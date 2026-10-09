# Sota y ciudad en movimiento · v0.2

## Integración

Caminata y carrera tienen ocho fotogramas cada una. La velocidad aumenta y disminuye progresivamente, también al cambiar de dirección. El avance de la animación depende de la distancia recorrida; mantener Mayús, activar Correr o hacer doble clic inicia la carrera. No hay consumo de energía ni obstáculo narrativo asociado a correr.

Al descansar, Sota pasa de perfil a tres cuartos y al frente. F y el botón De frente detienen el desplazamiento y muestran el frontal directamente. Durante una conversación mantiene el perfil hacia su interlocutor. La respiración es una deformación vertical de solo ±0,4 %, acompañada de un desplazamiento lateral mínimo, anclada al suelo. No se introduce un salto del cuerpo entero.

La orientación frontal nunca se refleja, para conservar el deck en su cadera derecha. Los perfiles izquierdos todavía se resuelven reflejando los derechos: limitación pendiente de una hoja específica.

## Recursos y procedencia

Se usó la herramienta integrada de generación de imágenes, con alfa transparente. Referencias: `../assets/sota_hoja_v1.png` (identidad) y `../../trabajo/arte/conceptos/fiebre_v8/fiebre_escena_v8.png` (estilo aprobado). Las primeras hojas nuevas seguían repitiendo demasiado una pierna; se hicieron correcciones específicas sobre la mitad opuesta del ciclo. Se conservan ambas revisiones, aunque el juego solo carga las finales.

| Recurso final | Dimensiones | Prompt | Original generado |
| --- | --- | --- | --- |
| [Caminar v3](../assets/sota_caminar_v3.png) | 1536 × 1024; 4 × 2 | [Base](prompts/movimiento_v2/caminar_v2.txt), [corrección](prompts/movimiento_v2/caminar_v3_correccion.txt) | exec-c5961529-0e4b-4602-a847-979f68988964.png |
| [Correr v3](../assets/sota_correr_v3.png) | 1536 × 1024; 4 × 2 | [Base](prompts/movimiento_v2/correr_v2.txt), [corrección](prompts/movimiento_v2/correr_v3_correccion.txt) | exec-1b73e13a-f8d4-4ea3-b4ef-dbb8dc79c492.png |
| [Reposo y frente v2](../assets/sota_reposo_v2.png) | 1254 × 1254; 2 × 2 | [Prompt](prompts/movimiento_v2/reposo_v2.txt) | exec-774a8004-39c3-4661-847f-1c2830c1c10e.png |

Generaciones intermedias: `sota_caminar_v2.png` (exec-ac4305b6-d01b-475c-a63c-6ef7e9bf4e11.png) y `sota_correr_v2.png` (exec-f8c8a550-3637-410c-a960-f37feccfe619.png). Originales en `/Users/glitchbane/.codex/generated_images/01a11b94-741e-7701-a416-bc223e250454/`. Se conserva también la hoja v1.

Los recortes, centros de apoyo y escalas se ajustaron en `src/sprites.js` tras inspeccionar imágenes y límites del alfa. No se reescribieron los PNG. La hoja frontal contiene una segunda pose de respiración disponible; el juego utiliza el frontal estable con respiración procedural para evitar variaciones de silueta entre ambas poses.

## Movimiento ambiental

- La Fiebre: lluvia en el vacío de la ciudad, vapor, reflejos tenues, respiración de los neones, ventilador y peatones diminutos en una pasarela lejana.
- El Nudo: movimiento tras la ventana, dos ventiladores, vapor, humedad y luz tenue del terminal.
- Taller: actividad lejana en las pasarelas, vapor de infraestructura, reflejos y luz de trabajo.
- Casillero: ventilación y partículas escasas bajo la lámpara, sin lluvia dentro del local.

Son capas dibujadas sobre los fondos; no hay desplazamiento de cámara ni deformación global del escenario. Los efectos dejan libres los accesos y documentos. Se limita el refresco visual a 30 Hz, se suspende al ocultar la pestaña y se congela con la libreta. Reducir movimiento suprime ambiente, respiración y ciclo de poses.

## Valoración y prueba

La vista frontal aporta identidad y la carrera se diferencia de la caminata por postura, cadencia y velocidad. En Safari se comprobaron ambas formas de desplazarse y la llegada a interacciones; la nueva hoja frontal se integra en el escenario con alfa correcto. Trece pruebas automáticas pasan, incluidas las seis anteriores del caso.

La coherencia entre poses ha mejorado, pero no equivale a un ciclo dibujado y retocado fotograma a fotograma: persisten pequeñas variaciones de mangas, manos y proporciones. El reflejo del equipo al ir a la izquierda sigue pendiente. Los personajes principales pintados en los fondos permanecen inmóviles; la sensación de ciudad activa procede de infraestructura, atmósfera y tránsito lejano. No se ha medido rendimiento sostenido ni probado esta revisión en móvil u otros navegadores.
