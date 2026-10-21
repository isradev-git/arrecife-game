# 21 vistas de las zonas · Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Hacer navegables las 21 vistas aprobadas del apartamento, La Fiebre, El Nudo y Los Puntales, con un fondo candidato distinto por vista y sin avanzar la misión al explorar.

**Architecture:** Ampliar `game/data/world.json` por cota: las salidas son hotspots `NAVIGATION` y los pasos entre cotas conservan las rutas y flags actuales. `Viewpoint`, `State`, la escena raíz y el guardado v1 siguen siendo los existentes. Generar los 17 fondos que faltan como candidatos, colocar los puntos sobre cada PNG real y comprobar las rutas en la interfaz.

**Tech Stack:** Godot 4.7.2, GDScript, JSON, PNG 16:9; imagegen integrado para arte candidato.

**Spec:** [Diseño espacial aprobado](../specs/2026-10-21-21-vistas-zonas-design.md).

## Global Constraints

- Conservar los 12 IDs de pantalla actuales y `retorno_agua`; añadir exactamente 9 IDs y 17 PNG candidatos propios.
- Sota vive en La Fiebre, cota 4; el oficio y los ingresos concretos siguen sin definirse. Marcar esa aprobación en los metadatos de `world.json` sin elevarla a canon literario.
- Mantener el primer encuentro con la Jefa y la observación de Velvet en `fiebre_calle`; no añadir diálogos, misiones, credenciales ni recompensas.
- Mantener `ap_cocina` → `fiebre_calle` sujeto al contrato, Fiebre → Nudo y Nudo → Puntales sujetos a `orden_visita`, y las subidas sujetas a los flags vigentes.
- El deck no transporta. Cada enlace aprobado se representa con hotspot físico de ida y vuelta; salidas y puntos quedan visibles a 1280×720 y 844×390.
- La Penumbra no recibe sol directo. Conservar retratos y originales, guardar prompts/versiones de nuevos fondos y marcar cada PNG como candidato hasta revisión artística del autor.
- No añadir observaciones a `story.json` antes de aprobar su texto; la exploración espacial funciona sin ellas.
- Hay cambios previos sin confirmar en el checkout: comprobar Git antes de cada tarea y seleccionar sólo los archivos de la tarea al confirmar. No enviar al remoto.

## Review Focus

1. Partida v1 guardada en `fiebre_calle`: debe cargar y conservar contrato, flags y pantalla tras ampliar el mapa (Tarea 4).
2. Acceso entre cotas sin `orden_visita`: debe informar el bloqueo y no mover a Sota (Tareas 2 y 3).
3. Subida desde El Nudo sin `acreditacion_residencia`: debe bloquearse aunque la bajada estuviera permitida (Tarea 2).
4. Pantalla nueva con salida fuera del recorte móvil: todos los botones deben caber sobre la ilustración y responder a toque (Tareas 1–3).
5. Hotspot que dispara progreso por explorar: `missions`, `flags`, `documents` y `choices` deben permanecer intactos al recorrer las vistas nuevas (Tarea 4).

---

### Task 1: Completar La Fiebre

**Files:**
- Modify: `game/data/world.json` (zona `fiebre`, seis pantallas y metadatos de residencia)
- Modify: `game/tests/run.gd` (inventario parcial, navegación y render)
- Create: `game/assets/backgrounds/candidates/{fiebre_entrada,fiebre_encuentro,fiebre_galeria,fiebre_suministros,fiebre_descenso}.png`
- Create: `art/prompts/zonas_fiebre.md` (referencias, prompts, versiones y límites)

**Interfaces:** Consumes `State.travel_reason(target: String)`, `State.navigate(target: String)` y `Viewpoint.show_screen(value: Dictionary)` sin cambiar sus firmas. Produces seis pantallas de La Fiebre con `implemented: true`, `art` propio y hotspots existentes más enlaces aprobados.

- [ ] **Step 1: Write the failing test.** En `run.gd`, afirmar 15 pantallas registradas y 9 jugables; comprobar las seis IDs de La Fiebre y estos pares: `fiebre_calle` ↔ `fiebre_entrada`, `fiebre_encuentro`, `fiebre_galeria`, `fiebre_descenso`; `fiebre_galeria` ↔ `fiebre_suministros`, `fiebre_descenso`. Verificar que `velvet` sigue siendo `OBJECT`, `jefa` sigue siendo `PERSON`, y que los hotspots nuevos navegan por clic/toque. Comprobar textura existente y área táctil visible en las dos resoluciones.
- [ ] **Step 2: Run red.** `godot --headless --path game --script tests/run.gd`; esperar fallo por 15 pantallas o por las vistas sin implementar.
- [ ] **Step 3: Produce the art.** Generar primero `fiebre_entrada.png` con referencia a `art/originals/sota.png`, `jefa.png` y el pasaje actual; revisar su render a tamaño de juego. Generar después los otros cuatro fondos candidatos. Conservar variantes, prompts y originales; ninguna figura tapa puertas o puntos.
- [ ] **Step 4: Complete world data.** Añadir `fiebre_galeria`, `fiebre_suministros`, `fiebre_descenso` a `zones.fiebre.screens` y `screens`. Activar los dos registros pendientes. Colocar cada `bounds` sobre el PNG real, mantener el diálogo en el pasaje y sustituir sólo el viejo hotspot de límite `transit` por la salida física hacia `fiebre_descenso`; desde allí el acceso a `nudo_acceso` aún explica el límite del hito. Marcar la residencia como decisión aprobada del juego en `proposal`/`cota_status`, sin cambiar rutas.
- [ ] **Step 5: Run green and inspect.** Ejecutar el test headless y el nativo del README; inspeccionar La Fiebre a 1280×720 y 844×390, incluida la observación existente, ida/vuelta y toque. Esperar cero fallos y 9 pantallas jugables.
- [ ] **Step 6: Commit.** Confirmar sólo los datos, tests, arte y prompt de esta tarea como `feat: completar vistas de La Fiebre`.

### Task 2: Completar El Nudo y abrir el primer descenso

**Files:**
- Modify: `game/data/world.json` (zona `nudo` y enlace desde `fiebre_descenso`)
- Modify: `game/tests/run.gd` (inventario parcial, permisos y recorrido)
- Create: `game/assets/backgrounds/candidates/{nudo_acceso,nudo_taller,nudo_terminal,nudo_mercado,nudo_archivo,nudo_paso_inferior}.png`
- Create: `art/prompts/zonas_nudo.md`

**Interfaces:** Consumes las seis vistas de La Fiebre de la Tarea 1 y `orden_visita`/`acreditacion_residencia` ya existentes. Produces seis vistas jugables de El Nudo y el paso físico bidireccional Fiebre ↔ Nudo.

- [ ] **Step 1: Write the failing test.** Afirmar 18 pantallas registradas y 15 jugables; comprobar `nudo_acceso` ↔ `nudo_taller` ↔ `nudo_terminal` ↔ `nudo_archivo` ↔ `nudo_mercado` ↔ `nudo_acceso`, más `nudo_archivo` ↔ `nudo_paso_inferior`. Desde `fiebre_descenso`, verificar bloqueo sin `orden_visita`, bajada al obtenerlo, subida con `acreditacion_residencia` y bloqueo de subida sin esa acreditación. Verificar PNG y hotspots a ambas resoluciones.
- [ ] **Step 2: Run red.** `godot --headless --path game --script tests/run.gd`; esperar fallo de inventario/acceso.
- [ ] **Step 3: Produce the art.** Generar y revisar primero `nudo_acceso.png` junto al control visible de Fiebre; producir los otros cinco fondos y registrar prompts/versiones. Mantener la densidad de técnicos y comerciantes, infraestructura física y ausencia de sol directo.
- [ ] **Step 4: Complete world data.** Añadir tres IDs, activar los otros tres, asignar seis `art` distintos y enlaces del anillo aprobado. En `fiebre_descenso`, convertir el límite a `NAVIGATION` hacia `nudo_acceso` conservando el texto/flag de la ruta; en `nudo_acceso`, añadir regreso físico al control de descenso. No mover la Jefa ni tocar `missions.json`.
- [ ] **Step 5: Run green and inspect.** Ejecutar pruebas headless/nativas y recorrer en la interfaz bajada, regreso y tramo interno a 1280×720 y 844×390. Esperar cero fallos y 15 pantallas jugables.
- [ ] **Step 6: Commit.** Confirmar sólo los archivos de esta tarea como `feat: abrir las vistas de El Nudo`.

### Task 3: Completar Los Puntales y el segundo descenso

**Files:**
- Modify: `game/data/world.json` (zona `puntales` y enlace desde `nudo_paso_inferior`)
- Modify: `game/tests/run.gd` (21 vistas, control y render)
- Create: `game/assets/backgrounds/candidates/{puntales_acceso,puntales_taller,puntales_observatorio,puntales_soportes,puntales_presion,puntales_verificacion}.png`
- Create: `art/prompts/zonas_puntales.md`

**Interfaces:** Consumes El Nudo jugable de la Tarea 2 y el flag existente `orden_visita`. Produces seis vistas jugables de Los Puntales y el paso físico bidireccional Nudo ↔ Puntales.

- [ ] **Step 1: Write the failing test.** Afirmar 21 pantallas registradas y jugables, 3/6/6/6 por zona, 21 fondos distintos; comprobar el anillo `puntales_acceso` ↔ `puntales_taller` ↔ `puntales_observatorio` ↔ `puntales_soportes` ↔ `puntales_presion` ↔ `puntales_verificacion` ↔ `puntales_acceso`. Desde `nudo_paso_inferior`, probar bloqueo sin `orden_visita`, bajada y subida con ella. Verificar PNG y áreas de toque a ambas resoluciones.
- [ ] **Step 2: Run red.** `godot --headless --path game --script tests/run.gd`; esperar fallo de inventario/acceso.
- [ ] **Step 3: Produce the art.** Generar y revisar primero `puntales_acceso.png` contra el paso inferior de El Nudo; producir los otros cinco fondos, versiones y prompts. Mantener soportes y conducciones reconocibles, cuadrillas adultas, accesos despejados y luz práctica.
- [ ] **Step 4: Complete world data.** Añadir tres IDs, activar los tres registrados, asignar seis `art` propios y el anillo aprobado. Enlazar `nudo_paso_inferior` con `puntales_acceso` en ambos sentidos; conservar los requisitos de `world.routes` sin añadir credenciales.
- [ ] **Step 5: Run green and inspect.** Ejecutar pruebas headless/nativas; recorrer ida/vuelta y revisar 1280×720 y 844×390. Esperar cero fallos y 21 pantallas jugables.
- [ ] **Step 6: Commit.** Confirmar sólo los archivos de esta tarea como `feat: completar vistas de Los Puntales`.

### Task 4: Comprobar el mapa completo y registrar límites

**Files:**
- Modify: `game/tests/run.gd` (regresión de guardado v1 y grafo completo)
- Create: `game/tests/fixtures/partida_h1_v1.json` (guardado con `version: 1`, `screen: fiebre_calle`, `zone: fiebre`, `retorno_agua: ACTIVE`, flags `acreditacion_residencia` y `orden_visita`; demás colecciones válidas)
- Modify: `docs/GAME_DESIGN.md`, `docs/ART_DIRECTION.md`, `docs/VALIDACION.md`, `README.md`, `task.md`, `proceso/ESTADO_DEL_PROYECTO.md` (estado implementado/comprobado/aprobado)
- Create: `docs/evidence/zonas_*.png` sólo para capturas necesarias

**Interfaces:** Consumes los 21 IDs, 21 artes y hotspots de las Tareas 1–3. No produce API nueva.

- [ ] **Step 1: Add the final regression.** Crear el fixture v1 indicado; en `run.gd`, cargarlo y comparar `screen`, `zone`, `missions`, `flags`, `documents` y `choices`; recorrer el grafo de hotspots aprobados desde `ap_dormitorio` y comprobar alcance y camino de vuelta de las 21 vistas. Tras navegar por vistas nuevas, afirmar que `missions`, `flags`, `documents` y `choices` no cambian. Probar rutas bloqueadas y autorizadas en ambos sentidos.
- [ ] **Step 2: Run and correct.** Ejecutar el test; corregir sólo omisiones reales de datos o del fixture. La regresión final puede pasar a la primera si las tres cotas ya cumplen el diseño.
- [ ] **Step 3: Verify fully.** Ejecutar los cuatro comandos de «Comprobar» del README, exportar Web con la versión del motor del proyecto y recorrer allí controles, recarga y «Continuar». Inspeccionar capturas a 1280×720 y 844×390 para cada vista nueva, con «Pistas» abierta donde haya muchas salidas. Esperar cero fallos, 21 fondos visibles y ningún aviso repetido por cambiar de vista.
- [ ] **Step 4: Update continuity.** Registrar en español qué se implementó, qué se comprobó y qué fondos/textos siguen pendientes de aprobación del autor. Mantener el canon y los originales intactos. No marcar H1 narrativo/artístico ni los fondos candidatos como aprobados por la prueba técnica.
- [ ] **Step 5: Commit.** Confirmar sólo la regresión, evidencias necesarias y documentos de cierre como `docs: verificar mapa de 21 vistas`. No publicar el reinicio.
