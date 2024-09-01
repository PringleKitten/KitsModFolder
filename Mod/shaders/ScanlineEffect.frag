#pragma header

uniform float strength;
uniform float pixelsBetweenEachLine;
uniform bool smoothed;
void main(){
	vec2 uv = openfl_TextureCoordv;
	vec4 normal_map = flixel_texture2D(bitmap,uv);
    if(strength != 0.0){
        float offset = openfl_TextureSize.y*0.0000015*pixelsBetweenEachLine;
        //float offset = 720.0*0.0000015*pixelsBetweenEachLine; //720.0 - screen height
        uv.y = mod(uv.y,offset*2.0);
        //if(uv.y <= offset/4.0){
        if(uv.y <= 0.0013922){
			normal_map = mix(normal_map,vec4(0.0,0.0,0.0,1.0),strength);
		}   
    }
	gl_FragColor = normal_map;
}
