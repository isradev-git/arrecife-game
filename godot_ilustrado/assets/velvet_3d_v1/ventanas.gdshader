shader_type spatial;
render_mode unshaded;
uniform vec4 tono : source_color;
void fragment(){
 float cortina=.78+.22*sin(UV.x*68.0);
 float interior=.35+.65*pow(max(0.0,1.0-abs(UV.y-.45)*1.5),2.0);
 float borde=smoothstep(0.0,.08,UV.x)*smoothstep(0.0,.08,1.0-UV.x);
 ALBEDO=tono.rgb*cortina*interior*borde*1.6;
}
