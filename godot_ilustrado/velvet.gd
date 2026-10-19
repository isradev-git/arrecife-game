extends "res://pasarela.gd"

var ventiladores: Array[Node3D] = []
var humo: Array[CPUParticles3D] = []
var tiempo := 0.0
var rng := RandomNumberGenerator.new()
var superficies := {}
var figurantes: Array[Node3D] = []
var paseantes: Array[Dictionary] = []
const BORDE_CALZADA = 4.1

func halo(p: Vector3, tamano: Vector2, color: String) -> void:
	var imagen := GradientTexture2D.new()
	imagen.width = 64
	imagen.height = 64
	imagen.fill = GradientTexture2D.FILL_RADIAL
	imagen.fill_from = Vector2(.5,.5)
	imagen.fill_to = Vector2(.5,1)
	imagen.gradient = Gradient.new()
	imagen.gradient.set_color(0,Color(Color(color),.22))
	imagen.gradient.set_color(1,Color(Color(color),0))
	var m := StandardMaterial3D.new()
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.albedo_texture = imagen
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	var quad := QuadMesh.new()
	quad.size = tamano
	quad.material = m
	var o := MeshInstance3D.new()
	o.mesh = quad
	o.position = p
	o.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(o)

func acabado(color: String, tipo := "metal") -> ShaderMaterial:
	var clave := color + tipo
	if not superficies.has(clave):
		var m := ShaderMaterial.new()
		m.shader = preload("res://assets/velvet_3d_v2/superficies.gdshader")
		m.set_shader_parameter("color_base", Color(color))
		m.set_shader_parameter("metal", 0.55 if tipo in ["metal", "suelo"] else 0.0)
		m.set_shader_parameter("rugosidad", 0.65 if tipo == "metal" else 0.93)
		m.set_shader_parameter("ladrillo", 1.0 if tipo == "ladrillo" else 0.0)
		m.set_shader_parameter("suelo", 1.0 if tipo in ["suelo","adoquin"] else 0.0)
		m.set_shader_parameter("adoquin", 1.0 if tipo == "adoquin" else 0.0)
		superficies[clave] = m
	return superficies[clave]

func pieza(p: Vector3, s: Vector3, color: String, tipo := "metal", solida := false) -> MeshInstance3D:
	var o := caja(p, s, color, solida)
	o.material_override = acabado(color, tipo)
	return o

func luz(p: Vector3, color: String, energia: float, alcance: float) -> void:
	var l := OmniLight3D.new()
	l.position = p
	l.light_color = Color(color)
	l.light_energy = energia
	l.omni_range = alcance
	add_child(l)

func neon(a: Vector3, b: Vector3, color: String, radio := 0.018) -> void:
	tubo(a,b,radio,color)
	var o := get_child(-1) as MeshInstance3D
	o.material_override = material(color,true)
	o.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

func cartel(texto: String, p: Vector3, ancho: float, color: String, fuente := 70) -> void:
	pieza(p-Vector3(0,0,.04),Vector3(ancho,.85,.13),"10161c")
	rotulo(texto,p+Vector3(0,0,.04),color,fuente)
	for y in [-.39,.39]: neon(p+Vector3(-ancho/2,y,.05),p+Vector3(ancho/2,y,.05),color)
	for x in [-ancho/2,ancho/2]: neon(p+Vector3(x,-.39,.05),p+Vector3(x,.39,.05),color)
	halo(p+Vector3(0,0,.09),Vector2(ancho*1.4,2.5),color)

func ventana(x: float, y: float, z: float, ancho: float, alto: float, color: String) -> void:
	pieza(Vector3(x,y,z),Vector3(ancho+.17,alto+.16,.16),"131c24")
	var vidrio := caja(Vector3(x,y,z+.09),Vector3(ancho,alto,.025),color,false,true)
	var clave := color+"vidrio"
	if not superficies.has(clave):
		var m := ShaderMaterial.new()
		m.shader = preload("res://assets/velvet_3d_v1/ventanas.gdshader")
		m.set_shader_parameter("tono",Color(color))
		superficies[clave] = m
	vidrio.material_override = superficies[clave]
	vidrio.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	for dx in [-ancho/2,0,ancho/2]: pieza(Vector3(x+dx,y,z+.13),Vector3(.045,alto+.12,.055),"252a30")
	pieza(Vector3(x,y,z+.14),Vector3(ancho,.045,.05),"282d35")
	pieza(Vector3(x,y-alto/2,z+.2),Vector3(ancho+.25,.08,.38),"4b4543")

func ventilador(p: Vector3, radio := .65) -> void:
	pieza(p,Vector3(radio*2.6,radio*2.6,.24),"393e44")
	var disco := MeshInstance3D.new()
	var forma := CylinderMesh.new()
	forma.top_radius = radio
	forma.bottom_radius = radio
	forma.height = .06
	forma.radial_segments = 32
	disco.mesh = forma
	disco.rotation.x = PI/2
	disco.position = p+Vector3(0,0,.15)
	disco.material_override = material("111a21")
	add_child(disco)
	var aspas := Node3D.new()
	aspas.position = p+Vector3(0,0,.2)
	add_child(aspas)
	ventiladores.append(aspas)
	for i in range(6):
		var pala := pieza(Vector3.ZERO,Vector3(radio*.32,radio*.75,.04),"5a666b")
		pala.reparent(aspas,false)
		var a := i*TAU/6
		pala.position = Vector3(sin(a),cos(a),0)*radio*.48
		pala.rotation.z = -a+.35
	for i in range(4):
		var aro := MeshInstance3D.new()
		var torus := TorusMesh.new()
		torus.inner_radius = radio*(.22+i*.24)-.013
		torus.outer_radius = radio*(.22+i*.24)+.013
		torus.rings = 32
		torus.ring_segments = 6
		aro.mesh = torus
		aro.rotation.x = PI/2
		aro.position = p+Vector3(0,0,.25)
		aro.material_override = material("627075")
		add_child(aro)
	for i in range(8):
		var a := i*TAU/8
		tubo(p+Vector3(0,0,.26),p+Vector3(sin(a)*radio,cos(a)*radio,.26),.009,"39444b")

func vapor(p: Vector3, color: String, grande := false) -> void:
	var imagen := Image.create(64,64,false,Image.FORMAT_RGBA8)
	var ruido := FastNoiseLite.new()
	ruido.seed = 94
	ruido.frequency = .09
	for y in range(64):
		for x in range(64):
			var radio := Vector2(x-31.5,y-31.5).length()/31.5
			var alpha := pow(maxf(0,1-radio),1.5)*(.6+.4*ruido.get_noise_2d(x,y))
			imagen.set_pixel(x,y,Color(1,1,1,alpha))
	var mat := StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	mat.vertex_color_use_as_albedo = true
	mat.albedo_texture = ImageTexture.create_from_image(imagen)
	mat.no_depth_test = false
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	var quad := QuadMesh.new()
	quad.size = Vector2.ONE*(3.8 if grande else 1.6)
	quad.material = mat
	var nube := CPUParticles3D.new()
	nube.position = p
	nube.mesh = quad
	nube.amount = 12 if grande else 20
	nube.lifetime = 9 if grande else 5
	nube.preprocess = 3
	nube.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	nube.emission_box_extents = Vector3(1.2,.2,.6) if grande else Vector3(.12,.05,.08)
	nube.direction = Vector3(.4,1,0)
	nube.spread = 22
	nube.gravity = Vector3(.025,.035,0)
	nube.initial_velocity_min = .14
	nube.initial_velocity_max = .32
	nube.scale_amount_min = .5
	nube.scale_amount_max = 1.2
	nube.angular_velocity_min = -12
	nube.angular_velocity_max = 12
	var curva := Curve.new()
	curva.add_point(Vector2(0,.25)); curva.add_point(Vector2(1,1.8))
	nube.scale_amount_curve = curva
	var grad := Gradient.new()
	var c := Color(color)
	grad.set_color(0,Color(c,0)); grad.set_color(1,Color(c,0))
	grad.add_point(.18,Color(c,.16 if grande else .5))
	grad.add_point(.65,Color(c,.08 if grande else .19))
	nube.color_ramp = grad
	nube.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(nube)
	humo.append(nube)

func toldo(x: float, y: float, z: float, ancho: float) -> void:
	var vertices := PackedVector3Array()
	var indices := PackedInt32Array()
	for fila in range(3):
		for i in range(41):
			var t := i/40.0
			vertices.append(Vector3(x+(t-.5)*ancho,y-fila*.18-sin(t*PI)*.16+sin(t*PI*20)*.035,z+fila*.45))
	for fila in range(2):
		for i in range(40):
			var a := fila*41+i
			indices.append_array([a,a+41,a+1,a+1,a+41,a+42])
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for v in vertices: st.add_vertex(v)
	for i in indices: st.add_index(i)
	st.generate_normals()
	var m := MeshInstance3D.new()
	m.mesh = st.commit()
	var tela := material("54232f").duplicate()
	tela.cull_mode = BaseMaterial3D.CULL_DISABLED
	m.material_override = tela
	add_child(m)
	tubo(Vector3(x-ancho/2,y-.36,z+.9),Vector3(x+ancho/2,y-.36,z+.9),.025,"56464a")

func _ready() -> void:
	rng.seed = 2135
	var ruido := FastNoiseLite.new()
	ruido.seed = 412
	ruido.frequency = .06
	desgaste = NoiseTexture2D.new()
	desgaste.noise = ruido
	desgaste.seamless = true
	desgaste.color_ramp = Gradient.new()
	desgaste.color_ramp.set_color(0,Color(.65,.65,.65))
	desgaste.color_ramp.set_color(1,Color.WHITE)
	var mundo := WorldEnvironment.new()
	var e := Environment.new()
	mundo.environment = e
	e.background_mode = Environment.BG_COLOR
	e.background_color = Color("080f1b")
	e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	e.ambient_light_color = Color("7796b0")
	e.ambient_light_energy = .22
	e.fog_enabled = true
	e.fog_light_color = Color("263c53")
	e.fog_light_energy = .6
	e.fog_density = .006
	e.glow_enabled = true
	e.glow_intensity = .7
	e.glow_bloom = .08
	add_child(mundo)
	var luna := DirectionalLight3D.new()
	luna.rotation_degrees = Vector3(-55,-35,0)
	luna.light_color = Color("8faec9")
	luna.light_energy = .3
	luna.shadow_enabled = true
	luna.directional_shadow_mode = DirectionalLight3D.SHADOW_ORTHOGONAL
	luna.directional_shadow_max_distance = 55
	add_child(luna)
	# Cota habitable: suelo continuo bajo toda la calle y las fachadas, sin vacío bajo el paseo.
	pieza(Vector3(17,-2.025,-7),Vector3(74,4,42),"3a3f43","suelo",true)
	# El carril lateral conserva su apoyo y barreras físicas.

	for i in range(14):
		var x := -2.5+i*3
		pieza(Vector3(x,-.15,0),Vector3(3,.3,3.6),"424951","suelo",true)
		for dx in [-1.48,0,1.48]:pieza(Vector3(x+dx,.003,0),Vector3(.014,.006,3.5),"161c22")
		pieza(Vector3(x,.015,1.8),Vector3(2.98,.08,.18),"5e6061","hormigon")

	# Testeros sólidos: el límite jugable coincide con un cierre de arquitectura.
	for x in [INICIO-10,FINAL+10]:
		pieza(Vector3(x,8,-8),Vector3(20,20,44),"29343b","ladrillo",true)
	for x in [INICIO+.08,FINAL-.08]:
		pieza(Vector3(x,3,-1.6),Vector3(.18,6,7.5),"35434b")
		for y in [.2,2.8,5.6]:pieza(Vector3(x,y,0),Vector3(.22,.18,4.2),"6a6360")
	# Calzada estrecha de servicio: sólo 2,3 m, con acera opuesta visible.
	pieza(Vector3(17,-.035,9),Vector3(42,.27,9.8),"53504a","adoquin",true)
	for i in range(14):
		pieza(Vector3(-2.5+i*3,.08,BORDE_CALZADA),Vector3(2.97,.2,.18),"716b60","hormigon")
		pieza(Vector3(-2.5+i*3,-.008,3.91),Vector3(2.5,.014,.08),"99866a","pintura")
	# Las manzanas del fondo nacen en el mismo tejido urbano y cierran las calles laterales.
	for capa in range(3):
		for i in range(-4,12):
			var x := i*5.1+capa*1.6
			if capa<2 and x>4 and x<13: continue
			var alto := rng.randf_range(13,24)
			var z := -9.0-capa*10
			pieza(Vector3(x,alto/2-8,z),Vector3(4.4,alto,4),["28333e","243342","202f40"][capa],"ladrillo")
			for piso in range(-5,int(alto)-8,2):
				for j in range(3):
					if rng.randf()<.62:
						ventana(x-1.4+j*1.3,piso,z+2.02,.55,.8,["ad674b","446d89","a52f57","cb9370"][rng.randi_range(0,3)])
			for y in range(-5,int(alto)-8,3):
				pieza(Vector3(x,y,z+2.25),Vector3(4.9,.12,.65),"192731")
			if i%3==0: neon(Vector3(x+1.8,-3,z+2.15),Vector3(x+1.8,8,z+2.15),"ba3c80",.035)
	for altura in [5.8,10.8]:
		var z := -12.0 if altura<7 else -22.0
		pieza(Vector3(9,altura,z),Vector3(19,.35,2),"24343f")
		for x in range(0,19):
			tubo(Vector3(x,altura,z+1),Vector3(x,altura+.85,z+1),.022,"617482")
		neon(Vector3(0,altura+.08,z+1.02),Vector3(18,altura+.08,z+1.02),"7b345b",.018)
		tubo(Vector3(0,altura+.85,z+1),Vector3(18,altura+.85,z+1),.035,"4b6275")
	# Fachada izquierda y recepción derecha, tomadas de la composición de Velvet.
	for datos in [[-1.0,8.0],[23.0,18.0],[37.0,8.0]]:
		var x: float = datos[0]
		var ancho: float = datos[1]
		pieza(Vector3(x,5,-3.8),Vector3(ancho,12,3),"4f3935","ladrillo")
		for piso in [4.8,7.8,10.5]:
			for j in range(int(ancho/2.3)):
				ventana(x-ancho/2+1.2+j*2.3,piso,-2.25,1.1,1.5,"9c3348")
			pieza(Vector3(x,piso-1,-1.95),Vector3(ancho+.3,.16,.9),"34414b")
		for dx in [-ancho/2+.3,ancho/2-.4]:
			tubo(Vector3(x+dx,-2,-1.95),Vector3(x+dx,12,-1.95),.11,"584b43")
			for y in range(0,11):pieza(Vector3(x+dx,y,-1.95),Vector3(.28,.06,.28),"798081")
	# Cabina de personal: vidrio oscuro, rejilla, pantalla y luz de trabajo.
	pieza(Vector3(-.8,1.35,-1.8),Vector3(3.4,2.7,1.3),"222c32")
	ventana(-.8,1.75,-1.1,2.8,1.3,"815739")
	pieza(Vector3(-.8,1.1,-.85),Vector3(3.6,.13,.8),"665344")
	for x in [-2.2,.6]:tubo(Vector3(x,0,-1),Vector3(x,3,-1),.055,"80715c")
	cartel("PERSONAL",Vector3(-.8,3.1,-1.05),3.5,"e5b374",55)
	rotulo("SALIDA AUTORIZADA",Vector3(-.8,2.6,-1.02),"b7a58d",23)
	luz(Vector3(-.8,2.4,.5),"ffc080",2.6,5)
	# Calle lateral con locales: el hueco entre fachadas tiene suelo y destinos visibles.
	pieza(Vector3(8,2.1,-12),Vector3(6,4.2,2),"443831","ladrillo")
	ventana(8,1.8,-10.9,4.6,2.6,"b56b3f")
	cartel("B A R",Vector3(8,3.9,-10.7),3.4,"f1b263",75)
	rotulo("ABIERTO",Vector3(8,1.7,-10.65),"e7b779",38)
	for x in [5.2,10.8]:pieza(Vector3(x,2,-10.8),Vector3(.22,4,.4),"53473f")
	for x in [0.0,18.0]:pieza(Vector3(x,2.8,-12),Vector3(.5,5.6,.6),"343e46","hormigon")

	for x in [4,12,30,36]:
		tubo(Vector3(x,0,2.4),Vector3(x,.6,2.4),.06,"53616a")
		pieza(Vector3(x,.44,2.4),Vector3(.14,.07,.14),"b29b65")
	for x in [6.0,13.0,24.0,34.0]:
		pieza(Vector3(x,.012,1.48),Vector3(1,.018,.36),"121b21")
		for j in range(12):pieza(Vector3(x-.46+j*.084,.026,1.48),Vector3(.018,.022,.34),"61686c")
	# Velvet: rótulo principal, dosel, recepción y acceso escalonado fuera del carril.
	pieza(Vector3(20.3,1.7,-2.15),Vector3(6.5,3.1,.16),"11151b")
	cartel("V E L V E T",Vector3(20,4.15,-1.5),7.0,"ff4a68",96)
	rotulo("ELLAS Y ELLOS   /   CARNE O SIMULACIÓN",Vector3(20,3.45,-1.4),"d17c87",27)
	toldo(21.5,3.15,-2.15,11)
	pieza(Vector3(20,.57,-1.2),Vector3(5.8,1.14,1.1),"594336")
	pieza(Vector3(20,1.18,-1.1),Vector3(6.1,.14,1.4),"8b7157")
	for x in range(17,24):
		pieza(Vector3(x,.57,-.62),Vector3(.055,1.05,.05),"a18661")
		for y in [.14,.98]:caja(Vector3(x,y,-.58),Vector3(.045,.045,.025),"a99b7d")
	for x in [17.4,21.8]:
		tubo(Vector3(x,1.23,-1),Vector3(x,1.9,-1),.024,"66594a")
		caja(Vector3(x,1.91,-1),Vector3(.32,.13,.25),"ffd28b",false,true)
		luz(Vector3(x,2,-.3),"ffb66b",2.4,4)
	pieza(Vector3(19,1.3,-1.15),Vector3(.5,.08,.34),"292e35")
	pieza(Vector3(19,1.48,-1.25),Vector3(.45,.29,.06),"293e42")
	caja(Vector3(19,1.49,-1.21),Vector3(.38,.21,.012),"74b4aa",false,true)
	for j in range(3):
		pieza(Vector3(21,1.65+j*.4,-2.03),Vector3(2.5,.06,.5),"574335")
		for i in range(6):pieza(Vector3(20.1+i*.35,1.8+j*.4,-2),Vector3(.24,.19,.2),"9d9384","tela")
	pieza(Vector3(15.5,1.8,-1.7),Vector3(1.2,2.8,.18),"1c262e")
	rotulo("30 / 60 MIN",Vector3(15.5,2.8,-1.58),"d0b39a",29)
	for j in range(5):
		for i in range(3):
			rotulo(str(j*3+i+1),Vector3(15.1+i*.39,2.4-j*.36,-1.57),"a1908b",26)
			if (i+j)%3==0:caja(Vector3(15.1+i*.39,2.28-j*.36,-1.55),Vector3(.055,.04,.01),"f5a35b",false,true)
	for i in range(8):
		pieza(Vector3(26+i*.28,.075+i*.15,-1.75),Vector3(.3,.15+i*.3,1.4),"48464b")
		neon(Vector3(25.87+i*.28,.154+i*.15,-1.04),Vector3(26.13+i*.28,.154+i*.15,-1.04),"a94b5b",.008)
	for x in [28,31]:
		pieza(Vector3(x,2.15,-2.15),Vector3(1.8,3.1,.25),"281f2b")
		for dx in [-.95,.95]:neon(Vector3(x+dx,.6,-1.97),Vector3(x+dx,3.7,-1.97),"d82f62")
		rotulo("2" if x==28 else "3",Vector3(x,3.45,-1.95),"ed6c8e",58)
		for j in range(6):pieza(Vector3(x,1+j*.32,-1.96),Vector3(1.7,.025,.025),"603843")
	luz(Vector3(20,4,-.5),"ff315e",2.3,7)
	luz(Vector3(28,2,.4),"d12c8b",2.7,5)
	luz(Vector3(8,2,-3),"469de0",3.8,9)
	luz(Vector3(34,2,.5),"53b7bf",2.2,5)
	# Baño de luz sobre Sota; la luminaria pertenece al techo del mostrador.
	var foco := SpotLight3D.new()
	foco.position = Vector3(20,3.3,1.0)
	foco.rotation_degrees = Vector3(-65,0,0)
	foco.light_color = Color("ffc190")
	foco.light_energy = 3
	foco.spot_range = 7
	foco.spot_angle = 66
	foco.shadow_enabled = true
	add_child(foco)
	pieza(Vector3(35,1.4,-1.96),Vector3(4.7,2.8,.3),"191c28")
	ventana(35,1.5,-1.75,3.8,1.65,"38868b")
	cartel("QUÍMICOS",Vector3(35,3.1,-1.5),4.2,"69d2bf",56)
	rotulo("REGULADORES · ESTIMULANTES",Vector3(35,.85,-1.5),"b6b3ae",23)
	cartel("CABINAS",Vector3(29.5,4.25,-1.55),4.6,"e44a91",55)
	rotulo("SENSORIAL / PRIVADO",Vector3(29.5,3.65,-1.5),"ba8da4",23)
	# Servicios, óxido, rejillas, ventilación y cableado atan la arquitectura.
	for p in [Vector3(3,4,-1.9),Vector3(16,6.4,-1.85),Vector3(25,6.4,-1.85),Vector3(34,3.8,-1.8)]:ventilador(p)
	for x in [3.0,14.1,24.0,33.8]:
		tubo(Vector3(x,-1,-1.9),Vector3(x,5.1,-1.9),.15,"4e585f")
		tubo(Vector3(x,5.1,-1.9),Vector3(x+3,5.1,-1.9),.15,"4e585f")
		for y in range(5):pieza(Vector3(x,y,-1.9),Vector3(.38,.075,.38),"7a7370")
		vapor(Vector3(x,1.0,-2),"7c8b9c")
	for x in [5.0,11.0,18.0]:vapor(Vector3(x,-6,-9),"526989",true)
	for fila in range(3):
		for i in range(80):
			var x := -4+i*.55
			var y := 5.8+fila*.22-sin(i/80.0*PI)*1.5
			var yn := 5.8+fila*.22-sin((i+1)/80.0*PI)*1.5
			tubo(Vector3(x,y,-.6-fila*.3),Vector3(x+.55,yn,-.6-fila*.3),.014,"141d27")
	for x in [4,13,32,36]:
		pieza(Vector3(x,.45,-1.1),Vector3(.6,.9,.55),"3f494e")
		for j in range(8):pieza(Vector3(x,.15+j*.075,-.8),Vector3(.48,.02,.035),"151e25")
		rotulo("220 V",Vector3(x,.85,-.8),"c5ac74",19)
	# Carteles de papel pegados, composición de manchas sin inventar marcas canónicas.
	for i in range(22):
		var x := rng.randf_range(17.2,22.7)
		var papel := pieza(Vector3(x,rng.randf_range(.2,.92),-.625),Vector3(.14,.2,.009),["807a6d","595f69","92745e"][i%3],"papel")
		papel.rotation.z = rng.randf_range(-.2,.2)
	# Marcos, contraventanas y reparaciones rompen la cuadrícula regular.
	for x in [-3.0,2.0,15.0,24.5,32.5,39.0]:
		pieza(Vector3(x,4,-1.5),Vector3(.16,10,.28),"363b40")
		for y in [3.9,6.9,9.6]:
			pieza(Vector3(x+.6,y,-1.4),Vector3(1.6,.12,1.2),"262e36")
			for i in range(6):pieza(Vector3(x+.05+i*.23,y+.45,-.82),Vector3(.025,.9,.025),"59636a")
	for x in [16.5,22.1,29.5,35.0]:
		for j in range(9):pieza(Vector3(x,5+j*.09,-2),Vector3(.65,.055,.08),"42363b")
	# Reflejos de las luces reales recogidos por la sonda de la recepción.
	halo(Vector3(28,2.1,-1.9),Vector2(3,5),"ad245e")
	halo(Vector3(8,0,-14),Vector2(9,18),"215e97")
	for x in [5.5,12.0]:
		cartel("04" if x<10 else "FIEBRE",Vector3(x,5.1,-8),1.8,"cc4685",45)
	# La jefa está de visita junto al mostrador; no ocupa el puesto de recepción.
	var persona := preload("res://cuerpo.gd").new()
	persona.estudio_sota = true
	persona.modelo_sota = load("res://assets/velvet_3d_v2/jefa.glb")
	persona.position = Vector3(15.35,0,-.8)
	persona.rotation.y = -.35
	add_child(persona)
	figurantes.append(persona)
	detallar_barrio()
	poblar()
	var reflejo := ReflectionProbe.new()
	reflejo.position = Vector3(19,1.5,0)
	reflejo.size = Vector3(24,8,12)
	reflejo.box_projection = true
	reflejo.intensity = .7
	add_child(reflejo)
	# La ciudad lejana aporta profundidad, no sombras al carril; conservar esta bandera al agrupar.
	for nodo in get_children():
		if nodo is GeometryInstance3D and nodo.position.z < -5:
			nodo.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	agrupar_estaticas()

func _process(delta: float) -> void:
	tiempo += delta
	for aspas in ventiladores:aspas.rotation.z += delta*1.7
	if get_parent().get("pausa") == true: return
	for persona in figurantes:persona.avanzar(delta,false)
	for vecino in paseantes:
		var cuerpo: Node3D = vecino.cuerpo
		var cerca: bool = absf(cuerpo.position.x-vecino.destino)<.15
		if cerca and vecino.espera<=0: vecino.espera=2.5
		var giro: bool = absf(angle_difference(cuerpo.rotation.y,vecino.sentido*PI/2))>.01
		var mover: bool = vecino.espera<=0 and not giro
		cuerpo.position += cuerpo.basis*cuerpo.avanzar(delta*vecino.ritmo,mover)
		if vecino.espera>0:
			vecino.espera-=delta
			if vecino.espera<=0:
				vecino.sentido=-vecino.sentido
				vecino.destino=vecino.fin if vecino.sentido>0 else vecino.inicio
		elif giro and cuerpo.mezcla<=.001:
			cuerpo.rotation.y=rotate_toward(cuerpo.rotation.y,vecino.sentido*PI/2,delta*2.4)

func detallar_barrio() -> void:
	# Instalaciones añadidas sobre las fachadas; cada local tiene una silueta propia.
	for x in [-1.5,15.2,23.4,32.7,36.8]:
		pieza(Vector3(x,6.35,-1.9),Vector3(1.35,.9,.68),"6a6560")
		for i in range(11):pieza(Vector3(x-.55+i*.11,6.35,-1.54),Vector3(.045,.7,.04),"242f37")
		for y in [5.91,6.79]:pieza(Vector3(x,y,-1.49),Vector3(1.45,.06,.06),"8b7c67")
		tubo(Vector3(x+.58,6.35,-1.8),Vector3(x+.58,5.2,-1.8),.035,"b29770")
		tubo(Vector3(x+.58,5.2,-1.8),Vector3(x+1.1,5.2,-1.8),.035,"b29770")
		# Bandejas de cable y conexiones reparadas.
		for j in range(3):tubo(Vector3(x-.6,7.2+j*.07,-1.8),Vector3(x+1.6,7.2+j*.07,-1.8),.018,"28282d")
		for dx in [-.6,.4,1.4]:pieza(Vector3(x+dx,7.27,-1.76),Vector3(.06,.3,.08),"8a7560")
	# Escaleras de mantenimiento y plataformas apoyadas en ménsulas.
	for x in [1.8,24.7,36.8]:
		for dx in [-.24,.24]:tubo(Vector3(x+dx,3.5,-1.25),Vector3(x+dx,9.6,-1.25),.025,"6d7777")
		for i in range(22):tubo(Vector3(x-.24,3.5+i*.28,-1.25),Vector3(x+.24,3.5+i*.28,-1.25),.018,"8b8e86")
		pieza(Vector3(x,7.2,-1.1),Vector3(1.6,.1,1.1),"434a4f")
		for dx in [-.65,.65]:tubo(Vector3(x+dx,6.4,-1.85),Vector3(x+dx,7.15,-.6),.04,"5c6465")
	# Suministros: armarios con interruptores, cerraduras y conducciones visibles.
	for x in [2.6,13.8,32.2]:
		pieza(Vector3(x,1.6,-1.42),Vector3(.78,1.22,.3),"6c6055")
		pieza(Vector3(x,1.6,-1.25),Vector3(.67,1.1,.025),"363e46")
		for j in range(4):
			pieza(Vector3(x-.18,1.88-j*.2,-1.21),Vector3(.23,.11,.05),"1b2027")
			caja(Vector3(x+.18,1.88-j*.2,-1.2),Vector3(.045,.045,.03),"c18c4c" if j%2 else "4f9b9e",false,true)
		for dx in [-.22,.22]:tubo(Vector3(x+dx,2.2,-1.45),Vector3(x+dx,3.3,-1.45),.023,"242f35")
		rotulo("ALTA TENSIÓN",Vector3(x,1.05,-1.2),"d2ab66",18)
	# Anuncios de servicio sin marcas nuevas de canon; rótulos secundarios más pequeños.
	cartel("IMPLANTES",Vector3(2.1,4.15,-1.2),2.5,"61c4c0",42)
	rotulo("AJUSTE / REPARACIÓN",Vector3(2.1,3.78,-1.08),"b6c5b7",17)
	cartel("24 h",Vector3(34.6,5.5,-1.05),1.4,"e2bc6d",52)
	cartel("CYBER / PRIVADO",Vector3(30,6.5,-1.2),3.3,"ac76b7",39)
	for x in [27.1,31.9]:
		pieza(Vector3(x,2.15,-1.8),Vector3(.22,3.1,.32),"53424c")
		neon(Vector3(x,1,-1.61),Vector3(x,3.45,-1.61),"c14987",.012)
	# Máquinas de pared: ranura, pantalla, teclado, vidrio y mercancía.
	for dato in [[3.8,"487c8b"],[12.7,"84525b"],[36.8,"637d6b"]]:
		var x: float = dato[0]
		var color: String = dato[1]
		pieza(Vector3(x,.95,-1),Vector3(.85,1.9,.72),color)
		pieza(Vector3(x,1.12,-.62),Vector3(.71,1.35,.04),"131e28")
		caja(Vector3(x-.14,1.4,-.59),Vector3(.34,.38,.025),"638a91",false,true)
		for i in range(4):
			for j in range(3):pieza(Vector3(x-.23+i*.14,.85+j*.13,-.59),Vector3(.09,.06,.03),"9a9785")
		pieza(Vector3(x,.34,-.58),Vector3(.52,.14,.08),"080e15")
		tubo(Vector3(x+.27,.96,-.56),Vector3(x+.27,1.3,-.56),.02,"cab58b")
		rotulo("RECARGA" if x<20 else "DOSIS",Vector3(x,1.82,-.57),"d8c9ab",18)
	# Elementos propios de Velvet: lista de turnos, cordón y pequeñas botellas.
	for x in [18.0,22.5]:
		for i in range(3):
			tubo(Vector3(x+i*.16,1.27,-1),Vector3(x+i*.16,1.47,-1),.035,"797060")
			tubo(Vector3(x+i*.16,1.47,-1),Vector3(x+i*.16,1.52,-1),.014,"b0a481")
	for x in [25.1,26.0]:
		tubo(Vector3(x,0,-.2),Vector3(x,.9,-.2),.035,"9b8061")
		pieza(Vector3(x,.03,-.2),Vector3(.3,.06,.3),"524b45")
	tubo(Vector3(25.1,.85,-.2),Vector3(25.55,.73,-.2),.025,"6d3549")
	tubo(Vector3(25.55,.73,-.2),Vector3(26,.85,-.2),.025,"6d3549")
	# Persianas reparadas, tablillas y afiches en los muros bajos.
	for x in [-2.8,14.8,32.2]:
		pieza(Vector3(x,2.8,-1.9),Vector3(.9,.65,.08),"8e7761","papel")
		rotulo("TURNOS\nNOCHE",Vector3(x,2.8,-1.84),"302d30",24)
		for j in range(5):pieza(Vector3(x+.1,3.7+j*.12,-1.88),Vector3(.9,.07,.12),"666463")
	for x in [6.1,10.2]:
		pieza(Vector3(x,.45,-9.8),Vector3(.8,.9,.7),"505c5a")
		for i in range(4):pieza(Vector3(x,.13+i*.22,-9.42),Vector3(.75,.025,.04),"232c30")
	# Acera opuesta y drenaje: evita que la carretera ocupe todo el primer plano.
	for x in [1,11,23,34]:
		pieza(Vector3(x,.32,5.2),Vector3(1.1,.45,.65),"4e514d","hormigon")
		pieza(Vector3(x,.55,5.2),Vector3(1.15,.06,.7),"838075")
		for j in range(6):pieza(Vector3(x-.45+j*.18,.39,5.56),Vector3(.06,.2,.02),"273536")
	for x in [5,18,30]:
		pieza(Vector3(x,-.009,3.72),Vector3(.7,.025,.35),"121c24")
		for j in range(9):pieza(Vector3(x-.3+j*.075,.008,3.72),Vector3(.025,.02,.32),"5e6260")
	# Un marco de luz bajo y cableado puntual guían la lectura sin iluminar todo por igual.
	for x in [1.2,12.4,32.8]:
		pieza(Vector3(x,3.4,-1.65),Vector3(.12,.3,.7),"242f39")
		caja(Vector3(x,3.25,-1.3),Vector3(.65,.06,.22),"a3c3b7",false,true)
		luz(Vector3(x,2.9,-.4),"8dc2c2",1.2,3.2)

func poblar() -> void:
	var modelos := [preload("res://assets/velvet_3d_v2/vecina_tecnica.glb"),preload("res://assets/velvet_3d_v2/vecino_visor.glb"),preload("res://assets/velvet_3d_v2/vecina_brazo.glb")]
	# Carriles separados del de Sota; sólo la jefa es conversable en este tramo.
	for dato in [[0,4.8,-.75,4.5,11.6,1.0],[1,30.0,.95,26.8,35.5,-1.0],[2,7.5,-6.0,6.5,10.5,1.0]]:
		var persona := preload("res://cuerpo.gd").new()
		persona.estudio_sota=true
		persona.modelo_sota=modelos[dato[0]]
		persona.position=Vector3(dato[1],0,dato[2])
		persona.rotation.y=dato[5]*PI/2
		add_child(persona)
		paseantes.append({"cuerpo":persona,"inicio":dato[3],"fin":dato[4],"sentido":dato[5],"destino":dato[4] if dato[5]>0 else dato[3],"espera":0.0,"ritmo":.88+float(dato[0])*.08})
	for dato in [[2,23.5,-.45,-.6],[1,10.6,-9.6,.8],[0,11.8,-9.2,-.9]]:
		var persona := preload("res://cuerpo.gd").new()
		persona.estudio_sota=true
		persona.modelo_sota=modelos[dato[0]]
		persona.position=Vector3(dato[1],0,dato[2])
		persona.rotation.y=dato[3]
		add_child(persona)
		figurantes.append(persona)
