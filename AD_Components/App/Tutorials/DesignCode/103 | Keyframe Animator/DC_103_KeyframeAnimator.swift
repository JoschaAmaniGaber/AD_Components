//
//  DC_103_KeyframeAnimator.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 01.10.24.
//

/// Tutorial by DesignCode: https://designcode.io/swiftui-handbook-keyframe-animator
import SwiftUI

struct DC_103_KeyframeAnimator: View {
    var body: some View {
        Circle()
            .fill(isTapped ? .blue : .purple)
            .frame(width: 200)
            .animation(.easeInOut(duration: 1), value: isTapped)
            .keyframeAnimator(
                initialValue: AnimationValues(),
                trigger: isTapped) { content, value in
                    content.offset(x: value.position.x, y: value.position.y)
                        .scaleEffect(value.scale)
                        .rotationEffect(value.rotation)
                } keyframes: { value in
                    KeyframeTrack(\.scale) {
                        CubicKeyframe(0.2, duration: 0.5)
                        CubicKeyframe(1, duration: 0.5)
                        CubicKeyframe(0.1, duration: 0.5)
                        CubicKeyframe(10, duration: 0.5)
                        CubicKeyframe(1, duration: 0.5)
                    }
                    KeyframeTrack(\.position) {
                        SpringKeyframe(CGPoint(x: -100, y: -100), duration: 1.5, spring: .snappy)
                        CubicKeyframe(CGPoint(x: 0, y: 0), duration: 0.5)
                    }
                    KeyframeTrack(\.rotation) {
                        CubicKeyframe(Angle(degrees: 720), duration: 1)
                        CubicKeyframe(Angle(degrees: 1080), duration: 3)
                    }
                }
                .onTapGesture {
                    isTapped.toggle()
                }
                .navigationTitle("Keyframe Animator")
    }
    // MARK: - Screen Variables
    @State private var isTapped: Bool = false
    
    private struct AnimationValues {
        var position = CGPoint(x: 0, y: 0)
        var scale = 1.0
        var rotation = Angle(degrees: 0)
    }
}

#Preview {
    NavigationStack {
        DC_103_KeyframeAnimator()
    }
}
