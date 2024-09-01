#pragma header

uniform float barrel;
uniform bool doChroma;
vec2 barrelDistortion (vec2 coord, float amt){
	vec2 cc = coord - 0.5;
	float dist = dot(cc, cc);
	return coord + cc * dist * amt;
}
void main(){
	vec2 uv = openfl_TextureCoordv;
    vec4 normal_map = flixel_texture2D(bitmap,uv);
    if(barrel != 0.0){
		float barrelDiv = barrel/60.0;
		uv -= 0.5;
		uv /= 1.0 + barrelDiv;
		uv += 0.5;
		
		if(!doChroma){
			for(float i = 1.0;i < 12.0;i++){
				normal_map += flixel_texture2D(bitmap,barrelDistortion(uv,i*barrelDiv));
			}
			normal_map /= 12.0;
		}
		else{
			vec2 barrelUv = barrelDistortion(uv,12.0*barrelDiv);


			/*vec2 red = flixel_texture2D(bitmap,vec2(barrelUv.x - barrelChrom.x,barrelUv.y - barrelChrom.y)).ra;
			vec2 blue = flixel_texture2D(bitmap,vec2(barrelUv.x + barrelChrom.x,barrelUv.y + barrelChrom.y)).ba;*/

			/*float red = flixel_texture2D(bitmap,vec2(barrelUv.x + barrelChrom.x,barrelUv.y - barrelChrom.y)).r;
			float blue = flixel_texture2D(bitmap,vec2(barrelUv.x - barrelChrom.x,barrelUv.y + barrelChrom.y)).b;
			normal_map.rb = vec2(red,blue);*/

			vec2 red = vec2(0.0);
			vec2 blue = vec2(0.0);
			normal_map = flixel_texture2D(bitmap,barrelUv);
			//vec2 barrelChrom = vec2(0.2) * barrelDiv * cos(barrelUv*3.14);
			vec2 barrelChrom = vec2(0.2) * barrelDiv * cos(barrelUv*3.14);
			for(float i = 0.0;i < 10.0;i++){
				vec2 chromUv = barrelChrom * (i*0.15);
				red += flixel_texture2D(bitmap,vec2(barrelUv.x + chromUv.x,barrelUv.y + chromUv.y)).ra;
				blue += flixel_texture2D(bitmap,vec2(barrelUv.x - chromUv.x,barrelUv.y - chromUv.y)).ba;
			}
			
			//Blur Effect
			for(float x = -1.0 ;x < 1.0; x++){
				for(float y = -1.0; y < 1.0; y++){
					normal_map += flixel_texture2D(bitmap,barrelUv + barrelChrom*(vec2(0.2*x,0.2*y)));
				}
			}
			normal_map /= 5.0;

			//Alternative Blur
			/*for(float x = -1.0 ;x < 1.0; x++){
				normal_map += flixel_texture2D(bitmap,vec2(barrelUv.x + barrelChrom.x*(0.1*x),barrelUv.y));
			}
			normal_map /= 3.0;*/

			red /= 10.0;
			blue /= 10.0;	
			normal_map.rb = vec2(red.x,blue.x);
			normal_map.a += ((red.y - normal_map.a)*red.x) + ((blue.y - normal_map.a)*blue.x);
		}
    }
	gl_FragColor = vec4(normal_map);
}
