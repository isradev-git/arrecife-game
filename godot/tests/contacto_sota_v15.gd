extends SceneTree
const RIG = preload("res://candidatas/sota_ik_v15.gd")
const OUT = "res://../trabajo/arte/revisiones/cinematica_sota_v15/"
func _initialize() -> void: call_deferred("check")
func check() -> void:
	assert(DisplayServer.get_name()!="headless")
	var passed := true
	for profile in range(2):
		for foot in range(2):
			var vp := SubViewport.new()
			vp.size=Vector2i(2048,2560)
			vp.transparent_bg=true
			vp.render_target_update_mode=SubViewport.UPDATE_ALWAYS
			root.add_child(vp)
			for phase in range(64):
				var rig := RIG.new()
				vp.add_child(rig)
				rig.build(profile)
				rig.position=Vector2((phase%8)*256+128,(phase/8)*320+300)
				rig.pose(phase/64.0)
				for part in rig.parts.values(): part.hide()
				rig.legs[foot].boot.show()
			for tick in range(3): await process_frame
			await RenderingServer.frame_post_draw
			var picture := vp.get_texture().get_image()
			picture.save_png(OUT+"botas_%d_%d.png" % [profile,foot])
			var soles := []
			var height_error := 0
			for phase in range(64):
				var cell := picture.get_region(Rect2i((phase%8)*256,(phase/8)*320,256,320))
				var bottom := cell.get_used_rect().end.y-1
				var xs := []
				for x in range(256):
					if cell.get_pixel(x,bottom).a>0.95: xs.append(x)
				assert(not xs.is_empty())
				soles.append((float(xs.front())+xs.back())*0.5-128.0)
				var p := fposmod(phase/64.0+(0.5 if foot==0 else 0.0),1.0)
				if p<0.6: height_error=maxi(height_error,absi(bottom-299))
			print("Suela renderizada perfil %d pie %d: distancia máxima al suelo %d px" % [profile,foot,height_error])
			passed=passed and height_error<=1
			for frames in [32,64]:
				for rate in [30,60,120]:
					var extrema := {}
					var drift := 0.0
					for tick in range(rate*5):
						var travel: float = tick*104.0/rate
						var raw: float = travel/128.0
						var frame: int = posmod(roundi(raw*frames),frames)*(64/frames)
						var p := fposmod(frame/64.0+(0.5 if foot==0 else 0.0),1.0)
						if p<0.15 or p>0.40: continue
						var key := floori(raw+(0.5 if foot==0 else 0.0))
						var x: float=roundf(travel*(1 if profile==0 else -1))+soles[frame]
						if not extrema.has(key): extrema[key]=Vector2(x,x)
						extrema[key]=Vector2(minf(extrema[key].x,x),maxf(extrema[key].y,x))
						drift=maxf(drift,extrema[key].y-extrema[key].x)
					print("P%d pie%d · %d dibujos · %d Hz · deriva suela raster %.2f px" % [profile,foot,frames,rate,drift])
					if frames==64: passed=passed and drift<=2.01
			vp.queue_free()
			await process_frame
	quit(0 if passed else 1)
