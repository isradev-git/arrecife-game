extends SceneTree

# Diagnóstico de las cuatro pruebas aisladas. No certifica su calidad artística.
const OUTPUT = "res://../trabajo/arte/revisiones/claves_sota_v71/"
const V7 = "res://assets/personajes/sota/perfiles_pixel_v7.png"
const NAMES = ["contacto", "apoyo", "impulso", "avance"]

func _initialize() -> void:
	var original := Image.load_from_file(ProjectSettings.globalize_path(V7))
	assert(not original.is_empty())
	var palette := {}
	for y in range(original.get_height()):
		for x in range(original.get_width()):
			var pixel := original.get_pixel(x, y)
			if pixel.a >= 0.95: palette[pixel.to_html(false)] = true
	var report := {}
	for name in NAMES:
		var frame := Image.load_from_file(ProjectSettings.globalize_path(OUTPUT + name + ".png"))
		assert(frame.get_size() == Vector2i(256, 320))
		var count := 0
		var partial := 0
		var foreign := 0
		var min_x := 256
		var min_y := 320
		var max_x := -1
		var max_y := -1
		for y in range(frame.get_height()):
			for x in range(frame.get_width()):
				var pixel := frame.get_pixel(x, y)
				if pixel.a > 0 and pixel.a < 1: partial += 1
				if pixel.a < 0.95: continue
				count += 1
				min_x = mini(min_x, x)
				min_y = mini(min_y, y)
				max_x = maxi(max_x, x)
				max_y = maxi(max_y, y)
				if not palette.has(pixel.to_html(false)): foreign += 1
		report[name] = {"size": [frame.get_width(), frame.get_height()], "opaque_pixels": count, "partial_alpha_pixels": partial, "bounds_inclusive": [min_x, min_y, max_x, max_y], "colors_outside_v7_pixels": foreign}
	var path := ProjectSettings.globalize_path(OUTPUT + "medidas.json")
	var file := FileAccess.open(path, FileAccess.WRITE)
	assert(file != null)
	file.store_string(JSON.stringify(report, "\t") + "\n")
	print(JSON.stringify(report))
	quit()
