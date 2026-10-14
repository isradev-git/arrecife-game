extends SceneTree

const RIG = preload("res://sota_articulada.gd")

func _initialize() -> void:
	call_deferred("inspect")

func inspect() -> void:
	for filename in ["base_anatomica_intento1.png", "base_anatomica_intento2.png"]:
		var image := Image.load_from_file(ProjectSettings.globalize_path("res://../trabajo/arte/revisiones/claves_sota_v71/" + filename))
		print("source %s %s: corners %s %s, glow %s, cloth %s" % [filename, image.get_size(), image.get_pixel(0, 0), image.get_pixel(image.get_width()-1, image.get_height()-1), image.get_pixel(100, 750), image.get_pixel(550, 850)])
	for phase in [0.0, 0.25, 0.5, 0.75]:
		var figure = RIG.new()
		root.add_child(figure)
		figure.build(0)
		figure.pose(phase)
		print("phase %.2f, body %s" % [phase, figure.body.position])
		for index in range(2):
			var leg: Dictionary = figure.legs[index]
			print("  leg %d hip %s knee %s ankle %s boot_angle %.3f" % [index, leg.thigh.position, leg.shin.position, leg.boot.position, leg.boot.rotation])
		figure.queue_free()
	quit()
