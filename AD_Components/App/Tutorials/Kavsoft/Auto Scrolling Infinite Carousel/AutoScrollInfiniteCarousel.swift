//
//  AutoScrollInfiniteCarousel.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 02.10.24.
//


/// Tutorial by Kavsoft: https://www.youtube.com/watch?v=p1nN9eFOPNQ
import SwiftUI

struct AutoScrollInfiniteCarousel: View {
    var body: some View {

        VStack(spacing: 16) {
            AutoCustomCarousel(activeIndex: $activePage) {

        VStack {
            AutoCustomCarousel {

                ForEach(mockItems) { mockItem in
                    RoundedRectangle(cornerRadius: 32)
                        .fill(mockItem.color.gradient)
                        .padding(.horizontal)
                }
            }
            .frame(height: 224)

            
            // MARK: - CustomIndicators
            HStack(spacing: 8) {
                ForEach(mockItems.indices, id: \.self) { index in
                    Circle()
                        .fill(activePage == index ? mockItems[index].color : .secondary)
                        .frame(width: 8, height: 8)
                }
            }
        }
        .navigationTitle("Auto Scroll Carousel")
    }
    @State private var activePage: Int = 0

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
    @Binding var activeIndex: Int
    @ViewBuilder var content: Content
    
    // TODO: Find out how Animation works on this
    var body: some View {
        GeometryReader {
            let size = $0.size
            Group(subviews: content) { collection in
                ScrollView(.horizontal) {
                    HStack(spacing: 0) {
                        
    
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

                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $scrollPosition)
                .scrollTargetBehavior(.paging)
                .scrollIndicators(.hidden)
                .onScrollPhaseChange { oldPhase, newPhase in
                    /// Magic going on here
                    isScrolling = newPhase.isScrolling
                    
                    if !isScrolling && scrollPosition == -1 {
                        scrollPosition = collection.count - 1
                    }
                    
                    if !isScrolling && scrollPosition == collection.count && !isHoldingScreen {
                        scrollPosition = 0
                    }
                }
                .simultaneousGesture(DragGesture(minimumDistance: 0).updating($isHoldingScreen, body: { _, out, _ in
                    out = true
                }))
                .onChange(of: isHoldingScreen, { oldValue, newValue in
                    if newValue {
                        timer.upstream.connect().cancel() // Combine 😍
                    } else {
                        if isSettled && scrollPosition != offsetBasedPosition {
                            scrollPosition = offsetBasedPosition
                        }
                        timer = Timer.publish(every: Self.autoScrollDuration, on: .main, in: .default).autoconnect()
                    }
                })
                .onReceive(timer) { _ in
                    /// Safe Check
                    guard !isHoldingScreen && !isScrolling else { return }
                    
                    let nextIndex = (scrollPosition ?? 0) + 1
                    // MARK: - Animation??? Not Working ???
                    withAnimation(.linear(duration: 2.25)) {
                        scrollPosition = (nextIndex == collection.count + 1) ? 0 : nextIndex
                    }
                }
                .onChange(of: scrollPosition) { oldValue, newValue in
                    if let newValue {
                        if newValue == -1 {
                            activeIndex = collection.count - 1
                        } else if newValue == collection.count {
                            activeIndex = 0
                        } else {
                            activeIndex = max(min(newValue, collection.count - 1), 0)
                        }
                    }
                }
                .onScrollGeometryChange(for: CGFloat.self) {
                    $0.contentOffset.x
                } action: { oldValue, newValue in
                    isSettled = size.width > 0 ? (Int(newValue) % Int(size.width) == 0) : false
                    let index = size.width > 0 ? Int((newValue / size.width).rounded() - 1) : 0
                    offsetBasedPosition = index
                    
                    if isSettled && (scrollPosition != index || index == collection.count) && !isScrolling && !isHoldingScreen {
                        scrollPosition = index == collection.count ? 0 : index
                    }
                }

            }
            .onAppear { scrollPosition = 0}
        }
    }
    /// for mathematical duration output 🤓
    private static var autoScrollDuration: CGFloat {
        return 3
    }
    // MARK: - View Variables
    @State private var scrollPosition: Int?
    @State private var offsetBasedPosition: Int = 0
    @State private var isSettled: Bool = false
    @State private var isScrolling: Bool = false
    @State private var timer = Timer.publish(every: autoScrollDuration, on: .main, in: .default).autoconnect()
    @GestureState private var isHoldingScreen: Bool = false

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
