# Sota 3D v1 · prueba de locomoción y vestuario

18 de octubre de 2026. [Fuente del modelo](../../personajes/sota/ilustrada_3d_v1/README.md), [proyecto y controles](../../../../godot_ilustrado/README.md).

## Revisar

- [Laboratorio Web interactivo local](http://127.0.0.1:8766/godot_ilustrado/build/web/).
- [Vídeo nativo, 6 s a 60 FPS](locomocion.mp4).
- [Secuencia](secuencia.png), [marcha derecha](fase_100.png), [izquierda](fase_250.png), [tras la parada](fase_350.png).
- [Registro](validacion.txt).

El proyecto predeterminado es `godot_ilustrado/project.godot`. Importar en Godot 4.7.2 y F5. El Web se regenera con el preset **Web laboratorio**, sin hilos. La exportación es regenerable y no se guarda en Git; servir la raíz del repositorio con `python3 -m http.server 8766`.

## Resultado técnico

Malla completa de Sota de prueba, con ropa, pelo, correa y equipo; 26 piezas, 13908 vértices con pesos normalizados, 65 huesos. Base CC0 y construcción propia documentadas. Retarget nativo entre las distintas posturas de reposo; sin nuevo IK propio, atlas ni espejado de perfil.

El root motion es coherente a 30/60/120 FPS: 3,900002 / 3,899998 / 3,900009 m en 4 s. Se conservan longitudes locales y escala; se comprueba que el destino recibe de verdad la animación. Teclado mediante eventos de entrada Godot, parada estable, inversión, interrupción del giro, clic/llegada, frenada antes del límite y pérdida de foco pasan.

Malla de botas deformada por GPU, 160 muestras después de calentamiento: borde inferior −4,952..+7,477 mm respecto al suelo. Marcadores de punta/talón tomados de la bota, ventanas con diferencia de altura <12 mm y altura máxima de ambos <40 mm: excursión mundial máxima 1,425 y 6,052 mm, con 4 y 26 muestras de contacto por pie respectivamente. **Es una comprobación parcial del apoyo plano, no del rodado completo ni de las transiciones.** La selección asimétrica de ventanas tampoco certifica todo el apoyo de ambos lados.

La primera suela rígida falló con penetración de 39,49 mm. Se retiró su geometría; no se amplió el umbral para ocultarla. Se mantienen los intentos como fuentes históricas. La prueba de contacto requiere GPU: el renderizador dummy de headless no puede hornear la malla.

## Alcance visual

Se inspeccionan renders de ambos sentidos y la secuencia nativa. Web: carga y render WebGL 2.0 en Helium/Chromium; controles comprobados por separado en el registro. No se extiende la validación a Safari/Firefox ni al juego narrativo completo.

Es un **estudio**, no una Sota final ni una aprobación del autor. La cara, pelo, cuello/solapas, puños, pliegues y acabado general necesitan trabajo para acercarse al retrato. Arranque/parada usan mezcla con reposo; el giro es una rotación en el sitio sin clip propio ni bloqueo de pies. No hay colisión de escenario, conversaciones, objetos narrativos ni guardado todavía. La dirección del juego sí está decidida; el arte nuevo y la calidad final del movimiento siguen abiertos.
