# El Arrecife 1.0 · diseño jugable

## Autoridad y alcance

El autor delegó el desarrollo de la versión 1.0 el 22 de octubre de 2026. Las situaciones siguientes pertenecen al videojuego y quedan separadas del canon literario. Se conservan el apartamento y las tres cotas, con 21 vistas y tres contratos. Sota sigue siendo investigadora independiente; el segundo encargo procede de la policía y es el único que exige informe policial. Ningún contrato la presenta como asesina a sueldo.

## Arco

1. **El parte del agua.** La Jefa encarga contrastar el cobro de una reparación. Sota copia la lectura doméstica, compara el parte, encuentra la ficha del equipo en El Nudo y verifica la conducción en Los Puntales. Entrega a la Jefa una conclusión limitada a los hechos: el trabajo se cerró sin prueba de presión y el cargo debe quedar en suspenso.
2. **La orden duplicada.** Tras esa entrega, una unidad policial pide a Sota investigar una segunda orden que usa la misma intervención. El trámite interno está detenido por una autorización superior. Sota coteja el registro físico del archivo, la transmisión del puesto de red y una remesa de suministros de La Fiebre. Envía un informe acotado: hay una orden duplicada, sin atribuir una culpa que las pruebas no sostienen.
3. **La prueba de presión.** La Jefa contrata una última comprobación antes de la siguiente revisión. Sota reúne la lista de cargos, el testigo material de Los Puntales y la lectura de presión. La Jefa obtiene una verificación independiente y se congela el cobro discutido. El jugador elige a quién entrega primero las copias: residentes o canal policial. El cierre muestra ambas consecuencias sin inventar una solución total a la corrupción.

## Interacción y progresión

Los contratos aparecen por mensaje cuando se completa el anterior. Los registros y puntos de interés se distribuyen por las 21 vistas: cada vista fuera del apartamento ofrece al menos una observación, documento, terminal o conversación adicional. Las acciones de misión posteriores están condicionadas al contrato activo. El deck muestra sólo mensajes disponibles, los pasos de los contratos y el cierre de la historia. Ninguna transición de vista repite un aviso de estado.

La interfaz reutiliza `State`, `Content`, `Viewpoint`, `Dialogue` y `Device`. Un terminal puede abrir un documento o un diálogo de decisión, siempre con la condición `available_if`. Los documentos de misión usan efectos declarativos existentes. La elección final se registra en `choices` y en flags al pulsar «Cerrar la historia»; salir antes permite volver a decidir. El cierre aparece al terminar y se puede reabrir desde el deck. No se añaden dependencias.

## Compatibilidad y aceptación

El guardado v1 existente sigue cargando: las misiones nuevas ausentes se inicializan como `LOCKED`, sin cambiar flags, elecciones o ubicación. Se rechazan los guardados mal tipados y las versiones futuras. Las pruebas recorren una partida completa con tres entregas, comprueban ambos desenlaces y cargan la partida anterior. Se validan importación, pruebas headless y nativas, preservación, exportación Web y render de pantallas afectadas. La aprobación artística de los fondos y una prueba en teléfonos reales se registran por separado de la comprobación técnica.
