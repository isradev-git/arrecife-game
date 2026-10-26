# Muestra de Los Puntales · plan de implementación

> **Para agentes ejecutores:** habilidad requerida: `superpowers:executing-plans` o `superpowers:subagent-driven-development`. Seguir los pasos marcados con `- [ ]` y leer antes la especificación.

**Objetivo:** producir un PNG candidato de `puntales_acceso` que exprese D225 y pueda compararse con el fondo actual sin alterar el juego.

**Arquitectura:** usar la generación integrada de imágenes con los retratos originales como referencia de estilo y el PNG actual sólo como referencia de destinos. Guardar una versión nueva y su prompt en `art/`; `world.json` seguirá apuntando al fondo actual.

**Herramientas:** `image_gen` integrado, `view_image`, `sips`, Git, Godot 4.7.2 sólo si se llegara a integrar el fondo en una tanda posterior.

**Especificación:** [diseño aprobado](../specs/2026-10-25-puntales-muestra-canon-design.md).

## Restricciones globales

- Conservar `art/originals/sota.png`, `art/originals/jefa.png` y `game/assets/backgrounds/candidates/puntales_acceso.png` byte a byte.
- La muestra es una ilustración horizontal 2D en primera persona, sin avatar, manos, texto legible ni acabado fotográfico.
- Retorno a El Nudo a la izquierda, taller en el centro y verificación a la derecha; rutas despejadas para los hotspots de `world.json`.
- Paleta y materiales D225: hormigón gris con polvo, acero oscuro, imprimación rojo óxido y lonas azules; soldadura naranja sólo local; cielo artificial entre estructuras.
- El candidato no cambia escenas, diálogos, misiones, partidas ni canon y queda pendiente de aprobación artística del autor.

## Focos de revisión

1. **Recorte horizontal móvil:** los tres destinos siguen distinguibles a 844×390.
2. **Figuras en primer plano:** ninguna bloquea las tres rutas ni el centro observable.
3. **Luz exterior:** no se lee como sol real en Penumbra.
4. **Estilo:** contornos y sombras conviven con los retratos; nada fotorrealista.
5. **Preservación:** original, fondo activo y `world.json` no cambian.

---

### Task 1: producir y revisar la muestra

**Archivos:**
- Crear: `art/iterations/zonas_puntales/puntales_acceso_canon_v1.png` — candidato visual.
- Crear: `art/prompts/puntales_acceso_canon_v1.md` — prompt final, referencias, herramienta y límites.
- Modificar: `task.md` y `proceso/ESTADO_DEL_PROYECTO.md` — implementación, comprobación y aprobación diferenciadas.

**Entradas:** `art/originals/sota.png`, `art/originals/jefa.png`, `game/assets/backgrounds/candidates/puntales_acceso.png`, `game/data/world.json` y el diseño aprobado.

**Salida:** un PNG versionado fuera de `game/`, con prompt reproducible, listo para valoración del autor.

- [x] **Paso 1:** registrar con `shasum -a 256` los dos retratos y el PNG activo; leer los cuatro hotspots de `puntales_acceso` en `world.json`.
- [x] **Paso 2:** redactar `art/prompts/puntales_acceso_canon_v1.md` con el prompt de generación, roles de las tres referencias, restricciones del diseño y estado de candidato.
- [x] **Paso 3:** generar una ilustración con `image_gen` integrado, usando el fondo actual sólo para orientación de rutas y los dos retratos sólo para estilo.
- [x] **Paso 4:** inspeccionar el resultado a tamaño completo; si falla un foco de revisión, repetir con una sola corrección dirigida. Guardar la versión elegida como `puntales_acceso_canon_v1.png`.
- [x] **Paso 5:** comprobar dimensiones con `sips`, mirar el PNG a tamaño de juego y horizontal móvil, verificar visualmente los cinco focos de revisión y confirmar con `shasum`/`git diff` que los originales y el fondo activo no han cambiado.
- [x] **Paso 6:** registrar el resultado real en `task.md` y `proceso/ESTADO_DEL_PROYECTO.md`; mostrar el candidato al autor y marcar su aprobación artística como pendiente.

**Verificación esperada:** archivo y prompt presentes, `git diff --check` limpio, tres destinos visibles en la muestra, ninguna modificación de `game/` ni de los originales. Las suites del README se ejecutarán al integrar un fondo en el juego, no al producir esta muestra externa.
