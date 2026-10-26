# Auditoría visual de las cotas jugables · 25 oct 2026

## Alcance y estado

Se han cotejado los 18 PNG activos de La Fiebre, El Nudo y Los Puntales con `game/data/world.json`, los retratos originales de Sota y la Jefa, `docs/ART_DIRECTION.md` y la anatomía vertical del canon local (D207–D227, en particular D225–D227). También se ha observado el fondo del menú y el dormitorio. `sources/` y `universo/` no están en este checkout. Los cambios locales previos del canon y del GIF ambiental se han dejado intactos.

Las tres cotas, sus nombres y las 18 vistas están aprobados como estructura del juego. **Los fondos siguen siendo candidatos sin aprobación artística final.** Este documento es un diagnóstico; no aprueba ficción nueva ni incorpora nada al canon.

## Hallazgo principal

Los fondos comparten una plantilla de pasarelas, columnas, lámparas ámbar, suelo mojado y brillos cian/rojos. Se reconocen actividades distintas por los objetos, pero al recorrerlos cuesta sentir el paso entre tres ciudades con función, población y luz propias. Los prompts de 21 oct preceden a las decisiones visuales D225–D227 del 24 oct. Dos fondos finales de Puntales (`puntales_presion` y `puntales_verificacion`) usan además un acabado casi fotográfico que rompe el lenguaje de contorno y sombra de los retratos y de las vistas anteriores.

| Cota | Lo que ya funciona | Lo que falta respecto al canon |
| --- | --- | --- |
| La Fiebre, 4 · D207/D227 | El pasaje de Velvet representa bien un corredor de ocio vivo y mezclado. | La galería residencial, suministros y control aún repiten demasiado la luz roja y el mismo corredor. La cota necesita distinguir el barrio cotidiano del ocio: ventanas habitadas, comercios modestos, reparto y menos publicidad monumental fuera del pasaje. El dormitorio tiene una claridad exterior que conviene identificar visualmente como cielo proyectado o bruma artificial, nunca sol directo. |
| El Nudo, 3 · D219/D220/D226 | Mercado, reparación, archivo y puerto físico están presentes; el cian ayuda a leer conexiones. | Casi todas las vistas se parecen a un gran atrio industrial de otra cota. Faltan cruces de carga, montacargas y señales de rutas reconocibles, además de fragmentos de barrio trabajador. El cian debería señalar circulación o lectura; el ámbar y las lonas rojas dominan ahora demasiadas superficies. El puesto de red debe leerse como nodo de acceso, sin sugerir que alberga los servidores centrales del Sustrato. |
| Los Puntales, 2 · D208–D212/D225 | Las tuberías, talleres y cuadrillas sostienen la actividad de la misión. | Predomina una industria genérica y brillante. Faltan uniones y refuerzos estructurales identificables, polvo de corte, imprimación rojo óxido, lonas azules, marcas de inspección y huellas del gremio y de cuadrillas independientes. Las vistas públicas deberían dejar ver vida civil bajo las obras. Las dos vistas finales requieren rehacerse en ilustración 2D coherente. |

## Revisión por vista activa

| Vista | Diagnóstico para la nueva versión |
| --- | --- |
| `fiebre_calle` | Conservar su papel de corredor de ocio y la mezcla social; reforzar magenta/azul violáceo y rótulos en varias alturas sin tapar Velvet ni el local contiguo. El piloto de bruma/luz depende de esta composición. |
| `fiebre_entrada` | El interior de Velvet ya se distingue del exterior; revisar continuidad de puerta y sala, sin vincular la propiedad del local a la Jefa. |
| `fiebre_encuentro` | El local contiguo funciona como pausa; separarlo aún más del salón de Velvet mediante luz de trabajo y mobiliario propio, sin cambiar la relación narrativa pendiente de aprobación. |
| `fiebre_galeria` | Prioridad alta: representa residentes, pero repite el rojo y los mismos conductos del pasaje; mostrar vivienda y comercio cotidiano. |
| `fiebre_suministros` | Prioridad alta: los carros ya ayudan; reducir la contaminación visual del ocio y distinguir la ruta de servicio de la galería. |
| `fiebre_descenso` | Prioridad alta: el control existe, pero el mismo atrio rojo/ámbar hace débil el cambio hacia El Nudo. Separar lectura de regreso y descenso. |
| `nudo_acceso` | Prioridad alta: convertir el atrio en cruce de carga y transporte con montacargas y destinos legibles por forma/color; mantener las tres salidas. |
| `nudo_taller` | Hacer que el oficio de reparación domine el primer plano, con barrio y circulación detrás, sin repetir el mercado. |
| `nudo_terminal` | Presentar puerto físico, lectores y ventilación como acceso de red vigilado; evitar estética de sala de servidores centrales. |
| `nudo_mercado` | La multitud funciona; sustituir la repetición de lámparas y lonas por una calle de intercambio con rutas de carga diferenciadas. |
| `nudo_archivo` | El papel y las mesas funcionan; reducir la impresión de atrio abierto y precisar archivo local de órdenes. |
| `nudo_paso_inferior` | Prioridad alta: lectura clara del control y del descenso; transición visible del azul petróleo/cian al hormigón/acero de Puntales. |
| `puntales_acceso` | Prioridad alta: mostrar soporte entre moles, refuerzos añadidos y barrio habitado; ahora domina el vestíbulo de fábrica. |
| `puntales_taller` | Mantener herramientas y piezas, pero diferenciarlo de acceso y frente con un trabajo concreto de estructura y marcas de cuadrilla. |
| `puntales_observatorio` | La escala de conducciones funciona; evidenciar la intervención local y su relación con los soportes, sin añadir pruebas narrativas. |
| `puntales_soportes` | Prioridad alta: el soporte central existe, pero necesita cartelas, tirantes y reparación visible; reducir el brillo ámbar uniforme. |
| `puntales_presion` | Prioridad alta: rehacer el acabado fotográfico; conservar la cámara de presión y las salidas necesarias para la misión. |
| `puntales_verificacion` | Prioridad alta: rehacer el acabado fotográfico; conservar puesto, registros y salidas sin inventar resultado del informe. |

## Reglas para producir y revisar candidatos

- Usar `art/originals/sota.png` y `jefa.png` sólo como referencia de lenguaje: contorno firme, sombras amplias, materiales selectivos. Conservar ambos originales sin alterar bytes.
- Crear archivos nuevos versionados y conservar los PNG activos, variantes y prompts anteriores. Los fondos del juego no se sustituyen hasta revisar cada candidato con el autor.
- Mantener vista fija en primera persona, cámara a altura humana, sin manos ni avatar. Los textos legibles y marcas de navegación los dibuja Godot.
- Cada nueva imagen debe partir de la función de **esa vista** y de las salidas y objetos que señala `world.json`; después de elegirla se recolocan los hotspots sobre el PNG real.
- Revisar a 1280×720 y 844×390, incluido recorte, señal de puerta, paneles y opción «Reducir movimiento». El pasaje requiere reajustar su capa ambiental si cambia la composición.
- Comprobar importación, suites del README, preservación y exportación Web al integrar un fondo; realizar al menos un recorrido de ida y vuelta por la cota afectada.

## Orden de producción propuesto, aún sin aprobación

1. Elegir una vista pública de Los Puntales como muestra de la nueva gramática visual: es la cota con mayor distancia respecto a D225 y con el salto de acabado más visible.
2. Revisar esa muestra con el autor antes de rehacer las otras cinco vistas de la cota; después pasar al Nudo y a la Fiebre, manteniendo continuidad en los controles entre cotas.
3. Tratar el menú aparte: `menu_nudo_ventana_v3.png` tiene nombre histórico, pero su cota **no está fijada** en el diseño; no asignarle el Nudo por el nombre del archivo.

La producción por fases evita dar por aprobada una estética a partir de la aprobación previa de la estructura de 21 vistas. Esta propuesta no altera el mapa, las partidas, las misiones ni el canon.
