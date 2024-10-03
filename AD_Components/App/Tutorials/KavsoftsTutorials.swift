//
//  SwiftUIView.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 03.10.24.
//

import SwiftUI

struct KavsoftsTutorials: View {
    var body: some View {
        ForEach(Kavsoft.allCases) { kavsoft in
            NavigationLink(destination: kavsoft.body) {
                Text(kavsoft.rawValue)
            }
        }
    }
}

#Preview {
    NavigationStack {
        KavsoftsTutorials()
            .fontWidth(.expanded)
    }
}

enum Kavsoft: String, CaseIterable, Identifiable {
    var id: Self { self }
    case autoScroll = "Auto Scrolling Infinite Carousel"
    case coverflowCarousel = "Coverflow Carousel"
    case floatingBottomSheet = "Floating Bottom Sheet"
    case interactiveFloatingButton = "Interactive Floating Button"
    case meshGradient = "Mesh Gradient Control"
    
    @ViewBuilder
    var body: some View {
        switch self {
        case .autoScroll: AutoScrollInfiniteCarousel()
        case .coverflowCarousel: CoverflowCarousel()
        case .floatingBottomSheet: FloatingSheetScreen()
        case .interactiveFloatingButton: InteractiveFloatingButton()
        case .meshGradient: MeshGradientByKavsoft()
        }
    }
}
