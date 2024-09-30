//
//  DC_121_HueRotation.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 30.09.24.
//

/// Tutorial by DeignCode: https://designcode.io/swiftui-handbook-image-gallery-huerotation-and-swipe-gesture
import SwiftUI

enum ImageAsset: String, CaseIterable, Identifiable {
    case image3, image5, image6, image7, image8, image11, image12, image13, image14, image15, image17, image20, image21, image22
    var id : String { self.rawValue }
}

struct DC_121_HueRotation: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
//                Color.jSeco.edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Tutorial by DesignCode")
                        .bold()
                        .fontWidth(.expanded)
                        .shadow(color: .indigo, radius: 8, y: 8)
                    ZStack {
                        ForEach(ImageAsset.allCases.indices, id: \.self) { index in
                            Image(ImageAsset.allCases[index].rawValue)
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .hueRotation(.degrees(isShiftingColors ? 720 : 0))
                                .animation(isShiftingColors ? .easeInOut(duration: 2).delay(0.4).repeatForever(autoreverses: true) : .default, value: isShiftingColors)
                                .offset(x: isSwiping ? CGFloat(index - indexSelectedImage) * geometry.size.width + offsetSelectedImage : 0)
                                .opacity(isSwiping ? 1 : (indexSelectedImage == index ? 1 : 0))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onChanged{ gesture in
                                isDragging = true
                                isSwiping = true
                                offsetSelectedImage = gesture.translation.width
                            }
                            .onEnded{ gesture in
                                isDragging = false
                                let threshold = geometry.size.width / 3
                                if abs(gesture.translation.width) > threshold {
                                    if gesture.translation.width > 0 && indexSelectedImage > 0 {
                                        indexSelectedImage -= 1
                                    } else if gesture.translation.width < 0 && indexSelectedImage < ImageAsset.allCases.count - 1 {
                                        indexSelectedImage += 1
                                    }
                                }
                                offsetSelectedImage = 0
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    isSwiping = false
                                }
                            }
                    )
                    .animation(isDragging ? nil : .spring(), value: offsetSelectedImage)
                    .animation(.default, value: indexSelectedImage)
                    ScrollViewReader { proxy in
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(ImageAsset.allCases.indices, id: \.self) { index in
                                    Image(ImageAsset.allCases[index].rawValue)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 104, height: 104)
                                        .clipped()
                                        .border(indexSelectedImage == index ? .blue : .clear, width: 2)
                                        .id(index)
                                        .onTapGesture {
                                            isSwiping = false
                                            indexSelectedImage = index
                                        }
                                }
                            }
                            .padding()
                        }
                        .onChange(of: indexSelectedImage) {_, newIndex in
                            withAnimation {
                                proxy.scrollTo(newIndex, anchor: .center)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Hue Rotation")
            .onAppear {
                isShiftingColors.toggle()
            }
        }
    }
    // MARK: - Screen only Variables
    @State private var indexSelectedImage: Int = 0
    @State private var offsetSelectedImage: CGFloat = 0
    @State private var isDragging: Bool = false
    @State private var isSwiping: Bool = false
    @State private var isShiftingColors: Bool = false
    
}

#Preview {
    NavigationStack {
        DC_121_HueRotation()
    }
}
