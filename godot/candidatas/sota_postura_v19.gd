extends "res://candidatas/sota_ropa_v18.gd"

func upper_offset() -> Vector2:
	# El perfil izquierdo tiene la cadera original desplazada respecto al centro del vestido.
	return Vector2((legs[1].hip.x-legs[0].hip.x)*0.5,0) if facing==1 else Vector2.ZERO

func pose(phase: float, amount: float = 1.0) -> void:
	super.pose(phase,amount)
	if legs.size()!=2 or arms.size()!=2: return
	var pixel_offset := body.position.round()-body.position
	var old_lean: float = parts.torso.rotation
	var lean := (0.035+(channel("tronco",phase)-float(capture.canales.tronco[0]))*0.5)*direction
	var shift := upper_offset()
	var pivot := Vector2(0,-124)
	parts.torso.position=pivot+pixel_offset+shift
	parts.torso.rotation=lean
	var neck := Vector2(-12*direction,-80)
	parts.head.position=neck.rotated(lean)-neck+pixel_offset+shift
	# El dibujo izquierdo baja la barbilla; abrir ligeramente el cuello conserva su punto de unión.
	var head_tilt := 0.06 if facing==1 else 0.0
	var head_pivot := pivot+neck
	parts.head.rotation=head_tilt
	parts.head.position+=head_pivot-head_pivot.rotated(head_tilt)
	parts.deck.rotation=lean
	parts.deck.position=pivot-pivot.rotated(lean)+pixel_offset+shift
	for arm in arms:
		# Trasladar hombro y codo juntos conserva el gesto y la longitud del brazo.
		var original: Vector2 = (arm.sleeve.position-pivot-pixel_offset).rotated(-old_lean)
		var shoulder := original.rotated(lean)+pivot+pixel_offset+shift
		var offset: Vector2 = shoulder-arm.sleeve.position
		arm.sleeve.position=shoulder
		arm.hand.position+=offset

func cloth_point(leg: Dictionary, source: Vector2, hip: Vector2, knee: Vector2, ankle: Vector2) -> Vector2:
	var cloth := super.cloth_point(leg,source,hip,knee,ankle)
	if facing==1:
		# La cintura debe nacer sobre la cadera animada, no sobre la pierna separada del dibujo estático.
		var waist := (490.0-hip_source.y)*pixel_scale
		cloth.x+=(hip.x-leg.hip.x)*(1.0-smoothstep(waist,waist+18,source.y))
	return cloth
