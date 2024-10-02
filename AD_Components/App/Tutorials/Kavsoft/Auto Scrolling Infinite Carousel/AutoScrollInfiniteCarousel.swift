//
//  AutoScrollInfiniteCarousel.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 02.10.24.
//

import SwiftUI

struct AutoScrollInfiniteCarousel: View {
    var body: some View {
        VStack {
            AutoCustomCarousel {
                ForEach(mockItems) { mockItem in
                    RoundedRectangle(cornerRadius: 32)
                        .fill(mockItem.color.gradient)
                        .padding(.horizontal)
                }
            }
            .frame(height: 224)
        }
        .navigationTitle("Auto Scroll Carousel")
    }
}

#Preview {
    NavigationStack {
        AutoScrollInfiniteCarousel()
    }
    
}
// MARK: - AutoScrollCustomCaroussel
struct AutoCustomCarousel<Content: View>: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    Group(subviews: content) { collection in
                        if let lastItem = collection.last {
                            lastItem
                                .frame(width: size.width, height: size.height)
                                .id(-1)
                                /// Magic going on here
                                .onChange(of: isScrolling) { oldValue, newValue in
                                    if newValue && scrollPosition == -1 {
                                        scrollPosition = collection.count - 1
                                    }
                                }
                        }
                        
                        ForEach(collection.indices, id: \.self) { index in
                            collection[index]
                                .frame(width: size.width, height: size.height)
                                .id(index)
                        }
                        
                        if let firstItem = collection.first {
                            firstItem
                                .frame(width: size.width, height: size.height)
                                .id(collection.count)
                                /// and Magic going on here
                                .onChange(of: isScrolling) { oldValue, newValue in
                                    if !newValue && scrollPosition == collection.count {
                                        scrollPosition = 0
                                    }
                                }
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $scrollPosition)
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .onScrollPhaseChange({ oldPhase, newPhase in
                isScrolling = newPhase.isScrolling
            })
            .onAppear { scrollPosition = 0}
        }
    }
    // MARK: - View Variables
    @State private var scrollPosition: Int?
    @State private var isScrolling: Bool = false
}

// MARK: - SampleData
struct MockItem: Identifiable {
    var id: String = UUID().uuidString
    var color: Color
}

var mockItems: [MockItem] = [
    .init(color: .red),
    .init(color: .yellow),
    .init(color: .orange),
    .init(color: .green),
    .init(color: .blue),
    .init(color: .purple),
    .init(color: .indigo)
]
