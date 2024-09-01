#pragma header
uniform float strength;
void main()
{
    vec4 normal_map = flixel_texture2D(bitmap,openfl_TextureCoordv);
	vec3 grey = vec3(normal_map.r + normal_map.g + normal_map.b)/3.0;
    gl_FragColor = mix(normal_map,vec4(grey,normal_map.a),strength);
    
}


