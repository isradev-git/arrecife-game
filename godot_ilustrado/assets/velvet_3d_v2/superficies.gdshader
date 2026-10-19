shader_type spatial;
uniform vec4 color_base : source_color = vec4(0.12,0.15,0.17,1.0);
uniform float metal = 0.5;
uniform float rugosidad = 0.75;
uniform float ladrillo = 0.0;
uniform float suelo = 0.0;
uniform float adoquin = 0.0;
varying vec3 lugar;
float hash(vec2 p) { return fract(sin(dot(p,vec2(127.1,311.7)))*43758.5453); }
float noise(vec2 p) {
 vec2 i=floor(p),f=fract(p); f=f*f*(3.0-2.0*f);
 return mix(mix(hash(i),hash(i+vec2(1,0)),f.x),mix(hash(i+vec2(0,1)),hash(i+1.0),f.x),f.y);
}
void vertex(){ lugar=(MODEL_MATRIX*vec4(VERTEX,1.0)).xyz; }
void fragment(){
 vec2 p=mix(lugar.xy,lugar.xz,suelo);
 float n=noise(p*7.0)*0.55+noise(p*41.0)*0.25+noise(p*139.0)*0.2;
 float manchas=smoothstep(0.5,0.82,noise(p*1.4+3.2))*0.6;
 vec3 base=mix(color_base.rgb,vec3(0.17,0.075,0.038),manchas*metal);
 vec2 b=vec2(p.x*2.5+mod(floor(p.y*5.0),2.0)*0.5,p.y*5.0);
 vec2 junta=smoothstep(vec2(0.025),vec2(0.065),fract(b))*smoothstep(vec2(0.025),vec2(0.065),1.0-fract(b));
 float mortero=junta.x*junta.y;
 ALBEDO=base*(0.68+n*0.55)*mix(1.0,0.5+0.5*mortero,ladrillo);
 ROUGHNESS=clamp(rugosidad+(n-.5)*.25,0.12,1.0);
 METALLIC=metal;
 // Humedad irregular, sin simular reflejos de objetos que no existen.
 float mojado=smoothstep(.48,.7,noise(p*1.7));
 ROUGHNESS=mix(ROUGHNESS,mix(.48,.17,mojado),suelo);
 vec2 baldosa=fract(p*vec2(1.4,2.0));
 float juntas=min(min(baldosa.x,1.0-baldosa.x),min(baldosa.y,1.0-baldosa.y));
 ALBEDO*=mix(1.0,mix(.5,1.0,smoothstep(.01,.035,juntas)),adoquin);
 ROUGHNESS=mix(ROUGHNESS,.85,adoquin);
 NORMAL=normalize(NORMAL+vec3(dFdx(n)*.28,dFdy(n)*.28,0.0));
}
