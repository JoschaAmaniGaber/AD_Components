//
//  PresentingScreen.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 14.10.24.
//

import SwiftUI

struct PresentingScreen: View {

    var body: some View {
        NavigationStack {
            VStack {
                Text("Tutorial by Kavsoft")
                    .bold()
                    .fontWidth(.expanded)
                    .shadow(color: .purple, radius: 8, y: 8)
                Spacer()
                
                /// Change here 👇 to the Screen of ur choice
                CustomCarousel(config: .init(hasOpacity: true, hasScale: true), selection: $activeID, data: images) { item in
                    Image(item.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                }
//                .frame(height: 280)
                Spacer()
                Text("Amani Dunia Apps")
                    .font(.headline)
                    .bold()
                    .fontWidth(.expanded)
                    .shadow(color: .purple, radius: 8, y: 8)
                
            }
            .navigationTitle("Cover Carousel")
            .navigationBarTitleDisplayMode(.inline)
        }
        .fontWidth(.expanded)
    }
    @State private var activeID: UUID?
}

#Preview {
    PresentingScreen()
}
