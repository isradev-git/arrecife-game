extends "res://recorrido.gd"

func _init() -> void:
	walk=preload("res://candidatas/movimiento_sota_v15.gd").new()

func build_controls() -> void:
	super.build_controls()
	var column := review_panel.get_child(0)
	column.get_child(0).text="VELVET · Candidata IK 15 · Sin aprobación artística"
	var row := HBoxContainer.new()
	column.add_child(row)
	add_button(row,"Volver a comparación",get_tree().change_scene_to_file.bind("res://candidatas/comparacion_sota_v15.tscn"))
