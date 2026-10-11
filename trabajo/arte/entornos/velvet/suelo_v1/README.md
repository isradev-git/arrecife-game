# Velvet · Suelo horizontal T07.2

11 de octubre de 2026. El autor valora positivamente la primera prueba de capas, pero pide corregir el entorno: **el suelo de juego debe ir siempre recto** para colocar barandillas y objetos sin conflictos de perspectiva. Criterio vigente para todas las escenas laterales.

## Entrega

[Fondo integrado](../../../../../godot/assets/entornos/velvet/fondo_suelo_recto_v1.png), editado con `imagegen` desde [Velvet aprobado](../../../referencias/pixel_art_v1/velvet_estilo.png). Pasarela horizontal de borde trasero aproximadamente y = 670 y borde delantero y = 735, en el encuadre 1672 × 941. Se retiran las barandillas pintadas en el recorrido y se reconstruye la ciudad detrás; la barandilla central sigue siendo una pieza independiente. Se conservan referencia, fondo anterior y sus capturas.

Dos generaciones conservadas:

- [Intento v1](../../../../../godot/assets/entornos/velvet/fondo_suelo_recto_v1.png), integrado sin retoque del PNG. [Prompt](prompt.txt).
- [Intento v2](fondo_intento_v2.png), ajuste de apoyos solicitado a la herramienta. [Prompt](prompt_apoyos.txt). No integrado: cambia la escala de figurantes y no coloca sus pies en y = 710 como se había solicitado.

El primer intento ofrece una pasarela recta y conserva mejor las proporciones. La línea de apoyo se calibra sobre el resultado real: **y = 675**, sustituyendo y = 710 de la prueba anterior. Sota conserva altura 252; suelo y pivote no varían con x ni con el perfil. La barandilla se apoya en esa misma línea, en x = 450–935; ya no hace falta el parche del fondo anterior. Edición generativa: no se afirma conservación exacta de detalles, texto o personas.

## Reglas de montaje

Suelo transitable horizontal y continuo. Los recursos independientes del mismo plano comparten línea de apoyo, con verticales rectas y elementos horizontales paralelos al suelo. Profundidad en fondos, arquitectura y capas, sin inclinar el recorrido. Escaleras visibles del local quedan en el fondo; no son tramos transitables implementados. Antes de animar o hacer interactivo un objeto/figurante, separarlo y calibrar su base respecto a esta línea.

## Comprobación y límites

[Seis capturas nativas](../../../revisiones/suelo_v1/README.md). Godot: importación, pruebas de escala/apoyos en seis posiciones, base de barandilla, dos perfiles, materiales, escena técnica y prueba GPU de oclusión correctas; exportación Web correcta. Suelo revisado visualmente por el asistente. El ajuste geométrico es una propuesta entregada, pendiente de valoración del autor.

Mobiliario, figurantes, ciudad, humo y luces siguen en el fondo; sus apoyos definitivos y oclusiones necesitan recursos independientes. La primera barandilla solo cubre el tramo central. Sin controlador, colisiones ni prueba visual Web; T07 continúa en curso.

**Comprobación posterior del mismo día:** [versión Web y capturas reales](../../../revisiones/suelo_web_v1/README.md). Helium/Chromium muestra el fondo, ambos perfiles y la oclusión; carga, recarga y clic comprobados sin errores registrados. Safari/Firefox, movimiento y validación completa pendientes.
