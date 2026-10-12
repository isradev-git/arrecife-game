# Solo caminar · Corrección de alcance

13 de octubre de 2026. El autor exige sprites de las fases del movimiento para una marcha natural y completa, y descarta correr por el tamaño de los escenarios. Se retira la carrera de la producción Godot; el prototipo JavaScript y las capturas anteriores se conservan como historial.

El controlador mantiene caminar a 220 px/s, aceleración/frenada, perfiles propios, escala 252, pies y = 705, límites/colisión, destinos y cancelación al perder foco. Se elimina velocidad/estado de carrera, casilla Correr y aceleración mediante Mayús/doble clic. Ambos tipos de clic llevan al destino caminando. Sin cambios de PNG ni narración.

**Comprobado:** `tests/movimiento.gd` pasa siete llegadas sin sobrepasar, marcha/aceleración/frenada/inversión, límites, destinos inválidos, pasos 30/60, colisión física, foco y Mayús sin aumentar velocidad. La misma prueba pasa en render nativo Apple M4. Importación y exportación Web correctas. Helium/Chromium WebGL 2.0: panel sin carrera, Mayús + D camina, doble clic en cabina camina hacia guardia; consola y errores sin fallos registrados. Eventos de teclado y doble clic enviados al canvas con códigos/modificadores completos, sin prueba manual de teclado físico.

| Captura nueva | Comprobación |
| --- | --- |
| [web_mayus_caminar.png](web_mayus_caminar.png) | Mayús mantenida: estado Caminando, sin control de carrera. |
| [web_doble_clic_caminar.png](web_doble_clic_caminar.png) | Doble clic: Caminando hacia guardia. |
| [nativo_jefa.png](nativo_jefa.png), [nativo_guardia.png](nativo_guardia.png) | Controlador actual en render nativo, puntos de llegada/planos conservados. |

Web a 1672 × 941; nativas al tamaño efectivo de la ventana de prueba. Estas capturas no sustituyen las anteriores de [T04 inicial](../recorrido_jugable_v1/README.md).

**Siguiente T05:** producir las poses clave de dos pasos en ambos perfiles, seguidas de los intermedios necesarios. Sprite propio por fotograma, identidad/equipo estables, celdas/pivote/escala comunes y pies sincronizados con distancia. Se ha observado el atlas v7 vigente antes de concretar el criterio. [Plan de producción](../../../../task.md). T06 queda para arranque/parada, giros y reposo. No se generan fotogramas en esta corrección ni se da por aprobado un ciclo; Sota continúa usando perfiles estáticos. Safari/Firefox/móvil pendientes.
