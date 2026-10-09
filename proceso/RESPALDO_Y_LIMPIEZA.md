# Base recuperable y limpieza

9 de octubre de 2026. Petición del autor: retirar lo innecesario y continuar generando recursos.

## Respaldo

Copia previa a la limpieza: `/Users/glitchbane/Documents/proyectos/el-arrecife-respaldos/base-20261009-234509.tar.gz`. Incluye fuentes, prototipo, versiones de arte, prompts y proyecto Godot; excluye cachés, exportaciones regenerables, metadatos de Finder y credenciales. Recuperación de `godot/project.godot` comprobada en una carpeta temporal con contenido idéntico. El respaldo está en el mismo equipo; no protege frente a pérdida del disco.

Control de versiones Git local iniciado con una base anterior a la limpieza. No se publica ni se crea remoto.

## Retirada realizada

- `godot/build/`: exportación técnica regenerable.
- `godot/.godot/`: caché regenerable; se recreará al importar.
- `godot/assets/fiebre_fondo_v1.png` y su `.import`: copia inactiva. El original y su prompt se conservan en `juego/`.
- Archivos `.DS_Store`: metadatos de Finder.

Se conservan el prototipo JavaScript, pruebas, guion y versiones anteriores: siguen siendo fuentes de migración y referencia. La limpieza no cancela la instalación de Godot ni elimina las plantillas Web.

Resultado: eliminados 47.0 MiB de archivos regenerables y copia inactiva. La caché volverá a existir al importar recursos.

Base Git: `740bbb3`. Recuperación de `godot/project.godot` desde esa revisión comprobada por comparación de bytes. Tras limpieza, las 13 pruebas del prototipo siguen pasando y la escena técnica de Godot sigue cargando su fondo activo. La referencia nueva de Sota importa correctamente; no se regenera la exportación Web en esta entrega.
