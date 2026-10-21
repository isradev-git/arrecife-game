# Diseño espacial de las 21 vistas

**Estado:** mapa, nombres, conexiones y residencia de Sota aprobados por el autor el 21 de octubre de 2026. Las composiciones y los fondos finales requieren revisión artística; las situaciones, diálogos y misiones nuevos requieren aprobación narrativa.

## Objetivo y límite

El juego tendrá 21 vistas fijas en primera persona: 3 del apartamento y 6 de cada una de las cotas La Fiebre, El Nudo y Los Puntales. Cada vista será un lugar reconocible y navegable por clic o toque, con regreso claro. El deck informa de lugares, pero no transporta. Se conserva el único proyecto `game/project.godot` y el recorrido jugable actual.

El autor ha decidido que **Sota vive en La Fiebre, cota 4, porque su trabajo le permite pagarlo**. Esta decisión pertenece al juego. El oficio, sus ingresos concretos y sus relaciones no se deducen de ella. La ubicación de la vivienda ya no está pendiente de aprobación; el resto de situaciones y textos creados para el juego siguen sujetos a revisión. No se modifica `canon_el_arrecife.md`.

Este alcance incluye mapa, fondos candidatos, salidas físicas y observaciones ambientales breves. No añade las misiones 2 y 3, desenlaces, personajes conversables, nuevas credenciales ni rutas clandestinas. La misión actual sólo conserva sus condiciones de acceso existentes.

## Decisión de estructura

Una secuencia lineal de 18 vistas urbanas sería sencilla, pero haría artificial el regreso. Un mapa libre con saltos desde el deck contradiría los controles físicos entre cotas. Se propone una **red pequeña por cota**: un lugar reconocible de llegada, un recorrido principal y atajos visibles. Las salidas se representan como puertas, pasos o controles concretos en el fondo. La persona puede retroceder sin quedar encerrada por un objetivo narrativo.

## Inventario

Los IDs existentes se conservan. El autor aprobó los nombres y funciones espaciales de las nueve vistas nuevas para este juego; no establecen hechos nuevos del canon.

| Zona | ID | Vista y función espacial | Estado actual |
| --- | --- | --- | --- |
| Apartamento | `ap_dormitorio` | Dormitorio; entrada inicial y deck | Jugable |
| Apartamento | `ap_cocina` | Salón/cocina; distribuidor de las habitaciones y salida | Jugable |
| Apartamento | `ap_bano` | Baño; extremo doméstico | Jugable |
| La Fiebre | `fiebre_calle` | Pasaje junto a Velvet; referencia y llegada desde casa | Jugable |
| La Fiebre | `fiebre_entrada` | Umbral de Velvet; transición entre calle y local | Registrada, sin fondo |
| La Fiebre | `fiebre_encuentro` | Rincón de trato adyacente; espacio de mesa, sin trasladar aún el diálogo existente de la Jefa | Registrada, sin fondo |
| La Fiebre | `fiebre_galeria` | Galería de residentes; circulación cotidiana sobre el pasaje | Nueva |
| La Fiebre | `fiebre_suministros` | Pasarela de suministros; zona de reparto y servicio | Nueva |
| La Fiebre | `fiebre_descenso` | Control de descenso; entrada física hacia El Nudo | Nueva |
| El Nudo | `nudo_acceso` | Llegada desde La Fiebre; control y circulación pública | Registrada, sin fondo |
| El Nudo | `nudo_taller` | Taller de reparaciones; trabajo visible | Registrada, sin fondo |
| El Nudo | `nudo_terminal` | Puesto de red; infraestructura y conexión física | Registrada, sin fondo |
| El Nudo | `nudo_mercado` | Intercambio de componentes; comercio y circulación | Nueva |
| El Nudo | `nudo_archivo` | Archivo de órdenes; soporte físico y consulta | Nueva |
| El Nudo | `nudo_paso_inferior` | Paso controlado hacia Los Puntales | Nueva |
| Los Puntales | `puntales_acceso` | Llegada de cuadrillas y control desde El Nudo | Registrada, sin fondo |
| Los Puntales | `puntales_taller` | Taller de conducción; herramientas y preparación | Registrada, sin fondo |
| Los Puntales | `puntales_observatorio` | Frente de trabajo estructural; se conserva el ID ya registrado | Registrada, sin fondo |
| Los Puntales | `puntales_soportes` | Galería de soportes; lectura de la estructura de la ciudad | Nueva |
| Los Puntales | `puntales_presion` | Cámara de presión; instalaciones materiales | Nueva |
| Los Puntales | `puntales_verificacion` | Puesto de verificación y salida de la zona de trabajo | Nueva |

Las 21 vistas son 3 + 6 + 6 + 6. Hay 12 IDs registrados hoy y 4 fondos jugables; faltan 9 IDs y 17 fondos candidatos para hacerlas todas navegables.

## Conexiones aprobadas para el juego

Cada pareja indicada admite ida y vuelta. Los trayectos entre cotas conservan la regla canónica de que bajar es más fácil que subir; cada sentido se valida por separado. Los controles concretos, la residencia y la orden de visita mantienen las condiciones actuales de `world.json` hasta que se diseñen las misiones.

- **Apartamento:** dormitorio ↔ cocina ↔ baño; cocina ↔ pasaje de La Fiebre.
- **La Fiebre:** pasaje ↔ umbral, pasaje ↔ rincón de trato, pasaje ↔ galería, galería ↔ suministros, galería ↔ control de descenso, control de descenso ↔ pasaje.
- **Cambio de cota:** control de descenso de La Fiebre ↔ acceso de El Nudo.
- **El Nudo:** acceso ↔ taller, taller ↔ puesto de red, puesto de red ↔ archivo, archivo ↔ mercado, mercado ↔ acceso, archivo ↔ paso inferior.
- **Cambio de cota:** paso inferior de El Nudo ↔ acceso de Los Puntales.
- **Los Puntales:** acceso ↔ taller, taller ↔ frente de trabajo, frente de trabajo ↔ galería de soportes, galería ↔ cámara de presión, cámara ↔ puesto de verificación, puesto ↔ acceso.

El pasaje conserva por ahora la conversación de la Jefa y los objetos del hito 1. El rincón de trato es un espacio nuevo; mover la conversación allí sería una decisión narrativa posterior. No se atribuye a la Jefa la propiedad de Velvet.

El enlace actual del pasaje con El Nudo es un límite jugable, no una ruta terminada. Al construir el control de descenso se trasladará allí ese enlace sin perder la condición ni el texto vigente; las partidas guardadas en `fiebre_calle` seguirán cargando.

## Lectura visual

La cámara permanece fija a la altura de Sota, sin avatar visible, en 16:9. Se mantienen el contorno oscuro, las masas de sombra y el detalle selectivo de los retratos originales. Todas las vistas están en la Penumbra: ninguna recibe sol directo. La ciudad debe verse acumulada, reparada y poblada en varias profundidades.

| Zona | Identidad visual y continuidad |
| --- | --- |
| Apartamento | Se conservan los tres fondos actuales. La puerta de cocina debe corresponder con el dormitorio, el baño y la salida; la ventana recibe luz filtrada por bruma, no sol. |
| La Fiebre | Rojos y ciruela de locales, luz práctica ámbar y sombra azul verdosa. Residentes, visitantes y trabajadores adultos comparten calles y galerías sin bloquear accesos. El umbral reproduce la puerta de Velvet visible a la izquierda del pasaje; el rincón de trato se relaciona con el acceso derecho sin convertirlo en recepción de Velvet. |
| El Nudo | Cian y verde apagados de red y reparación, paneles físicos, piezas reutilizadas, tránsito denso de técnicos y comerciantes. El acceso visto desde abajo corresponde al control de descenso de La Fiebre. |
| Los Puntales | Gris industrial y luz útil cálida; soportes, uniones, conducciones y cuadrillas en varios planos. El acceso corresponde al paso inferior de El Nudo. No se presenta como una cota vacía ni como una única sala de máquinas. |

Cada fondo nuevo necesita composición propia; no se reutiliza el mismo PNG con otro rótulo. Puertas, pasos y objetos interactivos se mantienen libres de figuras. Los textos legibles y marcadores los dibuja Godot, no quedan incrustados en el PNG. Se conservan originales, versiones y prompts. Los primeros fondos son **candidatos aplanados**; la fuente por capas y la aprobación artística final siguen siendo trabajo separado. La aprobación de los retratos no se extiende a estos fondos.

## Interacción y datos

Las vistas nuevas sólo necesitan navegación y observaciones ambientales breves. Cada salida visible tendrá un hotspot con etiqueta en «Pistas» y un punto discreto sobre el lugar exacto de la ilustración. Una vista sin ruta de retorno o cuya salida quede oculta por la banda superior/inferior no se considera terminada. No se añaden todavía decisiones, pistas de misión, diálogos ni recompensas a estos espacios.

`game/data/world.json` contiene las 21 entradas y los enlaces; `game/data/story.json` sólo las observaciones ambientales aprobadas. El componente `Viewpoint` y el guardado v1 no cambian de formato. Las partidas existentes conservan sus IDs de pantalla y misión. Como aquí no se añaden misiones, la validación de guardados no necesita migración. Se revisará la compatibilidad otra vez al diseñar las misiones 2 y 3.

## Producción y comprobación

Se trabaja por cota, dejando cada tramo navegable: La Fiebre, El Nudo y Los Puntales. Antes de multiplicar fondos de una cota, se revisa una vista candidata nueva de ella a tamaño de juego. Esa revisión de estilo no aprueba automáticamente los demás fondos. Los fondos candidatos se integran sólo tras ubicar hotspots sobre el PNG real; no se inventan coordenadas desde el prompt.

La comprobación técnica requiere: 21 IDs y 21 fondos distintos, grafo alcanzable y retorno desde todas las vistas, controles de cota en ambos sentidos, carga de una partida v1 anterior, ningún avance accidental de misión por explorar, ratón y toque sintético, render a 1280×720 y 844×390, los cuatro comandos de «Comprobar» del README y exportación Web. Las capturas evidencian navegación y legibilidad, no aprobación artística del autor.
