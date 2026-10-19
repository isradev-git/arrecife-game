# El Arrecife · tareas de la experiencia ilustrada

Actualizado: **19 de octubre de 2026**. [Tareas anteriores archivadas](task_ETAPA_PIXEL_20261018.md).

## Decisión vigente

Experiencia de unos **30 minutos** para descubrir el canon de forma interactiva. Sota protagonista; algunas personas conversables y objetos examinables. Se retiran crimen/caso, deducciones, encargo y objetivo obligatorio. Personajes y escenarios completamente 3D, con movimiento sólo izquierda/derecha y acabado ilustrado fiel a los retratos, sin pixel art. Primera entrega de unos 30 minutos; ampliable con nuevos espacios, personas y objetos para expandir el lore. **El entorno debe protagonizar la imagen, con cámara lejana; conservar locomoción convincente y producir un modelo fiel al retrato.** El autor rechazó visualmente la v2 por parecido insuficiente, acabado poligonal y arnés desconectado. [Diseño](trabajo/diseno/EXPERIENCIA_ILUSTRADA.md).

## Orden de trabajo

| Tarea | Estado | Cierre |
| --- | --- | --- |
| I00 · Archivar la etapa anterior | Completada | Respaldo íntegro del contenido no regenerable, con historial y cambios sin confirmar; 2320 archivos verificados por SHA256. Documentos congelados y proyectos anteriores recuperables. |
| I01 · Demostrar locomoción con cuerpo completo | Movimiento aprobado por el autor | Base 3D humana, animación preparada y desplazamiento sincronizado; probar apoyos, bucle, ambos sentidos, arranque, parada, inversión y controles. Estudio de Sota vestido disponible, retarget/controles/temporización y contacto plano parcial comprobados, con prueba nativa/Web. Recorrido 3D de 42 m con cámara de seguimiento y colisión física disponible para revisar el movimiento en contexto. Cyberdeck corregido en modelo v2 para liberar mano/antebrazo: 1.920 poses GPU sin cruce, regresiones y capturas revisadas; v1 conservada. El autor confirma que el movimiento actual está muy bien: conservarlo. Cobertura numérica del rodado completo aún parcial. |
| I02 · Construir Sota fiel al retrato | En curso | Candidata v7: revisión 360, solape de cintura, arnés sobre hombro y confección posterior; conserva piel cálida de v6; conserva vestuario v5 y parecido de la captura concreta elegida por el autor; prendas con abertura, espesor, holgura y calzado construido, seis materiales con mapas UV de color/rugosidad/normal. Cámara a 24 m. Movimiento aprobado conservado; versiones anteriores recuperables. No hay aprobación artística.  Modelo/vistas de cuerpo completo, pelo, ropa y equipo en su lado físico; acabado ilustrado y animación revisados a escala real. El estudio inicial de modelo durante I01 no cierra esta tarea de acabado. |
| I03 · Un fragmento jugable del nuevo estilo | Candidata para revisión | Demo de calle de la Fiebre: suelo y manzanas continuos, Velvet, bar, cabinas y químicos; materiales, luces, niebla y vapor. Cuatro encuentros opcionales con fondo oscuro, retratos enfrentados, hablante iluminado y monólogo sólo con Sota; visor 360. El autor rechazó la presentación inicial como puente, archivada.  Un tramo ilustrado con profundidad, una persona conversable y un objeto examinable; sin caso ni misión, con controles y lectura cómodos. |
| I04 · Experiencia de unos 30 minutos | Pendiente | Guion trazable al canon, recorrido compacto, conversaciones selectivas, conocimiento de Sota y cierre natural; duración medida con lectura real. |
| I05 · Integración y distribución | Pendiente | Guardado de descubrimientos/conversaciones sin convertirlos en objetivos, sonido, accesibilidad, exportación y pruebas de la experiencia completa en navegadores. |

## Criterios

El autor autoriza trabajar conjuntamente Sota y el primer nivel para la demo. Conservar versiones y fuentes; no modificar `canon_el_arrecife.md` ni `sources/`. Las pruebas técnicas no otorgan aprobación artística. Revisar la animación visible a velocidad normal y a escala de juego. No ampliar producción masiva antes de validar locomoción y acabado.

El autor ha aprobado el movimiento de la Sota vestida en la pasarela. Se conserva esa decisión; el trabajo actual es I02, aspecto y parecido. Las mediciones de apoyo siguen teniendo cobertura parcial y no equivalen a una certificación de contacto perfecto. La pasarela anterior sigue como prueba técnica. La demo activa recupera Velvet como candidata de escenario, con texto propuesto y figuración provisional.

## Revisión de barrio y población · 19 oct

Solicitud aplicada a I03: calzada 2,3 m, testeros/cámara limitados, detalle de fachadas y seis vecinos (tres rutas, tres en reposo). I02 secundario: jefa v2 con rasgos del retrato, pendiente de valoración. Cadencia de Sota +12 % con root motion sincronizado, sin modificar su modelo ni rig. Recursos anteriores conservados. [Entrega y pruebas](trabajo/arte/revisiones/demo_velvet_3d_v2/README.md).
