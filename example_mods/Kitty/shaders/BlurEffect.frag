#pragma header

uniform float strength;
void main()
{
    vec2 uv = openfl_TextureCoordv;
    vec4 normal_map = flixel_texture2D(bitmap,uv);
    if(strength != 0.0){
        for(float x = -1.0; x < 1.0; x++){
            //normal_map += flixel_texture2D(bitmap,vec2(uv.x + (x * (strength*0.0015)),uv.y));
            for(float y = -1.0; y < 1.0; y++){
                normal_map += flixel_texture2D(bitmap,uv + (vec2(x,y) * (strength*0.0015)));
            }
        }
        //normal_map /= 3.0;
        normal_map /= 5.0;
    }
    gl_FragColor = normal_map;
}