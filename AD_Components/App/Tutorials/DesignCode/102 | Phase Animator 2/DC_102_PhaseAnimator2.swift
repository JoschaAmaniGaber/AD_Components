//
//  DC_102_PhaseAnimator2.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 30.09.24.
//
// TODO: How to get deepth to symbol

/// Tutorial by DesignCode: https://designcode.io/swiftui-handbook-phase-animator & me exploring^^

import SwiftUI

struct DC_102_PhaseAnimator2: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .resizable()
                .scaledToFit()
                .frame(width: 104, height: 104)
                .foregroundStyle(.tint)
                .phaseAnimator([1, 2, 3, 1, 2, 4, 2], trigger: isTapped) {
                    content, phase in
                    content
                        .scaleEffect(phase * 0.5, anchor: .top)
                        .shadow(color: .jSeco, radius: phase == 1 ? 5 : 3, y: phase == 1 ? 3 : phase == 2 ? 8 : 4)
                        .blur(radius: phase == 1 ? 0 : phase == 3 ? 0.4 : 0.3)
//                        .scaleEffect(phase, anchor: .top)
                        .rotation3DEffect(.degrees(.init(phase == 2 ? 360 : 0)), axis: (x: 1, y: -1, z: 1))
                } animation: { phase in
                    switch phase {
                    case 1: .bouncy(duration: 3, extraBounce: 0.3)
                    case 2: .smooth(duration: 3, extraBounce: 0.5)
                    case 3: .easeOut(duration: 3)
                    default: .easeInOut
                    }
                }
                .onTapGesture {
                    isTapped.toggle()
                }
        }
        .padding()
    }
    @State var isTapped = false
}

#Preview {
    DC_102_PhaseAnimator2()
}
