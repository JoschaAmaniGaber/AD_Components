//
//  ModifingScrollView.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 09.10.24.
//

/// Tutorial by Kavsoft: https://www.youtube.com/watch?v=7SuorN7yZ-w
import SwiftUI

struct ModifingScrollView_1: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.horizontal) {
                LazyHStack(spacing: 8) {
                    ForEach(images) { image in
                        Image(image.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 220, height: size.height)
                            .clipShape(.rect(cornerRadius: 25))
                            .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                content
                                    .blur(radius: phase.isIdentity ? 0 : 3)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.8, anchor: .bottom)
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .safeAreaPadding(.horizontal, (size.width - 220) / 2)
        }
        .frame(height: 330)
    }
}

struct ModifingScrollView_2: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.horizontal) {
                LazyHStack(spacing: 8) {
                    ForEach(images) { image in
                        Image(image.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 220, height: size.height)
                            .clipShape(.rect(cornerRadius: 25))
                            .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                content
                                    .blur(radius: phase.isIdentity ? 0 : 3)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.8, anchor: .top)
                                    .offset(y: phase.isIdentity ? 0 : -35)
                                    .rotationEffect(.init(degrees: phase == .identity ? 0 : phase.value * -32), anchor: .top)
                            }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollClipDisabled()
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .safeAreaPadding(.horizontal, (size.width - 220) / 2)
        }
        .frame(height: 330)
    }
}

struct ModifingScrollView_3: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.horizontal) {
                LazyHStack(spacing: 8) {
                    ForEach(images) { image in
                        Image(image.image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 220 + 80)
                            .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                content
                                    .offset(x: phase.isIdentity ? 0 : -phase.value * 80)
                            }
                            .frame(width: 220, height: size.height)
                            .clipShape(.rect(cornerRadius: 25))
                    }
                }
                .scrollTargetLayout()
            }
            .scrollClipDisabled()
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .safeAreaPadding(.horizontal, (size.width - 220) / 2)
        }
        .frame(height: 330)
    }
}

struct ModifingScrollView_4: View {
    var body: some View {
        GeometryReader {
            let size = $0.size
            ScrollView(.horizontal) {
                LazyHStack(spacing: 8) {
                    ForEach(images) { image in
                        let index = Double(images.firstIndex(where: { $0.id == image.id }) ?? 0)
                        GeometryReader {
                            let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                            Image(image.image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 220, height: size.height)
                                .clipShape(.rect(cornerRadius: 25))
                                .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                    content
                                        .blur(radius: phase.isIdentity ? 0 : 2, opaque: false)
                                        .scaleEffect(phase.isIdentity ? 1 : 0.9, anchor: .bottom)
                                        .offset(y: phase.isIdentity ? 0 : -16)
                                        .rotationEffect(.init(degrees: phase.isIdentity ? 0 : phase.value * 5), anchor: .bottomTrailing)
                                        .offset(x: minX < 0 ? minX / 2 : -minX)
                                }
                                
                        }
                        .frame(width: 220)
                        .zIndex(-index)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollClipDisabled()
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .safeAreaPadding(.horizontal, (size.width - 220) / 2)
        }
        .frame(height: 330)
    }
}

#Preview {
    ModifingScrollView_4()
}
