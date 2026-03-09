vec4 open_color(vec3 coords_geo, vec3 size_geo) {
    float progress = niri_clamped_progress;
    float inv_progress = 1.0 - progress;

    float angle = inv_progress * -0.1; 
    float s = sin(angle);
    float c = cos(angle);
    mat2 rotation = mat2(c, -s, s, c);

    vec2 pivot = vec2(0.5, 0.5);
    vec2 rotated_coords = rotation * (coords_geo.xy - pivot) + pivot;

    float slide_amount = 0.1;
    float offset = inv_progress * slide_amount;
    
    vec3 final_geo_coords = vec3(rotated_coords.x, rotated_coords.y + offset, 1.0);

    vec3 coords_tex = niri_geo_to_tex * final_geo_coords;

    vec4 color = vec4(0.0);
    if (coords_tex.x >= 0.0 && coords_tex.x <= 1.0 &&
        coords_tex.y >= 0.0 && coords_tex.y <= 1.0) {
        color = texture2D(niri_tex, coords_tex.st);
    }

    return color * progress;
}
