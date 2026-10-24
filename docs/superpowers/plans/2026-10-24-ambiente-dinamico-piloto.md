# Ambiente dinámico del pasaje · plan de implementación

> **Para agentes de desarrollo:** usar `superpowers:executing-plans` para implementar este plan tarea por tarea. Los pasos usan casillas para registrar la comprobación.

**Goal:** Dar vida al pasaje de La Fiebre con neón/reflejo, vapor y bruma ambiental, manteniendo la lectura de la aventura y la opción de reducir movimiento.

**Architecture:** Un `Control` dibuja capas vectoriales translúcidas en coordenadas normalizadas sobre `fiebre_multitud_v2.png`. `Viewpoint` lo incorpora como hijo de la imagen, por debajo de los hotspots, y `Main` conecta el ajuste existente `reduced_motion`. El fondo y el guardado no cambian.

**Tech Stack:** Godot 4.7.2, GDScript, Web Compatibility; sin dependencias nuevas.

**Spec:** [Diseño aprobado](../specs/2026-10-23-ambiente-dinamico-design.md).

## Global Constraints

- Sólo `game/project.godot` es jugable; primera persona con cámara fija.
- Ningún personaje animado; canon, originales y PNG de fondo intactos.
- Efectos detrás de los hotspots y paneles, colocados respecto al rectángulo completo de la ilustración incluso al recortarse en 844×390.
- `reduced_motion` elimina bucles y se aplica al instante; sin cambio de esquema de partida.
- Esta tanda implementa y verifica **sólo el pasaje**. Menú/cielo y las otras 20 vistas siguen a la valoración visual del piloto.

## Review Focus

- Abrir/cerrar la misma vista varias veces: no quedan animaciones duplicadas; prueba de reentrada en tarea 2.
- Redimensionar a 844×390: los efectos siguen sus fuentes en la ilustración, no en la ventana; prueba de geometría en tarea 2.
- Activar «Reducir movimiento» con la vista abierta: los efectos se detienen de inmediato; prueba UI en tarea 2.
- Tocar una salida bajo un efecto: la interacción se conserva; prueba de entrada en tarea 2.
- Mostrar un panel o diálogo: el texto mantiene su contraste; captura e inspección visual en tarea 3.

---

### Task 1: Capas ambientales del pasaje

**Files:**
- Create: `game/scripts/ui/ambient_fiebre.gd`
- Create: `game/tests/ambient_fiebre.gd`

**Interfaces:** `AmbientFiebre.set_motion_enabled(enabled: bool) -> void`; `elapsed: float`; dibuja dentro de su propio rectángulo con coordenadas normalizadas.

- [ ] **Step 1:** Escribir prueba que instancia el control, comprueba que `elapsed` avanza con movimiento y queda fijo al desactivarlo, y que el estado sin movimiento oculta los efectos.
- [ ] **Step 2:** Ejecutar `godot --headless --path game --script tests/ambient_fiebre.gd` y comprobar el fallo inicial.
- [ ] **Step 3:** Implementar capas vectoriales específicas de la composición existente: brillo del neón y reflejo unidos por la misma intensidad; vapor de la unidad visible en la pared derecha; bruma suave dentro del arco lejano. Limitar alpha y variar ritmos sin destellos repentinos. El código de coordenadas es la fuente editable de estas capas; documentar esa procedencia.
- [ ] **Step 4:** Repetir prueba y comprobar 0 fallos.
- [ ] **Step 5:** Commit de efecto y prueba.

### Task 2: Vista y ajuste inmediato

**Files:**
- Modify: `game/scripts/ui/viewpoint.gd`
- Modify: `game/scripts/ui/main.gd`
- Test: `game/tests/ambient_fiebre.gd`

**Interfaces:** `Viewpoint.set_ambient_motion(enabled: bool) -> void`; `Viewpoint.ambient: Control` o `null`.

- [ ] **Step 1:** Ampliar la prueba: sólo `fiebre_calle` recibe efectos; éstos son hijos de `image`, quedan bajo los botones y siguen exactamente `image.size` tras cambiar tamaño. Reentrada no duplica nodos; activar el ajuste desde Opciones modifica la vista abierta y mantiene los hotspots pulsables.
- [ ] **Step 2:** Ejecutarla y comprobar el fallo.
- [ ] **Step 3:** Añadir el control al mostrar `fiebre_multitud_v2`, liberar el anterior al cambiar de vista y aplicar `not State.settings.reduced_motion`; conectar el CheckButton actual y renombrar su etiqueta a «Reducir movimiento».
- [ ] **Step 4:** Repetir la prueba aislada y la suite principal headless.
- [ ] **Step 5:** Commit de integración.

### Task 3: Render, Web y continuidad

**Files:**
- Modify: `docs/ART_DIRECTION.md`, `docs/VALIDACION.md`, `task.md`, `proceso/ESTADO_DEL_PROYECTO.md`
- Test: capturas nativas y Web en carpeta regenerable; `game/tests/preservation.py`.

- [ ] **Step 1:** Capturar dos momentos del pasaje a 1280×720 y 844×390, con movimiento activo y reducido; comprobar que se aprecia el cambio sin tapar salidas o paneles.
- [ ] **Step 2:** Importar, ejecutar suite headless y nativa, preservación y exportación Web; abrir el pasaje por HTTP y comprobar errores de página.
- [ ] **Step 3:** Registrar resultados y límites; dejar menu/cielo y resto de vistas como siguiente lote dependiente de valoración visual.
- [ ] **Step 4:** Revisar diff, commit y push a la rama de trabajo.
