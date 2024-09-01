#pragma header
uniform float stretch;
uniform float stretchY;
/*mat2 rotate(float rot){
    return mat2(
        degrees(rot), cos(rot),
        degrees(rot), sin(rot)
    );
}*/
void main()
{
    vec2 uv = openfl_TextureCoordv;
    vec4 normal_map = flixel_texture2D(bitmap,uv);
    if(stretch != 0.0){
        vec4 mirror_1 = flixel_texture2D(bitmap, vec2(uv.x + stretch,uv.y));
        vec4 mirror_2 = flixel_texture2D(bitmap, vec2(uv.x - stretch,uv.y));
        mirror_1 *= (mirror_1.a - normal_map.a)/2.0;
        mirror_2 *= (mirror_2.a - normal_map.a)/2.0;
        normal_map += (mirror_1 + mirror_2);
    }
    if(stretchY != 0.0){
        vec4 mirror_1 = flixel_texture2D(bitmap, vec2(uv.x,uv.y + stretchY));
        vec4 mirror_2 = flixel_texture2D(bitmap, vec2(uv.x,uv.y - stretchY));
        mirror_1 *= (mirror_1.a - normal_map.a)/2.0;
        mirror_2 *= (mirror_2.a - normal_map.a)/2.0;
        normal_map += (mirror_1 + mirror_2);
    }
    //gl_FragColor = vec4(normal_map);
    gl_FragColor = normal_map;
}
