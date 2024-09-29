//
//  InteractiveFloatingButton.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 28.09.24.
//

/// Tutorial by Kavsoft: https://www.youtube.com/watch?v=ogblzP7rXHg&t=325s

import SwiftUI

struct InteractiveFloatingButton: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(colors, id: \.self) { color in
                        RoundedRectangle(cornerRadius: 21)
                            .fill(color.gradient)
                            .frame(height: 200)
                    }
                }
                .padding()
            }
            .navigationTitle("Interactive Floating Button")
        }
        .overlay(alignment: .bottomTrailing) {
            FloatingButton {
                FloatingAction(symbol: "tray.full.fill") {
                    print("Tray")
                }
                
                FloatingAction(symbol: "lasso.badge.sparkles") {
                    print("Spark")
                }
                
                
                FloatingAction(symbol: "square.and.arrow.up.fill") {
                    print("Share")
                }
                
            } label: { isExpanded in
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.jPrime)
                    .rotationEffect(.init(degrees: isExpanded ? 45 : 0))
                    .scaleEffect(isExpanded ? 1 : 2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.jSeco, in: .circle)
            }
            .padding()
            
        }
    }
    @State private var colors: [Color] = [
        .red,
        .blue,
        .green,
        .yellow,
        .cyan,
        .brown,
        .purple,
        .indigo,
        .mint,
        .pink
    ]
}

/// Custom Button
struct FloatingButton<Label: View>: View {
    /// Actions
    var buttonsize: CGFloat
    var actions: [FloatingAction]
    var label: (Bool) -> Label
    init(buttonsize: CGFloat = 56, @FloatingActionBuilder actions: @escaping () -> [FloatingAction], @ViewBuilder label: @escaping (Bool) -> Label) {
        self.buttonsize = buttonsize
        self.actions = actions()
        self.label = label
    }
    /// View Properties
    @State private var isExpended: Bool = false
    @State private var dragLocation: CGPoint = .zero
    @State private var selectedAction: FloatingAction?
    @GestureState private var isDragging: Bool = false
    var body: some View {
        Button {
            isExpended.toggle()
        } label: {
            label(isExpended)
                .frame(width: buttonsize, height: buttonsize)
                .contentShape(.rect)
        }
        .buttonStyle(NoAnimationButtonStyle())
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.2)
                .onEnded { _ in
                    isExpended = true
                }
                .sequenced(before: DragGesture().updating($isDragging, body: { _, out, _ in
                    out = true
                }).onChanged { value in
                    guard isExpended else { return }
                    dragLocation = value.location
                }.onEnded{ _ in
                    Task {
                        if let selectedAction {
                            isExpended = false
                            selectedAction.action()
                        }
                        selectedAction = nil
                        dragLocation = .zero
                    }
                })
        )
        .background {
            ZStack {
                ForEach(actions) { action in
                    ActionView(action)
                }
            }
            .frame(width: buttonsize, height: buttonsize)
        }
        .coordinateSpace(.named("FLOATING VIEW"))
        .animation(.snappy(duration: 0.4, extraBounce: 0), value: isExpended)
    }
    /// Action View
    @ViewBuilder
    func ActionView(_ action: FloatingAction) -> some View {
        Button {
            action.action()
            isExpended = false
        } label: {
            Image(systemName: action.symbol)
                .font(action.font)
                .foregroundStyle(action.tint)
                .frame(width: buttonsize, height: buttonsize)
                .background(action.background, in: .circle)
                .contentShape(.circle)
        }
        .buttonStyle(PressableButtonStyle())
        .disabled(!isExpended)
        .animation(.snappy(duration: 0.4, extraBounce: 0)) { content in
            content.scaleEffect(selectedAction?.id == action.id ? 1.35 : 1)
        }
        .background {
            GeometryReader {
                let rect = $0.frame(in: .named("FLOATING VIEW"))
                Color.clear
                    .onChange(of: dragLocation) { oldValue, newValue in
                        if isExpended && isDragging {
                            /// Checking if the drag location is inside any action's rect
                            if rect.contains(newValue) {
                                /// User is Pressing on this Action
                                selectedAction = action
                            } else {
                                /// Checking if it's gone out of the rect
                                if selectedAction?.id == action.id && !rect.contains(newValue) {
                                    selectedAction = nil
                                }
                            }
                        }
                    }
            }
        }
        .rotationEffect(.init(degrees: isExpended ? progress(action) * -90 : 0))
        .offset(x: isExpended ? -offset / 2 : 0)
        .rotationEffect(.init(degrees: isExpended ? progress(action) * 90 : 0))
    }
    
    private var offset: CGFloat {
        let buttonSize = buttonsize + 8
        return Double(actions.count) * (actions.count == 1 ? buttonSize * 3 : (actions.count == 2 ? buttonSize * 1.5 : buttonSize))
    }
    
    private func progress(_ action: FloatingAction) -> CGFloat {
        let index = CGFloat(actions.firstIndex(where: { $0.id == action.id }) ?? 0)
        return actions.count == 1 ? 1 : (index / CGFloat(actions.count - 1))
    }
}

/// Custom Button Styles
fileprivate struct NoAnimationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

fileprivate struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.snappy(duration: 0.3, extraBounce: 0.2), value: configuration.isPressed)
    }
}

struct FloatingAction: Identifiable {
    private(set) var id: UUID = .init()
    var symbol: String
    var font: Font = .title3
    var tint: Color = .jPrime
    var background: Color = .jSeco
    var action: () -> Void
}

/// SwiftUI View like Builder to get an array of actions using ResultBuilder
@resultBuilder
struct FloatingActionBuilder {
    static func buildBlock(_ components: FloatingAction...) -> [FloatingAction] {
        components.compactMap ({ $0 }) // TODO:
    }
}


#Preview {
    InteractiveFloatingButton()
}
