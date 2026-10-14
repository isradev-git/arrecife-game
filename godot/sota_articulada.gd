extends Node2D

const SOURCE = preload("res://assets/personajes/sota/perfiles_pixel_v7.png")
const CUTOUT = preload("res://assets/personajes/sota/silueta.gdshader")
const STRIDE = 128.0
# shortcut: tela oculta reconstruida con UV originales; redibujar pliegues si la revisión detecta repetición.

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
		add_leg([Vector2(521,507), Vector2(511,690), Vector2(514,885)], [[502,497],[549,497],[550,650],[535,713],[488,705],[496,637]], [[492,678],[539,682],[535,796],[531,807],[484,807],[474,800]], [[485,800],[531,796],[534,849],[554,874],[594,887],[601,930],[480,933],[471,880]], 932, -2)
		add_arm([Vector2(1090,278),Vector2(1100,446),Vector2(1101,549)], [[1069,265],[1107,256],[1133,283],[1146,361],[1145,430],[1121,461],[1065,450],[1053,401],[1054,317]], [[1069,449],[1098,449],[1097,484],[1093,507],[1101,517],[1100,549],[1085,562],[1055,558],[1046,545],[1048,518],[1060,500],[1064,464]], -3)
		piece("torso", [[390,217],[451,216],[501,239],[538,273],[562,321],[562,410],[549,435],[562,510],[515,528],[444,514],[447,447],[459,398],[465,344],[456,300],[418,260],[378,260]], hip_source, 0)
		piece("head", [[0,0],[836,0],[836,244],[0,244]], hip_source, 1)
		add_leg([Vector2(465,514),Vector2(436,699),Vector2(425,885)], [[448,506],[500,506],[502,570],[497,614],[474,656],[458,726],[389,711],[396,648],[404,624],[406,569],[444,565]], [[395,688],[461,710],[455,763],[468,805],[380,808],[378,749]], [[378,797],[452,796],[455,851],[474,883],[496,903],[501,947],[369,948],[373,906]], 947, 2)
		add_arm([Vector2(423,280),Vector2(407,445),Vector2(414,548)], [[380,265],[416,255],[442,281],[453,340],[450,392],[440,422],[445,449],[400,466],[367,446],[360,414],[376,375],[367,344]], [[398,449],[430,449],[430,492],[438,504],[445,513],[443,548],[435,560],[412,564],[393,553],[383,543],[385,518],[395,502]], 3)
		piece("deck", [[436,408],[493,408],[503,445],[494,494],[444,505],[430,459]], hip_source, 2)
	else:
		add_leg([Vector2(1104,510),Vector2(1119,698),Vector2(1110,885)], [[1063,566],[1136,566],[1138,589],[1142,653],[1135,715],[1070,715],[1060,643]], [[1071,686],[1138,687],[1145,752],[1146,807],[1066,807],[1066,802]], [[1070,794],[1145,796],[1147,850],[1160,888],[1164,945],[1037,946],[1036,911],[1070,879]], 946, -2)
		add_arm([Vector2(423,280),Vector2(407,445),Vector2(414,548)], [[380,265],[416,255],[442,281],[453,340],[450,392],[440,422],[445,449],[400,466],[367,446],[360,414],[376,375],[367,344]], [[398,449],[430,449],[430,492],[438,504],[445,513],[443,548],[435,560],[412,564],[393,553],[383,543],[385,518],[395,502]], -3)
		piece("torso", [[1024,218],[1078,213],[1117,240],[1128,264],[1091,287],[1055,344],[1046,407],[1046,450],[1046,515],[988,515],[995,447],[973,399],[972,328],[995,285],[1014,249]], hip_source, 0)
		piece("head", [[700,0],[1536,0],[1536,244],[700,244]], hip_source, 1)
		add_leg([Vector2(1034,514),Vector2(1034,694),Vector2(1026,885)], [[995,499],[1046,494],[1046,565],[1063,586],[1060,656],[1055,716],[992,715],[986,636]], [[994,685],[1058,689],[1068,757],[1063,806],[988,808],[983,796]], [[946,796],[1087,796],[1087,940],[946,940]], 938, 2)
		add_arm([Vector2(1090,278),Vector2(1100,446),Vector2(1101,549)], [[1069,265],[1107,256],[1133,283],[1146,361],[1145,430],[1121,461],[1065,450],[1053,401],[1054,317]], [[1069,449],[1098,449],[1097,484],[1093,507],[1101,517],[1100,549],[1085,562],[1055,558],[1046,545],[1048,518],[1060,500],[1064,464]], 3)
		piece("deck", [[1136,426],[1158,431],[1160,507],[1135,511]], hip_source, 2)
	restore_covered_cloth()
	prepare_continuous_legs()
	var torso_vertices: PackedVector2Array = parts.torso.polygon
	for i in range(torso_vertices.size()): torso_vertices[i].y += 124.0
	parts.torso.polygon = torso_vertices
	for patch in parts.torso.get_children():
		var vertices: PackedVector2Array = patch.polygon
		for i in range(vertices.size()): vertices[i].y += 124.0
		patch.polygon = vertices
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
	if facing == 1 and name in ["torso","thigh1"]:
		uv = Geometry2D.clip_polygons(uv,points([[956,507],[1003,507],[1003,577],[956,577]]))[0]
	if facing==1 and name=="boot1":
		uv=Geometry2D.intersect_polygons(uv,points([[0,0],[1065,0],[1065,1024],[0,1024]]))[0]
	if name.begins_with("boot"):
		uv = Geometry2D.intersect_polygons(uv,points([[0,810],[1536,810],[1536,1024],[0,1024]]))[0]
	if name == "torso":
		uv = Geometry2D.intersect_polygons(uv,PackedVector2Array([Vector2(0,244),Vector2(1536,244),Vector2(1536,1024),Vector2(0,1024)]))[0]
		if facing == 0:
			uv = Geometry2D.clip_polygons(uv,points([[430,408],[504,408],[504,505],[430,505]]))[0]
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


func cloth_patch(parent: Polygon2D, outline: Array, uv: Array, pivot: Vector2) -> void:
	var patch := Polygon2D.new()
	var vertices := points(outline)
	for i in range(vertices.size()): vertices[i] = (vertices[i] - pivot) * pixel_scale
	patch.polygon = vertices
	patch.uv = points(uv)
	patch.texture = SOURCE
	patch.use_parent_material = true
	patch.set_meta("original_polygon", vertices)
	patch.show_behind_parent = true
	parent.add_child(patch)


func restore_covered_cloth() -> void:
	# La referencia aplanada oculta tela bajo brazos/manos; estas piezas reutilizan tela limpia del mismo atlas.
	if facing == 0:
		cloth_patch(parts.torso, [[390,265],[467,265],[467,410],[399,410]], [[466,281],[500,281],[500,391],[466,391]], hip_source)
		cloth_patch(parts.torso, [[399,409],[514,409],[514,435],[399,435]], [[1034,409],[1048,409],[1048,425],[1034,425]], hip_source)
		cloth_patch(parts.torso, [[399,434],[514,434],[514,514],[402,514]], [[455,498],[486,498],[486,532],[455,532]], hip_source)
		cloth_patch(parts.boot1, [[446,833],[470,874],[497,898],[487,910],[453,887],[440,855]], [[406,827],[433,827],[438,877],[436,898],[405,887],[403,850]], Vector2(425,885))
		parts.boot1.get_child(0).show_behind_parent=false
		cloth_patch(parts.thigh1, [[403,490],[500,489],[500,566],[406,575]], [[455,498],[486,498],[486,532],[455,532]], Vector2(465,514))
	else:
		cloth_patch(parts.torso, [[1034,270],[1116,270],[1133,409],[1046,409]], [[1019,275],[1043,275],[1043,342],[1019,342]], hip_source)
		cloth_patch(parts.torso, [[1045,409],[1133,409],[1133,435],[1045,435]], [[1034,409],[1048,409],[1048,425],[1034,425]], hip_source)
		cloth_patch(parts.torso, [[1045,434],[1133,434],[1133,514],[1045,514]], [[1018,444],[1045,444],[1045,491],[1018,491]], hip_source)
		cloth_patch(parts.boot1, [[1023,873],[1065,873],[1065,940],[1023,940]], [[985,865],[1018,865],[1018,936],[985,936]], Vector2(1026,885))
		parts.boot1.get_child(0).show_behind_parent=false
		cloth_patch(parts.boot1, [[1006,800],[1046,800],[1046,870],[1010,870]], [[1035,819],[1055,819],[1055,866],[1035,866]], Vector2(1026,885))
		cloth_patch(parts.thigh0, [[1062,489],[1133,489],[1137,577],[1063,577]], [[1018,444],[1042,444],[1042,491],[1018,491]], Vector2(1104,510))
		cloth_patch(parts.thigh1, [[986,506],[1004,506],[1004,579],[986,579]], [[1018,444],[1035,444],[1035,491],[1018,491]], Vector2(1034,514))
		cloth_patch(parts.torso, [[986,505],[1004,505],[1004,516],[986,516]], [[1018,444],[1035,444],[1035,456],[1018,456]], hip_source)
		cloth_patch(parts.thigh1, [[1045,494],[1063,494],[1063,566],[1045,566]], [[1030,448],[1045,448],[1045,489],[1030,489]], Vector2(1034,514))


func subdivide_surface(node: Polygon2D, outline: PackedVector2Array, pivot: Vector2) -> void:
	# Filas compartidas permiten doblar la tela sin juntar dos bordes rígidos en la rodilla.
	var vertices := PackedVector2Array()
	var uv := PackedVector2Array()
	var triangles: Array[PackedInt32Array] = []
	for y in range(480,1024,12):
		var strip := points([[0,y],[1536,y],[1536,y+12],[0,y+12]])
		for region in Geometry2D.intersect_polygons(outline,strip):
			var indices := Geometry2D.triangulate_polygon(region)
			var offset := vertices.size()
			for point in region:
				uv.append(point)
				vertices.append((point-pivot)*pixel_scale)
			for i in range(0,indices.size(),3):
				triangles.append(PackedInt32Array([offset+indices[i],offset+indices[i+1],offset+indices[i+2]]))
	node.polygon=vertices
	node.uv=uv
	node.polygons=triangles
	node.set_meta("original_polygon",vertices)


func prepare_continuous_legs() -> void:
	for leg in legs:
		var plane := Node2D.new()
		plane.use_parent_material=true
		plane.z_index=leg.thigh.z_index
		body.add_child(plane)
		for node in [leg.thigh,leg.shin,leg.boot]:
			node.reparent(plane,false)
			# Toda la cadena lejana queda detrás de la cercana; la bota tapa su propio borde de tela.
			node.z_index=1 if node==leg.boot else 0
		var cloth := Geometry2D.merge_polygons(leg.thigh.uv,leg.shin.uv)[0]
		subdivide_surface(leg.thigh,cloth,hip_source+leg.hip/pixel_scale)
		subdivide_surface(leg.boot,leg.boot.uv,hip_source+leg.neutral_ankle/pixel_scale)
		leg.shin.hide()


func stretched(point: Vector2, axis: Vector2, length: float) -> Vector2:
	var unit := axis.normalized()
	return point+unit*point.dot(unit)*(length/axis.length()-1.0)


func cloth_point(leg: Dictionary, source: Vector2, hip: Vector2, knee: Vector2, ankle: Vector2) -> Vector2:
	var upper: Vector2 = hip+stretched(source-leg.hip,leg.thigh_axis,(knee-hip).length()).rotated(leg.thigh.rotation)
	var lower: Vector2 = knee+stretched(source-leg.neutral_knee,leg.shin_axis,(ankle-knee).length()).rotated(leg.shin.rotation)
	var knee_weight := smoothstep(leg.neutral_knee.y-9.0,leg.neutral_knee.y+9.0,source.y)
	var cloth := upper.lerp(lower,knee_weight)
	var normal := Vector2((ankle-hip).normalized().y,-(ankle-hip).normalized().x)
	cloth+=normal*(cloth-knee).dot(normal)*0.4*(1.0-smoothstep(0.0,14.0,absf(source.y-leg.neutral_knee.y)))
	var foot: Vector2 = ankle+(source-leg.neutral_ankle).rotated(leg.boot.rotation)
	return cloth.lerp(foot,smoothstep(leg.neutral_ankle.y-7.0,leg.neutral_ankle.y+7.0,source.y))


func deform_leg(leg: Dictionary, hip: Vector2, knee: Vector2, ankle: Vector2) -> void:
	for node in [leg.thigh,leg.boot]:
		var pivot: Vector2 = leg.hip if node==leg.thigh else leg.neutral_ankle
		var originals: PackedVector2Array = node.get_meta("original_polygon")
		var vertices := PackedVector2Array()
		for point in originals:
			var source := pivot+point
			# Solapar menos de tres píxeles de tela con la caña evita el hueco del recorte del puño.
			if node==leg.thigh and source.y > (800.0-hip_source.y)*pixel_scale:
				source.y+=8.0*pixel_scale
			vertices.append((cloth_point(leg,source,hip,knee,ankle)-node.position).rotated(-node.rotation))
		node.polygon=vertices
		for patch in node.get_children():
			if not patch.has_meta("original_polygon"): continue
			vertices=PackedVector2Array()
			for point in patch.get_meta("original_polygon"):
				vertices.append((cloth_point(leg,pivot+point,hip,knee,ankle)-node.position).rotated(-node.rotation))
			patch.polygon=vertices


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
		if index==0:
			hip=hip.lerp(Vector2(legs[1].hip.x+direction*3.0,hip.y),amount)
		var axis := ankle-hip
		var reach := clampf(axis.length(),1.0,111.9)
		var unit := axis.normalized()
		var along := (56.0*56.0-56.0*56.0+reach*reach)/(2.0*reach)
		var bend := sqrt(maxf(0.0,56.0*56.0-along*along))
		var knee: Vector2 = hip+unit*along+Vector2(unit.y,-unit.x)*direction*bend
		knee = leg.neutral_knee.lerp(knee,amount)
		ankle = leg.neutral_ankle.lerp(ankle,amount)
		leg.thigh.position=hip
		leg.thigh.rotation=(knee-hip).angle()-leg.thigh_angle
		leg.shin.position=knee
		leg.shin.rotation=(ankle-knee).angle()-leg.shin_angle
		leg.boot.position=ankle
		leg.boot.rotation=angle*amount
		deform_leg(leg,hip,knee,ankle)
		var arm: Dictionary = arms[index]
		var shoulder: Vector2 = arm.shoulder if index==1 else (Vector2(537,287) if facing==0 else Vector2(1006,287))-hip_source
		if index==0:
			shoulder *= pixel_scale
			shoulder=shoulder.lerp(arms[1].shoulder+Vector2(direction*3.0,2.0),amount)
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
	for patch in node.get_children():
		if patch.has_meta("original_polygon"):
			stretch_limb(patch, axis, length)
