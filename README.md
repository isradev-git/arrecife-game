# EL ARRECIFE

Aventura narrativa **2D ilustrada, en primera persona**, en el universo de *CARGA ADMISIBLE*. Exploras a través de los ojos de Sota: clic o toque sobre objetos, personas y accesos. Godot **4.7.2**, GDScript y español de España.

## Estado: hito 1 jugable

Menú, introducción saltable, tres habitaciones, una primera vista de La Fiebre, interacciones, diálogo con retratos originales, deck, mensajes, contrato, documentos, terminal y guardado local. El contrato puede recibirse, aceptarse y avanzar hasta contrastar el parte con la Jefa.

**No es todavía la aventura completa de 30 minutos.** El Nudo, Los Puntales, la resolución y el final están pendientes. Los cuatro fondos son candidatos ilustrados; la ficción nueva y el arte requieren revisión del autor.

## Abrir y jugar

1. Abre Godot 4.7.2 e importa **`game/project.godot`**.
2. Pulsa **F5** y selecciona **Jugar**. También puedes ejecutar:

```sh
godot --path game
```

En este Mac:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path game
```

Todo se juega con clic o toque. **Deck** abre mensajes, contratos, archivo, noticias, contactos y lugares. Los objetos y accesos se tocan directamente en la ilustración; pequeños puntos de luz indican dónde. **Pistas** abre la lista de acciones y permite ocultar los puntos. Los textos extensos se desplazan. Se recomienda horizontal.

### Recorrido de comprobación

Deck → mensaje de la Jefa → revisar y aceptar contrato → cocina → terminal doméstico → copiar lectura → cerrar → salir a La Fiebre → hablar con la Jefa → mostrar la lectura. Puedes visitar el baño, mirar el espejo y leer el recibo antes o después. El acceso a El Nudo explica el límite del hito. Menú → Continuar recupera el progreso.

### Web local

Instala las plantillas de exportación de **la misma versión** del motor:

```sh
godot --headless --path game --export-release Web
python3 -m http.server 8767 --bind 127.0.0.1 --directory game/build/web
```

Abre `http://127.0.0.1:8767`. El directorio `build/` es regenerable y está excluido de Git. No abras el HTML con `file://`. La exportación Web usa Compatibility, sin hilos ni extensiones.

El guardado usa `user://partida.json` y una copia `.bak`; una partida nueva conserva además una copia `.previa-*`. En navegador depende del almacenamiento del sitio: borrar sus datos, cambiar de origen o usar modo privado puede hacer perder el acceso al progreso. No hay guardado en la nube.

## Comprobar

```sh
godot --headless --path game --editor --import --quit
godot --headless --path game --script tests/run.gd
godot --path game --script tests/run.gd
python3 game/tests/preservation.py
```

La prueba con GPU guarda capturas reales en `docs/evidence/`; usa partidas temporales aisladas. [Resultados y límites](docs/VALIDACION.md).

## Organización

- `game/`: único juego activo. Datos narrativos en JSON; controles nativos reutilizables.
- `art/originals/`: originales protegidos, incluidos los dos retratos y las figuras históricas del acceso.
- `art/prompts/`: especificaciones exactas usadas para los fondos candidatos.
- `docs/`: diseño, dirección artística, validación, preservación y atribución.
- `canon_el_arrecife.md`: canon literario, sólo consulta.
- `proceso/ESTADO_DEL_PROYECTO.md`: continuidad vigente.

[Diseño](docs/GAME_DESIGN.md) · [Arte](docs/ART_DIRECTION.md) · [Tareas](task.md) · [Recuperación de las etapas anteriores](docs/RECUPERACION.md).

El reinicio vive en `feat/interactive-arrecife-reboot`. Las etapas anteriores están respaldadas en `backup/pre-reboot-20261020`, desde `433e099`. **Este reinicio no se ha enviado al remoto.**
