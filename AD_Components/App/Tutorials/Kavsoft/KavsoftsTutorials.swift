//
//  KavsoftsTutorials.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 03.10.24.
//

import SwiftUI

struct KavsoftsTutorials: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    KavsoftsTutorials()
}

enum Kavsofts: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case autoCarousel = "Auto Scroll Infinite Carousel"
    case coverflowCarousel = "Coverflow Carousel"
    case floatingBottomSheet = "Floating Bottom Sheet"
    case interactiveFloatingButton = "Interactive Floating Button"
    case meshGradient = "Mesh Gradient"
    
//    var view: some View {
//        switch self {
//        case .autoCarousel: AutoScrollInfiniteCarousel()
//        case .coverflowCarousel: CoverflowCarousel()
//        case .floatingBottomSheet: FloatingSheetScreen()
//        case .interactiveFloatingButton: InteractiveFloatingButton()
//        case .meshGradient: MeshGradientByKavsoft()
//        }
//    }
}
