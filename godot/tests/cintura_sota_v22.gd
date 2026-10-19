extends SceneTree
func _initialize() -> void: call_deferred("run")
func edge(image: Image, origin: Vector2i, y: int, direction: int) -> int:
	var x := 96
	assert(image.get_pixel(origin.x+x,origin.y+y).a>0.95,"Corte en el centro de la cintura")
	while x>0 and x<191 and image.get_pixel(origin.x+x,origin.y+y).a>0.95: x+=direction
	return x*direction
func run() -> void:
	var results := []
	for folder in ["captura_v21_candidata","captura_v22_candidata"]:
		var base: String = "res://assets/personajes/sota/"+folder+"/"
		var data: Dictionary = JSON.parse_string(FileAccess.get_file_as_string(base+"movimiento.json"))
		var image := Image.load_from_file(ProjectSettings.globalize_path(base+"marcha.png"))
		var maximum := 0
		var location := Vector2i.ZERO
		for profile in range(2):
			var scale: float = 252.0/(869.0 if profile==0 else 865.0)
			for phase in range(64):
				var pose: Dictionary = data.perfiles[profile].marcha[phase]
				var origin := Vector2i(pose.celda[0],pose.celda[1])
				var first := ceili(272+float(pose.pelvis[1])+(490-945)*scale)
				var last := floori(272+float(pose.pelvis[1])+(550-945)*scale)
				var before := edge(image,origin,first-1,1 if profile==0 else -1)
				for y in range(first,last+1):
					var current := edge(image,origin,y,1 if profile==0 else -1)
					if before-current>maximum:
						maximum=before-current
						location=Vector2i(profile,phase)
					before=current
		print(folder,": mayor entrante entre filas = ",maximum," px; perfil/fase ",location)
		results.append(maximum)
	assert(results[0]>=7,"La prueba debe detectar el hueco abierto señalado en la 21")
	assert(results[1]<=3,"Hendidura brusca entre el torso y el pantalón")
	quit()
