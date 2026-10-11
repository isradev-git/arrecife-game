# Velvet · Revisión de oclusión T07.1

Seis capturas nativas de Godot 4.7.2 en Apple M4, 11 de octubre de 2026. Sota base_v1, altura 252, suelo y = 710, posición Galería y luz de Velvet. [Recursos y prompts](../../entornos/velvet/capas_v1/README.md).

| Modo | Perfil derecho | Perfil izquierdo |
| --- | --- | --- |
| Barandilla delante | [Captura](delante_0.png) | [Captura](delante_1.png) |
| Barandilla detrás | [Captura](detras_0.png) | [Captura](detras_1.png) |
| Sin barandilla | [Captura](sin_barandilla_0.png) | [Captura](sin_barandilla_1.png) |

Para repetir la revisión: ejecutar `godot/project.godot` con F5, pulsar **Galería** y alternar **Barandilla delante / Detrás / Ocultar** en ambos perfiles. «Ocultar» permite comprobar el fondo reparado.

`godot/tests/capas.gd`, ejecutado sin `--headless`, comprueba el render de las mismas posiciones: 290/223 píxeles de Sota ocultos por metal opaco y 4079/3796 visibles en las aberturas en perfiles derecho/izquierdo. Al invertir el orden, el personaje vuelve a cubrir el metal en las muestras opacas. Se detectó metal semitransparente en el PNG generado y se resolvió con recorte de alfa en shader; las capturas aquí reflejan esa corrección.

Importación, pruebas de escala/materiales/apoyos y escena técnica, prueba GPU de oclusión y exportación Web correctas. Revisión visual del asistente de ambos perfiles y fondo reparado. **No se ha comprobado esta entrega visualmente en navegador ni animada.** Solo se separa el tramo central; humo, luces, figurantes y ciudad permanecen pintados en el fondo. Sin aprobación estética nueva del autor todavía.
