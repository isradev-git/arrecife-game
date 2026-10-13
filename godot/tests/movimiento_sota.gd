extends SceneTree

const WALK = preload("res://movimiento_sota.gd")
const OUTPUT = "res://../trabajo/arte/revisiones/movimiento_completo_v1/"


func _initialize() -> void:
	call_deferred("check")


func check() -> void:
	var walk := WALK.new()
	for profile in range(2):
		var view: Dictionary = walk.data.perfiles[profile]
		assert(view.marcha.size() == 16)
		assert(is_equal_approx(view.escala * view.reposo.limites[3], 252.0))
		var reference: float = view.reposo.medida.luminancia_srgb_media
		for pose in view.marcha + [view.preparar, view.cerrar_a, view.cerrar_b, view.respirar]:
			assert(pose.limites[3] > 820 and pose.limites[3] < 910)
			var ratio: float = pose.medida.luminancia_srgb_media / reference
			assert(ratio > 0.8 and ratio < 1.15, "Revisar paleta: " + pose.archivo)
			assert(pose.apoyo_x >= pose.limites[0] and pose.apoyo_x < pose.limites[0] + pose.limites[2])
			var texture: AtlasTexture = walk.textures[pose.archivo + str(pose.celda[0])]
			assert(texture.get_size() == Vector2(836, 1024) and texture.filter_clip)
		assert(view.marcha[0].archivo != walk.data.perfiles[1 - profile].marcha[0].archivo)
	for index in range(16):
		assert(walk.frame_at(index * WALK.CYCLE_DISTANCE / 16.0) == (index + 4) % 16)
	assert(walk.frame_at(WALK.CYCLE_DISTANCE) == walk.frame_at(0.0))
	var scene = load("res://recorrido.tscn").instantiate()
	root.add_child(scene)
	scene.set_physics_process(false)
	await process_frame
	await physics_frame
	for profile in range(2):
		scene.cancel_movement()
		scene.body.position = Vector2(780, 705)
		scene.show_pose(profile)
		var direction := 1.0 if profile == 0 else -1.0
		var seen: Dictionary = {}
		var old_step := -1
		var anchor := 0.0
		for tick in range(180):
			scene.advance(1.0 / 60.0, direction)
			assert(scene.sota.scale.is_equal_approx(Vector2.ONE * float(scene.walk.data.perfiles[profile].escala)))
			assert(not scene.sota.flip_h and not scene.sota.flip_v)
			if scene.walk.state != "marcha":
				continue
			seen[scene.walk.frame_index] = true
			var pose: Dictionary = scene.walk.data.perfiles[profile].marcha[scene.walk.frame_index]
			var sole: Vector2 = scene.sota.to_global(scene.sota.offset + Vector2(pose.apoyo_x - pose.celda[0], pose.suelo_y))
			assert(is_equal_approx(sole.y, 705.0))
			if scene.walk.plant_step == old_step:
				assert(absf(sole.x - anchor) < 0.05, "Deslizamiento del pie plantado")
			old_step = scene.walk.plant_step
			anchor = sole.x
			assert(absf(scene.walk.visual_offset) < 40.0, "Revisar pivote/zancada: perfil %d fase %d, offset %.2f" % [profile, scene.walk.frame_index, scene.walk.visual_offset])
		assert(seen.size() == 16, "El recorrido no muestra todas las fases")
		var stopped: Vector2 = scene.body.position
		for tick in range(60):
			scene.advance(1.0 / 60.0, 0.0)
		assert(scene.motion.velocity == 0.0 and scene.walk.state == "reposo")
		stopped = scene.body.position
		for tick in range(300):
			scene.advance(1.0 / 60.0, 0.0)
			assert(scene.body.position == stopped)
		scene.walk.reduced_motion = true
		for tick in range(300):
			scene.advance(1.0 / 60.0, 0.0)
			assert(scene.sota.texture.atlas.resource_path.ends_with("perfiles_pixel_v7.png"))
		scene.walk.reduced_motion = false
	# Inversión repetida sin frontal ni fases heredadas del sentido anterior.
	scene.body.position = Vector2(780, 705)
	for intent in [1.0, -1.0, 1.0, -1.0]:
		for tick in range(45):
			scene.advance(1.0 / 60.0, intent)
		assert(scene.walk.profile == (0 if intent > 0.0 else 1))
		assert(scene.walk.state == "marcha")
	# Comprobar todas las fases al aproximarse al borde, incluidas botas adelantadas.
	for profile in range(2):
		for start in range(16):
			scene.cancel_movement()
			scene.show_pose(profile)
			scene.body.position.x = scene.MOTION.MAX_X - 180.0 - start * 12.0 if profile == 0 else scene.MOTION.MIN_X + 180.0 + start * 12.0
			for tick in range(200):
				scene.advance(1.0 / 60.0, 1.0 if profile == 0 else -1.0)
				var view: Dictionary = scene.walk.data.perfiles[scene.walk.profile]
				var pose: Dictionary = view.marcha[scene.walk.frame_index] if scene.walk.state == "marcha" else view.preparar if scene.walk.state == "arranque" else view.cerrar_a if scene.walk.state == "parada" and scene.walk.closing_step == 0 else view.cerrar_b if scene.walk.state == "parada" else view.reposo
				var left: Vector2 = scene.sota.to_global(scene.sota.offset + Vector2(pose.limites[0] - pose.celda[0], 0))
				var right: float = left.x + float(pose.limites[2]) * scene.sota.scale.x
				assert(left.x >= 0.0 and right <= 1672.0, "Sprite cortado en el extremo")
	if "--capturas" in OS.get_cmdline_user_args() and DisplayServer.get_name() != "headless":
		await capture(scene)
	scene.queue_free()
	await process_frame
	print("OK: 32 fases propias, escala común, paleta, pies 705 sin deslizamiento, bucle, ambos sentidos, reposo/respiración, reducción de movimiento e inversión.")
	quit()


func capture(scene: Node2D) -> void:
	for profile in range(2):
		scene.cancel_movement()
		scene.body.position = Vector2(520 if profile == 0 else 1160, 705)
		scene.show_pose(profile)
		var direction := 1.0 if profile == 0 else -1.0
		for tick in range(110):
			scene.advance(1.0 / 60.0, direction)
			if tick in [1, 10, 30, 50, 70, 90]:
				await save_frame("%s_%03d" % ["derecha" if profile == 0 else "izquierda", tick])
		for tick in range(25):
			scene.advance(1.0 / 60.0, 0.0)
			if tick in [3, 15, 24]:
				await save_frame("%s_parada_%02d" % ["derecha" if profile == 0 else "izquierda", tick])
		for tick in range(100):
			scene.advance(1.0 / 60.0, 0.0)
		await save_frame("%s_respiracion" % ["derecha" if profile == 0 else "izquierda"])


func save_frame(name: String) -> void:
	for tick in range(3):
		await process_frame
	await RenderingServer.frame_post_draw
	assert(root.get_texture().get_image().save_png(OUTPUT + name + ".png") == OK)
