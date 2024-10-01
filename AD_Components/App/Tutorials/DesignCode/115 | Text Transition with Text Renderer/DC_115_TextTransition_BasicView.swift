//
//  DC_115_TextTransition.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 30.09.24.
//

import SwiftUI

struct DC_115_TextTransition_BasicView: View {
    var body: some View {
        VStack {
            if isVisible {
                Text("Text Transition")
                    .customAttribute(EmphasisAttribute())
                    .transition(TextTransition())
                    .foregroundStyle(.jSeco)
                    .font(.system(size: 44, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
            }
            Button("Toggle Visibility") {
                isVisible.toggle()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.extraLarge)
        }
    }
    
    // MARK: - Screen Variables
    @State private var isVisible: Bool = true
}

#Preview {
    DC_115_TextTransition_BasicView()
}

struct DC_115_TextTransition_GraphicView: View {
    var body: some View {
        VStack {
            if isVisible {
                Text("Text Transition")
                    .customAttribute(EmphasisAttribute())
                    .transition(TextTransition())
                    .foregroundStyle(.jSeco)
                    .font(.system(size: 44, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .multilineTextAlignment(.center)
            }
            Button("Toggle Visibility") {
                isVisible.toggle()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.extraLarge)
        }
    }
    
    // MARK: - Screen Variables
    @State private var isVisible: Bool = true
}

#Preview {
    DC_115_TextTransition_GraphicView()
}
