# El Arrecife · experiencia ilustrada

**Dirección aprobada por el autor el 18 y 19 de octubre de 2026.** Juego de aproximadamente 30 minutos para conocer El Arrecife, su canon, a Sota y a otras personas mediante exploración, conversaciones opcionales e interacción con objetos. Sin caso que resolver, crimen central, encargos ni lista de objetivos.

Todo el juego se producirá en **3D, con movimiento izquierda/derecha**, escenarios más largos y acabado ilustrado. La primera entrega de unos 30 minutos podrá ampliarse con nuevo lore. Se abandona el pixel art. El estilo de los retratos de Sota y Jefa guía personajes y escenarios. **La prioridad de producción es una Sota que camine de forma convincente**, con arranque, parada y cambio de dirección cuidados.

## Trabajo actual

- [Continuidad vigente](proceso/ESTADO_DEL_PROYECTO.md).
- [Tareas](task.md), [plan](proceso/PLAN_GODOT.md).
- [Diseño de experiencia](trabajo/diseno/EXPERIENCIA_ILUSTRADA.md).
- [Dirección artística](trabajo/direccion_artistica.md).
- [Proyecto 3D y laboratorio de locomoción](godot_ilustrado/README.md): importar `godot_ilustrado/project.godot` en Godot 4.7.2 y ejecutar **F5**.

F5 abre **la demo de Velvet 3D**, con 42 m de recorrido lateral, cámara lejana, cuatro encuentros opcionales y visor de Sota en 360°. Sota v7 conserva el movimiento aprobado y revisa cintura, arnés y confección posterior. [Probar en navegador local](http://127.0.0.1:8766/godot_ilustrado/build/web/) · [Capturas, instrucciones y resultados](trabajo/arte/revisiones/demo_velvet_3d_v1/README.md). Es una candidata de demo, pendiente de valoración artística; no contiene los treinta minutos. La pasarela técnica y versiones anteriores siguen disponibles.

## Etapa anterior archivada

[Respaldo completo, verificación e instrucciones de recuperación](proceso/ARCHIVO_ETAPA_PIXEL_20261018.md). Se conservan código, arte, prompts, versiones, guiones, pruebas y cambios sin confirmar. `godot/` y `juego/` son proyectos históricos de la etapa de investigación/pixel art. No ejecutar esos proyectos esperando encontrar la nueva dirección.

[README histórico](README_ETAPA_PIXEL_20261018.md). No se han borrado recursos ni modificado el canon literario. No hay publicación nueva para jugadores.

Demo actual: **Velvet 3D con Sota v7 y visor 360°**. Abrir `godot_ilustrado/project.godot` y pulsar F5. [Probar y revisar](trabajo/arte/revisiones/demo_velvet_3d_v1/README.md).

## Recuperar los recursos originales

El ZIP original de personajes Quaternius se conserva mediante Git LFS. Después de clonar, ejecutar `git lfs install` y `git lfs pull`. Los recursos jugables y las fuentes editables del proyecto están versionados; las carpetas `.godot/`, `build/` y las credenciales de exportación quedan fuera de Git.
