# EL ARRECIFE · ambientes dinámicos

**Estado:** propuesta para aprobación del autor, 23 oct 2026. No cambia la dirección de aventura 2D ilustrada en primera persona.

## Intención

Las 21 vistas y el menú usan PNG aplanados. El autor quiere que el mundo se perciba vivo mediante luces, bruma, humo y cambios atmosféricos. En esta fase no se animarán personas ni se moverá la cámara. El movimiento debe sugerir actividad urbana y reforzar cada cota sin competir con pistas, diálogos o lectura.

## Alternativas consideradas

1. **Efectos sobre toda la imagen:** rápidos de añadir, pero la niebla y el cielo atravesarían edificios y personas; la luz no correspondería a sus fuentes.
2. **Secuencias completas de cada fondo:** permitirían cualquier cambio, pero multiplicarían los archivos y obligarían a reconstruir 21 composiciones para cada fotograma.
3. **Capas locales sobre los fondos actuales — propuesta:** pequeñas zonas transparentes con máscara cuando haga falta, alineadas con la misma escala y recorte de la ilustración. Requieren trabajo artístico por vista, pero conservan los PNG originales y admiten aprobación gradual.

## Escena piloto y lenguaje visual

El pasaje de La Fiebre será la primera escena. Tendrá un pulso irregular y suave del neón de Velvet, con su reflejo correspondiente en el suelo; vapor lento que salga de una instalación visible; y una variación de bruma en el fondo del pasaje. Las figuras del PNG permanecen quietas. Las entradas y cualquier punto de interacción deben seguir legibles. El movimiento será continuo, con pausas naturales y sin destellos bruscos.

Después de validar el pasaje, el menú servirá para probar atmósfera lejana entre los edificios: niebla y luminosidad industrial variables dentro del hueco de la ventana. Donde exista cielo visible, se moverá la bruma o la luz ambiental sin simular sol directo en la Penumbra ni inventar un ciclo día/noche. En el apartamento bastarán luces de dispositivos y alguna fuente física; El Nudo y Los Puntales tendrán iluminación de trabajo, ventilación y emisiones acordes a sus espacios. Cada vista recibirá sólo efectos que tengan una fuente creíble.

## Integración

- Las capas de efectos se dibujan entre el fondo y los controles, con coordenadas ligadas al rectángulo **total** de la ilustración, incluido el tramo recortado en móvil horizontal. Una vista libera efectos y tweens al salir. El menú, cuyo fondo usa otro modo de escalado, necesitará adaptar esa geometría cuando llegue su turno.
- Cada efecto usa un recurso transparente local y una animación breve de posición u opacidad. Para el piloto se preparan capas editables específicas de `fiebre_multitud_v2.png`: emisión del neón y su reflejo, vapor y máscaras de la arquitectura/figuras que crucen. Su procedencia y coordenadas se documentan junto al original aplanado. Las máscaras o recortes evitan que humo y bruma tapen elementos del primer plano. Los PNG actuales y los originales del autor permanecen íntegros.
- La opción existente `reduced_motion` detiene los bucles ambientales y muestra un estado estático legible; su rótulo pasará a describir el movimiento ambiental además de las transiciones. Cambiarla durante la partida surtirá efecto en la vista abierta. No cambia el formato de la partida.
- La presentación será discreta durante conversaciones, documentos y paneles: los efectos permanecen detrás de ellos y no reducen el contraste del texto. No se añade audio nuevo en esta tanda.

## Comprobación y extensión

Primero se revisará el pasaje en ejecución nativa y Web a 1280×720 y 844×390, con movimiento activo y reducido. Se comprobarán la estabilidad de los hotspots, la ausencia de parpadeo molesto, la alineación de reflejos y la carga al entrar/salir varias veces. Se medirá el coste de render donde haya herramientas disponibles. Tras la valoración artística del autor, se aplicará el mismo patrón a menú y vistas restantes, con revisión individual. Teléfonos físicos y navegadores adicionales seguirán pendientes hasta poder probarlos.
