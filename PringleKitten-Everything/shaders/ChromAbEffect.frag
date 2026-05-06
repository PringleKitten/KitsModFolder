#pragma header

uniform float strength;
void main()
{
    vec2 uv = openfl_TextureCoordv;
    vec4 normal_map = flixel_texture2D(bitmap, uv);
    if(strength != 0.0){
        vec2 red = flixel_texture2D(bitmap, vec2(uv.x + strength,uv.y)).ra;
        vec2 blue = flixel_texture2D(bitmap, vec2(uv.x - strength,uv.y)).ba;
        normal_map.rb = vec2(red.x,blue.x);
        normal_map.a = normal_map.a + ((red.y- normal_map.a)*red.x) + ((blue.y - normal_map.a) * blue.x);
    }
    gl_FragColor = normal_map;
}