shader_type canvas_item;

uniform float fV; // Fill value
uniform sampler2D bottle_mask; // The potion bottle texture (used as a mask)

void fragment() {
    vec2 uv = ((UV / -0.10)) + vec2(1.25, 1.25);
    
    // Get the alpha of the bottle sprite (used as a mask)
    float mask_alpha = texture(bottle_mask, UV).a;

    float sdf = length(uv); // Distance function (for the circular wave effect)
    
    float c = mask_alpha; // Use the bottle's alpha as the mask

    float vB = smoothstep(.1, .9, sin(uv.x + (PI * .5)) - .3);
    float vBA = vB * sin(TIME * 4.) * .1;

    float fW = (sin(((TIME * 2.) + uv.x) * 2.) * .05) + vBA;
    float bW = (sin(((TIME * -2.) + uv.x) * 2. + PI) * .05) - vBA;

    float fA = (sin(TIME * 4.) * .05) * vB;

    float fP = fV * 2.3 + (sin((TIME) * PI) * .1) - 1.1;

    float fF = step(uv.y, (fA + fW) + fP) * c;
    float bF = step(uv.y, (-fA + bW) + fP) * c;

    COLOR = vec4((fF + (clamp(bF - fF, 0., 1.) * .8)) * c, (fF + bF) * c, (1.0 - (fF + bF)) * c, mask_alpha);
}