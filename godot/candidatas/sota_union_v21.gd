extends "res://candidatas/sota_pelvis_v20.gd"
const TORSO_CUT = preload("res://candidatas/recorte_torso_v21.gdshader")

func build(profile: int) -> void:
	super.build(profile)
	# Recortar por UV conserva la triangulación y los píxeles superiores del torso.
	var cut := ShaderMaterial.new()
	cut.shader=TORSO_CUT
	cut.set_shader_parameter("profile",profile)
	cut.set_shader_parameter("alpha_threshold",0.95)
	cut.set_shader_parameter("opaque_cutout",true)
	parts.torso.use_parent_material=false
	parts.torso.material=cut
	if profile==1:
		# Retirar el relleno histórico que prolongaba el borde junto a la mano pintada.
		for patch in parts.torso.get_children():
			var bounds := Rect2(patch.polygon[0],Vector2.ZERO)
			for point in patch.polygon: bounds=bounds.expand(point)
			var corner := (bounds.position-Vector2(0,124))/pixel_scale+hip_source
			if corner.x<1005 and corner.y>500: patch.hide()
	pose(0.0)

func pose(phase: float, amount: float = 1.0) -> void:
	super.pose(phase,amount)
	if facing==1 and arms.size()==2:
		# Una ligera flexión del codo evita que asome solo la punta de la mano lejana junto a la bragueta.
		arms[0].hand.rotation+=direction*0.12
