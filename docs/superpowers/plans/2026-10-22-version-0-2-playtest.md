# Plan de implementación · El Arrecife 0.2.0

> **Para agentes de desarrollo:** usar superpowers:executing-plans y registrar los avances por tarea.

**Goal:** Dejar la aventura 0.2.0 preparada para una primera partida con diálogos alineados y conversaciones persistentes por el deck.

**Arquitectura:** El diálogo reutiliza su fila actual y sitúa el bloque central junto a los retratos. Los chats reutilizan `story.messages`, `State.data.messages` y `State.data.choices`; `Device` agrupa las entradas visibles por remitente y `State` calcula las no leídas. No se cambia el formato del guardado.

**Tecnología:** Godot 4.7.2, GDScript, JSON, exportación Web Compatibility.

**Especificación:** [Diseño 0.2.0](../specs/2026-10-22-version-0-2-playtest-design.md).

## Restricciones

- Un solo juego activo: `game/project.godot`; trabajo y documentación en español.
- No modificar `canon_el_arrecife.md`, retratos originales ni sus copias.
- Apartamento y tres cotas: 21 vistas, tres contratos y dos finales conservados.
- Móvil sólo horizontal; escritorio 1280×720 y móvil horizontal 844×390 en pruebas visuales.
- Mantener guardado interno v1 y carga de partidas anteriores.

## Revisión

- Mensaje de misión ya leído: reabrirlo no ofrece ni acepta de nuevo el contrato; probar en tarea 2.
- Respuesta elegida y recarga: se ve la misma réplica; probar en tarea 2.
- Mensajes futuros: no aparecen al entrar en un hilo antiguo; probar en tarea 2.
- Texto largo y resolución baja: diálogo y chats siguen desplazables y el cierre accesible; probar en tareas 1 y 3.
- Guardado v1 anterior: los mensajes nuevos no invalidan IDs ni elecciones antiguas; probar en tarea 2.

---

### Task 1: Composición del diálogo

**Files:** `game/scripts/ui/dialogue.gd`, `game/tests/run.gd`.

**Interfaces:** El bloque central conserva `column`, `advance()` y los botones existentes; se alinea con `sota` y `other` sin tocar los PNG.

- [x] Añadir prueba de posición vertical del bloque de texto junto a la cabeza de los retratos a 1280×720 y 844×390; capturar ambas vistas.
- [x] Ejecutar `godot --headless --path game --script tests/run.gd` y comprobar el fallo esperado.
- [x] Ajustar tamaño y alineación vertical del `VBoxContainer` central en `dialogue.gd`.
- [x] Repetir prueba headless y nativa; inspeccionar capturas y desplazamiento de texto largo.

### Task 2: Hilos y contenido por hitos

**Files:** `game/data/story.json`, `game/scripts/core/state.gd`, `game/scripts/ui/device.gd`, `game/scripts/ui/main.gd`, `game/tests/run.gd`.

**Interfaces:** `State.unread_messages() -> Array[String]`; `Device.show_tab(host, selected, contact)`; `Main.show_device(tab, contact)`; elecciones en `State.data.choices["message:" + id]`.

- [x] Añadir prueba de remitentes, aparición condicionada, lectura, oferta original y respuesta persistente; comprobar el fallo.
- [x] Añadir episodios breves de madre, hermana, Lía y Jefa en `story.json`, conservando los mensajes de misión.
- [x] Implementar agrupación por remitente, bocadillos de chat, elección guardada y contactos condicionados.
- [x] Mostrar indicador de no leídos junto al botón Deck y actualizarlo cuando cambie `State`.
- [x] Repetir pruebas, incluida partida v1 anterior y ambos desenlaces.

### Task 3: Versión, primera prueba y cierre

**Files:** `game/project.godot`, `game/data/story.json`, `README.md`, `docs/GAME_DESIGN.md`, `docs/VALIDACION.md`, `docs/ART_DIRECTION.md`, `docs/GUIA_PRIMERA_PARTIDA.md`, `task.md`, `proceso/ESTADO_DEL_PROYECTO.md`, `game/tests/run.gd`.

- [x] Fijar 0.2.0 en proyecto, créditos y documentación vigente; conservar referencias históricas con contexto.
- [x] Crear guía breve, sin spoilers, para el primer jugador y sus observaciones.
- [x] Importar; ejecutar pruebas headless, nativas y preservación; exportar Web y abrirla por HTTP.
- [x] Inspeccionar capturas de conversación y chats en escritorio y horizontal móvil.
- [x] Actualizar evidencia, continuidad y tareas, revisar diff y preparar el commit y push autorizados.
