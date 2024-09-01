#pragma header
uniform float posXStart;
uniform float posXEnd;
uniform float posYStart;
uniform float posYEnd;
uniform float x;
uniform float y;
uniform float fade;

void main()
{
    vec2 uv = openfl_TextureCoordv;
    if(fade != 0.0){
        vec2 texSize = openfl_TextureSize;
        vec2 areaX = vec2(posXStart,posXEnd);
        vec2 areaY = vec2(posYStart,posYEnd);
        if(areaX.y == -1.0){
            areaX.y = texSize.x; 
        }
        if(areaY.y == -1.0){
            areaY.y = texSize.y; 
        }
        vec2 posX = mix(vec2(0.0,texSize.x),areaX,fade);
        vec2 posY = mix(vec2(0.0,texSize.y),areaY,fade);
        uv.x -= x;
        uv.y += y;
        uv.x = mod(uv.x,(posX.y - posX.x)/texSize.x);
        uv.y = mod(uv.y,(posY.y - posY.x)/texSize.y);
        uv.x += posX.x/texSize.x;
        uv.y += posY.x/texSize.y;
    }
    vec4 normal_map = flixel_texture2D(bitmap,uv);
    //gl_FragColor = vec4(normal_map);
    gl_FragColor = normal_map;
}