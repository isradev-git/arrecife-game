extends SceneTree

const WALK = preload("res://animacion_marcha.gd")
var walk := WALK.new()


func _initialize() -> void:
	call_deferred("check")


func check() -> void:
	for profile in range(2):
		assert(walk.frames[profile].size() == 8)
		for index in range(8):
			var texture: AtlasTexture = walk.frames[profile][index]
			assert(texture.get_size() == Vector2(512, 544))
			assert(texture.filter_clip)
			assert(texture.margin.position.x >= 0.0 and texture.margin.position.y >= 0.0)
			assert(texture.margin.position.x <= texture.margin.size.x and texture.margin.position.y <= texture.margin.size.y)
			var image: Image = texture.atlas.get_image()
			assert(image.get_pixel(0, 0).a == 0.0)
			assert(Rect2(Vector2.ZERO, image.get_size()).encloses(texture.region))
			assert(walk.frame_at(index * walk.data.distancia_ciclo / 8.0) == index)
	assert(walk.frame_at(walk.data.distancia_ciclo) == 0)
	assert(walk.frames[0][0].atlas != walk.frames[1][0].atlas)
	# Archivo de la propuesta rechazada: comprueba datos y retirada del recorrido, no aprobación artística.
	var scene = load("res://recorrido.tscn").instantiate()
	root.add_child(scene)
	scene.set_physics_process(false)
	await physics_frame
	await process_frame
	for profile in range(2):
		scene.cancel_movement()
		scene.body.position = Vector2(780, 705)
		scene.show_pose(profile)
		for tick in range(90):
			scene.advance(1.0 / 60.0, 1.0 if profile == 0 else -1.0)
			assert(scene.sota.texture.atlas == scene.ATLASES[0])
			assert(scene.sota.material.shader == scene.CUTOUT)
	print("OK: datos históricos de 16 poses conservados; recorrido usa únicamente v7 al moverse.")
	scene.queue_free()
	await process_frame
	# Las capturas rechazadas se conservan; la corrección se renderiza con identidad_marcha.gd.
	quit()
