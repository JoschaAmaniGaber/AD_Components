//
//  TransitionEffets.metal
//  AD_Components
//
//  Created by Joscha Amani Gaber on 10.10.24.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// MARK: - Transition Effects

/// circles
[[stitchable]] half4 circles(float2 pos, half4 color, float2 s, float amount) {
    float2 uv = pos / s;
    float strength = 20;
    
    /// How far away from the center
    float2 f = fract(pos / strength);
    float d = distance(f, 0.5);
    
    if (d + uv.x + uv.y < amount * 3) {
        return color;
    } else {
        return 0;
    }
}

