window.ArrecifeContent = {
  scenes: {
    fiebre: { name: 'Velvet', area: 'Cota 4 · La Fiebre', image: 'fiebre_velvet_v1.png', floor: .752, height: .267, description: 'Una galería húmeda se abre sobre torres y pasarelas. La recepción del local sigue trabajando a la derecha.', hotspots: [
      { id: 'jefa', label: 'La del libro', x: .79, y: .53 },
      { id: 'vestuario', label: 'Dependencias', x: .91, y: .64 },
      { id: 'vecino', label: 'Control de personal', x: .12, y: .50 },
      { id: 'rutas', label: 'Galería', x: .37, y: .70 }
    ] },
    vestuario: { name: 'El casillero de Iria', area: 'Cota 4 · Velvet', image: 'vestuario_v1.png', floor: .806, height: .38, description: 'Tras una cortina, un casillero abierto contiene ropa nueva, un sobre y efectos de trabajo.', hotspots: [
      { id: 'sobre', label: 'Sobre de documentos', x: .57, y: .48 },
      { id: 'ropa', label: 'Ropa para el Cordón', x: .62, y: .36 },
      { id: 'hueco', label: 'Efectos personales', x: .57, y: .62 },
      { id: 'recepcion', label: 'Recepción', x: .12, y: .68 }
    ] },
    nudo: { name: 'Gestiones Sanz', area: 'Cota 3 · El Nudo', image: 'nudo_v1.png', floor: .735, height: .283, description: 'Una oficina reparada bajo conductos de refrigeración. Sanz espera tras el terminal de la derecha.', hotspots: [
      { id: 'sanz', label: 'Sanz', x: .80, y: .48 },
      { id: 'expediente', label: 'Terminal del expediente', x: .88, y: .50 },
      { id: 'carpeta', label: 'Carpeta de Iria', x: .73, y: .55 },
      { id: 'rutas', label: 'Salir a la galería', x: .14, y: .66 }
    ] },
    taller: { name: 'Taller de Berta', area: 'Cota 0 · Mercado de recambios', image: 'taller_sin_iria_v1.png', floor: .735, height: .29, description: 'Un taller entre puestos de recambios. Berta trabaja bajo una lámpara; una puerta da a la trastienda.', hotspots: [
      { id: 'berta', label: 'Berta', x: .69, y: .50 },
      { id: 'deck', label: 'Deck reparado', x: .77, y: .54 },
      { id: 'iria', label: 'Iria', x: .88, y: .46, needs: 'met' },
      { id: 'rutas', label: 'Mercado', x: .20, y: .66 }
    ] }
  },
  sources: { E0: 'Libro de la Nómina', P1: 'Sobre de Iria · La Fiebre', P2: 'Reenvío conservado por la jefa', P3: 'Sobre de Iria · La Fiebre', P4: 'Oficina de Sanz · El Nudo', P5: 'Carpeta que dejó Iria', P6: 'Copia de Iria · Taller de Berta', P7: 'Iria y Berta · Taller' },
  conversations: {
    encargo: { title: 'La del libro', effect: 'accept', docs: ['E0', 'P2'], lines: [
      ['', 'Sota deja el deck junto al libro. La mujer retira una ficha que había usado para marcar la página.'],
      ['La jefa', 'Iria no vino anoche. Tenía turno a las diez. Le hemos mandado mensajes y nada.'],
      ['Sota', '¿Qué sabes de ella?'],
      ['La jefa', 'Que pagó a un gestor para trabajar en el Cordón. Ayer nos enseñó una confirmación. Luego dejó de contestar. Su cuota está al día. Quiero que averigües dónde está y qué necesita.'],
      ['Sota', '¿La quieres de vuelta?'],
      ['La jefa', 'Quiero saber si necesita que gastemos en algo. Si está trabajando arriba y no le ha dado la gana de avisar, que lo diga ella.'],
      ['Sota', '¿Puedo ver lo que dejó?'],
      ['La jefa', 'Los papeles del gestor, sí. Me dio permiso para mirarlos si había que tirar de la cobertura. Su casillero está al fondo. Dejé fuera sus cosas privadas.'],
      ['', 'La jefa pasa el encargo y el mensaje al deck de Sota. Las copias quedan en la libreta.']
    ] },
    confirmacion: { title: 'La confirmación', lines: [
      ['Sota', '¿Te dijo quién le había conseguido el trabajo?'], ['La jefa', 'Sanz. Tiene oficina en el Nudo. Me reenvió su mensaje. Míralo tú.'],
      ['Sota', '¿Iba a faltar anoche?'], ['La jefa', 'En el mensaje dice que venía. Una de las otras tuvo que quedarse. Hoy no pienso volver a repartirle el turno sin saber qué pasa.']
    ] },
    cordon: { title: 'El trabajo de arriba', lines: [
      ['Sota', '¿Qué buscaba en el Cordón?'], ['La jefa', 'Seguir con lo suyo, cobrando más. Tenía una cita pendiente y había comprado ropa. Le dije que primero viera el permiso. Ella tenía prisa por enseñarme la confirmación.'],
      ['Sota', '¿Crees que se marchó por su cuenta?'], ['La jefa', 'Podría. Iria se enfada, cambia de idea y vuelve a enfadarse. Pero había dejado trabajo reservado aquí. Algo no me encaja.']
    ] },
    cobertura: { title: 'La cobertura', lines: [
      ['Sota', '¿Hasta dónde llega su cobertura?'], ['La jefa', 'A tu encargo y, si hace falta, a una noche para que no duerma donde no debe. Lo demás se mira. La caja tiene lo que hemos puesto.']
    ] },
    vecino: { title: 'El local vecino', lines: [
      ['', 'La cámara apunta al acceso del personal. Una persona controla los pases desde dentro.'],
      ['Sota', 'Desde aquí puedo ver quién controla la puerta. No puedo saber las condiciones de quienes trabajan allí. Nada sitúa a Iria en ese local.']
    ] },
    sobre: { title: 'Los papeles de Iria', effect: 'papers', docs: ['P1', 'P3'], lines: [
      ['', 'Sota apoya el sobre sobre la funda de ropa para que no coja la humedad del banco. Dentro hay un justificante de presentación y un acuerdo firmado.'],
      ['Sota', 'Guardaré una copia de cada uno.']
    ] },
    ropa: { title: 'Ropa sin estrenar', lines: [
      ['', 'La chaqueta lleva un cierre plano bajo la solapa, todavía protegido por la película de fábrica. El bajo del pantalón está cogido con dos alfileres.'],
      ['Sota', 'Estaba preparando el trabajo de arriba. El permiso habrá que comprobarlo por otra parte.']
    ] },
    hueco: { title: 'El hueco de la bolsa', lines: [
      ['', 'Quedan unas botas de recambio y un peine con dos púas pegadas. Donde apoyaba la bolsa de trabajo hay una marca limpia.'],
      ['Sota', 'Se llevó la bolsa y dejó cosas que aún usa. Eso no me dice dónde pasó la noche.']
    ] },
    nudo_intro: { title: 'El Nudo', lines: [
      ['', 'La cabina baja una cota. Por la malla del lateral pasan tubos de refrigeración y ventanas tapadas desde dentro.'],
      ['', 'Sanz ha puesto una lámina de material nuevo sobre la mesa vieja. Por debajo asoma el canto hinchado.'],
      ['Sanz', 'Iria obtuvo la gestión que pagó. Después se marchó. No sé dónde está.'],
      ['Sota', 'Trabajo por encargo de la Nómina. Quiero ver qué se tramitó.'], ['Sanz', 'Eso sí puedo enseñártelo.']
    ] },
    expediente: { title: 'El expediente', effect: 'expediente', docs: ['P4'], lines: [
      ['', 'Sanz gira la pantalla y deja el conector de copia sobre la mesa.'], ['Sanz', 'Ahí está todo. Presentación, resolución, acuse. Mi trabajo se hizo.'],
      ['', 'Sota conserva la copia que le facilita.']
    ] },
    dinero: { title: 'Las tres láminas', lines: [
      ['Sota', '¿Y las tres láminas?'], ['Sanz', 'Se cobró por mover la solicitud. Las condiciones generales dicen que la gestión no se devuelve.'],
      ['Sota', 'Revisaré qué firmasteis.']
    ] },
    acuerdo: { title: 'Presentar el acuerdo particular', lines: [
      ['', 'Sanz repasa su firma con el pulgar.'], ['Sanz', 'Ese papel se hizo antes de ver la dificultad del patrocinio. Podía intentarse otra vez con el mismo dinero.'],
      ['Sota', '¿Iria aceptó dejarlo para otra solicitud?'], ['Sanz', 'Me exigió que se lo devolviera. No llegamos a hablarlo con calma.']
    ] },
    lectura: { title: 'La lectura de la resolución', lines: [
      ['Sota', '¿Abriste tú la resolución?'], ['Sanz', 'Sí. Ese acuse es mío.'],
      ['Sota', '¿Hubo otra resolución?'], ['Sanz', 'No. Confiaba en que el patrocinador cambiaría de idea. El historial es el que estás viendo.']
    ] },
    confronto: { title: 'La confirmación de Sanz', lines: [
      ['Sota', 'Leíste la negativa antes de anunciar que estaba aprobado.'], ['Sanz', 'Lo de aprobado fue adelantarme. Esperaba cerrarlo.'],
      ['Sota', 'Le dijiste que había terminado.'], ['Sanz', 'Y vino aquí. Le enseñé la resolución. No la mandé a pegarse con una esclusa.'],
      ['', 'Se acomoda el cable del cuello. El conector ha quedado tirante.']
    ] },
    carpeta: { title: 'La última visita de Iria', effect: 'carpeta', docs: ['P5'], lines: [
      ['Sota', '¿Qué pasó cuando vino?'], ['Sanz', 'Me pidió el dinero. Saqué el seguimiento para explicarle los anticipos y le hizo una foto. Ahí hay operaciones de otros clientes. Le dije que podía denunciarla.'],
      ['Sota', '¿Por eso quieres encontrarla?'], ['Sanz', 'Quiero que borre lo que se llevó. La carpeta la dejó aquí.'],
      ['', 'Sanz desliza una funda de documentos por la mesa.'], ['Sanz', 'Había un resguardo de taller. Si la encuentras, dile que lo mío sigue pendiente.']
    ] },
    poder: { title: 'Los contactos de Sanz', lines: [
      ['Sota', '¿Qué puedes hacerle?'], ['Sanz', 'Puedo contar al local lo que ha hecho. Y puedo presentar una denuncia. No necesito mandar en toda la ciudad para eso.'],
      ['Sota', '¿Conoces a Berta?'], ['Sanz', 'No he ido a ese taller. La dirección está en el resguardo.']
    ] },
    taller_intro: { title: 'El suelo', lines: [
      ['', 'El aire de un extractor llega caliente hasta el pasillo de recambios. Alguien ha marcado las dimensiones de una pieza sobre la pared. El puesto 12 sigue abierto.'],
      ['Sota', 'Busco a Iria.'], ['Berta', '¿Quién paga?']
    ] },
    berta: { title: 'Mostrar el encargo', effect: 'meet', lines: [
      ['Sota', 'La Nómina. Aquí tienes el encargo.'], ['', 'Berta lee hasta el final.'], ['Berta', '¿Sanz te ha pedido que la lleves?'],
      ['Sota', 'Quiere que borre una copia. Yo no trabajo para él.'], ['Berta', 'Espera.'],
      ['', 'Berta cruza la puerta de chapa. Cuando vuelve, aparta una caja para dejar sitio.'], ['Berta', 'Dice que puedes pasar.'],
      ['', 'Iria sale con una taza. Lleva una prenda doblada sobre el brazo.'], ['Iria', '¿Ya has estado con Sanz?'], ['Sota', 'Sí.'], ['Iria', 'Entonces habrá dicho que le he robado algo.']
    ] },
    deck: { title: 'El deck de Iria', lines: [
      ['Berta', 'El conector de alimentación hacía mal contacto. Lleva arreglado desde mayo.'],
      ['', 'La carcasa verde tiene dos tornillos distintos en el cierre.'], ['Sota', 'El resguardo corresponde a esta reparación. El equipo sigue siendo de Iria.']
    ] },
    copia: { title: 'La copia de seguimiento', effect: 'copy', docs: ['P6'], lines: [
      ['Iria', 'Puso esa hoja delante de mí para explicar dónde estaba el dinero. Vi mi nombre. Le hice una foto y me pidió la cámara.'],
      ['', 'Saca una tarjeta de memoria de la costura interior de la bolsa.'], ['Iria', 'Puedes copiarla. Guarda la fecha también.'],
      ['Sota', '¿Te devolvió algo después?'], ['Iria', 'Nada. Tampoco le he dicho que vuelva a presentar nada. Quiero mis tres láminas.']
    ] },
    nota: { title: 'El sobre para la jefa', effect: 'note', docs: ['P7'], lines: [
      ['', 'Berta saca un sobre de debajo de una caja de conectores.'], ['Berta', 'Esto era para la del libro. No ha salido.'], ['Iria', 'Puedes leerlo.'],
      ['', 'La hoja del reparto está junto al sobre. Sota copia las dos piezas con su permiso.']
    ] },
    silencio: { title: 'Por qué no avisó antes', effect: 'explain', lines: [
      ['Sota', '¿Por qué no avisaste por el canal de siempre?'], ['', 'Iria pasa el pulgar por el asa de la taza.'],
      ['Iria', 'Ya había contado que me iba al Cordón. Luego salí de allí sin permiso, sin dinero y con una foto que, según él, me podía meter en un lío. No quería oír a la jefa decir que me lo había buscado.'],
      ['Sota', 'Pagaste la cobertura.'], ['Iria', 'Ya. Por eso acabé escribiendo. La nota la podía dejar y no esperar a que contestara.'],
      ['Sota', 'El reparto sale mañana.'], ['Iria', 'Berta me lo dijo. Pensé que podía faltar una noche y arreglarlo antes del siguiente turno. No pensé que mandarían a alguien hoy.'],
      ['Berta', 'Le ofrecí que llamara desde aquí. Eligió esperar.']
    ] },
    ayuda_iria: { title: 'Qué ayuda acepta Iria', effect: 'permission', lines: [
      ['Sota', '¿Puedes regresar a la Fiebre?'], ['Iria', 'Mi residencia sigue valiendo. Hoy prefería estar aquí. Él sabe dónde encontrarme cuando trabajo.'],
      ['Sota', '¿Y el Cordón?'], ['Iria', 'Tenía una cita para conocer el sitio. Pagarían mejor. Sigo queriendo eso, pero por su oficina no vuelvo a pasar.'],
      ['Sota', 'Puedo decirle a la jefa que estás aquí y llevarle las copias.'], ['Iria', 'A ella, sí. A Sanz, mi dirección no. Y que reclame el anticipo. Le dejo la foto para eso.'],
      ['Sota', 'El fondo puede cubrirte una noche.'], ['Iria', 'La de ayer ya se la pagué a Berta. Que me la repongan y esta tarde subo por mi cuenta. Tengo que terminar el bajo del pantalón.']
    ] },
    coda: { title: 'De vuelta en la Fiebre', effect: 'finish', lines: [
      ['', 'La jefa recibe las copias y llama a Sanz delante de Sota. Le pide las tres láminas. Hasta que responda, dejará de recomendar su oficina; el acuerdo y la resolución pueden llegar también a quienes patrocinan sus solicitudes.'],
      ['', 'Sanz discute la cantidad. Acaba ofreciendo dos láminas esa misma tarde. La jefa se lo consulta a Iria antes de aceptar.'],
      ['Iria', 'Que mande esas dos. Por la otra le seguimos pidiendo cuentas. Nada de firmar que hemos terminado.'],
      ['', 'Cuando Iria regresa al local, la jefa está abriendo el sobre que acaban de entregar. Saca dos láminas, comprueba ambas y las deja delante de ella.'],
      ['La jefa', 'Doscientos recibidos. Cien pendientes. La comisión va aparte, como firmaste.'], ['Iria', '¿Me dejaste el turno del catorce?'],
      ['La jefa', 'Está en su sitio. A la próxima, avisa antes de dejarlo vacío.'],
      ['', 'La jefa anota la noche de alojamiento y los honorarios de Sota en el libro del fondo. Iria recoge la funda del casillero. Uno de los alfileres ha caído al fondo; lo busca antes de sentarse a coser.'],
      ['', 'Sota desconecta el deck y ajusta el cierre de la correa. En la galería, el escalón reparado vuelve a encenderse en blanco bajo su bota.']
    ] }
  },
  deductions: {
    D1: { title: 'La promesa de acceso', question: '¿Qué respaldan los papeles de Iria?', pair: ['P1', 'P2'], answers: [
      ['approved', 'El justificante acredita que ya puede subir.'], ['unproven', 'La solicitud se presentó; falta el resultado que respalde la aprobación.'], ['denied', 'Estos dos papeles ya demuestran que Sanz conocía una denegación.']
    ], feedback: { approved: 'El justificante dice «solicitud recibida» y distingue la autorización de ascenso.', denied: 'El justificante es anterior al mensaje. Todavía podría haberse aprobado después: necesitamos el resultado.' }, summary: 'La presentación no acredita aprobación. Hay que comprobar el resultado del expediente.', hints: ['Fíjate en el estado que aparece en el justificante.', 'Compara «solicitud recibida» con lo que Sanz afirma en su mensaje.', 'P1 prueba la presentación; P2 afirma aprobación. Falta una autorización o resolución que respalde esa afirmación.'] },
    D2: { title: 'Qué sabía Sanz', question: '¿Qué permite afirmar la secuencia de fechas?', pair: ['P2', 'P4'], answers: [
      ['later', 'La negativa llegó después de que anunciara la aprobación.'], ['automatic', 'Solo sabemos que el buzón recibió la negativa; no quién la leyó.'], ['knew', 'Sanz leyó la negativa antes de afirmar que el acceso estaba aprobado.']
    ], feedback: { later: 'Compara el 10 de junio de la resolución con el 11 del mensaje. ¿Qué ocurrió antes?', automatic: 'P4 separa recepción automática y confirmación manual. Busca la identidad de la sesión que leyó.' }, summary: 'Sanz leyó la denegación el 10 de junio y anunció aprobación el 11. El historial no muestra otra autorización.', hints: ['Busca dos acciones de Sanz y el orden en que ocurrieron.', 'Compara la lectura confirmada de P4 con el envío de P2.', 'Leyó la denegación el 10 y anunció aprobación el 11. Sabía que no había autorización cuando escribió.'] }
  }
};
