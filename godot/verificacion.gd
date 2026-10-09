extends Control


func _ready() -> void:
	$Center/Panel/Margin/Column/Check.grab_focus()


func _on_check_pressed() -> void:
	$Center/Panel/Margin/Column/Status.text = "Entrada recibida. Godot está funcionando."
