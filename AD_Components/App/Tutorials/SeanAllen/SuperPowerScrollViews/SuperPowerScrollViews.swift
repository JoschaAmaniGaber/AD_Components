//
//  SuperPowerScrollViews.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 04.10.24.
//

/// Tutorial by SeanAllen: https://www.youtube.com/watch?v=IwUp2iP0jnI
import SwiftUI

struct SuperPowerScrollViews: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(MockData.items) { item in
                    Circle()
                        .containerRelativeFrame(
                            .horizontal,
                            count: verticalSizeClass == .regular ? 1 : 3,
                            spacing: 16
                        )
                        .foregroundStyle(item.color.gradient)
                        .scrollTransition { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.1)
                                .scaleEffect(
                                    x: phase.isIdentity ? 1 : 0.1,
                                    y: phase.isIdentity ? 1 : 0.1
                                )
                                .offset(
                                    x: phase.isIdentity ? 0 : -88,
                                    y: phase.isIdentity ? 0 : -88
                                )
                        }
                }
            }
            .scrollTargetLayout()
        }
        .contentMargins(64, for: .scrollContent)
        .scrollTargetBehavior(.viewAligned)
    }
   
}
struct Item: Identifiable {
    let id = UUID()
    let color: Color
}

struct MockData {
    static var items = [
        Item(color: .red),
        Item(color: .yellow),
        Item(color: .orange),
        Item(color: .green),
        Item(color: .blue),
        Item(color: .purple),
        Item(color: .indigo)
    ]
}
#Preview {
    SuperPowerScrollViews()
}
