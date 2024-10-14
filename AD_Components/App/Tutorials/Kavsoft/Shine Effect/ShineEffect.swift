//
//  ShineEffect.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 13.10.24.
//

/// Tutorial by Kavsoft: https://youtu.be/UETjgKWWB1I?si=XMIlRp3VxFchdEgT
import SwiftUI

struct ShineEffect: View {
    var body: some View {
        Button {} label: {
            Text("Shine") 
                .font(.headline)
            Image(systemName: "sun.max.fill")
        }
        .buttonStyle(.borderedProminent)
        .shine(isShining, duration: 0.8, clipShape: .capsule)
        
        Image(.image7)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 160, height: 160)
            .shine(isShining, duration: 2.5, clipShape: .rect(cornerRadius: 16))
            .onTapGesture {
                isShining.toggle()
            }
    }
    // MARK: - View Properties
    @State var isShining: Bool = false
}

extension View {
    // MARK: - Custom View Modifier
    @ViewBuilder func shine(_ toggle: Bool, duration: CGFloat = 0.5, clipShape: some Shape = .rect, angle: Angle = .degrees(45)) -> some View {
        self
            .overlay {
                GeometryReader {
                    let size = $0.size
                    /// Eliminating negative duration
                    let moddedDuration = max(0.3, duration)
                    
                    Rectangle().fill(.linearGradient(
                        colors: [
                            .clear,
                            .clear,
                            .jWhite.opacity(0.1),
                            .jWhite.opacity(0.5),
                            .jWhite.opacity(1),
                            .jWhite.opacity(0.5),
                            .jWhite.opacity(0.1),
                            .clear,
                            .clear,
                        ],
                        startPoint: .trailing,
                        endPoint: .leading
                    ))
                    .scaleEffect(y: 8)
                    .keyframeAnimator(
                        initialValue: 0.0,
                        trigger: toggle,
                        content: { content, progress in
                            content
                                .offset(x: -size.width + (progress * (size.width * 2)))
                        }, keyframes: { _ in
                            CubicKeyframe(.zero, duration: 0.1)
                            CubicKeyframe(1, duration: moddedDuration)
                        })
                    .rotationEffect(angle)
                }
            }
            .clipShape(clipShape)
    }
    
}
#Preview {
    ShineEffect()
}
