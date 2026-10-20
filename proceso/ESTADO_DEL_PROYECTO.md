# EL ARRECIFE · continuidad vigente

Actualizado: **20 de octubre de 2026**.

## Dirección del autor

**Reinicio completo** como aventura narrativa **2D ilustrada en primera persona**, desde los ojos de Sota. Clic/toque, vistas fijas, exploración, diálogo, deck, contratos y progresión. Duración objetivo de la primera aventura completa: unos 30 minutos. Los retratos originales marcan el estilo.

La orden actual sustituye las decisiones jugables anteriores. El único proyecto activo es **`game/project.godot`**, Godot 4.7.2. [Diseño vigente](../docs/GAME_DESIGN.md) y [dirección artística](../docs/ART_DIRECTION.md).

## Respaldo y preservación

Inspección inicial limpia en `main`, checkpoint previo ya publicado **433e099**. Se creó `backup/pre-reboot-20261020` y se trabajó en **`feat/interactive-arrecife-reboot`**. Las carpetas retiradas se trasladaron completas a `../el-arrecife-respaldos/pre-reboot-20261020-433e099/`. [Recuperación exacta](../docs/RECUPERACION.md), [manifiesto SHA256](../docs/PRESERVACION.json).

Canon intacto. Dos retratos originales ilustrados (Sota/Jefa) migrados sin alterar bytes; guardia, figurante y acompañante del acceso conservados como originales históricos pixel, no confundidos con retratos. Licencias/atribución conservadas. No existen `sources/` ni `universo/` en este checkout; no se ha certificado lectura de fuentes ausentes. Todo el historial y los prompts anteriores permanecen recuperables.

**El reinicio no se ha enviado al remoto.** Requiere autorización explícita para publicar esta limpieza.

## Entrega del asistente: hito 1

Menú, opciones, créditos, intro saltable, tres habitaciones y primer pasaje de La Fiebre. Hotspots por datos, observaciones, terminal, documentos paginados y leídos, diálogo con temas/elecciones/revisita, Sota izquierda/Jefa derecha y hablante iluminado. Deck con mensajes, contrato, archivo, noticias, contactos y lugares. Guardado v1, copia anterior, recuperación y nueva partida confirmada con respaldo fechado. Interacción de ratón y toque sobre la ilustración, puntos de luz discretos y lista de acciones a petición dentro de «Pistas».

Contrato **`retorno_agua`**: mensaje → aceptar → copiar lectura doméstica → contrastar con Jefa. El contrato permanece ACTIVE al terminar el contenido del hito. El Nudo y Los Puntales tienen IDs, rutas y condiciones, pero sus vistas no están construidas. Doce vistas registradas, cuatro construidas. No hay desenlace ni duración final comprobada.

Cuatro fondos candidatos generados con imagegen desde referencia de retrato, en `game/assets/backgrounds/candidates/`. PNG originales y prompts conservados; ninguna regeneración de retratos. Son imágenes aplanadas, sin aprobación artística ni fuentes por capas. Revisar luz exterior del dormitorio, continuidad arquitectónica y representación ambiental de la Jefa.

## Canon frente a propuesta

Cotas, jerarquía, tecnología física y límites de la Nómina proceden del canon. La residencia de Sota cerca de La Fiebre, su acreditación, el parte del agua, el encuentro y todos los diálogos nuevos son **propuestas de juego pendientes de aprobación**. La Jefa no se convierte en dueña ni recepcionista de Velvet. No se incluyen revelaciones principales de las novelas ni se modifica el canon literario.

## Resultados probados

Importación y arranque correctos. **162 comprobaciones headless y 181 nativas con GPU, cero fallos**, incluidas 19 capturas reales. Integridad de canon, cinco originales y dos copias; una única implementación sin dependencia 3D. Web exportada y comprobada en Helium/WebGL 2: clic, toque sintético, contrato y recuperación de ubicación/progreso después de recargar. Cuatro tamaños de viewport nativo, incluido vertical. Tras la corrección de indicadores, se verificaron además la pulsación directa en vertical, el panel «Pistas» y un toque Web sobre la puerta a 844×390.

[Resultados, evidencias y límites](../docs/VALIDACION.md). No se han probado móviles físicos, Safari/iOS, Windows ni Linux. El navegador depende de su almacenamiento local. No hay música ni efectos finales; los buses están preparados. Las pruebas técnicas no constituyen aprobación artística.

## Siguiente trabajo

Revisión del autor sobre la propuesta narrativa y los cuatro fondos. Completar La Fiebre y El Nudo con una comprobación técnica y consecuencias, después Puntales y el final. Producir capas y sonido, revisar ritmo y validar dispositivos reales. [Tareas completas](../task.md).

## Historial breve

- **20 oct 2026 · decisión del autor:** abandonar la implementación anterior y construir una aventura ilustrada en primera persona, con misiones, contratos y progresión.
- **20 oct 2026 · entrega del asistente:** retiro recuperable, proyecto único, hito 1 jugable y pruebas descritas arriba. **Pendiente de revisión narrativa y artística por el autor.**
- **20 oct 2026 · corrección solicitada por el autor:** retirar los rótulos y botones grandes sobre los objetos, con prioridad móvil. **Entrega del asistente:** puntos pequeños, toque directo sobre la imagen y acciones nombradas sólo al abrir «Pistas». Verificación técnica y visual realizada; el autor aún no ha aprobado esta presentación.

El historial de las etapas anteriores está íntegro en la rama de respaldo y la copia local; no describe la producción actual.
