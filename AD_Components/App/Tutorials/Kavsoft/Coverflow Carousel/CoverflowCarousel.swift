//
//  CoverCarousel.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 29.09.24.
//

/// Tutorial by Kavsoft: https://www.youtube.com/watch?v=xU5z4IJpVg4&t=9s
import SwiftUI

struct CoverflowCarousel: View {
    var body: some View {
        VStack {
            Text("Tutorial by Kavsoft")
                .bold()
                .fontWidth(.expanded)
                .shadow(color: .purple, radius: 8, y: 8)
            Spacer()
            CustomCarousel(config: .init(hasOpacity: true, hasScale: true), selection: $activeID, data: images) { item in
                Image(item.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            }
            .frame(height: 180)
            Spacer()
            Text("Amani Dunia Apps")
                .font(.headline)
                .bold()
                .fontWidth(.expanded)
                .shadow(color: .purple, radius: 8, y: 8)

        }
        .navigationTitle("Cover Carousel")
    }
    @State private var activeID: UUID?
}

/// Custom View
struct CustomCarousel<Content: View, Data: RandomAccessCollection>: View where Data.Element: Identifiable {
    var config: Config
    @Binding var selection: Data.Element.ID?
    var data: Data
    @ViewBuilder var content: (Data.Element) -> Content
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal) {
                HStack(spacing: config.spacing) {
                    ForEach(data) { item in
                        ItemView(item)
                    }
                }
                .scrollTargetLayout()
            }
            /// Making it to start and end at the center
            .safeAreaPadding(.horizontal, max((size.width - config.cardWidth) / 2, 0))
            .scrollPosition(id: $selection)
            /// Making it a carousel
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            /// Hidding Scroll Indicators
            .scrollIndicators(.hidden)
        }
    }
    
    /// Item View
    @ViewBuilder
    func ItemView(_ item: Data.Element) -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
            let progress = minX / (config.cardWidth + config.spacing)
            let minimumCardWidth = config.minimumCardWidth
            
            let diffWidth = config.cardWidth - minimumCardWidth
            let reducingWidth = progress * diffWidth
            /// Limiting diffWidth as the Max Value
            let cappedWidth = min(reducingWidth, diffWidth)
            
            let resizedFrameWidth = size.width - (minX > 0 ? cappedWidth : min(-cappedWidth, diffWidth))
            let negativeProgress = max(-progress, 0)
            
            let scaleValue = config.scaleValue * abs(progress)
            let opacityValue = config.opacityValue * abs(progress)
            
            
            content(item)
                .frame(width: size.width, height: size.height)
                .frame(width: resizedFrameWidth)
                .opacity(config.hasOpacity ? 1 - opacityValue : 1)
                .scaleEffect(config.hasScale ? 1 - scaleValue : 1)
                .hueRotation(.degrees(scaleValue * 2222))
                .mask({
                    let hasScale = config.hasScale
                    let scaledHeight = (1 - scaleValue) * size.height
                    
                    RoundedRectangle(cornerRadius: config.cornerRadius)
                        .frame(height: hasScale ? max(scaledHeight, 0) : size.height)
                })
                .offset(x: -reducingWidth)
                .offset(x: min(progress, 1) * diffWidth)
                .offset(x: negativeProgress * diffWidth)
        }
        .frame(width: config.cardWidth)
    }
    
    /// Config
    struct Config {
        var hasOpacity: Bool = false
        var opacityValue: CGFloat = 0.4
        var hasScale: Bool = false
        var scaleValue: CGFloat = 0.3
        
        var cardWidth: CGFloat = 240
        var spacing: CGFloat = 4
        var cornerRadius: CGFloat = 21
        var minimumCardWidth: CGFloat = 36
    }
}

// MARK: - Model
struct ImageModel : Identifiable {
    let id: UUID = .init()
    let image: String
}

var images: [ImageModel] = (45...71).compactMap {( ImageModel(image: "image\($0)" )) }



#Preview {
    NavigationStack {
        CoverflowCarousel()
    }
}

