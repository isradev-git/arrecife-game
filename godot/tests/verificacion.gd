extends SceneTree


func _initialize() -> void:
	call_deferred("check_scene")


func check_scene() -> void:
	var scene := load("res://verificacion.tscn").instantiate() as Control
	root.add_child(scene)
	assert(scene.get_node("Fiebre").texture.get_width() == 1672)
	var button := scene.get_node("Center/Panel/Margin/Column/Check") as Button
	assert(button.has_focus())
	button.pressed.emit()
	assert(scene.get_node("Center/Panel/Margin/Column/Status").text == "Entrada recibida. Godot está funcionando.")
	print("OK: escena, textura, foco y señal de entrada.")
	quit()
