# Diseño vigente · aventura ilustrada

## Experiencia

Primera persona desde Sota. Vistas fijas, exploración por clic/toque, conversaciones y decisiones breves. Objetivo de la primera entrega completa: unos 30 minutos, ampliables con nuevos contratos y localizaciones. El hito actual es una base jugable más corta; su duración no se ha medido con una sesión del autor.

Al arrancar: logo original «EL ARRECIFE PRODUCTS» suministrado por el autor → crédito del universo original de Israel Zamora → aviso de orientación → menú. Cada pantalla avanza sola tras una breve espera o al tocar «Continuar». En Web se marca al empezar la apertura en `sessionStorage`: recargar la misma pestaña va directamente al menú, mientras que una pestaña nueva muestra la secuencia. La carga del motor usa fondo neutro, sin otro logo. En móvil, la tercera espera a que la pantalla esté horizontal; si se vuelve a vertical durante el juego, un aviso cubre la interfaz hasta recuperar la orientación. El ordenador muestra «disfruta» y no se bloquea por la forma de su ventana. Los textos de crédito y orientación están en `story.json`; la imagen original del logo se conserva sin modificar.

La estructura propone una actividad concreta: comprobar un cargo de reparación de agua. El mundo aparece en recibos, lecturas, desplazamientos y conversaciones. No hay combate, avatar caminando ni cámara libre.

## Canon y propuesta

| Elemento | Situación |
| --- | --- |
| Cotas, Penumbra/Luz, ciudad acumulada y reparada | Canon: secciones 1–4 de `canon_el_arrecife.md` |
| La Fiebre (4), El Nudo (3), Los Puntales (2) | Denominación y temática canónicas; vistas concretas propuestas |
| Subida restringida, puertos físicos, decks externos | Canon; los permisos concretos de Sota son ficción de juego |
| Nómina, cuotas y fondo limitado | Canon, decisión D31. No autoridad universal ni refugio garantizado |
| Jefa como titular de Velvet | No se establece: su encuentro es en un pasaje adyacente |
| Sota protagonista y retratos originales | Decisión artística y de juego del autor |
| Vivienda de Sota cerca de La Fiebre, en la misma cota | **Propuesta no aprobada**, `cota_status: PROPUESTA`; cambiar junto con las rutas si el autor elige otra residencia |
| Contrato «El parte del agua», afectada, recibo, orden de visita y diálogos | **Ficción nueva pendiente de aprobación** |
| Deck de Sota: memoria local, mensajes, contratos y notas | Interfaz propuesta compatible con tecnología canónica; no teléfono mágico ni transporte |

No se incorporan tramas ni revelaciones de los protagonistas de las novelas. No se ha alterado el canon. `sources/`, `universo/` y los documentos literarios externos citados por el canon no existen en el checkout inspeccionado; esta entrega contrasta con el canon local disponible, no certifica revisión de fuentes ausentes.

## Mapa y alcance

| Zona | Vistas registradas | Construido |
| --- | --- | --- |
| Apartamento | Dormitorio, salón/cocina, baño | Las tres navegables |
| La Fiebre | Pasaje, umbral, encuentro | Pasaje y conversación con Jefa; otras dos vistas pendientes |
| El Nudo | Acceso, reparaciones, puesto de red | Identificadores y reglas; vistas pendientes |
| Los Puntales | Acceso estructural, taller, zona de trabajo | Identificadores y reglas; vistas pendientes |

Las puertas conectan habitaciones. La salida del apartamento se habilita al aceptar el contrato. Los trayectos entre cotas tienen rutas explícitas en `world.json`; bajar y subir se comprueban por separado. La residencia y la orden de visita justifican regresos concretos. El deck informa de los lugares y nunca permite saltarse estos accesos. Los destinos no construidos explican su estado sin cambiar de pantalla.

## Contrato principal

ID `retorno_agua`. Mensaje recibido → AVAILABLE → aceptación → ACTIVE → copia de lectura → contraste con Jefa → equipo en El Nudo (pendiente) → comprobación física en Puntales (pendiente) → READY_TO_COMPLETE → entrega explícita → COMPLETED.

Las fases futuras se prueban con datos sintéticos, pero **no se completan en el juego actual**. El hito termina mostrando el siguiente paso y conserva el contrato activo. El cierre narrativo, los honorarios concretos y una decisión con consecuencias finales se escribirán en otro hito.

## Interacciones

Hotspots con ID por pantalla, tipo, etiqueta, rectángulo normalizado, condición visible y disponible, y destino. El centro del rectángulo sitúa el punto de luz y un área pulsable fija de 56×56 unidades lógicas; el rectángulo completo no captura toques. El punto mide 9 unidades lógicas y no cubre la imagen con letras. «Pistas» abre, sólo a petición, la lista de acciones disponibles en la vista y permite ocultar los puntos. La ilustración se contiene completa en cada proporción.

La experiencia móvil sólo está disponible en horizontal. La nota de revisión de los fondos se mantiene en el menú y la documentación, fuera de la exploración.

- OBJECT: observación breve, sin diálogo modal.
- PERSON: diálogo con temas, condiciones, efectos, elecciones y salida.
- TERMINAL: menú de registros locales con arranque breve.
- DOCUMENT: visor de papel, páginas y lectura persistente.
- DEVICE: interfaz del deck.
- NAVIGATION: ruta y cambio de vista.
- SPECIAL_EVENT: acceso contextual; actualmente el límite de El Nudo.

En conversaciones, Sota izquierda e interlocutora derecha, mirando al centro con sus PNG originales. Sólo Sota en monólogos. Escena oscurecida, hablante iluminado y oyente atenuado. Texto central, desplazable. Texto completo inmediatamente: no se necesita ajuste de velocidad de escritura.

## Arquitectura

`Content` carga cuatro JSON: mundo, historia, diálogos y misiones. `State` conserva datos, evalúa condiciones, controla rutas/fases y escribe el guardado. Las interfaces sólo presentan esos datos y solicitan efectos.

`main.gd`: menú, intro, exploración y apertura de paneles. `startup.gd`: tres pantallas previas y aviso reutilizado al girar el móvil. `viewpoint.gd`: imagen e indicadores. `dialogue.gd`: secuencia de nodos y opciones. `device.gd`: secciones del deck. `ui.gd`: controles y tema compartidos. Una escena raíz; las vistas son datos y usan el mismo componente. Sin dependencias externas ni frameworks.

Guardado v1: vista/zona, misiones, flags, descubrimientos, documentos, mensajes, lugares y elecciones. Validación de tipos e IDs, escritura temporal verificada, copia anterior, rechazo de versiones desconocidas y recuperación de `.bak`. Nueva partida pide confirmación y conserva copia fechada. Opciones en archivo separado. No hay migración desde los prototipos retirados.

## Próximos hitos

1. **H1 actual:** fundación y primer tramo, revisión narrativa/artística pendiente.
2. **H2:** aprobar propuesta de vivienda/contrato, completar La Fiebre y El Nudo con una consecuencia jugable; producir fondos por capas.
3. **H3:** Puntales, resolución, final, edición del ritmo hasta la duración objetivo.
4. **H4:** sonido, arte definitivo, accesibilidad, dispositivos reales y exportaciones de escritorio.
