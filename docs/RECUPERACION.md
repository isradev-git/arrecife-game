# Preservación y recuperación

20 de octubre de 2026. Inspección inicial: rama `main` limpia, sin trabajo valioso sin seguimiento. `HEAD` y remoto coincidían en **433e0998172180466cdb832060e653ecfc3cd6d1**. El checkpoint previo ya estaba publicado. El autor autorizó el 22 de octubre de 2026 publicar la nueva rama de trabajo.

Antes de retirar archivos se creó **`backup/pre-reboot-20261020`** en ese commit. El reinicio se desarrolla en **`feat/interactive-arrecife-reboot`**.

Además, las carpetas retiradas se trasladaron completas, incluidos los archivos ignorados locales, a:

`/Users/glitchbane/Documents/proyectos/el-arrecife-respaldos/pre-reboot-20261020-433e099/`

Es un respaldo local en el mismo equipo. La base publicada y el historial Git proporcionan otra vía de recuperación; la rama nueva de respaldo es local.

## Retirado del árbol activo

`godot/`, `godot_ilustrado/`, `juego/`: escenas, movimiento, locomoción, shaders, modelos, atlas, pruebas y exportaciones antiguas. `trabajo/`: producción, fuentes y revisiones de aquellas etapas, prompts y diseños abandonados. Documentación histórica de `proceso/` y archivos raíz `*_ETAPA_PIXEL_20261018.md`. Se reescriben README, AGENTS y task para el nuevo juego. Las carpetas históricas completas permanecen en la copia local y sus archivos versionados en la rama de respaldo.

## Protegido

- `canon_el_arrecife.md` intacto; SHA256 en `PRESERVACION.json`.
- Retratos originales Sota/Jefa, copias de producción idénticas y procedencia.
- Guardia y dos figuras del acceso en originales históricos; no eran retratos ilustrados.
- Licencias y atribución Quaternius en `docs/attribution/`. Los ZIP y todos sus recursos siguen en el respaldo, no en el juego.
- Historia de Git, incluidos prompts, versiones fallidas y aprobaciones históricas.

No había `sources/` ni `universo/` en el checkout. No se ha eliminado material de esas rutas ni se presupone haberlo leído.

## Recuperar sin tocar el juego nuevo

Para inspeccionar un archivo:

```sh
git show backup/pre-reboot-20261020:proceso/ESTADO_DEL_PROYECTO.md
```

Para abrir la etapa anterior en una carpeta separada:

```sh
git worktree add ../arrecife-etapa-anterior backup/pre-reboot-20261020
```

Si se recupera desde un clon remoto, el mismo estado es `433e099`. El ZIP histórico Universal Base Characters usa Git LFS: instala Git LFS y ejecuta `git lfs pull` dentro de ese checkout para obtenerlo. La copia local trasladada ya conserva el ZIP completo.

`python3 game/tests/preservation.py` comprueba canon, recursos protegidos y que sólo haya un proyecto activo. La autorización del 22 de octubre se refiere al push de `feat/interactive-arrecife-reboot`; no cambia `main` ni publica la rama local de respaldo.
