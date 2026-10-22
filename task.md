# EL ARRECIFE · tareas del reinicio

Dirección del autor, 20 oct 2026: aventura **2D ilustrada en primera persona**, clic/toque, contratos y progresión. Sólo `game/` es jugable. [Diseño](docs/GAME_DESIGN.md).

## H0 · retiro recuperable

- [x] Inspeccionar Git, canon, documentación, proyectos y arte.
- [x] Confirmar checkpoint publicado `433e099`, crear `backup/pre-reboot-20261020` y rama `feat/interactive-arrecife-reboot`.
- [x] Copia local de carpetas retiradas, incluidos recursos ignorados.
- [x] Preservar y cotejar canon, retratos Sota/Jefa, guardia/figuras de acceso y atribución.
- [x] Retirar implementaciones y documentación activas obsoletas.
- [x] Mantener el reinicio local, sin push.

## H1 · fundación jugable

- [x] Proyecto Godot 4.7.2 limpio, menú e introducción saltable.
- [x] Tres vistas del apartamento; una vista navegable de La Fiebre.
- [x] Hotspots reutilizables con tipos, condiciones y coordenadas normalizadas.
- [x] Objetos con observación breve; terminal y documentos con interfaces diferenciadas.
- [x] Observaciones temporales: cierre con X, desaparición a los 14 s y reapertura al tocar el objeto.
- [x] Evitar que el estado del contrato reaparezca al cambiar de vista o continuar; mantener los avisos del diálogo y los trayectos cuando suceden.
- [x] Diálogos estructurados, retratos originales, hablante iluminado, temas, elecciones y revisita.
- [x] Deck con mensajes, contratos, archivo, noticias, contactos y lugares.
- [x] Recepción, aceptación y dos avances del contrato `retorno_agua`.
- [x] Cuatro zonas y doce IDs registrados al cerrar H1; rutas y permisos definidos.
- [x] Guardado versionado, copia de seguridad, recuperación, continuar y reinicio confirmado.
- [x] Opciones de volumen/buses, texto grande, indicadores y reducción de transiciones.
- [x] Ratón y toque sobre áreas acotadas de la ilustración, puntos de luz discretos, lista de acciones a petición y desplazamiento de texto.
- [x] Sustituir las filas de botones cuadrados de «Pistas», deck y terminal por acciones tipográficas; mostrar «Pistas» como panel lateral compacto y conservar el desplazamiento cuando hay más destinos.
- [x] Comprobación histórica de móvil vertical, sustituida después por la decisión de jugar sólo en horizontal; se mantiene la prueba de toque Web dentro y fuera del punto.
- [x] Sustituir la orientación móvil vertical por apertura de tres pantallas y aviso persistente de giro; conservar el uso libre de la ventana en ordenador.
- [x] Usar el logo original facilitado por el autor, con original/copia íntegros; en Web mostrar la apertura una vez por pestaña, saltarla al recargar y repetirla en pestaña nueva.
- [x] Menú ilustrado de ventana a la ciudad sin Sota y con enlaces tipográficos; apertura con texto discreto y avance por clic/toque/Intro.
- [x] Paisaje a pantalla completa, controles superpuestos, puntos circulares con áreas acotadas, tipografía de PC contenida y letra móvil ampliada.
- [x] Variante poblada del pasaje de La Fiebre con PNG anteriores y prompts conservados.
- [x] Opciones de misión amarillas e información opcional gris; ampliar los textos del primer recorrido.
- [x] Importación, pruebas automáticas, ejecución nativa con GPU y capturas reales.
- [x] Exportación Web, clic/toque sintético, recarga y persistencia en navegador de escritorio.
- [x] README, AGENTS, diseño, arte, recuperación y continuidad renovados.

**Entrega técnica del hito 1. No equivale a aprobación narrativa o artística.** Ver resultados concretos y límites en [VALIDACION](docs/VALIDACION.md).

**Cierre técnico revisado el 21 oct 2026:** importación, 239/239 pruebas headless, 268/268 nativas, preservación y recorrido Web previo hasta el límite de El Nudo. Después de las correcciones se inspeccionaron «Pistas», «Continuar» y el cambio de habitación en la nueva exportación Web. La aprobación del autor sigue separada de esta comprobación.

- [ ] Autor: valorar el primer recorrido, los detalles de la vivienda y el contrato propuestos, la voz de Sota, la relación con la Jefa y el texto de autoría. Su residencia en La Fiebre ya está aprobada.
- [ ] Autor: valorar la presentación actual del menú, «Pistas» y los demás paneles, las cuatro vistas, la multitud de La Fiebre y las observaciones temporales como base para continuar; señalar las correcciones necesarias.

**Decisión posterior del autor:** móvil sólo horizontal. La implementación actual anula el uso vertical móvil documentado en el punto histórico anterior. El autor facilitó el logo definitivo para la apertura; la redacción legal aún necesita revisión editorial.

## H2 · siguiente trabajo

- [x] Autor: aprobar el reparto de 21 vistas (3 + 6 + 6 + 6) y que Sota vive en La Fiebre porque su trabajo se lo permite.
- [x] Redactar la [propuesta espacial de las 21 vistas](docs/superpowers/specs/2026-10-21-21-vistas-zonas-design.md), sin convertir las conexiones nuevas ni los fondos en canon.
- [x] Autor: aprobar los nombres y conexiones de la especificación espacial escrita.
- [x] Autor: aprobar el [plan de implementación de zonas](docs/superpowers/plans/2026-10-21-21-vistas-zonas.md); ejecución nativa en la rama actual.
- [x] Crear pasos públicos de El Nudo y Los Puntales con población y trabajo visibles, como fondos candidatos.
- [ ] Resolver luz de Penumbra en la ventana y continuidad espacial entre habitaciones.
- [ ] Ilustrar a la Jefa en el entorno y producir fuentes por capas.
- [x] Completar las cinco vistas restantes de La Fiebre y las seis de El Nudo, con navegación de ida y vuelta y fondos candidatos propios.
- [x] Completar las seis vistas de Los Puntales y verificar los controles de cota, el guardado v1 anterior y el render de las 21 vistas.
- [x] Comprobar grafo completo, importación, pruebas headless/nativas, preservación y exportación Web; resultados en [VALIDACION](docs/VALIDACION.md).
- [ ] Autor: revisar y aprobar o corregir los 17 fondos candidatos nuevos y la continuidad visual de las cuatro zonas.
- [x] Autor: autorizar el commit y push de `feat/interactive-arrecife-reboot` al remoto (22 oct 2026).

## Versión 0.2.0 · primera prueba completa

- [x] Autor: definir e incorporar al canon a Sota como protagonista del videojuego, su pasado Vesta, oficio y relación con la policía (22 oct 2026).
- [x] Diseñar e implementar las misiones 2 y 3, la entrega del parte del agua y dos decisiones de cierre; ficción del juego separada del canon.
- [x] Dotar a cada vista de las tres cotas de una observación o prueba contextual y completar el recorrido de las tres misiones por interfaz.
- [x] Cargar partidas v1 anteriores con los dos contratos nuevos bloqueados, sin perder ubicación ni pruebas.
- [x] Ordenar los contratos pendientes de acción antes de los completados y ocultar los mensajes futuros.
- [x] Añadir ambiente sonoro discreto y toque de interfaz, con volumen separado. La versión narrativa no usa partitura musical.
- [x] Validar históricamente importación, recorrido completo con ambos desenlaces, migración de guardado, preservación, render nativo y exportación Web de la candidata previa, rotulada 1.0.
- [x] Apoyar los retratos originales de Sota y la Jefa en el borde inferior del diálogo; comprobar escritorio y horizontal móvil.
- [x] Alinear la conversación con la parte superior de los retratos, manteniendo el texto desplazable.
- [x] Diseñar e implementar conversaciones por mensajes con respuestas guardadas y llegada por hitos. Madre, Hermana y Lía son ficción de juego, pendientes de revisión del autor; no se añaden al canon.
- [x] Rotular 0.2.0 en proyecto, créditos y documentación vigente; preparar guía de primera partida.
- [x] Cerrar la validación técnica y visual de 0.2.0, incluida Web local, y preparar el paquete de prueba.
- [x] Integrar el proyecto 2D completo en `main` y actualizar su README con capturas reales (autorización del autor, 22 oct 2026).
- [ ] Revisar ritmo/duración en una partida completa de unos 30 minutos.
- [ ] Aprobar y finalizar todas las ilustraciones y capas animadas necesarias.
- [ ] Pruebas en teléfonos físicos, Safari/iOS, Android, Windows y Linux.
- [ ] Revisar la redacción del crédito legal.
- [ ] Exportaciones de escritorio y comprobación final de rendimiento/accesibilidad.
- [ ] Publicación de la versión final tras las aprobaciones narrativas, artísticas y técnicas.
