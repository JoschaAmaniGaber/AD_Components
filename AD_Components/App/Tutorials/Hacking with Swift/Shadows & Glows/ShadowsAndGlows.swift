//
//  ShadowsAndGlows.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 22.10.24.
//

import SwiftUI

// MARK: - Glow
struct HWS_Glow: View {
    var body: some View {
        Rectangle()
            .fill(.blue)
            .frame(width: 300, height: 300)
            .glow(color: .red, radius: 32)
    }
}

// MARK: - extension VIEW Glow
extension View {
    func glow(color: Color = .black, radius: CGFloat = 6) -> some View {
        self
            .overlay(self.blur(radius: radius / 6))
            .shadow(color: color, radius: radius / 3, x: 1, y: 1)
            .shadow(color: color, radius: radius / 6, x: 2, y: 2)
            .shadow(color: color, radius: radius / 9, x: 3, y: 3)
    }
}


// MARK: - MultiColor Glow
struct HWS_MultiColorGlow: View {
    var body: some View {
        VStack {
            
            Spacer(minLength: 0)
            
            VStack(spacing: 16) {
                ZStack {
                    Text("Kids")
                        .font(.system(size: 88, weight: .black, design: .serif))
                        .frame(width: 240, height: 108)
                        .shine(isShining, duration: 0.8, clipShape: .rect)
                        .multiColorGlow(isTop: false)
                        
                }
                .frame(maxWidth: .infinity, maxHeight: 108)
                ZStack {
                    Text("Kitchen")
                        .font(.system(size: 80, weight: .black, design: .serif))
                        .frame(width: 360, height: 108)
                        .shine(isShining, duration: 1.6, clipShape: .rect)
                        .multiColorGlow(isTop: false)
                }
                .frame(maxWidth: .infinity, maxHeight: 108)
            }
            .frame(maxWidth: 360, maxHeight: 240)
//            .shine(isShining, duration: 2.5, clipShape: .rect(cornerRadius: 16))
            Spacer(minLength: 0)
            
//            Button("Shine") {
//                isShining.toggle()
//            }
        }
          
        
    }
    // MARK: View Properties
    @State private var isShining: Bool = false
}

// MARK: - extension VIEW MultiColor Glow
extension View {
    func multiColorGlow(isTop: Bool = false) -> some View {
        ForEach(0..<2) { index in
            Rectangle()
                .fill(AngularGradient(
                    gradient: Gradient(colors: [
                        .red,
                        .yellow,
                        .green,
                        .blue,
                        .purple,
                        .red
                    ]),
                    center: .center
                ))
                .frame(width: 400, height: 400)
                .overlay(self.glow())
//                .overlay(self.shadow(color: .jPrime, radius: 1 - CGFloat(index * 1),x: isTop ? -3 : 3, y: isTop ? -3 : 3))
                .mask(self.blur(radius: 20))
                .overlay(self.blur(radius: 0 - CGFloat(index)))
                
        }
    }
}

#Preview {
    HWS_MultiColorGlow()
}
