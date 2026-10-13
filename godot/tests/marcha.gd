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
	print("OK: datos históricos de 16 poses rechazadas conservados; animación vigente comprobada en movimiento_sota.gd.")
	quit()
