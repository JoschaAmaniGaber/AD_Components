//
//  DC_114_NavigationTransition.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 12.10.24.
//

import SwiftUI

struct DC_114_NavigationTransition: View {
    @Namespace var namespace
    var body: some View {
        NavigationStack {
            ForEach(0 ..< 3) { index in
                NavigationLink {
                    Text(texts[index])
                        .navigationTransition(.zoom(sourceID: "icon\(index)", in: namespace))
                } label: {
                    Image(systemName: icons[index])
                        .font(.largeTitle)
                        .foregroundColor(.jSeco)
                        .padding()
                        .background(colors[index], in: .rect(cornerRadius: 8))
                        .matchedTransitionSource(id: "icon\(index)", in: namespace)
                }
            }
        }
    }
    // MARK: - View Properties
    let colors: [Color] = [.red, .green, .yellow]
    let icons: [String] = ["figure.surfing", "figure.surfing.circle", "figure.surfing.circle.fill"]
    let texts: [String] = ["Surfing", "Surfing Circle", "Surfing Circle Fill"]
}

#Preview {
    DC_114_NavigationTransition()
}
