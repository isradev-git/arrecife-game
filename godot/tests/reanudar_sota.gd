extends SceneTree

func _initialize() -> void:
	var script = load("res://movimiento_sota.gd")
	if "--antes" in OS.get_cmdline_user_args():
		script = GDScript.new()
		script.source_code=FileAccess.get_file_as_string("res://../trabajo/arte/revisiones/movimiento_integral_v10/controlador_antes.gd.txt")
		assert(script.reload()==OK)
	var errors := 0
	for profile in range(2):
		for phase in range(32):
			for pause in [0.016,0.08,0.16]:
				var walk = script.new()
				var sprite := Sprite2D.new()
				var direction := 1.0 if profile==0 else -1.0
				walk.reset(profile)
				walk.update(sprite,direction*(128+phase*4),1.0/60,profile)
				var distance: float = walk.distance
				for tick in range(ceili(pause*60)):
					walk.update(sprite,0.0,1.0/60,profile)
				walk.update(sprite,direction*0.2,1.0/60,profile)
				if not is_equal_approx(walk.distance,distance+0.2): errors+=1
				if sprite.position!=Vector2.ZERO: errors+=1
				sprite.free()
	print("Reanudar tras pulsaciones cortas: %d reinicios de fase en 192 casos." % errors)
	quit(1 if errors else 0)
