# PASE PENDIENTE · Base Godot

Preparación técnica del 9 de octubre de 2026. **Todavía no contiene el caso jugable ni el movimiento de Sota.** La escena principal actual permite revisar ambos perfiles de Sota en Velvet, su altura y filtrado. La escena técnica anterior se conserva en `verificacion.tscn`.

**Entrega pixel art · 11 de octubre:** el autor rechaza el primer atlas por cara definida y píxel fino. La propuesta v3 conserva dos perfiles propios, con píxel más intenso y cara resuelta en manchas, sobre el Velvet aportado por el autor. La escena alterna entre rechazado y nuevo; nearest inicial para ambos. [Comparación nativa y límites](../trabajo/arte/revisiones/escala_v4/README.md). Importación, pruebas y exportación correctas; pendientes valoración del autor, retícula, luz y comprobación visual Web. [Dirección vigente](../trabajo/direccion_artistica.md).

## Instalación comprobada

- Editor estándar **4.7.2.stable.official.ed1daf0bf**, en `/Applications/Godot.app`.
- Plantillas **Web** de la misma versión, en `~/Library/Application Support/Godot/export_templates/4.7.2.stable/`.
- Descarga desde las publicaciones oficiales de [godot-builds](https://github.com/godotengine/godot-builds/releases/tag/4.7.2-stable); SHA-512 de editor y paquete de plantillas contrastados con `SHA512-SUMS.txt`. Firma del editor y evaluación de Gatekeeper correctas.
- Solo se instalaron las plantillas Web. Para distribuir ejecutables de otras plataformas habrá que instalar también sus plantillas.

Abrir Godot e importar `project.godot`, o ejecutar desde la raíz del repositorio de trabajo:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --editor --path godot
```

F5 ejecuta la revisión de escala. Los botones cambian vista, altura, ubicación y filtrado; todavía no hay desplazamiento. [Comparación vigente y capturas](../trabajo/arte/revisiones/escala_v4/README.md). El proyecto usa GDScript y Compatibility; la exportación Web desactiva hilos y extensiones. No necesita .NET ni complementos.

## Repetir la comprobación y exportar

Desde la raíz `el-arrecife/`:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --editor --import
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script tests/verificacion.gd
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --script tests/escala.gd
mkdir -p godot/build/web
/Applications/Godot.app/Contents/MacOS/Godot --headless --path godot --export-release Web
python3 -m http.server 8766 --bind 127.0.0.1 --directory godot/build/web
```

Con ese servidor, abrir `http://127.0.0.1:8766/`. Si el puerto está ocupado, cerrar el servidor de la sesión anterior o escoger otro. No abrir el HTML exportado mediante `file://`: servirlo por HTTP local o HTTPS público. Detener el servidor con Ctrl+C.

Durante la verificación de esta entrega se sirvió la raíz completa del proyecto en el puerto 8766; por eso la pestaña de prueba usa `http://127.0.0.1:8766/godot/build/web/`. La prueba no publica el juego en Internet y el servidor no debe darse por activo en futuras sesiones.

## Resultado registrado

| Prueba | Resultado |
| --- | --- |
| Versión, SHA-512, firma y Gatekeeper | Correctos. |
| Importación del proyecto y apertura del editor gráfico | Correctas; Compatibility en Apple M4. |
| Comprobación automática | Pasa: escena instanciada, textura de ancho 1672, foco del botón y señal que actualiza texto. |
| Exportación Web release | Termina con código 0. Paquete de aproximadamente 40 MiB sin compresión de transporte; no es el peso del futuro juego completo. |
| Safari por HTTP local | Fondo, interfaz, respuesta al clic, recarga y activación con Enter comprobados visualmente. |

No se ha validado aquí guardado, audio, lectores de pantalla, móvil, otros navegadores ni rendimiento del juego completo. El árbol de accesibilidad de Safari expone esta prueba principalmente como un canvas: los controles nativos de Godot no heredan automáticamente la accesibilidad HTML del prototipo. Hay que comprobarla expresamente al migrar la libreta.

Cambio posterior del mismo día: el fondo activo pasa a Velvet. Importación, comprobación automática y exportación Web repetidas con resultado correcto; la prueba visual en Safari de la tabla corresponde a la entrega anterior.

Revisión de escala posterior: cuatro vistas y tres alturas verificadas por prueba automática y capturas nativas. La exportación Web se regenera correctamente. La prueba en Safari de la tabla corresponde a la escena técnica anterior: no se ha observado todavía la revisión nueva en navegador.

Decisión del 10 de octubre: el autor aprueba el aspecto de Sota en escena y elige solo perfiles. Los controles actuales ya no ofrecen frontal ni tres cuartos; el atlas original se conserva. [Revisión vigente](../trabajo/arte/revisiones/escala_v2/README.md). Respiración, carrera y cambios de dirección animados siguen pendientes.

## Recursos y continuidad

La revisión actual usa `assets/fiebre_velvet_pixel_v1.png`, copia idéntica de la [imagen 1 aprobada](../trabajo/arte/referencias/pixel_art_v1/README.md), y `assets/personajes/sota/perfiles_pixel_v3.png` con medidas en su JSON. El fondo sigue aplanado. Se conservan el atlas anterior para comparar y `assets/fiebre_velvet_v1.png` para la escena técnica; este último es copia del recurso del prototipo con el neón renombrado a **VELVET** por decisión del autor. [Procedencia y valoración](../juego/arte/velvet_v1.md); [prompt](../juego/arte/prompts/velvet_rotulo_v1.txt). La versión anterior se conserva en `juego/assets/fiebre_fondo_v1.png`; se retiró su copia inactiva de Godot durante la limpieza.

La carpeta `build/` y la caché `.godot/` se pueden regenerar y están excluidas del control de versiones. Los archivos de importación y UID junto a recursos/scripts sí forman parte del proyecto reproducible. No distribuir canon, guion de moderación o documentos de proceso como parte del paquete Web.

Siguiente trabajo: [plan de migración y criterios de cierre](../proceso/PLAN_GODOT.md). Estado general: [continuidad](../proceso/ESTADO_DEL_PROYECTO.md).
