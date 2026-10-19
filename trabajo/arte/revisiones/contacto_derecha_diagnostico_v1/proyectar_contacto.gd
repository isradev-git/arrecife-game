extends SceneTree

const DIR = "res://../trabajo/arte/revisiones/contacto_derecha_diagnostico_v1/"
const INPUT = DIR + "contacto_ia_intento1_descartado.png"
const REFERENCE = "res://../trabajo/arte/revisiones/claves_sota_v71/v7_reposo_derecha.png"
const OUTPUT = DIR + "contacto_derecha_prueba_v2.png"
const ZOOM = DIR + "contacto_derecha_prueba_v2_4x.png"
const COMPARISON = DIR + "comparacion_reposo_contacto_v2.png"

func _initialize() -> void:
	var source := Image.load_from_file(ProjectSettings.globalize_path(INPUT))
	assert(source.get_size() == Vector2i(1122, 1402))
	var figure := source.get_region(Rect2i(340, 237, 463, 1029))
	figure.resize(104, 250, Image.INTERPOLATE_NEAREST)
	var reference := Image.load_from_file(ProjectSettings.globalize_path(REFERENCE))
	assert(reference.get_size() == Vector2i(256, 320))
	var palette: Array[Color] = []
	var seen := {}
	for y in range(176, 300):
		for x in range(256):
			var color := reference.get_pixel(x, y)
			if color.a < 0.95: continue
			var key := color.to_rgba32()
			if not seen.has(key):
				seen[key] = true
				palette.append(color)
	var frame := Image.create_empty(256, 320, false, Image.FORMAT_RGBA8)
	frame.fill(Color(0, 0, 0, 0))
	var mapped := {}
	for y in range(figure.get_height()):
		for x in range(figure.get_width()):
			var pixel := figure.get_pixel(x, y)
			if pixel.a < 0.95: continue
			var key := pixel.to_rgba32()
			if not mapped.has(key):
				var best := palette[0]
				var distance := INF
				for sample in palette:
					var delta := pixel - sample
					var score := delta.r * delta.r + delta.g * delta.g + delta.b * delta.b
					if score < distance:
						distance = score
						best = sample
				mapped[key] = Color(best.r, best.g, best.b, 1.0)
			# shortcut: mover el dibujo inferior hasta siete píxeles bajo la cintura; redibujar esa unión si se aprueba el gesto.
			var row := 50 + y
			var shift := roundi(lerpf(-7.0, 0.0, clampf((row - 170.0) / 100.0, 0.0, 1.0)))
			frame.set_pixel(80 + x + shift, row, mapped[key])
	frame.blit_rect(reference, Rect2i(0, 0, 256, 176), Vector2i.ZERO)
	for y in range(176, 211):
		for x in range(95, 117):
			# La mano original queda delante; el bolsillo viejo del pantalón no se copia.
			var pixel := reference.get_pixel(x, y)
			if pixel.a >= 0.95:
				frame.set_pixel(x, y, pixel)
	var bounds := Rect2i(256, 320, 0, 0)
	for y in range(320):
		for x in range(256):
			var pixel := frame.get_pixel(x, y)
			assert(pixel.a == 0.0 or pixel.a == 1.0)
			if y < 176: assert(pixel == reference.get_pixel(x, y))
			if pixel.a == 1.0:
				bounds.position.x = mini(bounds.position.x, x)
				bounds.position.y = mini(bounds.position.y, y)
				bounds.end.x = maxi(bounds.end.x, x + 1)
				bounds.end.y = maxi(bounds.end.y, y + 1)
	assert(bounds == Rect2i(80, 48, 104, 252))
	assert(frame.get_pixel(121, 294).a == 1.0 and frame.get_pixel(183, 295).a == 1.0)
	assert(frame.get_pixel(130, 290).a == 0.0)
	assert(frame.save_png(ProjectSettings.globalize_path(OUTPUT)) == OK)
	var comparison := Image.create_empty(512, 320, false, Image.FORMAT_RGBA8)
	comparison.fill(Color8(23, 22, 27))
	comparison.blend_rect(reference, Rect2i(0, 0, 256, 320), Vector2i.ZERO)
	comparison.blend_rect(frame, Rect2i(0, 0, 256, 320), Vector2i(256, 0))
	assert(comparison.save_png(ProjectSettings.globalize_path(COMPARISON)) == OK)
	var enlarged := frame.duplicate()
	enlarged.resize(1024, 1280, Image.INTERPOLATE_NEAREST)
	assert(enlarged.save_png(ProjectSettings.globalize_path(ZOOM)) == OK)
	quit()
