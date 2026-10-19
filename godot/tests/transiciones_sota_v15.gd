extends SceneTree
const WALK=preload("res://candidatas/movimiento_sota_v15.gd")
func _initialize() -> void: call_deferred("check")
func check() -> void:
	var walk:=WALK.new()
	var sprite:=Sprite2D.new()
	var stop_jump:=0.0
	var start_jump:=0.0
	var turn_jump:=0.0
	var turn_height:=0.0
	var support_drift:=0.0
	for rate in [30,60,120]:
		for profile in range(2):
			for phase in range(64):
				walk.reset(profile)
				walk.blend=1.0
				walk.state="marcha"
				walk.frame_index=phase
				walk.closing_frame=phase
				walk.distance=posmod(phase-16,64)*2.0
				walk.apply(sprite,walk.data.perfiles[profile].marcha[phase])
				var previous:=walk.current_pose()
				for tick in range(ceili(rate*0.5)):
					walk.update(sprite,0,1.0/rate,profile)
					var pose:=walk.current_pose()
					for leg in range(2):
						for joint in range(3): stop_jump=maxf(stop_jump,point(previous,leg,joint).distance_to(point(pose,leg,joint)))
						var p:=fposmod(phase/64.0+(0.5 if leg==0 else 0.0),1.0)
						if p>=0.12 and p<=0.42: support_drift=maxf(support_drift,point(previous,leg,2).distance_to(point(pose,leg,2)))
					previous=pose
				assert(walk.state=="reposo")
				var distance:=walk.distance
				walk.update(sprite,0.1*(1 if profile==0 else -1),1.0/rate,profile)
				assert(is_equal_approx(walk.distance,distance+0.1))
				assert(sprite.position==Vector2.ZERO and sprite.scale==Vector2.ONE and not sprite.flip_h)
				walk.reset(profile)
				walk.phase_offset=phase
				walk.closing_frame=phase
				walk.apply(sprite,walk.blended_pose(phase))
				previous=walk.current_pose()
				var motion=load("res://movimiento.gd").new()
				var x:=780.0
				var accumulated:=0.0
				for tick in range(rate):
					var next_x: float=motion.step(x,1.0/rate,1.0 if profile==0 else -1.0)
					var moved:=next_x-x
					x=next_x
					accumulated+=absf(moved)
					walk.update(sprite,moved,1.0/rate,profile)
					assert(is_equal_approx(walk.distance,accumulated))
					assert(walk.frame_index==posmod(roundi(accumulated/2.0)+phase,64))
					var pose:=walk.current_pose()
					if walk.state=="arranque" or previous.amplitud<1.0:
						for leg in range(2):
							for joint in range(3): start_jump=maxf(start_jump,point(previous,leg,joint).distance_to(point(pose,leg,joint)))
					previous=pose
				for blend in [0.0,0.5,1.0]:
					walk.profile=profile
					walk.blend=blend
					walk.apply(sprite,walk.blended_pose(phase))
					previous=walk.current_pose()
					walk.turn(1-profile)
					var next:=walk.blended_pose(walk.closing_frame)
					var direct:=maxf(point(previous,0,2).distance_to(point(next,0,2)),point(previous,1,2).distance_to(point(next,1,2)))
					var swapped:=maxf(point(previous,0,2).distance_to(point(next,1,2)),point(previous,1,2).distance_to(point(next,0,2)))
					turn_jump=maxf(turn_jump,minf(direct,swapped))
					turn_height=maxf(turn_height,absf(previous.pelvis[1]-next.pelvis[1]))
	print("Paradas/reanudaciones: 384 casos. Mayor salto articular por tick %.3f px; deriva tobillo de apoyo plano %.5f px. Inversión: pies %.3f px, pelvis %.3f px." % [stop_jump,support_drift,turn_jump,turn_height])
	print("Arranque con aceleración real: mayor salto articular %.3f px; sincronía por distancia comprobada en 384 casos a 30/60/120 Hz." % start_jump)
	sprite.free()
	quit(0 if start_jump<18.0 and stop_jump<8.0 and support_drift<0.001 and turn_jump<5.0 and turn_height<3.0 else 1)
func point(pose: Dictionary,leg: int,joint: int) -> Vector2:
	return Vector2(pose.articulaciones[leg][joint][0],pose.articulaciones[leg][joint][1])
