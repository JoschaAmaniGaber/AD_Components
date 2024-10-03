//
//  IsometricAnimation.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 03.10.

/// Tutorial by Swift Odyssey: https://www.youtube.com/watch?v=hR4g6rgQBio
import SwiftUI

struct IsometricAnimation: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                createAnimatedShape(image: "diamond", animatedState: $isAnimatingDiamond)
                    .onAppear {
                        isAnimatingDiamond.toggle()
                    }
                createAnimatedShape(image: "plus", animatedState: $isAnimatingPlus)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
                            isAnimatingPlus.toggle()
                        }
                    }
            }
            HStack(spacing: 0) {
                createAnimatedShape(image: "circle", animatedState: $isAnimatingCircle)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            isAnimatingCircle.toggle()
                        }
                    }
                createAnimatedShape(image: "triangle", animatedState: $isAnimatingTriangle)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.55) {
                            isAnimatingTriangle.toggle()
                        }
                    }
            }
        }
        .rotationEffect(.degrees(-1))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.pink.gradient)
        .navigationTitle("Isometric Animation")
    }
    @State private var isAnimatingDiamond: Bool = false
    @State private var isAnimatingPlus: Bool = false
    @State private var isAnimatingCircle: Bool = false
    @State private var isAnimatingTriangle: Bool = false
    private let backgroundShapeSize: CGFloat = 108.0
    private let movementOffset = -48.0
    
    private func createAnimatedShape(image: String, animatedState: Binding<Bool>) -> some View {
        BackgroundShape(
            xOffset: animatedState.wrappedValue ? movementOffset : 0,
            yOffset: animatedState.wrappedValue ? movementOffset : 0)
            .fill(.blue.gradient)
            .frame(width: backgroundShapeSize, height: backgroundShapeSize)
            .animation(.easeOut(duration: 0.6).repeatForever(autoreverses: true), value: animatedState.wrappedValue)
            .overlay {
                ForeGroundShape(image: image, fillCollor: .pink)
                    .offset(
                        x: animatedState.wrappedValue ? movementOffset : 0,
                        y: animatedState.wrappedValue ? movementOffset : 0
                    )
                    .animation(.easeOut(duration: 0.6).repeatForever(autoreverses: true), value: animatedState.wrappedValue)
            }
    }
}

struct ForeGroundShape: View {
    let image: String
    let fillCollor: Color
    
    var body: some View {
        Rectangle()
            .fill(fillCollor)
            .frame(width: foregroundShapeSize, height: foregroundShapeSize)
            .overlay {
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: iconSize, height: iconSize)
                    .foregroundStyle(.blue.gradient)
            }
    }
    private let foregroundShapeSize: CGFloat = 104.0
    private let iconSize: CGFloat = 64.0
}

struct BackgroundShape: Shape {
    var xOffset: CGFloat = 0.0
    var yOffset: CGFloat = 0.0
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { .init(xOffset, yOffset) }
        set {
            xOffset = newValue.first
            yOffset = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + xOffset, y: rect.minY + yOffset))
        path.addLine(to: CGPoint(x: rect.width + xOffset, y: rect.minY + yOffset))
        path.addLine(to: CGPoint(x: rect.width, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.width + xOffset, y: rect.height + yOffset))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + xOffset, y: rect.height + yOffset))
        path.closeSubpath()
        
        return path
    }
    
    
}

#Preview {
    IsometricAnimation()
}
