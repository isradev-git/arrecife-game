extends SceneTree
func _initialize():
 var image=Image.load_from_file('res://assets/personajes/sota/perfiles_pixel_v7.png')
 for y in [444,470,490,498,510,530,550,570,580,610,650,690,710,730,770,800]:
  var runs=[]
  var start=-1
  for x in range(950,1170):
   var c=image.get_pixel(x,y)
   var ok=c.a>=0.95
   if ok and start<0: start=x
   if not ok and start>=0:
    runs.append([start,x-1]);start=-1
  print(y,': ',runs)
 quit()
