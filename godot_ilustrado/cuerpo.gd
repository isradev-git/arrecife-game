extends Node3D

@export var estudio_sota := false
@export var modelo_sota: PackedScene = preload("res://assets/sota_3d_v7/sota.glb")

var origen: Skeleton3D
var esqueleto: Skeleton3D
var reproductor: AnimationPlayer
var arbol: AnimationTree
var adaptador: RetargetModifier3D
var mezcla := 0.0
var recorrido := 0.0

func _ready() -> void:
	var fuente := preload("res://assets/base/locomocion.glb").instantiate()
	add_child(fuente)
	origen=fuente.get_node("Armature/Skeleton3D")
	for pieza in origen.get_children():
		if pieza is MeshInstance3D: pieza.visible=false
	reproductor=fuente.get_node("AnimationPlayer")
	var recurso: PackedScene=modelo_sota if estudio_sota else preload("res://assets/base/Superhero_Female_FullBody.gltf")
	var destino := recurso.instantiate()
	add_child(destino)
	esqueleto=destino.find_child("Skeleton3D",true,false)
	esqueleto.get_parent().remove_child(esqueleto)
	var perfil := SkeletonProfile.new()
	perfil.bone_size=origen.get_bone_count()
	for i in range(origen.get_bone_count()):
		perfil.set_bone_name(i,origen.get_bone_name(i))
		var padre := origen.get_bone_parent(i)
		if padre>=0: perfil.set_bone_parent(i,origen.get_bone_name(padre))
	adaptador=RetargetModifier3D.new()
	adaptador.profile=perfil
	adaptador.use_global_pose=false
	adaptador.set_scale_enabled(false)
	origen.add_child(adaptador)
	adaptador.add_child(esqueleto)
	destino.queue_free()
	var material := StandardMaterial3D.new()
	material.albedo_color=Color("829497")
	material.roughness=0.95
	material.diffuse_mode=BaseMaterial3D.DIFFUSE_TOON
	material.specular_mode=BaseMaterial3D.SPECULAR_DISABLED
	for pieza in esqueleto.get_children():
		if pieza is MeshInstance3D:
			if not estudio_sota: pieza.material_override=material
			else:
				for i in range(pieza.mesh.get_surface_count()):
					var propio: StandardMaterial3D=pieza.get_active_material(i).duplicate()
					var colores = pieza.mesh.surface_get_arrays(i)[Mesh.ARRAY_COLOR]
					propio.vertex_color_use_as_albedo = colores != null and not colores.is_empty()
					propio.vertex_color_is_srgb = false
					propio.diffuse_mode=BaseMaterial3D.DIFFUSE_BURLEY
					propio.specular_mode=BaseMaterial3D.SPECULAR_SCHLICK_GGX
					pieza.set_surface_override_material(i,propio)
	var red := AnimationNodeBlendTree.new()
	var reposo := AnimationNodeAnimation.new()
	reposo.animation="Idle"
	var marcha := AnimationNodeAnimation.new()
	marcha.animation="Walk"
	red.add_node("Reposo",reposo)
	red.add_node("Marcha",marcha)
	red.add_node("Mezcla",AnimationNodeBlend2.new())
	red.connect_node("Mezcla",0,"Reposo")
	red.connect_node("Mezcla",1,"Marcha")
	red.connect_node("output",0,"Mezcla")
	arbol=AnimationTree.new()
	fuente.add_child(arbol)
	arbol.anim_player=arbol.get_path_to(reproductor)
	arbol.tree_root=red
	arbol.root_motion_track=NodePath("Armature/Skeleton3D:root")
	arbol.callback_mode_process=AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	arbol.active=true
	arbol.advance(0.0)

func avanzar(delta: float, andando: bool) -> Vector3:
	mezcla=move_toward(mezcla,1.0 if andando else 0.0,delta/0.2)
	arbol.set("parameters/Mezcla/blend_amount",mezcla)
	arbol.advance(delta)
	var desplazamiento := arbol.get_root_motion_position()
	recorrido+=desplazamiento.length()
	return desplazamiento
