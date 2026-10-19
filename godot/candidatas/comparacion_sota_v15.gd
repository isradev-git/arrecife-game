extends Node2D

const BEFORE = preload("res://movimiento_sota.gd")
const AFTER = preload("res://candidatas/movimiento_sota_v15.gd")
const MOTION = preload("res://movimiento.gd")
const OLD_RIG = preload("res://sota_articulada.gd")
var players: Array = []
var sprites: Array[Sprite2D] = []
var roots: Array[Vector2] = []
var motions: Array = []
var positions := [780.0,780.0]
var old_rig := OLD_RIG.new()
var elapsed := 0.0
var travel := 0.0
var paused := false
var slow := false
var debug := false
var transitions := false
var status := Label.new()

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color("202a37"))
	add_child(old_rig)
	old_rig.build(0)
	old_rig.hide()
	for row in range(2):
		motions.append(MOTION.new())
		for column in range(2):
			var walk = BEFORE.new() if column==0 else AFTER.new()
			var sprite := Sprite2D.new()
			add_child(sprite)
			sprite.show_behind_parent=true
			walk.reset(row)
			walk.update(sprite,0,0,row)
			players.append(walk)
			sprites.append(sprite)
			roots.append(Vector2(410+column*840,450+row*390))
	var ui := CanvasLayer.new()
	add_child(ui)
	var box := VBoxContainer.new()
	box.position=Vector2(24,16)
	ui.add_child(box)
	var title := Label.new()
	title.text="SOTA · Comparación independiente · Izquierda: Modelo 14 / Derecha: candidata IK 15"
	box.add_child(title)
	var controls := HBoxContainer.new()
	box.add_child(controls)
	button(controls,"Pausar",func(): paused=true)
	button(controls,"Reanudar",func(): paused=false)
	button(controls,"0,25× / 1×",func(): slow=not slow)
	button(controls,"− Fotograma",func(): step_frame(-1))
	button(controls,"+ Fotograma",func(): step_frame(1))
	button(controls,"Marcha / Transiciones",func(): transitions=not transitions; restart())
	button(controls,"Articulaciones",func(): debug=not debug; queue_redraw())
	button(controls,"Probar en Velvet",func(): get_tree().change_scene_to_file("res://candidatas/recorrido_sota_v15.tscn"))
	box.add_child(status)
	refresh()

func button(parent: Node, text: String, action: Callable) -> void:
	var control := Button.new()
	control.text=text
	control.pressed.connect(action)
	parent.add_child(control)

func restart() -> void:
	elapsed=0
	travel=0
	positions=[780.0,780.0]
	for i in range(4): players[i].reset(i/2)
	for motion in motions: motion.stop()

func step_frame(step: int) -> void:
	paused=true
	transitions=false
	travel=fposmod(travel+step*2.0,128.0)
	refresh()

func _process(delta: float) -> void:
	if not paused:
		var dt := minf(delta,0.05)*(0.25 if slow else 1.0)
		elapsed+=dt
		if transitions:
			var time := fposmod(elapsed,8.0)
			var intent := 1.0 if time<2.0 or (time>2.7 and time<3.0) else (-1.0 if time>4.0 and time<6.5 else 0.0)
			for row in range(2):
				var previous: float=positions[row]
				positions[row]=motions[row].step(previous,dt,intent*(1.0 if row==0 else -1.0))
				for column in range(2):
					var i := row*2+column
					var moved: float=positions[row]-previous
					players[i].update(sprites[i],moved,dt,(0 if moved>0 else 1) if moved!=0 else players[i].profile)
		else:
			travel+=104.0*dt
		refresh()

func refresh() -> void:
	for i in range(4):
		if not transitions:
			var phase := fposmod(travel/128.0,1.0)
			var walk = players[i]
			walk.profile=i/2
			walk.frame_index=posmod(roundi(phase*walk.data.fases),int(walk.data.fases))
			walk.state="marcha"
			walk.apply(sprites[i],walk.data.perfiles[walk.profile].marcha[walk.frame_index])
		sprites[i].position=roots[i]
	status.text="%s · %s · fase %.3f · 104 px/s · ciclo 128 px · escala 252 · %s" % ["Pausa" if paused else "Reproduciendo","0,25×" if slow else "1×",(players[1].frame_index/64.0 if transitions else fposmod(travel/128.0,1.0)),"arranque / parada / reanudación / inversión" if transitions else "dos perfiles simultáneos"]
	queue_redraw()

func _draw() -> void:
	for i in range(roots.size()):
		var base := roots[i]
		var row := i/2
		var scroll: float=positions[row]-780.0 if transitions else travel*(1 if row==0 else -1)
		draw_line(Vector2(base.x-370,base.y+1),Vector2(base.x+370,base.y+1),Color("8293a4"),1)
		for grid in range(-6,7):
			var x := base.x+grid*64-fposmod(scroll,64.0)
			draw_line(Vector2(roundf(x),base.y+2),Vector2(roundf(x),base.y+12),Color("55616f"),1)
		if debug:
			var walk = players[i]
			var pose: Dictionary=walk.current_pose()
			var joints: Array=[]
			if i%2==1: joints=pose.articulaciones
			else:
				var phase: float=maxi(walk.frame_index,0)/32.0
				old_rig.pose(phase,walk.blend if transitions else 1.0)
				for leg in old_rig.legs:
					var points := []
					for point in [leg.thigh.position,leg.shin.position,leg.boot.position]:
						var p: Vector2=point+old_rig.body.position
						if walk.profile==1: p.x=-p.x
						points.append([p.x,p.y])
					joints.append(points)
			for index in range(joints.size()):
				var leg: Array=joints[index]
				var h := Vector2(leg[0][0],leg[0][1])+base
				var k := Vector2(leg[1][0],leg[1][1])+base
				var a := Vector2(leg[2][0],leg[2][1])+base
				draw_line(h,k,Color.CYAN,1)
				draw_line(k,a,Color.YELLOW,1)
				for p in [h,k,a]: draw_circle(p,2,Color.WHITE)
				draw_string(ThemeDB.fallback_font,base+Vector2(100,-170+index*22),"%s: %.2f / %.2f" % ["Fondo" if index==0 else "Cerca",h.distance_to(k),k.distance_to(a)],HORIZONTAL_ALIGNMENT_LEFT,-1,13)
				if i%2==1 and pose.apoyo[index]: draw_circle(a,4,Color.GREEN,false,1.0)
