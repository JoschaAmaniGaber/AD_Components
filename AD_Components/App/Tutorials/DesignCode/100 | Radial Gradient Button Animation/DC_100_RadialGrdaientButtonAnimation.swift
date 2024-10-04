//
//  RadialGradientButtonAnimation.swift
//  TestingiOS18
//
//  Created by Joscha Amani Gaber on 12.08.24.
//

/// Tutorial by DesignCode: https://designcode.io/swiftui-handbook-radial-gradient-button-animation
import SwiftUI

struct RadialGradientButtonAnimation: View {
    
    @State private var appear = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 64) {
                RoundedRectangle(cornerRadius: 35)
                    .frame(width: 164, height: 144)
                    .foregroundStyle(
                        .linearGradient(
                            colors: [.gray, .black, .gray],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .shadow(.inner(color: .jSeco.opacity(0.3), radius: 0, x: 1, y: 1))
                        .shadow(.inner(color: .jSeco.opacity(0.1), radius: 4, x: 0, y: -4))
                        .shadow(.drop(color: .jSeco.opacity(0.25), radius: 30, x: 0, y: 30))
                    )
                    .overlay(RoundedRectangle(cornerRadius: 35).stroke(.jSeco))
                    .overlay(
                        Image(systemName:"rainbow")
                            .symbolEffect(.variableColor.iterative.hideInactiveLayers.reversing)
                            .symbolRenderingMode(.multicolor)
                            .font(.largeTitle)
                            .bold()
                            .shadow(color: .jSeco, radius: 1)
                    )
                    
                    .background(
                        ZStack {
                            AngularGradient(colors: [.red, .blue, .teal, .red], center: .center, angle: .degrees(appear ? 360 : 0))
                                .cornerRadius(35)
                                .blur(radius: 5)
                                .blur(radius: 8)
                                .blur(radius: 15)
                            AngularGradient(colors: [.white, .blue, .teal, .white], center: .center, angle: .degrees(appear ? 360 : 0))
                                .cornerRadius(35)
                                .blur(radius: 8)
                                .blur(radius: 15)
                        }
                    )
                    .onAppear {
                        withAnimation(.linear(duration: 3).repeatForever(autoreverses: true)) {
                            appear = true
                        }
                    }
                
                RoundedRectangle(cornerRadius: 35)
                    .frame(width: 164, height: 144)
                    .foregroundStyle(
                        .linearGradient(
                            colors: [.gray, .black, .gray],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .shadow(.inner(color: .jSeco.opacity(0.3), radius: 0, x: 1, y: 1))
                        .shadow(.inner(color: .jSeco.opacity(0.1), radius: 4, x: 0, y: -4))
                        .shadow(.drop(color: .jSeco.opacity(0.25), radius: 30, x: 0, y: 30))
                    )
                    .overlay(RoundedRectangle(cornerRadius: 35).stroke(.jSeco))
                    .overlay(
                        Image(systemName: "rainbow")
                            .symbolEffect(.variableColor.hideInactiveLayers.reversing)
                            .symbolRenderingMode(.multicolor)
                            .font(.largeTitle)
                            .bold()
                    )
                    .background(
                        ZStack {
                            AngularGradient(colors: [.red, .blue, .teal, .red], center: .center, angle: .degrees(appear ? 360 : 0))
                                .cornerRadius(35)
                                .blur(radius: 5)
                                .blur(radius: 8)
                                .blur(radius: 15)
                            AngularGradient(colors: [.white, .blue, .teal, .white], center: .center, angle: .degrees(appear ? 360 : 0))
                                .cornerRadius(35)
                                .blur(radius: 8)
                                .blur(radius: 15)
                        }
                    )
                    .onAppear {
                        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                            appear = true
                        }
                    }
                RoundedRectangle(cornerRadius: 35)
                    .frame(width: 164, height: 144)
                    .foregroundStyle(
                        .linearGradient(
                            colors: [.gray, .black, .gray],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .shadow(.inner(color: .jSeco.opacity(0.3), radius: 0, x: 1, y: 1))
                        .shadow(.inner(color: .jSeco.opacity(0.1), radius: 4, x: 0, y: -4))
                        .shadow(.drop(color: .jSeco.opacity(0.25), radius: 30, x: 0, y: 30))
                    )
                    .overlay(RoundedRectangle(cornerRadius: 35).stroke(.jSeco))
                    .overlay(
                        Image(systemName: "rainbow")
                            .symbolEffect(.variableColor.reversing)
                            .symbolRenderingMode(.multicolor)
                            .font(.largeTitle)
                            .bold()
                    )
                    .background(
                        ZStack {
                            AngularGradient(colors: [.red, .blue, .teal, .red], center: .center, angle: .degrees(appear ? 360 : 0))
                                .cornerRadius(35)
                                .blur(radius: 5)
                                .blur(radius: 8)
                                .blur(radius: 15)
                            AngularGradient(colors: [.white, .blue, .teal, .white], center: .center, angle: .degrees(appear ? 360 : 0))
                                .cornerRadius(35)
                                .blur(radius: 8)
                                .blur(radius: 15)
                        }
                    )
                    .onAppear {
                        withAnimation(.linear(duration: 3).repeatForever(autoreverses: true)) {
                            appear = true
                        }
                    }
            }.padding(.vertical, 64)
                .padding()
        }
        
    }
}

#Preview {
    RadialGradientButtonAnimation()
}
