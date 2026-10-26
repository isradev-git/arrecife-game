# EL ARRECIFE · tareas del reinicio

Dirección del autor, 20 oct 2026: aventura **2D ilustrada en primera persona**, clic/toque, contratos y progresión. Sólo `game/` es jugable. [Diseño](docs/GAME_DESIGN.md).

## Prioridad actual · juego antes que guardado

Decisión del autor, 23 oct 2026: dejar en pendiente la siguiente tanda de guardado y nube; concentrar el desarrollo en la experiencia jugable. Se conserva lo ya implementado en la rama `feat/save-integrity-021`, sin presentarlo como copia remota activa.

- [x] Revalidar la base actual: importación Godot 4.7.2, recorrido principal 827/827 headless y 899/899 nativas, preservación de canon y originales.
- [x] Explicar el permiso concreto cuando una ruta entre cotas está bloqueada y mostrar el aviso en un panel compacto. Prueba previa: 2 fallos; después 831/831 headless y 905/905 nativas, con capturas de escritorio y horizontal móvil.
- [ ] Revisar el recorrido de los tres contratos, ambos finales, acciones repetidas y bloqueos desde la perspectiva de un jugador nuevo (P0-06/07).
- [ ] Observar una primera partida humana completa, sin guía de soluciones y cronometrada; registrar dónde se atasca el jugador antes de cambiar ritmo o mecánicas (P1-01–05). [Protocolo preparado](docs/PRUEBA_JUGADOR_0_2.md).
- [ ] Preparar para revisión del autor las fichas de los tres contratos, la voz de Sota, los mensajes y las consecuencias del final; mantener separado el canon (P1-06–10).
- [ ] Revisar individualmente las 21 vistas y el menú a tamaño de juego, junto con continuidad, personajes, sonido, lectura, accesibilidad y rendimiento (P1-11–17).
- [x] Preparar el empaquetado Web de prueba con versión, commit, Godot 4.7.2, hashes y hoja sin soluciones; comprobar su ZIP y apertura local (P0-08). Falta la sesión humana y su ronda de correcciones.
- [ ] Corregir los problemas que revele la partida humana y repetirla antes de cerrar P1-19/20.

Los pendientes de guardado y publicación Web siguen registrados al final de este archivo y en la [hoja de mejoras](docs/EL_ARRECIFE_AUDITORIA_Y_PLAN_DE_MEJORA.md); este cambio de prioridad no los da por completados.

## Revisión de estética por cotas · 25 oct 2026

- [x] Cotejar los 18 fondos activos de La Fiebre, El Nudo y Los Puntales con los retratos originales, `world.json` y el canon visual D225–D227. [Auditoría por vista](docs/AUDITORIA_VISUAL_COTAS_2026-10-25.md).
- [x] Autor: escoger el enfoque de producción: una muestra de Los Puntales y después avanzar cota por cota (25 oct 2026).
- [x] Autor: aprobar el [diseño de la muestra](docs/superpowers/specs/2026-10-25-puntales-muestra-canon-design.md) (25 oct 2026).
- [x] Generar la [muestra candidata de `puntales_acceso`](art/iterations/zonas_puntales/puntales_acceso_canon_v1.png) con prompt y primer borrador conservados; comprobar composición a 1672×941 y [recorte 844×390](docs/evidence/puntales_acceso_canon_v1_844x390.png).
- [x] Atender la observación del autor sobre exceso de luz: [v2 más sombría](art/iterations/zonas_puntales/puntales_acceso_canon_v2.png), [recorte 844×390](docs/evidence/puntales_acceso_canon_v2_844x390.png) y [prompt](art/prompts/puntales_acceso_canon_v2.md), sin sobrescribir la v1.
- [x] Incorporar la regla del autor de igualar el lenguaje gráfico de los retratos y crear la [v3 de estilo](art/iterations/zonas_puntales/puntales_acceso_canon_v3.png), con [recorte móvil](docs/evidence/puntales_acceso_canon_v3_844x390.png) y [prompt](art/prompts/puntales_acceso_canon_v3.md).
- [x] Autor: aprobar el enfoque de la muestra v3 de acceso para continuar con Los Puntales.
- [ ] Rehacer La Fiebre y El Nudo según su identidad propia; conservar versiones, prompts, hotspots y continuidad entre vistas.

**Estado:** Los Puntales integrados como candidatos técnicos tras aprobarse el enfoque del acceso v3. Las otras cinco vistas esperan aprobación artística individual; La Fiebre y El Nudo siguen pendientes de renovación. No se ha cambiado el canon ni la ficción. La prueba de preservación completa se detiene en el canon ya modificado localmente por el autor; retratos y seis fondos antiguos se comprobaron por hash.

## Navegación legible en todas las vistas · 24 oct 2026

- [x] Auditar las 21 vistas: todas conservan al menos una ruta y un camino de vuelta; los permisos entre cotas siguen vigentes.
- [x] Distinguir las rutas con un aro tenue y una puerta interior de los puntos de interacción, sin alterar el tamaño táctil ni los IDs de las vistas. El autor rechazó la primera flecha por llamativa.
- [x] Sacar la ruta a la galería de debajo de la cabecera móvil y explicar las dos marcas al entrar en la partida.
- [x] Comprobar tests headless y nativos, y revisar capturas de La Fiebre y Velvet a 844×390 y de las pasarelas a 1280×720.
- [ ] Probar la claridad y comodidad de ambas marcas en un teléfono físico y con el primer jugador.

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

## Protección del progreso · primera tanda técnica · 23 oct 2026

- [x] P0-01: nueva partida y mutaciones informan fallos; conservar memoria y archivo válido en fallos simulados.
- [x] P0-02: documento, efectos y elecciones se confirman por acción lógica única; pruebas de repetición y fallo.
- [ ] P0-03/P0-04: completar matriz real de cuota/renombres Web y validación de transiciones imposibles. Recuperación local y fixture v1 ya probados.
- [ ] SAVE-01: completar matriz de validación y migración futura. Esquema v1, fixture, migración de contenido y versión futura protegida.
- [x] SAVE-02: exportación/importación por menú nativo y Web, aviso de privacidad, confirmación, respaldo recuperable desde «Copias anteriores» y prueba Chromium de descarga, archivo inválido, perfil nuevo y restauración tras borrar IndexedDB.
- [ ] SAVE-03/SAVE-04/SAVE-05: configurar entorno de ensayo, identidad verificable, RLS, repositorio remoto, cola persistente y conflictos en dos clientes. Modelo local con mock probado; **no hay nube real**.
- [ ] WEB-01: aprobar slug y comprobar carga HTTPS en subruta del hosting. Exportación en `/ensayo/` servida localmente y empaquetado limpio probados.
- [ ] SAVE-06–09 y WEB-02–04: integración multidispositivo, seguridad, restauración y publicación; pendientes.

[Arquitectura y límites](docs/SAVE_SYSTEM_ARCHITECTURE.md) · [Resultados](docs/VALIDACION.md). Implementación técnica pendiente de revisión; ninguna aprobación nueva de arte o ficción.

## Movimiento ambiental · piloto del pasaje · 24 oct 2026

- [x] Autor: aprobar el [diseño](docs/superpowers/specs/2026-10-23-ambiente-dinamico-design.md) de luces, reflejos, vapor y bruma, sin animar personas ni mover la cámara.
- [x] Implementar la capa del pasaje con coordenadas ligadas al fondo, por detrás de hotspots y paneles, y detenerla con «Reducir movimiento» desde la escena.
- [x] Comprobar reentrada, recorte a 844×390, clic sobre hotspot, capturas nativas, exportación Web y recorrido en Chromium; [resultados](docs/VALIDACION.md).
- [x] Corregir la prueba local en `:8768`: servir sin caché, reexportar y aumentar la visibilidad de los efectos tras la captura del autor.
- [ ] Autor: valorar la intensidad y el aspecto del [piloto animado actual](docs/evidence/ambient_fiebre_visible_844x390.gif) antes de aplicarlo al menú y a las otras veinte vistas.
- [ ] Extender con fuentes de luz, bruma y vapor propios de cada vista aprobada; comprobar rendimiento y lectura en teléfono físico.

La ampliación del guardado y de la nube permanece pendiente por decisión del autor; esta tanda no cambia partidas ni esquema de guardado.

## Velvet por dentro · corrección del autor · 24 oct 2026

- [x] Conservar el antiguo fondo exterior y su prompt; crear un candidato interior que no repita el pasaje.
- [x] Mantener `fiebre_entrada` y las seis vistas de La Fiebre; colocar entrada, salida y observación sobre el arte nuevo.
- [x] Comprobar clic en la puerta, retorno táctil, capturas 1280×720 y 844×390, suites nativa/headless y Web local.
- [ ] Autor: valorar la [imagen interior candidata](docs/evidence/velvet_interior_1280x720.png) y su continuidad antes de darla por arte final.

## Los Puntales · renovación visual cota 2 · 25 oct 2026

- [x] Autor: aprobar la luz sombría y el lenguaje de retratos de la [muestra v3 del acceso](art/iterations/zonas_puntales/puntales_acceso_canon_v3.png) como dirección de Los Puntales.
- [x] Crear los otros cinco fondos con composición propia, conservar borradores, PNG anteriores y [prompts](art/prompts/zonas_puntales_canon_2026-10-25.md); corregir en soportes la marca sobre unión metálica en v2.
- [x] Integrar seis candidatos versionados sin cambiar IDs, rutas, contratos ni canon; alinear marca, manómetro y registro con sus hotspots.
- [x] Comprobar importación, 931/931 headless, 1007/1007 nativas, guardado, render a 1280×720 y 844×390 y exportación Web local; [evidencias](docs/VALIDACION.md).
- [ ] Autor: valorar individualmente taller, frente de trabajo, soportes, presión y verificación dentro del juego; corregir acabado y continuidad donde lo indique.
- [x] Recorrer las seis vistas y sus retornos en Chromium a 1280×577 y 844×390; abrir los tres documentos condicionados, recargar y continuar desde Puntales; comprobar consola y ZIP Web privado. [Evidencias](docs/VALIDACION.md).
- [ ] Repetir navegación y toque en teléfono físico, además de Safari/iOS, antes de la aprobación técnica final.
