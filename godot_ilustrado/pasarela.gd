extends Node3D

# Estudio de composición: no establece una localización nueva en el canon.
const INICIO = -4.0
const FINAL = 38.0
var materiales := {}
var desgaste: NoiseTexture2D

func material(color: String, luminoso := false) -> StandardMaterial3D:
	var clave := color + str(luminoso)
	if not materiales.has(clave):
		var m := StandardMaterial3D.new()
		m.albedo_color = Color(color)
		m.roughness = 0.88
		if not luminoso and color not in ["21323c", "1c2c38", "172733"]:
			m.albedo_texture = desgaste
			m.uv1_triplanar = true
			m.uv1_world_triplanar = true
			m.uv1_scale = Vector3(0.3, 0.3, 0.3)
		if luminoso:
			m.emission_enabled = true
			m.emission = Color(color)
			m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		materiales[clave] = m
	return materiales[clave]

func caja(posicion: Vector3, tamano: Vector3, color: String, solida := false, luminosa := false) -> MeshInstance3D:
	var pieza := MeshInstance3D.new()
	var malla := BoxMesh.new()
	malla.size = tamano
	pieza.mesh = malla
	pieza.material_override = material(color, luminosa)
	pieza.position = posicion
	add_child(pieza)
	if solida:
		var cuerpo := StaticBody3D.new()
		var colision := CollisionShape3D.new()
		var forma := BoxShape3D.new()
		forma.size = tamano
		colision.shape = forma
		cuerpo.add_child(colision)
		pieza.add_child(cuerpo)
	return pieza

func tubo(desde: Vector3, hasta: Vector3, radio: float, color: String) -> void:
	var pieza := MeshInstance3D.new()
	var cilindro := CylinderMesh.new()
	cilindro.top_radius = radio
	cilindro.bottom_radius = radio
	cilindro.height = desde.distance_to(hasta)
	cilindro.radial_segments = 10
	pieza.mesh = cilindro
	pieza.material_override = material(color)
	pieza.position = (desde + hasta) / 2
	var eje := (hasta - desde).normalized()
	pieza.quaternion = Quaternion(Vector3.UP, eje)
	add_child(pieza)

func rotulo(texto: String, posicion: Vector3, color: String, tamano := 42) -> void:
	var etiqueta := Label3D.new()
	etiqueta.text = texto
	etiqueta.position = posicion
	etiqueta.font_size = tamano
	etiqueta.pixel_size = 0.006
	etiqueta.modulate = Color(color)
	etiqueta.no_depth_test = false
	add_child(etiqueta)

func _ready() -> void:
	var ruido := FastNoiseLite.new()
	ruido.seed = 2135
	ruido.frequency = 0.045
	desgaste = NoiseTexture2D.new()
	desgaste.width = 256
	desgaste.height = 256
	desgaste.noise = ruido
	desgaste.seamless = true
	desgaste.color_ramp = Gradient.new()
	desgaste.color_ramp.set_color(0, Color(0.84, 0.84, 0.84))
	desgaste.color_ramp.set_color(1, Color(1, 1, 1))
	var ambiente := WorldEnvironment.new()
	ambiente.environment = Environment.new()
	ambiente.environment.background_mode = Environment.BG_COLOR
	ambiente.environment.background_color = Color("111d27")
	ambiente.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	ambiente.environment.ambient_light_color = Color("99b6c2")
	ambiente.environment.ambient_light_energy = 0.30
	add_child(ambiente)
	var principal := DirectionalLight3D.new()
	principal.rotation_degrees = Vector3(-42, -28, 0)
	principal.light_color = Color("f2c5a2")
	principal.light_energy = 0.88
	principal.shadow_enabled = true
	principal.directional_shadow_max_distance = 55
	add_child(principal)
	var contraluz := DirectionalLight3D.new()
	contraluz.rotation_degrees = Vector3(-22, 150, 0)
	contraluz.light_color = Color("73a7bd")
	contraluz.light_energy = 0.3
	add_child(contraluz)
	# Tres capas de edificios: profundidad real, sin fondos rasterizados.
	for capa in range(3):
		for i in range(-5, 16):
			var x := i * 3.5 + capa * 1.3
			var alto := 7.0 + posmod(i * 7 + capa * 3, 9)
			var z := -8.0 - capa * 8.0
			caja(Vector3(x, alto / 2 - 4, z), Vector3(3.0, alto, 3), ["21323c", "1c2c38", "172733"][capa])
			for piso in range(2, int(alto)):
				for ventana in range(3):
					if posmod(i * 11 + piso * 7 + ventana * 3, 5) < 2:
						caja(Vector3(x - 0.9 + ventana * 0.85, piso - 3.5, z + 1.51), Vector3(0.26, 0.38, 0.02), "ba8053" if capa == 0 else "567380", false, true)
	for i in range(14):
		var x := INICIO + 1.5 + i * 3.0
		caja(Vector3(x, -0.17, 0), Vector3(3, 0.34, 2.9), "303c40", true)
		caja(Vector3(x, -0.55, 0), Vector3(2.9, 0.16, 2.7), "17252c")
		for borde in [-1.25, 1.25]:
			caja(Vector3(x, 0.005, borde), Vector3(2.92, 0.014, 0.045), "a07e4c")
		for junta in [-1.0, 0.0, 1.0]:
			caja(Vector3(x + junta, 0.003, 0), Vector3(0.018, 0.006, 2.4), "19282e")
		# Barandilla trasera; el borde frontal queda despejado para leer los pies.
		for poste in [-1.5, 1.5]:
			caja(Vector3(x + poste, 0.52, -1.3), Vector3(0.07, 1.05, 0.07), "3f4c4d")
		tubo(Vector3(x - 1.5, 1.04, -1.3), Vector3(x + 1.5, 1.04, -1.3), 0.045, "707267")
		tubo(Vector3(x - 1.5, 0.42, -1.3), Vector3(x + 1.5, 0.42, -1.3), 0.027, "39484b")
		if i % 2 == 0:
			caja(Vector3(x, 2.4, -2.3), Vector3(0.22, 5.4, 0.4), "293940")
			caja(Vector3(x, 3.65, -0.8), Vector3(0.16, 0.16, 3.2), "354348")
			caja(Vector3(x, 3.54, -0.2), Vector3(0.8, 0.08, 0.25), "d5ba88", false, true)
			var lampara := OmniLight3D.new()
			lampara.position = Vector3(x, 2.7, 0.5)
			lampara.light_color = Color("edb477")
			lampara.light_energy = 0.65
			lampara.omni_range = 4.2
			add_child(lampara)
	for extremo in [INICIO, FINAL]:
		caja(Vector3(extremo, 1.1, 0), Vector3(0.18, 2.2, 2.9), "4a4a3e", true)
		caja(Vector3(extremo, 1.6, 0.01), Vector3(0.22, 0.10, 2.95), "b18a51")
	# Dos fachadas habitadas separadas por un vano abierto hacia la ciudad.
	for x in [1.5, 25.5, 31.5]:
		caja(Vector3(x, 1.45, -2.8), Vector3(5.7, 3.6, 1.2), "403f38")
		caja(Vector3(x, 3.35, -2.0), Vector3(5.9, 0.18, 2.5), "5d5141")
		for panel in range(7):
			caja(Vector3(x - 2.4 + panel * 0.8, 1.2, -2.18), Vector3(0.025, 2.4, 0.025), "2d3330")
		caja(Vector3(x, 1.65, -2.13), Vector3(3.1, 1.25, 0.1), "151f24")
		caja(Vector3(x, 1.65, -2.06), Vector3(2.9, 1.05, 0.025), "1c2b30")
		caja(Vector3(x, 2.08, -2.02), Vector3(2.85, 0.045, 0.03), "cba76f", false, true)
		for estante in range(2):
			caja(Vector3(x, 1.32 + estante * 0.43, -2.01), Vector3(2.8, 0.04, 0.04), "74614a")
			for objeto in range(8):
				var altura := 0.12 + posmod(objeto * 3 + estante, 4) * 0.045
				caja(Vector3(x - 1.15 + objeto * 0.32, 1.34 + estante * 0.43 + altura / 2, -2.01), Vector3(0.15, altura, 0.06), ["7b7161", "677578", "9c7e55"][objeto % 3])
		for rejilla in range(5):
			caja(Vector3(x - 1.2 + rejilla * 0.6, 1.65, -2.01), Vector3(0.04, 1.1, 0.04), "253235")
		caja(Vector3(x, 0.6, -1.85), Vector3(3.5, 0.12, 0.65), "726351")
		caja(Vector3(x + 2.2, 1.4, -2.02), Vector3(0.65, 0.9, 0.18), "28383d")
		for ranura in range(7):
			caja(Vector3(x + 2.2, 1.1 + ranura * 0.085, -1.91), Vector3(0.48, 0.018, 0.02), "65706b")
		tubo(Vector3(x - 2.3, 0, -2.05), Vector3(x - 2.3, 3.1, -2.05), 0.08, "726453")
	for x in [9.0, 18.0]:
		caja(Vector3(x, 0.65, -1.8), Vector3(1.2, 1.3, 0.5), "485354")
		for i in range(8):
			caja(Vector3(x, 0.3 + i * 0.1, -1.53), Vector3(0.95, 0.035, 0.06), "1b2a30")
		tubo(Vector3(x, 1.3, -1.9), Vector3(x, 3.8, -1.9), 0.12, "5c625c")
	rotulo("PASO / 03", Vector3(1.5, 2.7, -2.10), "e1c28b")
	rotulo("TRÁNSITO", Vector3(15, 3.05, -2.0), "79b3bb", 56)
	rotulo("04 / PASO", Vector3(28.5, 2.8, -2.1), "e1c28b")

	# Cableado colgante por tramos, con una curva continua visible a contraluz.
	for vano in range(7):
		for tramo in range(12):
			var xa := INICIO + 1.5 + vano * 6 + tramo * 0.5
			var xb := xa + 0.5
			var ya := 3.45 - sin(tramo / 12.0 * PI) * 0.4
			var yb := 3.45 - sin((tramo + 1) / 12.0 * PI) * 0.4
			tubo(Vector3(xa, ya, -1.5), Vector3(xb, yb, -1.5), 0.018, "1c272c")

	# El plano amplio debe mostrar estructura y otra profundidad bajo la pasarela.
	for x in range(-2, 39, 6):
		caja(Vector3(x, -2.0, -0.6), Vector3(0.3, 3.8, 0.4), "26353b")
		tubo(Vector3(x, -0.5, 0.8), Vector3(x + 3, -2.3, -0.8), 0.06, "3e4847")
		caja(Vector3(x + 1.5, -2.6, -4.4), Vector3(5.8, 0.22, 2.6), "27373c")
		caja(Vector3(x + 1.5, -2.3, -5.4), Vector3(3.0, 0.08, 0.08), "7b8271", false, true)
	caja(Vector3(17, 4.8, -4.8), Vector3(18, 0.22, 2.3), "2b393d")
	for x in range(9, 27, 3):
		caja(Vector3(x, 5.35, -3.65), Vector3(0.055, 1.0, 0.055), "63716e")
		tubo(Vector3(x, 4.8, -3.65), Vector3(x + 3, 4.8, -3.65), 0.03, "485b5b")
		tubo(Vector3(x, 5.82, -3.65), Vector3(x + 3, 5.82, -3.65), 0.035, "657670")
	for altura in [4.2, 4.45]:
		tubo(Vector3(-5, altura, -3), Vector3(42, altura, -3), 0.075, "4b5451")
	for x in range(-1, 40, 6):
		caja(Vector3(x, 4.32, -3), Vector3(0.12, 0.55, 0.23), "303f42")
	for x in [6, 21, 34]:
		caja(Vector3(x, 4.0, -6.2), Vector3(0.12, 5.0, 0.1), "507a80", false, true)
		caja(Vector3(x - 0.18, 4.0, -6.22), Vector3(0.04, 5.0, 0.08), "31454d")
	agrupar_estaticas()

func agrupar_estaticas() -> void:
	var grupos := {}
	for nodo in get_children():
		if not nodo is MeshInstance3D or nodo.get_child_count() != 0: continue
		if not (nodo.mesh is BoxMesh or nodo.mesh is CylinderMesh): continue
		var clave: String = str(nodo.material_override.get_instance_id()) + nodo.mesh.get_class() + str(nodo.cast_shadow)
		if not grupos.has(clave): grupos[clave] = []
		grupos[clave].append(nodo)
	for piezas in grupos.values():
		var cilindro: bool = piezas[0].mesh is CylinderMesh
		var base: PrimitiveMesh
		if cilindro:
			var forma := CylinderMesh.new()
			forma.top_radius = 1
			forma.bottom_radius = 1
			forma.height = 1
			forma.radial_segments = 10
			base = forma
		else:
			var forma := BoxMesh.new()
			forma.size = Vector3.ONE
			base = forma
		var malla := MultiMesh.new()
		malla.transform_format = MultiMesh.TRANSFORM_3D
		malla.mesh = base
		malla.instance_count = piezas.size()
		for i in range(piezas.size()):
			var pieza: MeshInstance3D = piezas[i]
			var escala: Vector3 = Vector3(pieza.mesh.top_radius, pieza.mesh.height, pieza.mesh.top_radius) if cilindro else pieza.mesh.size
			malla.set_instance_transform(i, pieza.transform * Transform3D(Basis.from_scale(escala), Vector3.ZERO))
			pieza.queue_free()
		var lote := MultiMeshInstance3D.new()
		lote.multimesh = malla
		lote.material_override = piezas[0].material_override
		lote.cast_shadow = piezas[0].cast_shadow
		add_child(lote)
