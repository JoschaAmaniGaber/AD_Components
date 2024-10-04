//
//  Home.swift
//  AD_Learning
//
//  Created by Joscha Amani Gaber on 03.09.24.
//

/// Tutorial by Kavsoft: https://www.youtube.com/watch?v=oI_zsmA_M3g
import SwiftUI

struct CircularCarouselSlider: View {
    var body: some View {
        VStack {
            Picker("", selection: $pickerType) {
                    ForEach(TripPicker.allCases, id: \.rawValue) {
                        Text($0.rawValue)
                            .tag($0)
                    }
            }
            .pickerStyle(.segmented)
            .padding()
            
            Spacer(minLength: 0)
            
            GeometryReader {
                let size = $0.size
                let padding = (size.width - 88) / 2 // MARK: - 0 / 2 ?
                
                // Circular Slider
                ScrollView(.horizontal) {
                    HStack(spacing: 35) {
                        ForEach(1...21, id: \.self) { index in
                            Image("image\(index)")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 88, height: 88)
                                .clipShape(.circle)
                                
                                .shadow(color: .black, radius: 8, x: 0, y: 8)
                                .visualEffect { view, proxy in
                                    view
                                        .offset(y: offset(proxy))
                                        .offset(y: scale(proxy) * 22)
                                        
                                }
                                .scrollTransition(.interactive, axis: .horizontal) {
                                    view, phase in
                                    view
                                        //.offset(y: phase.isIdentity && activID == index ? 44 : 0)
                                        .scaleEffect(phase.isIdentity && activeID == index && pickerType != .normal ? 1.53 : 1, anchor: .bottom)
                                        .blur(radius: phase.isIdentity && activeID == index || pickerType == .normal ? 0 : 8)
                                }
                        }
                        
                    }
                    
                    .frame(height: size.height)
                    .offset(y: -44)
                    .scrollTargetLayout()
                }
                .background {
                    if pickerType == .scaledWithBG {
                        Circle()
                            .fill(.white.shadow(.drop(color: .black, radius: 8, y: 8)))
                            .frame(width: 156, height: 156)
                            .offset(y: -16)
                            
                    }
                }
                .background(.red)
                .safeAreaPadding(.horizontal, padding)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.viewAligned)
                .scrollPosition(id: $activeID)
                .frame(height: size.height)
            }
            .frame(height: 300)
            
        }
    }
    private func offset(_ proxy: GeometryProxy) -> CGFloat {
        let progress = progress(proxy)
        // Moving View Up/Down Based on Progress
        return progress < 0 ? progress * -88 : progress * 88
    }
    
    func scale(_ proxy: GeometryProxy) -> CGFloat {
        let progress = min(max(progress(proxy), -1), 1)
        
        return progress < 0 ? 1 + progress : 1 - progress
    }
    
    private func progress(_ proxy: GeometryProxy) -> CGFloat {
        // View Width
        let viewWidth = proxy.size.width
        let minx = (proxy.bounds(of: .scrollView)?.minX ?? 0)
        return minx / viewWidth
    }
    
    // ViewProperties
    @State private var pickerType: TripPicker = .normal
    @State private var activeID: Int?
}

enum TripPicker: String, CaseIterable {
    case scaled = "Scaled"
    case scaledWithBG = "Scaled&BG"
    case normal = "Normal"
}

#Preview {
    CircularCarouselSlider()
}
