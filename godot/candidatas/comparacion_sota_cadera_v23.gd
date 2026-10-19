extends Node2D
var data: Array = []
var atlases: Array[Texture2D] = []
var elapsed := 0.0
var paused := false
var slow := false
var debug := false
var status := Label.new()
const ROOTS = [Vector2(420,480),Vector2(1250,480),Vector2(420,850),Vector2(1250,850)]
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("202a37"))
	texture_filter=CanvasItem.TEXTURE_FILTER_NEAREST
	for folder in ["captura_v22_candidata","captura_v23_candidata"]:
		var base: String = "res://assets/personajes/sota/"+folder+"/"
		data.append(JSON.parse_string(FileAccess.get_file_as_string(base+"movimiento.json")))
		atlases.append(load(base+"marcha.png"))
	var panel := VBoxContainer.new()
	panel.position=Vector2(30,25)
	add_child(panel)
	var title := Label.new()
	title.text="SOTA · Cadera 22 / 23 · Arriba: derecha · Abajo: izquierda"
	panel.add_child(title)
	var controls := HBoxContainer.new()
	panel.add_child(controls)
	button(controls,"Pausar",func(): paused=true)
	button(controls,"Reanudar",func(): paused=false)
	button(controls,"0,25× / 1×",func(): slow=not slow)
	button(controls,"+ Fotograma",func(): paused=true; elapsed=(floor(elapsed*104/140*64)+1)/64*140/104; queue_redraw())
	button(controls,"Articulaciones",func(): debug=not debug; queue_redraw())
	panel.add_child(status)
	var note := Label.new()
	note.text="104 px/s en ambas versiones · ciclo 140 px en ambas versiones\nVestuario heredado provisional. No es dibujo final ni nueva versión predeterminada."
	panel.add_child(note)
func button(parent: Node, text: String, action: Callable) -> void:
	var control := Button.new()
	control.text=text
	control.pressed.connect(action)
	parent.add_child(control)
func _process(delta: float) -> void:
	if not paused: elapsed+=minf(delta,0.05)*(0.25 if slow else 1.0)
	status.text="Fase %d/63 · %s" % [int(elapsed*104/140*64)%64,"Pausa" if paused else "Marcha"]
	queue_redraw()
func _draw() -> void:
	if data.is_empty(): return
	for column in range(4):
		var version := column%2
		var profile: int = column/2
		var frame := int(elapsed*104/float(data[version].distancia_ciclo)*64)%64
		var pose: Dictionary = data[version].perfiles[profile].marcha[frame]
		var cell: Array = pose.celda
		var root: Vector2 = ROOTS[column]
		var origin := Vector2(pose.cadera_x-cell[0],pose.suelo_y-cell[1])
		draw_texture_rect_region(atlases[version],Rect2((root-origin).round(),Vector2(cell[2],cell[3])),Rect2(cell[0],cell[1],cell[2],cell[3]))
		draw_line(root+Vector2(-220,1),root+Vector2(220,1),Color("667686"))
		for x in range(-200,201,32):
			var offset := fposmod(elapsed*104*(-1 if profile==1 else 1),32)
			draw_line(root+Vector2(x-offset,8),root+Vector2(x-offset,15),Color("667686"))
		if debug:
			for i in range(2):
				var points: Array = pose.articulaciones[i]
				var color := Color("73c8e2") if i==0 else Color("eab877")
				for j in range(3):
					var point := root+Vector2(points[j][0],points[j][1])
					draw_circle(point,2,color)
					if j>0: draw_line(root+Vector2(points[j-1][0],points[j-1][1]),point,color)
