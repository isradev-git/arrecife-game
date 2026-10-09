# EL ARRECIFE · PASE PENDIENTE · Continuidad del proyecto

Última actualización: **9 de octubre de 2026**. Caso ejecutable de referencia: **v0.2.0 (JavaScript)**. Motor elegido: **Godot 4.7.2**, con base técnica y exportación Web verificadas; caso todavía sin migrar.
Este es el punto de entrada para retomar el trabajo en otro chat. Contiene decisiones, resultados y pendientes; los archivos enlazados conservan el detalle. No es una transcripción literal ni modifica el canon literario. Contiene la solución del misterio.

## 1. Por dónde vamos

Existe un juego local de navegador con el caso completo: tres localizaciones, cuatro pantallas, conversaciones, siete pruebas más el encargo, comparación de documentos, informe, cierre y guardado local.

La última entrega del caso fue **movimiento v0.2**: caminar y correr con hojas distintas, aceleración y frenada, giro frontal, respiración y efectos ambientales. El autor ha pedido revisar el proyecto completo, **hacer el juego íntegramente con Godot** y preparar la instalación y el camino para que otras personas puedan jugarlo en navegador y presentarlo como proyecto.

**Estado de aprobación:** el autor aprobó expresamente el concepto visual **Fiebre v8**, especialmente Sota. Ahora valora que **movimiento y entorno siguen «MUY MUY verdes»** y decide usar Godot. No consta una partida completa suya documentada ni aprobación del acabado de v0.2. Una entrega del asistente no equivale a aprobación del autor.

**Entregado en esta revisión:** Godot estándar 4.7.2 en `/Applications/Godot.app`, plantillas Web de la misma versión y proyecto independiente en `godot/`. La escena de verificación carga un fondo existente y responde al clic y a Enter en Safari tras exportar; no contiene Sota ni el caso. Se conservan `juego/`, arte y prompts anteriores. Diagnóstico y propuesta de producción en [PLAN_GODOT.md](PLAN_GODOT.md); comandos y límites de la instalación en [godot/README.md](../godot/README.md).

**Siguiente paso recomendado:** una escena de Velvet en Godot con movimiento, apoyos, escala, giros, oclusiones, encargo y primer documento. Resolverla con el autor antes de extender el patrón a las otras pantallas. Conserva la identidad de Sota y exige corregir el deck en perfil izquierdo. El autor pidió continuar durante la revisión; no ha aprobado todavía un acabado nuevo ni el alojamiento propuesto en itch.io.

**Organización solicitada después:** el autor pide desarrollar **una tarea cada vez**, con especial exigencia en entornos y personajes. [task.md](../task.md) es la fuente del orden y estado de la cola: T00 completada; T01 (base recuperable) es la siguiente; ninguna tarea de producción está en curso. El primer bloque conduce a revisar Velvet completo antes de extender el estándar.

**Nombre del local:** el autor descarta «Doble Piel» y elige **Velvet**. Se actualizan ejecución, guion v2, plan y tareas; el neón del fondo pasa a VELVET en [fiebre_velvet_v1.png](../juego/assets/fiebre_velvet_v1.png), también integrado en Godot. [Prompt y procedencia](../juego/arte/velvet_v1.md). El nombre está elegido por el autor; la nueva imagen es una entrega del asistente, pendiente de valoración estética específica. V8 y los recursos anteriores se conservan sin cambios.

**Título:** el autor descarta «Pase pendiente» como nombre definitivo. El nuevo se decidirá más adelante. Las menciones y nombres técnicos actuales identifican el prototipo histórico; todavía no se ha aplicado un cambio de título a la ejecución.

## 2. Cómo retomar y mantener este registro

1. Leer las secciones 1, 3 y 8 de este documento antes de proponer trabajo.
   Para ejecutar producción, consultar también [task.md](../task.md) y continuar una única tarea de su cola.
2. Abrir los archivos de la rama afectada en la sección 7. Antes de modificar arte, observar las referencias aprobadas y los recursos actuales; antes de cambiar historia, consultar el canon y el guion.
3. Contrastar el estado descrito con los archivos: puede haber cambios del autor posteriores a esta actualización. Si una fuente falta, indicar cuál; no reconstruirla como si se hubiera leído.
4. Al cerrar una tarea, actualizar aquí el estado actual, las comprobaciones, los pendientes y una entrada del historial. Registrar qué pidió o aprobó el autor, qué se entregó realmente y qué queda sin verificar.
5. Mantener las entradas históricas breves y los detalles en sus archivos propios. Corregir el estado actual cuando algo cambie; no acumular instrucciones contradictorias.

Texto para iniciar otro chat:

> Continuamos PASE PENDIENTE, el videojuego de EL ARRECIFE. El proyecto está en `/Users/glitchbane/Documents/proyectos/el-arrecife`. Lee `AGENTS.md` y `proceso/ESTADO_DEL_PROYECTO.md`; después consulta y abre los archivos relevantes antes de hacer cambios. Háblame en español y conserva el canon y las decisiones aprobadas. Comprueba el estado real de los archivos y continúa desde el punto registrado. Mi petición de esta sesión es: [añadir aquí la tarea].

El otro chat necesita acceso a esta carpeta. `AGENTS.md` sirve de entrada para los agentes que lo leen; no proporciona memoria automática a un chat sin acceso a los archivos. Si se traslada el proyecto a otro equipo, las rutas relativas siguen sirviendo; las fuentes externas requieren acceso o una copia autorizada.

## 3. Objetivo, alcance y forma de trabajar

- Juego breve de investigación que haga conocer El Arrecife y deje ganas de leer **CARGA ADMISIBLE**. También es portfolio y aprendizaje.
- Objetivo de duración: **25–35 minutos**, todavía sin medir con lectura natural.
- **Tres localizaciones y cuatro pantallas:** recepción de Velvet y casillero de Iria en cota 4; oficina de Sanz en cota 3; taller de Berta en cota 0. El final reutiliza la recepción.
- Sin combate. Observar, preguntar, contrastar y deducir. Evitar búsqueda de píxeles diminutos y combinaciones arbitrarias.
- El equipo de desarrollo y prueba es **el autor y el asistente**. El autor rechazó depender de otros jugadores o un artista externo. El asistente genera los recursos visuales y realiza la implementación.
- Español, criterio propio, libertad creativa dentro del canon y decisiones del autor. Avanzar con autonomía en tareas reversibles; explicar límites reales y no pedir confirmación por cada paso.
- Guardar recursos e instrucciones de generación por versiones. Conservar los anteriores. **No modificar `canon_el_arrecife.md` ni archivos sincronizados bajo `sources/`.** Trabajar en esta carpeta editable.
- Las ampliaciones del relato, rótulos, ropa y procedimientos administrativos son propuestas del juego, salvo que el canon o el autor los establezcan expresamente. La aprobación estética no los convierte en canon literario.
- La fase inicial de «solo dirección artística» quedó superada cuando el autor pidió preparar guion, recursos y comenzar a montar el juego. Sigue vigente el alcance pequeño.
- ElevenLabs está disponible según el autor, pero **no se ha verificado el acceso ni generado audio o consumido créditos**. Primero cerrar y probar el guion; verificar el acceso cuando corresponda. No asumir que una suscripción mensual sigue vigente.
- La invitación final a la novela es discreta. **No existe un enlace de producto Amazon verificado**; no inventarlo.

## 4. Universo y dirección aprobada

El Arrecife es una megaciudad vertical habitada, con torres, pasarelas, infraestructura superpuesta, reparaciones y diferencias de clase por altura y acceso. Cota 0: talleres y mercados. Cota 3: el Nudo, redes y economía gris. Cota 4: la Fiebre, vicio, prostitución, ocio y encuentros entre clases. Cota 5: el Cordón. Para subir hacen falta permisos o patrocinio. Hay puertos corporales físicos y decks externos reparables. Para detalles, manda el [canon](../canon_el_arrecife.md).

**Sota** es una mujer adulta que verifica reclamaciones y localiza personas. No va armada. Pelo oscuro corto con pequeña mecha gris, chaqueta de trabajo marrón rojiza, pantalón oscuro, deck gastado con correa clara. En los sprites actuales el deck está en su cadera derecha. El nombre Inés está descartado. Marcus es otro personaje del libro; no es el protagonista de este juego.

Referencia visual principal: [Fiebre v8](../trabajo/arte/conceptos/fiebre_v8/fiebre_escena_v8.png). Se quiere el acabado fino y pulido próximo a v1, cinematográfico, con profundidad lateral 2D/2.5D. La experiencia de ciudad prima sobre hacer muy visible el tamaño del píxel. V7 quedó como prueba de píxel demasiado grueso. **No rediseñar a Sota al retomar.**

Referencias expresas: REPLACED para composición, luz y profundidad; Gibson, Cyberpunk 2077 y Edgerunners para identidad cyberpunk. Sin copiar personajes ni escenarios. El vestuario debe ser futurista, no ropa contemporánea rodeada de neón.

Conservar recorrido lateral claro, Sota pequeña en una ciudad enorme, torres y pasarelas arriba y abajo, recepción a la derecha y puntos legibles. Rojos y rosas en la Fiebre, humedad, vapor, suciedad, cables, edificios viejos y tecnología reparada. El tramo mostrado admite clientela con dinero; no implica que toda la cota o sus trabajadores sean ricos.

El barrio debe comunicar trabajo sexual adulto mediante nombres y publicidad de los negocios, accesos, turnos, recepción y habitaciones. El autor descartó «Citas» y «compañía íntima» como rótulos genéricos. Se usa **VELVET · ELLAS Y ELLOS · CARNE O SIMULACIÓN**. Se admiten nombres en inglés, japonés o español.

Todos los personajes son adultos, vestidos, sin desnudos ni actos sexuales explícitos. Diferenciar trabajo sexual de explotación. La vigilancia y el control de personal pueden sugerir relaciones de poder, pero no prueban por sí solos trata. No usar abuso como decoración ni convertir por ello la ausencia de Iria en secuestro. En la revisión visual 2 anterior hubo un rechazo del generador documentado: respetar sus límites sin eludirlos.

## 5. Caso actual — incluye solución

La jefa de la Nómina contrata a Sota porque Iria faltó a su turno. La Nómina es apoyo mutual sostenido por cuotas, libro y caja. El encargo consiste en localizarla y ofrecer ayuda, no devolverla como propiedad de quien paga.

Sanz cobró a Iria un **depósito de tres láminas (300 universales)** por tramitar patrocinio de trabajo en el Cordón. Hay una **comisión separada de 15 universales**; la cifra concreta es propuesta del juego. El acuerdo garantiza devolución del depósito si se deniega. Sanz presentó realmente la solicitud; después recibió y leyó la denegación, anunció aprobación y retuvo el dinero.

Iria descubrió la irregularidad, obtuvo una copia del seguimiento de anticipos y se refugió por voluntad propia con Berta, reparadora de decks de cota 0. Sanz amenaza con denunciar la copia de datos y hablar con el local; no controla toda la ciudad. Berta comprueba el encargo y consulta a Iria antes del contacto. Iria autoriza informar a la jefa y reclamar con las copias, **no comunicar su refugio a Sanz**.

### Documentos y deducciones

| Pieza | Función |
| --- | --- |
| E0 | Encargo, cobertura y límites del consentimiento. |
| P1 | Presentación N3-417, 3 de junio a las 09:20; solicitud recibida, no permiso de subida. Dirección de Sanz. |
| P2 | Mensaje de Sanz del 11 de junio a las 12:40: afirma aprobación. Reenvío de Iria a las 12:46; espera mantener su turno nocturno. |
| P3 | Acuerdo y recibo del 2 de junio: depósito 300 y comisión 15 separados; devolución del depósito ante denegación. Otra solicitud requiere consentimiento. |
| P4 | Denegación del 10 de junio, 13:10; lectura manual de Sanz a las 13:14. Historial hasta el 12, sin autorización posterior. |
| P5 | Resguardo de reparación del deck: depósito 28 de mayo, listo el 30; no es una venta. Dirección de Berta. |
| P6 | Foto de seguimiento hecha por Iria el 11 de junio, 18:06, actualizada a las 17:50. Tres saldos denegados; el de Iria sigue en 300. No conocemos los contratos de los otros clientes. |
| P7 | Nota de Iria y hoja del reparto: salida prevista el 13 de junio a las 08:00, todavía sin salir. Refugio voluntario y petición de ayuda. |

D1, P1 + P2: la presentación no respalda por sí sola la aprobación; falta comprobar la resolución. D2, P2 + P4: Sanz sabía de la negativa cuando afirmó aprobación. Se puede resolver D2 más tarde, sin bloquear la historia por no haber hecho D1 primero.

Inicio: **12 de junio, 14:00**, sin fijar año de la novela. Iria fue a la oficina el día 11 hacia las 18:00; llegó al taller hacia las 20:00 y escribió la nota hacia las 20:20. El envío previsto tarda casi 36 horas desde que la escribió; al empezar ya han pasado unas 18. **Podía llamar y eligió esperar**, por miedo y vergüenza: su credibilidad narrativa sigue pendiente de prueba, no es una imposibilidad técnica.

El informe exige leer las siete pruebas, demostrar D2, escuchar la explicación del silencio y obtener el consentimiento. Se reclaman 300, sin confundirlos con la comisión. La jefa deja de recomendar a Sanz y usa las copias para presionar; él ofrece devolver 200. **Iria acepta esa devolución sin renunciar a los 100 restantes**, vuelve por decisión propia y conserva el turno del 14. El fondo cubre una noche y honorarios de Sota. Se resuelven la ausencia y la mentira; no se afirma devolución íntegra.

Los textos exactos están en la prueba de mesa v2 y en el juego; este resumen no los sustituye.

## 6. Qué está implementado y qué se ha comprobado

### Implementado

El caso completo sigue en HTML, CSS y JavaScript con Canvas para la escena y controles/documentos HTML. Sin dependencias de ejecución, cuentas o servicios externos. **El autor ha elegido Godot para la producción definitiva.** Existe una base técnica en GDScript, 2D y Compatibility con exportación Web sin hilos; la migración del caso está pendiente. La lista siguiente describe el prototipo JavaScript, no funciones ya migradas.

- Las cuatro pantallas y el caso hasta el cierre; diálogo sin audio, libreta, mapa, pistas opcionales y retroalimentación de respuestas incorrectas.
- Lectura de direcciones para desbloquear destinos; controles amplios y lista «Explorar».
- Guardado automático en `localStorage`, clave `arrecife:pase-pendiente:v1`; v0.2 conserva el esquema. Una conversación se guarda al terminarla. Archivo local y servidor tienen almacenamientos distintos. No asumir que una partida de prueba concreta siga guardada.
- Caminar/correr, aceleración/frenada, cadencia vinculada a distancia, giro frontal y respiración sutil con pies anclados. Mayús, botón Correr o doble clic para carrera; F para detenerse de frente.
- Recursos activos: `sota_caminar_v3.png`, `sota_correr_v3.png`, `sota_reposo_v2.png`. Ocho poses por ciclo y hoja de cuatro vistas de reposo; se usa el frontal estable con respiración procedural.
- Vapor, lluvia localizada, luces, reflejos, ventilación y siluetas lejanas. Fondos aplanados y personajes principales del fondo estáticos. Sin parallax.
- Texto ampliable y movimiento reducido. La libreta congela la animación; una pestaña oculta suspende la actualización. Refresco visual limitado a unos 30 Hz.

### Comprobación registrada, no promesa de cobertura total

| Comprobación | Resultado y límite |
| --- | --- |
| v0.1: recorrido manual completo en Safari | Completado, incluida respuesta incorrecta, corrección, informe, devolución parcial y cierre. |
| v0.1: recarga y guardado | «Continuar» recuperó cierre y ocho tarjetas. |
| v0.2: prueba visual en Safari | Arranque, frontal, caminar y correr hasta conversaciones, controles y opción de movimiento reducido comprobados. No se repitió todo el caso manualmente con v0.2. |
| v0.2: `npm test` | **13 pruebas pasan**: seis del caso y siete de movimiento, destinos, límites, fotogramas y efectos ambientales. Última ejecución registrada: 9 de octubre de 2026. |
| Duración y recepción del autor | Sin partida de lectura natural cronometrada ni evaluación final documentada de v0.2. |
| Otros entornos | Móvil, otros navegadores y rendimiento sostenido pendientes. |
| Revisión actual: prototipo v0.2 | Las 13 pruebas vuelven a pasar; arranque por HTTP y acercamiento a una interacción observados en Safari. No se repitió el caso completo. |
| Instalación Godot 4.7.2 | SHA-512 de editor y plantillas oficiales correctos; firma y Gatekeeper correctos; editor gráfico abre el proyecto. Solo plantillas Web instaladas. |
| Base Godot | Comprobación automática de escena, textura, foco y señal superada. Exportación release termina con código 0. Fondo, botón, clic, recarga y Enter comprobados visualmente en Safari por HTTP local. No prueba aún movimiento, caso, audio ni guardado. |
| Cambio del local a Velvet | Revisión visual del nuevo neón, dimensiones 1672 × 941 y copias de JavaScript/Godot idénticas. Pasan las 13 pruebas del prototipo y la comprobación de escena Godot; importación y exportación Web terminan con código 0. No se repite la partida ni la prueba de navegador en este cambio. |

Para abrir: [juego/index.html](../juego/index.html) en Safari. Para ejecutar las pruebas:

```sh
cd /Users/glitchbane/Documents/proyectos/el-arrecife/juego
npm test
```

`npm start` sirve en `http://127.0.0.1:8765` con Python 3. La restricción del sandbox de una sesión anterior quedó superada: esta revisión pudo servir el proyecto por HTTP local en 8766. El prototipo se probó en `/juego/` y la exportación en `/godot/build/web/`. No hay una publicación pública ni un servidor que deba darse por activo al cambiar de chat. Los fallos temporales de control de escritorio tampoco equivalen a errores del juego.

## 7. Mapa de fuentes — leer según la tarea

Todos los enlaces siguientes son relativos a este documento y pertenecen al proyecto editable, salvo el bloque externo.

| Tema | Fuentes |
| --- | --- |
| Canon literario, autoridad del universo | [canon_el_arrecife.md](../canon_el_arrecife.md) — solo lectura. |
| Decisiones visuales | [Dirección artística](../trabajo/direccion_artistica.md) y [escena v8](../trabajo/arte/conceptos/fiebre_v8/fiebre_escena_v8.png). |
| Evolución visual | `trabajo/arte/conceptos/fiebre_v4/` a `fiebre_v8/`: imagen, prompt y evaluación de cada versión. |
| Guion y pruebas narrativas | [Prueba de mesa v2](../trabajo/diseno/prueba_mesa_v2/README.md), [guion](../trabajo/diseno/prueba_mesa_v2/moderacion/guion.md), [deducciones](../trabajo/diseno/prueba_mesa_v2/moderacion/deducciones.md), [protocolo](../trabajo/diseno/prueba_mesa_v2/moderacion/prueba.md). Tarjetas completas en su carpeta `jugador/`. |
| Apertura y alcance técnico | [README del juego](../juego/README.md), [producción](../juego/PRODUCCION.md), [package.json](../juego/package.json). |
| Contenido en ejecución | [content.js](../juego/src/content.js): conversaciones/escenas/deducciones; [evidence.js](../juego/src/evidence.js): copias de tarjetas. No hay sincronización automática documentada entre tarjetas Markdown y este JS. |
| Reglas y partida | [engine.js](../juego/src/engine.js), [app.js](../juego/src/app.js), [pruebas del caso](../juego/tests/case.test.cjs). |
| Movimiento y ambiente | [motion.js](../juego/src/motion.js), [sprites.js](../juego/src/sprites.js), [atmosphere.js](../juego/src/atmosphere.js), [pruebas](../juego/tests/motion.test.cjs). |
| Arte y procedencia | [Recursos iniciales](../juego/arte/README.md), [revisión de movimiento](../juego/arte/movimiento_v2.md), [rótulo Velvet](../juego/arte/velvet_v1.md). PNG en `juego/assets/`; instrucciones en `juego/arte/prompts/`. |
| Migración a Godot | [Diagnóstico y plan](PLAN_GODOT.md), [instalación y comprobación](../godot/README.md), [proyecto](../godot/project.godot), [exportación](../godot/export_presets.cfg). |
| Tareas de producción | [task.md](../task.md) — orden, estado, entregas y criterios de cierre; una tarea cada vez. |

**Fuentes externas del trabajo trasladado:**

Raíz: `/Users/glitchbane/.codex/.chatgpt-projects/g-p-6ac776b40a0481919f4b56d2cc871a93`.

- `diseno/pase_pendiente_caso_v1.md`.
- `arte/conceptos/sota_referencia_v1.png` y `fiebre_escena_v1.png`, `fiebre_escena_v2.png`, `fiebre_escena_v3.png`.
- `arte/conceptos/README.md`, `fiebre_direccion_v2.md` y `fiebre_direccion_v3.md`.

Consultadas durante el traslado según el registro de v4. La fuente original de diseño, las notas v2/v3 y la referencia de Sota seguían disponibles al crear este documento. Mantener estas fuentes fuera de las ediciones del juego. Para cambios de voz literaria, la prueba de mesa v2 documenta también las directrices del proyecto CARGA ADMISIBLE que se consultaron.

**Disponibilidad de fuentes en esta revisión:** no existe `sources/` en esta copia. Se consultaron el canon local y los materiales editables existentes; no se revalidó la disponibilidad del proyecto externo. No asumir sincronización activa.

**Notas históricas superadas:** algunas evaluaciones antiguas dicen «pendiente de aprobación» para v8, «solo arte», «no hay implementación» o «siguiente prueba: una escena». Reflejan su fecha de escritura. La aprobación posterior de v8 y el paso a v0.1/v0.2 están registrados aquí. La nueva escena pequeña es una prueba de producción en Godot, no una vuelta a la fase de diseño de mesa. También queda superada la indecisión sobre el motor: el autor ha elegido Godot. La partida guardada mencionada en el README tampoco es un estado permanente del navegador.

## 8. Pendientes, con criterio para cerrarlos

Este bloque resume áreas pendientes. El orden y estado de ejecución están en [task.md](../task.md), solicitado por el autor para avanzar una tarea cada vez. No son promesas de ampliar alcance.

| Prioridad | Pendiente | Se considera resuelto cuando… |
| --- | --- | --- |
| Próximo | Velvet jugable en Godot | Movimiento, escala, apoyos, giros, oclusiones, encargo y primer documento funcionan en navegador; se registra la valoración del autor. Véase PLAN_GODOT.md. |
| Próximo | Perfil izquierdo y continuidad del deck | El deck permanece en la cadera correcta en ambos sentidos, frente y transiciones. |
| Próximo | Afinar los ciclos de Sota | Se revisan apoyos, manos, mangas, proporciones y transición caminar/correr/reposo a escala real; sin saltos visibles ni deslizamiento excesivo. |
| Próximo | Escala, oclusiones y resolución del píxel | Se comprueba Sota junto a los personajes, mobiliario y accesos de las cuatro pantallas; se fija una escala de producción que conserve el acabado aprobado. |
| Narrativa | Ritmo y credibilidad del silencio de Iria | El autor recorre y valora el guion, se revisa la espera del reparto y se mide una lectura natural. Conocer la solución limita cualquier interpretación de dificultad. |
| Técnica | Migración del caso, accesibilidad y persistencia | Se trasladan las reglas y textos, las seis pruebas del caso y la interfaz; se comprueban foco, lectura y guardado web. La prueba Godot aparece principalmente como canvas en el árbol de Safari: no hereda la accesibilidad HTML. |
| Técnica | Rendimiento y navegadores de destino | Se prueba el juego completo en Safari, Chromium y Firefox; medir carga y rendimiento. Móvil no se considera validado. |
| Después | Capas, parallax y secundarios animados | Se decide qué aporta a esta experiencia y se produce solo lo necesario; los fondos actuales no son capas separadas. |
| Después | Voces selectivas y ambiente sonoro | Guion probado, acceso/suscripción de ElevenLabs verificados y alcance de audio decidido antes de generar. |
| Después | Distribución pública y portfolio | Godot ya está decidido y la exportación mínima funciona. Falta terminar el juego, preparar su página y probar el paquete alojado. itch.io es propuesta del asistente, no publicación realizada. Control de versiones local pendiente. |
| Cierre | Invitación comercial a la novela | Se obtiene y verifica el enlace real de CARGA ADMISIBLE antes de añadirlo. |

No consta ningún bloqueo que impida seguir desarrollando localmente. Las limitaciones del generador y del entorno se documentan; no deben ocultarse con afirmaciones de acabado definitivo.

## 9. Historial de trabajo y decisiones

Las fechas solo se fijan donde están documentadas; el trabajo anterior al traslado se agrupa sin inventar sesiones.

| Etapa | Trabajo, decisión y resultado |
| --- | --- |
| Trabajo previo trasladado | Canon, diseño PASE PENDIENTE, referencia de Sota y Fiebre v1–v3. V1 gustó por composición, ciudad y aspecto de juego; v2 añadió neones/adultos y v3 desgaste, vapor, infraestructura y YUME. Faltaba identidad de barrio sexual. Rechazo anterior del generador documentado en v2. |
| 8 oct 2026 · v4 | Se leyeron fuentes y observaron referencias. Se desarrollaron recepción, habitaciones, tiempos y control de personal, sin ligar coerción con la ausencia de Iria. Se guardó imagen, prompt y valoración. |
| 8 oct · v5 | A petición del autor, nombre de negocio y publicidad concreta sustituyeron «Citas / compañía íntima». Aparece Doble Piel y su oferta real/virtual. |
| 8 oct · v6 | Ropa más cyberpunk. El autor aprueba la dirección y la clientela con capacidad de gasto en este tramo; admite nombres en varios idiomas. |
| 8 oct · v7 | Recuperación del píxel. El autor precisa que prefiere la finura de v1 al grano grueso; la experiencia del universo tiene prioridad. |
| 8 oct · v8 | Síntesis del acabado fino y contenido de v6. El autor la declara «PERFECTO», destacando a la protagonista. Pasa a ser referencia principal aprobada. |
| 8 oct · prueba de mesa v1/v2 | Guion, ocho tarjetas, deducciones, ayudas y protocolo. V2 adapta la prueba a autor + asistente, sin terceros. V1 queda conservada. No consta una sesión de mesa completa cronometrada del autor. |
| 8–9 oct · juego v0.1 | Tras autorización para montar el juego, se producen fondos, hoja inicial de Sota y versión de navegador con caso completo. Guion y siete pruebas integrados. Se recorre el caso en Safari, se prueba recarga/guardado y pasan seis pruebas automáticas. |
| 9 oct · juego v0.2 | El autor pide movimiento natural, correr, frontal, respiración y entorno vivo. Se generan hojas nuevas y correcciones de alternancia, se calibran recortes/pivotes y se integran controles, velocidad progresiva y ambiente. Prueba visual parcial en Safari y trece pruebas automáticas superadas. Quedan variaciones entre poses y reflejo del equipo en perfil izquierdo. |
| 9 oct · continuidad | El autor pide `/proceso` para cambiar de chat sin perder contexto. Se crea este documento y `AGENTS.md` como entrada y regla de mantenimiento. Se separan aprobación, implementación y verificación; se señalan instrucciones históricas superadas. Sin cambios al juego ni al canon en esta tarea. |
| 9 oct · revisión y Godot | El autor considera verdes movimiento y entorno, decide desarrollar íntegramente en Godot y pide preparar instalación y distribución web. Se revisan fuentes, código y arte activos; pasan 13 pruebas del prototipo. Se instala Godot 4.7.2 y plantillas Web oficiales verificadas; se crea `godot/` con escena técnica y prueba automática, y se valida exportación en Safari (renderizado, clic, recarga y Enter). `PLAN_GODOT.md` propone Doble Piel como siguiente hito. Sin migración del caso, aprobación estética nueva ni publicación. |
| 9 oct · tareas y título | El autor pide `task.md`, trabajo secuencial y especial calidad de personajes y entornos; descarta el título actual y aplaza el nuevo. Se crea la cola T00–T28 con entregas, criterios y registro de cierre; T00 recoge la verificación ya realizada y T01 es la siguiente. Comprobados enlaces y orden documental. Sin ejecutar producción ni renombrar archivos o juego. |

| 9 oct · Velvet | El autor rechaza «Doble Piel» y elige Velvet para el local; el título del juego sigue pendiente. Se actualizan textos activos, guion v2, dirección, plan y tareas; imagegen edita el neón en una versión nueva integrada en JavaScript y Godot, con prompt y versiones anteriores conservados. Revisión visual del asistente, 13 pruebas, importación, comprobación Godot y exportación Web correctas. Sin nueva partida de navegador ni aprobación estética específica del PNG. |

Para futuras entradas: **fecha · petición o decisión · resultado y archivos · comprobación · pendiente**. Registrar el proceso por hitos; los intentos que expliquen una decisión o limitación merecen conservarse, el ruido de herramientas no.
