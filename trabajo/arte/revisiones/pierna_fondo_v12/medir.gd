extends SceneTree
func _initialize():
 var rig=load('res://sota_articulada.gd').new()
 root.add_child(rig)
 rig.build(0)
 for phase in range(32):
  rig.pose(phase/32.0)
  var measures=[]
  for leg in rig.legs:
   var hip:Vector2=leg.thigh.position
   var knee:Vector2=leg.shin.position
   var ankle:Vector2=leg.boot.position
   var bend=rad_to_deg(abs((knee-hip).angle_to(ankle-knee)))
   measures.append([snapped(bend,0.1),snapped(hip.distance_to(ankle),0.1),snapped(knee.x,0.1),snapped(ankle.y+rig.body.position.y,0.1)])
  print(phase,': ',measures)
 rig.free()
 quit()
