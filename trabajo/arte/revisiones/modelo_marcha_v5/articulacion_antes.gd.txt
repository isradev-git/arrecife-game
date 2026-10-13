extends Node2D

const SOURCE = preload("res://assets/personajes/sota/perfiles_pixel_v7.png")
const CUTOUT = preload("res://assets/personajes/sota/silueta.gdshader")
const STRIDE = 128.0
# shortcut: piezas UV sin redibujar pliegues; pulir contornos si la revisión artística detecta uniones.

var facing := 0
var parts: Dictionary = {}
var legs: Array = []
var hip_center := Vector2.ZERO
var hull_cache: Array = JSON.parse_string(FileAccess.get_file_as_string("res://assets/personajes/sota/articulacion_v1.json")) if FileAccess.file_exists("res://assets/personajes/sota/articulacion_v1.json") else []
var arms: Array = []
var body := Node2D.new()
var pixel_scale := 252.0 / 869.0
var hip_source := Vector2(493.5, 945)
var direction := 1.0


func build(profile: int) -> void:
	facing = profile
	direction = 1.0 if profile == 0 else -1.0
	pixel_scale = 252.0 / (869.0 if profile == 0 else 865.0)
	hip_source = Vector2(493.5, 945) if profile == 0 else Vector2(1027, 945)
	add_child(body)
	body.use_parent_material = true
	var mat := ShaderMaterial.new()
	mat.shader = CUTOUT
	mat.set_shader_parameter("alpha_threshold", 0.95)
	mat.set_shader_parameter("opaque_cutout", true)
	material = mat
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if profile == 0:
		add_leg([Vector2(521,507), Vector2(523,690), Vector2(514,885)], [[502,497],[549,497],[550,650],[535,713],[488,705],[496,637]], [[492,678],[539,682],[535,796],[544,854],[491,876],[474,800]], [[485,800],[531,796],[534,849],[554,874],[594,887],[601,930],[480,933],[471,880]], 932, -2)
		add_arm([Vector2(1090,278),Vector2(1100,446),Vector2(1101,549)], [[1069,265],[1107,256],[1133,283],[1146,361],[1145,430],[1121,461],[1065,450],[1053,401],[1054,317]], [[1081,448],[1123,450],[1125,505],[1142,533],[1127,558],[1074,553],[1066,529]], -3)
		piece("torso", [[390,217],[451,216],[501,239],[538,273],[562,321],[562,410],[549,435],[562,510],[515,528],[444,514],[447,447],[459,398],[465,344],[456,300],[418,260],[378,260]], hip_source, 0)
		piece("head", [[0,0],[836,0],[836,244],[0,244]], hip_source, 1)
		add_leg([Vector2(465,514),Vector2(436,699),Vector2(425,885)], [[448,487],[500,493],[502,570],[497,614],[474,656],[458,726],[389,711],[396,648],[404,624],[406,569],[444,565]], [[395,688],[461,710],[455,763],[468,805],[451,863],[378,867],[380,808],[378,749]], [[378,797],[452,796],[455,851],[474,883],[496,903],[501,947],[369,948],[373,906]], 947, 2)
		add_arm([Vector2(423,280),Vector2(407,445),Vector2(414,548)], [[380,265],[416,255],[442,281],[453,340],[450,392],[440,422],[445,449],[400,466],[367,446],[360,414],[376,375],[367,344]], [[398,443],[431,443],[430,494],[443,511],[441,545],[426,558],[390,548],[385,535],[397,500]], 3)
		piece("deck", [[436,408],[493,408],[503,445],[494,494],[444,505],[430,459]], hip_source, 4)
	else:
		add_leg([Vector2(1104,510),Vector2(1119,698),Vector2(1110,885)], [[1062,492],[1133,489],[1138,589],[1142,653],[1135,715],[1070,715],[1060,643]], [[1071,686],[1138,687],[1145,752],[1146,804],[1144,865],[1073,866],[1066,802]], [[1070,794],[1145,796],[1147,850],[1160,888],[1164,945],[1037,946],[1036,911],[1070,879]], 946, -2)
		add_arm([Vector2(423,280),Vector2(407,445),Vector2(414,548)], [[380,265],[416,255],[442,281],[453,340],[450,392],[440,422],[445,449],[400,466],[367,446],[360,414],[376,375],[367,344]], [[398,443],[431,443],[430,494],[443,511],[441,545],[426,558],[390,548],[385,535],[397,500]], -3)
		piece("torso", [[1024,218],[1078,213],[1117,240],[1128,264],[1091,287],[1055,344],[1053,407],[1068,450],[1065,515],[988,515],[995,447],[973,399],[972,328],[995,285],[1014,249]], hip_source, 0)
		piece("head", [[700,0],[1536,0],[1536,244],[700,244]], hip_source, 1)
		add_leg([Vector2(1034,514),Vector2(1034,694),Vector2(1026,885)], [[995,499],[1060,494],[1063,586],[1060,656],[1055,716],[992,715],[986,636]], [[994,685],[1058,689],[1068,757],[1063,806],[1058,866],[988,863],[983,796]], [[946,796],[1087,796],[1087,940],[946,940]], 938, 2)
		add_arm([Vector2(1090,278),Vector2(1100,446),Vector2(1101,549)], [[1069,265],[1107,256],[1133,283],[1146,361],[1145,430],[1121,461],[1065,450],[1053,401],[1054,317]], [[1081,448],[1123,450],[1125,505],[1142,533],[1127,558],[1074,553],[1066,529]], 3)
		piece("deck", [[1136,426],[1158,431],[1160,507],[1135,511]], hip_source, 4)
	var torso_vertices: PackedVector2Array = parts.torso.polygon
	for i in range(torso_vertices.size()): torso_vertices[i].y += 124.0
	parts.torso.polygon = torso_vertices
	parts.torso.position.y = -124.0
	hip_center.x = (float(legs[0].hip.x) + float(legs[1].hip.x)) / 2.0
	pose(0.0)


func points(values: Array) -> PackedVector2Array:
	var result := PackedVector2Array()
	for value in values:
		result.append(Vector2(value[0], value[1]))
	return result


func piece(name: String, values: Array, pivot: Vector2, depth: int) -> Polygon2D:
	var node := Polygon2D.new()
	var uv := points(values)
	if name == "torso":
		uv = Geometry2D.intersect_polygons(uv,PackedVector2Array([Vector2(0,244),Vector2(1536,244),Vector2(1536,1024),Vector2(0,1024)]))[0]
	var poly := PackedVector2Array()
	for point in uv:
		poly.append((point - pivot) * pixel_scale)
	node.polygon = poly
	node.set_meta("original_polygon", poly)
	node.uv = uv
	node.texture = SOURCE
	node.use_parent_material = true
	node.z_index = depth
	body.add_child(node)
	parts[name] = node
	return node


func add_leg(joints: Array, thigh: Array, shin: Array, boot: Array, ground_y: float, depth: int) -> void:
	var n := str(legs.size())
	var leg := {"thigh":piece("thigh"+n, thigh,joints[0],depth),"shin":piece("shin"+n,shin,joints[1],depth),"boot":piece("boot"+n,boot,joints[2],depth),"thigh_angle":(joints[1]-joints[0]).angle(),"shin_angle":(joints[2]-joints[1]).angle(),"sole":(ground_y-joints[2].y)*pixel_scale,"hull":PackedVector2Array(), "hip":(joints[0]-hip_source)*pixel_scale, "neutral_knee":(joints[1]-hip_source)*pixel_scale, "neutral_ankle":(joints[2]-hip_source)*pixel_scale, "thigh_axis":(joints[1]-joints[0])*pixel_scale, "shin_axis":(joints[2]-joints[1])*pixel_scale}
	var uv := points(boot)
	if not hull_cache.is_empty():
		leg.hull = points(hull_cache[facing][legs.size()])
		stretch_limb(leg.thigh, (joints[1]-joints[0])*pixel_scale, 56.0)
		stretch_limb(leg.shin, (joints[2]-joints[1])*pixel_scale, 56.0)
		legs.append(leg)
		return
	var image := SOURCE.get_image()
	var solid := PackedVector2Array()
	for y in range(int(joints[2].y)-60,int(ground_y)+1):
		for x in range(int(joints[2].x)-130,int(joints[2].x)+130):
			var point := Vector2(x,y)
			if Geometry2D.is_point_in_polygon(point,uv) and image.get_pixel(x,y).a >= 0.95:
				solid.append((point-joints[2])*pixel_scale)
	leg.hull = Geometry2D.convex_hull(solid)
	stretch_limb(leg.thigh, (joints[1]-joints[0])*pixel_scale, 56.0)
	stretch_limb(leg.shin, (joints[2]-joints[1])*pixel_scale, 56.0)
	legs.append(leg)


func add_arm(joints: Array, sleeve: Array, hand: Array, depth: int) -> void:
	var n := str(arms.size())
	arms.append({"sleeve":piece("sleeve"+n,sleeve,joints[0],depth),"hand":piece("hand"+n,hand,joints[1],depth),"sleeve_angle":(joints[1]-joints[0]).angle(),"hand_angle":(joints[2]-joints[1]).angle(),"shoulder":(joints[0]-hip_source)*pixel_scale, "upper_length":(joints[1]-joints[0]).length()*pixel_scale,"lower_length":(joints[2]-joints[1]).length()*pixel_scale})


func pose(phase: float, amount: float = 1.0) -> void:
	body.position = Vector2(0, roundf(cos((phase-0.08)*TAU*2.0)*3.0*amount))
	parts.torso.rotation = sin(phase*TAU)*0.015*direction*amount
	for index in range(2):
		var p := fposmod(phase+(0.5 if index==0 else 0.0),1.0)
		var foot_x := 56.0-p*STRIDE
		var lift := 0.0
		var tilt := 0.0
		if p >= 0.6:
			var swing := (p-0.6)/0.4
			var eased := swing*swing*(3.0-2.0*swing)
			var tangent := swing*(1.0-swing)*(1.0-2.0*swing)
			foot_x = lerpf(56.0-STRIDE*0.6,56.0,eased) - STRIDE*0.4*tangent
			lift = pow(sin(swing*PI),2.0)*10.0
			tilt = lerpf(0.24,-0.16,eased)
		else:
			tilt = -0.16*(1.0-p/0.1) if p<0.1 else 0.24*smoothstep(0.43,0.6,p)
		var leg: Dictionary = legs[index]
		var angle := direction*tilt
		var low := -INF
		var toe := -INF
		for point in leg.hull:
			var rotated: Vector2 = point.rotated(angle)
			low = maxf(low,rotated.y)
			toe = maxf(toe,direction*rotated.x)
		var ankle := Vector2(direction*(foot_x-toe)+hip_center.x,-low-lift)-body.position
		var hip: Vector2 = leg.hip
		var axis := ankle-hip
		var reach := clampf(axis.length(),1.0,111.9)
		var unit := axis.normalized()
		var along := (56.0*56.0-56.0*56.0+reach*reach)/(2.0*reach)
		var bend := sqrt(maxf(0.0,56.0*56.0-along*along))
		var knee: Vector2 = hip+unit*along+Vector2(unit.y,-unit.x)*direction*bend
		knee = leg.neutral_knee.lerp(knee,amount)
		ankle = leg.neutral_ankle.lerp(ankle,amount)
		stretch_limb(leg.thigh,leg.thigh_axis,(knee-hip).length())
		stretch_limb(leg.shin,leg.shin_axis,(ankle-knee).length())
		leg.thigh.position=hip
		leg.thigh.rotation=(knee-hip).angle()-leg.thigh_angle
		leg.shin.position=knee
		leg.shin.rotation=(ankle-knee).angle()-leg.shin_angle
		leg.boot.position=ankle
		leg.boot.rotation=angle*amount
		var arm: Dictionary = arms[index]
		var shoulder: Vector2 = arm.shoulder if index==1 else (Vector2(537,287) if facing==0 else Vector2(1006,287))-hip_source
		if index==0: shoulder *= pixel_scale
		var swing := cos(p*TAU)*0.27*direction
		var upper_angle := lerp_angle(arm.sleeve_angle,PI/2.0+swing,amount)
		var elbow: Vector2 = shoulder+Vector2.from_angle(upper_angle)*arm.upper_length
		var lower_angle := lerp_angle(arm.hand_angle,upper_angle-0.1*direction-0.12*direction*(0.5+0.5*cos(p*TAU)),amount)
		arm.sleeve.position=shoulder
		arm.sleeve.rotation=upper_angle-arm.sleeve_angle
		arm.hand.position=elbow
		arm.hand.rotation=lower_angle-arm.hand_angle


func stretch_limb(node: Polygon2D, axis: Vector2, length: float) -> void:
	var unit := axis.normalized()
	var vertices: PackedVector2Array = node.get_meta("original_polygon")
	for i in range(vertices.size()):
		var along := vertices[i].dot(unit)
		vertices[i] += unit * along * (length / axis.length() - 1.0)
	node.polygon = vertices
