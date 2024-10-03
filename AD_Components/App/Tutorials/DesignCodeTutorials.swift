//
//  DesignCodeTutorials.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 03.10.24.
//
import SwiftUI

struct DesignCodeTutorials: View {
    var body: some View {
        ForEach(DesignCode.allCases) { designCode in
            NavigationLink(destination: designCode.body) {
                Text(designCode.rawValue)
            }
        }   
    }
}

#Preview {
    NavigationStack {
        List {
            DesignCodeTutorials()
        }
        
    }
    .fontWidth(.expanded)
}

enum DesignCode: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case phaseAnimator2 = "Phase Animator 2"
    case keyframeAnimator = "Keyframe Animator"
    case meshGradient = "Mesh Gradient Animatation"
    case textTransition = "Text Transition"
    case scrollHueRotation = "Scroll View with Hue Rotation"
    
    @ViewBuilder
    var body: some View {
        switch self {
        case .phaseAnimator2: DC_102_PhaseAnimator2()
        case .keyframeAnimator: DC_103_KeyframeAnimator()
        case .meshGradient: DC_112_MeshGradient()
        case .textTransition: DC_115_TextTransition_BasicView()
        case .scrollHueRotation: DC_121_HueRotation()
        }
    }
    
    var number: Int {
        switch self {
        case .phaseAnimator2: 102
        case .keyframeAnimator: 103
        case .meshGradient: 112
        case .textTransition: 115
        case .scrollHueRotation: 121
        }
    }
}
