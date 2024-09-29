//
//  CircularScrollWheelPicker.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 29.09.24.
//

/// Tutorial by EverythingSwiftUI: https://www.youtube.com/watch?v=rA6_LALQr64

import SwiftUI

enum Categories: String, CaseIterable, Identifiable {
    case home, exploration, sports, politics, technology, music, science
    
    var id: Self { self }
    
    var view: AnyView {
        switch self {
        case .home: return AnyView(Text("Home"))
        case .exploration: return AnyView(Text("Exploration"))
        case .sports: return AnyView(Text("Sports"))
        case .politics: return AnyView(Text("Politics"))
        case .technology: return AnyView(Text("Technology"))
        case .music: return AnyView(Text("Music"))
        case .science: return AnyView(Text("Science"))
        }
    }
    
    var color: Color {
        switch self {
        case .home: return .red
        case .exploration: return .blue
        case .sports: return .green
        case .politics: return .yellow
        case .technology: return .orange
        case .music: return .purple
        case .science: return .pink
        }
    }
}

struct CircularScrollWheelPicker: View {
    var body: some View {
        ZStack {
            
            if let selectedCategory {
                VStack {
                    selectedCategory.view
                    Spacer()
                }
            }
            
            GeometryReader {
                let size = $0.size
                if isShowingPicker {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(Categories.allCases) { category in
                                Button {
                                    withAnimation(.smooth) {
                                        selectedCategory = category
                                    }
                                } label: {
                                    // Custom textView
                                    textView(category: category, size: size)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .scrollTargetLayout()
                    }
                    .onChange(of: scrollID) { oldValue, newValue in
                        if let newValue {
                            withAnimation(.smooth) {
                                scrollID = newValue
                                selectedCategory = newValue
                            }
                        }
                    }
                    .safeAreaPadding(.top, (size.height * 0.5) - 20)
                    .safeAreaPadding(.bottom, (size.height * 0.5))
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $scrollID, anchor: .trailing)
                }
            }
        }
        .background(selectedCategory?.color.gradient ?? .init(.init(colors: [.jPrime, .jSeco.opacity(0.3)])))
        .overlay(alignment: .trailing) {
            ZStack {
                Circle()
                    .fill(.ultraThinMaterial)
                    .frame(width: 48, height: 48)
                    .shadow(color: .jSeco, radius: 8, y: 8)
                
                Image(systemName: "xmark")
                    .foregroundStyle(.jSeco)
                    .fontWeight(.bold)
                    .imageScale(.large)
            }
            .offset(x: -UIScreen.main.bounds.width * 0.08)
            .offset(y: isShowingPicker ? 0 : UIScreen.main.bounds.height * 0.35)
            .padding(.bottom)
            .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.7, dampingFraction: 0.7, blendDuration: 0.3)) {
                    isShowingPicker.toggle()
                }
            }
        }
        .overlay(alignment: .bottom) {
            HStack {
                ForEach(Categories.allCases) { category in
                    Circle()
                        .frame(width: 16, height: 8)
                        .foregroundStyle(scrollID == category ? category.color : .halfJPrime)
                        .onTapGesture {
                            withAnimation(.smooth) {
                                scrollID = category
                                selectedCategory = category
                            }
                        }
                }
            }
            .padding()
            .background(.ultraThinMaterial, in: Capsule())
            .opacity(isShowingPicker ? 1 : 0.1)
            .disabled(!isShowingPicker)
        }
    }
    // MARK: - View Properties
    @State private var selectedCategory: Categories? = .home
    @State private var scrollID: Categories? = .home
    @State private var isShowingPicker: Bool = false
    
    // MARK: - View Methods
    private func rotation(proxy: GeometryProxy, size: CGSize) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let height = (size.height * 0.5)
        let progress = (minY / height)
        let maxRotation: CGFloat = 220 // change this value to whatever you like and test it yourself
        
        return progress * maxRotation
    }
    
    private func opacity(proxy: GeometryProxy, size: CGSize) -> CGFloat {
        let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
        let height = (size.height * 0.5)
        let progress = (minY / height) * 2.8
        
        return progress < 0 ? 1 + progress : 1 - progress
    }
    
    // MARK: - ViewBuilder
    @ViewBuilder
    func textView(category: Categories, size: CGSize) -> some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            
            Text(category.rawValue.capitalized)
                .fontWeight(.bold)
                .foregroundStyle(selectedCategory == category ? .jPrime : .halfJPrime)
                .blur(radius: selectedCategory == category ? 0 : 2)
                .offset(x: -width * 0.25)
                .rotationEffect(.degrees(-rotation(proxy: geometry, size: size)))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .trailing)
                .opacity(opacity(proxy: geometry, size: size))
        }
        .frame(height: 20)
        .lineLimit(1)
    }
}

#Preview {
    CircularScrollWheelPicker()
}
