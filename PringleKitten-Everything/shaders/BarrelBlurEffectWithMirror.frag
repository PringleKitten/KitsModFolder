#pragma header
//Barrel variables
uniform float barrel;
uniform bool doChroma;

//Mirror variables
uniform float angle;
uniform float zoom;
uniform float x;
uniform float y;
vec2 barrelDistortion (vec2 coord, float amt){
	vec2 cc = coord - 0.5;
	float dist = dot(cc, cc);
	return coord + cc * dist * amt;
}
vec2 mirror(vec2 uv){
	vec2 intUv = vec2(
	float(int(uv.x)),
	float(int(uv.y))
	);
	return uv = abs(uv - (intUv*2.0));
}
void main(){
	float barrelDiv = barrel/60.0;
	vec2 uv = openfl_TextureCoordv - 0.5;
    if(mod(angle,360.0) != 0.0){
        float rotation = mod(-angle,360.0) * (3.14/180.0);//3.14 = PI
        float c = cos(rotation), s = sin(rotation);
        uv *= mat2(
            vec2(c,-s/(openfl_TextureSize.x/openfl_TextureSize.y)),
            vec2(s/(openfl_TextureSize.y/openfl_TextureSize.x),c)
        );
    } 
    uv = mod(uv * zoom + 0.5 + vec2(x,y),2.0);
	uv = mirror(uv);
	vec4 normal_map = flixel_texture2D(bitmap,uv);
    if(barrel != 0.0){
		float barrelDiv = barrel/60.0;
		if(!doChroma){
			for(float i = 1.0;i < 12.0;i++){
				normal_map += flixel_texture2D(bitmap,barrelDistortion(uv,i*barrelDiv));
			}
			normal_map /= 12.0;
		}
		else{
			vec2 barrelUv = mirror(barrelDistortion(uv,12.0*barrelDiv));


			/*vec2 red = flixel_texture2D(bitmap,vec2(barrelUv.x - barrelChrom.x,barrelUv.y - barrelChrom.y)).ra;
			vec2 blue = flixel_texture2D(bitmap,vec2(barrelUv.x + barrelChrom.x,barrelUv.y + barrelChrom.y)).ba;*/

			/*float red = flixel_texture2D(bitmap,vec2(barrelUv.x + barrelChrom.x,barrelUv.y - barrelChrom.y)).r;
			float blue = flixel_texture2D(bitmap,vec2(barrelUv.x - barrelChrom.x,barrelUv.y + barrelChrom.y)).b;
			normal_map.rb = vec2(red,blue);*/

			vec2 red = vec2(0.0);
			vec2 blue = vec2(0.0);
			normal_map = flixel_texture2D(bitmap,barrelUv);
			vec2 barrelChrom = vec2(0.2) * barrelDiv * cos(barrelUv*3.14);
			for(float i = 0.0;i < 10.0;i++){
				vec2 chromUv = barrelChrom * (i*0.15);
				red += flixel_texture2D(bitmap,vec2(barrelUv.x + chromUv.x,barrelUv.y + chromUv.y)).ra;
				blue += flixel_texture2D(bitmap,vec2(barrelUv.x - chromUv.x,barrelUv.y - chromUv.y)).ba;
			}
			
			//Blur Effect
			for(float x = -1.0 ;x < 1.0; x++){
				for(float y = -1.0; y < 1.0; y++){
					normal_map += flixel_texture2D(bitmap,barrelUv + barrelChrom*(vec2(0.15*x,0.15*y)));
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
