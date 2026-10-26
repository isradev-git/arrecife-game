# Renovación de Los Puntales · plan de implementación

> **Para agentes ejecutores:** usar `superpowers:executing-plans` o `superpowers:subagent-driven-development`. Seguir los pasos de la lista y leer la especificación.

**Objetivo:** sustituir técnicamente los seis fondos activos de Los Puntales por candidatos ilustrados coherentes con la v3 aprobada, sin cambiar juego ni canon.

**Arquitectura:** cada fondo tiene un PNG versionado en `art/iterations/` y una copia consumida por `game/`. `world.json` mantiene IDs y hotspots, cambiando `art` por vista; los prompts se conservan en un solo documento. Los originales permanecen.

**Herramientas:** `image_gen` integrado, Godot 4.7.2, Python estándar, `sips`, Git.

**Especificación:** [diseño de la cota](../specs/2026-10-25-puntales-cota-completa-design.md).

## Restricciones globales

- Referencia artística maestra: `art/originals/sota.png` y `jefa.png`, sin alterar bytes.
- Luz de la v3 aprobada: Penumbra sombría, cielo artificial azul grisáceo, luminarias locales, sin sol directo.
- Seis vistas y todos sus IDs, rutas, documentos y reglas de acceso se conservan; la ficción no cambia.
- PNG antiguos, versiones nuevas y prompts se preservan; los cinco fondos nuevos quedan pendientes de aprobación artística individual.
- Recorte y hotspots legibles a 1280×720 y 844×390; el render de Godot decide posiciones finales.

**Línea base SHA-256, comprobada antes y después:**

| Archivo | Hash |
| --- | --- |
| `art/originals/sota.png` | `5e170db20f0bca73fb25eb923fef45d565f158f3bea0b7227ff6790eed09e81b` |
| `art/originals/jefa.png` | `ef0461a6f4561c7dd7ba3dde0b87fb7a0808cd7af943ffd5dc09f0fe983a8f0d` |
| `puntales_acceso.png` antiguo | `bfac98c3172a796c46898014fdcacba3609b19c98793ee597a5dc56543ea2e54` |
| `puntales_taller.png` antiguo | `7466f7251266a41f68b7d37272963680afc2027049194c3a28c3e13662597c03` |
| `puntales_observatorio.png` antiguo | `c6830c013da64a7202be6b20c3638c7d2c9c8c2bdb4e1917e3b8c129f31c5ad9` |
| `puntales_soportes.png` antiguo | `751836094a965b6029cc36dec1364b882b9f1326bde1467c1de5e3c7b3b48260` |
| `puntales_presion.png` antiguo | `b02bf0040a4aa68ca0263ac13ae835f8c3cb43c77f03c873325e803fab80f189` |
| `puntales_verificacion.png` antiguo | `a14bd5943823de624c5bed8696a834b7031784aece835a27e00517024027722c` |

**Ajuste tras revisión:** la v1 de soportes situaba la marca sobre hormigón. Se conservó y se editó una v2 con pintura continua sobre unión metálica corroída; la v2 es la integrada. Los demás candidatos quedaron en v1 y el acceso en v3.

## Focos de revisión

1. Los retratos no se modifican y su estilo domina los cinco fondos nuevos.
2. Tres objetos de misión (`marca_soporte`, `lectura_actual`, `verificacion_fisica`) siguen visibles y pulsables.
3. Cada vista conserva salidas distintas, incluida la conexión con El Nudo.
4. No aparece sol real, acabado fotográfico ni otra cota disfrazada de Puntales.
5. Las capturas móviles no ocultan rutas bajo cabecera, paneles o recorte.

---

### Task 1: generar los cinco fondos restantes

**Archivos:** crear `art/prompts/zonas_puntales_canon_2026-10-25.md` y cinco `art/iterations/zonas_puntales/puntales_<vista>_canon_v1.png` (taller, observatorio, soportes, presion, verificacion).

**Entradas:** especificación, `puntales_acceso_canon_v3.png`, retratos originales, PNG antiguo de cada vista y hotspots de `world.json`.

**Salida:** cinco candidatos 16:9, uno por vista, con prompt final reproducible y rutas/objetos visibles.

- [x] **Paso 1:** registrar hashes de los retratos, v3 y seis PNG activos; comprobar que las cinco rutas y tres objetos de misión descritos en la especificación coinciden con `world.json`.
- [x] **Paso 2:** redactar cinco prompts distintos en `art/prompts/zonas_puntales_canon_2026-10-25.md`, etiquetando el papel de cada referencia y el hotspot que guía la composición.
- [x] **Paso 3:** generar un PNG por vista con `image_gen`; inspeccionar cada resultado y corregir sólo el fallo concreto si hay rutas tapadas, acabado fotográfico o luz incorrecta.
- [x] **Paso 4:** guardar cada candidato con nombre versionado, comprobar tamaño y revisar todos a 844×390; conservar variantes que se generen.

### Task 2: integrar y comprobar la cota

**Archivos:** crear seis copias versionadas en `game/assets/backgrounds/candidates/`; modificar sólo `art` y, si el render lo exige, `bounds` de hotspots en `game/data/world.json`; actualizar `docs/ART_DIRECTION.md`, `docs/VALIDACION.md`, `task.md` y `proceso/ESTADO_DEL_PROYECTO.md`.

**Entradas:** seis candidatos de Task 1 y la v3 aprobada; `Viewpoint.show_screen()` carga el `art` por nombre.

**Salida:** juego activo con seis fondos nuevos y rutas funcionales, pendiente de aprobación artística final de las cinco vistas nuevas.

- [x] **Paso 1:** copiar los seis PNG con nombres versionados a `game/assets/backgrounds/candidates/`; cambiar los seis valores `art` en `world.json`, sin renombrar IDs ni tocar misiones.
- [x] **Paso 2:** importar Godot y ejecutar las pruebas headless del README; corregir sólo fallos causados por esta integración.
- [x] **Paso 3:** ejecutar prueba nativa con GPU, inspeccionar las doce capturas de las seis vistas a 1280×720 y 844×390 y ajustar `bounds` si algún marcador cae fuera del elemento visual.
- [x] **Paso 4:** ejecutar las pruebas de guardado del README, preservación y exportación Web; registrar cualquier límite previo de preservación separado de los cambios de arte.
- [x] **Paso 5:** documentar qué se integró, qué se comprobó y qué espera aprobación del autor, con enlaces a los candidatos y capturas.

**Verificación esperada:** suites principales sin fallos, fondos únicos y encontrados, navegación de ida/vuelta, seis vistas legibles en ambos tamaños, originales y PNG antiguos intactos. No se publica el juego.
