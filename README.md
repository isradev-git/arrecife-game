# EL ARRECIFE

Aventura narrativa **2D ilustrada, en primera persona**, en el universo de *CARGA ADMISIBLE*. Exploras a través de los ojos de Sota: clic o toque sobre objetos, personas y accesos. Godot **4.7.2**, GDScript y español de España.

## Estado: versión 1.0 candidata

Tres pantallas de apertura (logo, autoría y orientación), menú, introducción saltable, tres habitaciones y seis vistas de cada cota: La Fiebre, El Nudo y Los Puntales. Hay exploración por clic/toque, diálogo con retratos originales, deck, mensajes, tres contratos completos, documentos, terminal, ambiente sonoro y guardado local.

El arco narrativo y sus dos decisiones de cierre están implementados. La duración objetivo de unos 30 minutos aún no se ha medido en una partida del autor. Los 21 fondos de exploración y el fondo de menú son candidatos ilustrados; la ficción nueva y el arte requieren su revisión antes de publicar la versión final.

## Abrir y jugar

1. Abre Godot 4.7.2 e importa **`game/project.godot`**.
2. Pulsa **F5**. Después de las tres pantallas de apertura, selecciona **Jugar**. Puedes adelantarlas con clic, toque o Intro antes de que termine su breve espera. También puedes ejecutar:

```sh
godot --path game
```

En este Mac:

```sh
/Applications/Godot.app/Contents/MacOS/Godot --path game
```

Todo se juega con clic o toque. **En móvil se juega sólo en horizontal**: el aviso de giro aparece antes del menú y vuelve a cubrir la partida si se gira el dispositivo a vertical. En ordenador se puede usar cualquier orientación de ventana. El menú muestra la ciudad desde una ventana, sin retrato de Sota; sus opciones son enlaces de texto. **Deck** abre mensajes, contratos, archivo, noticias, contactos y lugares; tras el tercer contrato conserva el cierre. Toca los pequeños puntos de luz sobre los objetos y accesos; cada uno tiene un área pulsable acotada alrededor. **Pistas** abre la lista de acciones y permite ocultarlos. Los textos extensos se desplazan. En diálogo, el amarillo avanza el contrato y el gris ofrece información opcional. Opciones permite ajustar por separado ambiente y sonidos de acción.

El logo original de **EL ARRECIFE PRODUCTS**, suministrado por el autor, abre el juego. En Web, la secuencia de apertura se muestra una vez por pestaña: **recargar lleva directamente al menú** y abrir el juego en una pestaña nueva vuelve a mostrarla. El aviso de orientación sigue activo incluso cuando se omite la apertura.

Mientras la exportación Web descarga el motor aparece un fondo neutro; el logo sólo se muestra dentro de la secuencia de apertura.

### Recorrido de comprobación

Deck → mensaje de la Jefa → aceptar el parte del agua → copiar la lectura doméstica → hablar con la Jefa → comprobar la ficha en El Nudo y la conducción en Los Puntales → entregar el parte. Tras cada entrega aparece el siguiente mensaje: la orden duplicada se cierra con un informe en el puesto de red; la prueba de presión vuelve a la Jefa y termina con una decisión sobre las copias. **Menú → Continuar** recupera el progreso.

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
- `art/prompts/`: especificaciones y registro de iteraciones de los fondos candidatos.
- `docs/`: diseño, dirección artística, validación, preservación y atribución.
- `canon_el_arrecife.md`: canon literario, sólo consulta.
- `proceso/ESTADO_DEL_PROYECTO.md`: continuidad vigente.

[Diseño](docs/GAME_DESIGN.md) · [Arte](docs/ART_DIRECTION.md) · [Tareas](task.md) · [Recuperación de las etapas anteriores](docs/RECUPERACION.md).

El reinicio vive en `feat/interactive-arrecife-reboot`. El autor autorizó el 22 de octubre de 2026 su publicación en `origin` como rama de trabajo. Las etapas anteriores están respaldadas en la rama local `backup/pre-reboot-20261020`, desde `433e099`; `main` permanece en ese checkpoint.
