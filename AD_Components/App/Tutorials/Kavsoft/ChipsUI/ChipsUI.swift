//
//  ChipsUI.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 04.10.24.
//

/// Tutorial by Kavsoft: https://www.youtube.com/watch?v=V7tRbzbSU6M&t=305s
import SwiftUI

struct ChipsUI: View {
    var body: some View {
        NavigationStack {
            VStack {
                ChipsView {
                    ForEach(mockChips) { chip in
                        let viewWidth = chip.name.size(.preferredFont(forTextStyle: .body)).width + 20
                        Text(chip.name)
                            .font(.body)
                            .foregroundColor(.jPrime)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 10)
                            .background(.red.gradient, in: .capsule)
                            .containerValue(\.viewWidth, viewWidth)
                    }
                }
                .frame(width: 200)
                .padding()
                .background(.primary.opacity(0.1), in: .rect(cornerRadius: 21))
            }
            .padding()
            .navigationTitle("Chip's")
        }
    }
}


// MARK: - ChipsView
struct ChipsView<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        Group(subviews: content) { collection in
            let chunkedCollection = collection.chunkByWidth(200)
            
            VStack(alignment: .center, spacing: 10) {
                ForEach(chunkedCollection.indices, id: \.self) { index in
                    HStack(spacing: 8) {
                        ForEach(chunkedCollection[index]) { subview in
                            subview
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Get chips indivdual width
extension String {
    func size(_ font: UIFont) -> CGSize {
        let attributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: attributes)
    }
}

extension ContainerValues {
    @Entry var viewWidth: CGFloat = 0
}

// MARK: - SubviewsCollection
/// Splits a single array into a chunk of multiple arrays with a specified size.
extension SubviewsCollection {
    func chunkByWidth(_ containerWidth: CGFloat) -> [[Subview]] {
        var row: [Subview] = []
        var rowWidth: CGFloat = 0
        var rows: [[Subview]] = []
        let spacing: CGFloat = 8
        
        for subview in self {
            let viewWidth = subview.containerValues.viewWidth + spacing
            
            rowWidth += viewWidth
            
            if rowWidth < containerWidth {
                row.append(subview)
            } else {
                rows.append(row)
                row = [subview]
                rowWidth = viewWidth
            }
        }
        if !row.isEmpty {
            rows.append(row)
        }
        
        return rows
    }
    
    func chunked(_ size: Int) -> [[Subview]] {
        return stride(from: 0, to: count, by: size).map { index in
            Array(self[index..<Swift.min(index + size, count)])
        }
    }
}

// MARK: - MockData
struct Chip: Identifiable {
    var id: String = UUID().uuidString
    var name: String
}

var mockChips: [Chip] = [
    Chip(name: "Chip 1"),
    Chip(name: "Chip 2"),
    Chip(name: "Chip 3"),
    .init(name: "Chip 4"),
    .init(name: "Chip 5"),
    .init(name: "Chip 6"),
    .init(name: "Apple"),
    .init(name: "Banana"),
    .init(name: "Orange"),
    .init(name: "Pineapple"),
    .init(name: "Strawberry"),
    .init(name: "Watermelon"),
    .init(name: "Kiwi"),
    .init(name: "Mango"),
    .init(name: "Papaya"),
    .init(name: "Pear"),
    .init(name: "Plum")
]

#Preview {
        ChipsUI()
}
