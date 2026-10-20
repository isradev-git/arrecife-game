extends Node

var world: Dictionary
var story: Dictionary
var missions: Dictionary
var dialogues: Dictionary

func _ready() -> void:
	world = read_data("world")
	story = read_data("story")
	missions = read_data("missions")
	dialogues = read_data("dialogues")

func read_data(id: String) -> Dictionary:
	var result = JSON.parse_string(FileAccess.get_file_as_string("res://data/%s.json" % id))
	assert(result is Dictionary, "Contenido inválido: " + id)
	return result
