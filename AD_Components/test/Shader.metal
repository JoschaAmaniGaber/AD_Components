//
//  Shader.metal
//  Tests_App_Navigation
//
//  Created by Joscha Amani Gaber on 12.10.24.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]] float2 demoShader(float2 position, float2 size) {
    float f = sin(position.x/size.x*M_PI_F*2);
    return float2(position.x, position.y+f*20);
}

// MARK: - CheckOut
[[ stitchable ]] float2 slideAwayShader(float2 position, float2 size, float time, float direction) {
    float2 c = size/2;
    float2 v = position - c;
    
    float f = (direction > 0 ? position.x : (size.x - position.x) )/size.x;
    
    if ( time > f ) {
        float mul = (time-f)/(1-f);
        return c + v*mul;
    }
    else {
        return float2(-1, -1);
    }
}

[[ stitchable ]] half4 circleLoader(
    float2 position,
    half4 color,
    float4 bounds,
    float secs
) {
    float cols = 6;
    float PI2 = 6.2831853071795864769252867665590;
    float timeScale = 0.04;

    vector_float2 uv = position/bounds.zw;

    float circle_rows = (cols * bounds.w) / bounds.z;
    float scaledTime = secs * timeScale;

    float circle = -cos((uv.x - scaledTime) * PI2 * cols) * cos((uv.y + scaledTime) * PI2 * circle_rows);
    float stepCircle = step(circle, -sin(secs + uv.x - uv.y));

    // Blue Colors
    vector_float4 background = vector_float4(0.2, 0.6, 0.6, 1.0);
    vector_float4 circles = vector_float4(0, 0.8, 0.8, 1.0);

    return half4(mix(background, circles, stepCircle));
}
