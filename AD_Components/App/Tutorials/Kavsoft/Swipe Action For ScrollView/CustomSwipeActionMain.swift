//
//  CustomSwipeAction.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 12.10.24.
//

/// Tutorial by Kavsoft: https://www.youtube.com/watch?v=K8VnH2eEnK4
import SwiftUI

struct CustomSwipeActionMain: View {
    var body: some View {
        NavigationStack {
            CustomSwipeActionHome()
        }
    }
}

struct CustomSwipeActionHome: View {
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16) {
                ForEach(colors, id: \.self) { color in
                    CustomSwipeAction(cornerRadius: 0, direction: color == .red ? .leading : .trailing) {
                        CardView(color)
                    } actions: {
                        CustomAction(tint: .blue, icon: "figure.surfing.circle.fill", isEnabled: color == .red) {
                            print("Lets Surf")
                        }
                        CustomAction(tint: .red, icon: "trash") {
                            withAnimation(.linear(duration: 2)) {
                                colors.removeAll(where: { $0 == color })
                            }
                        }
                    }
                    
                }
                
            }
            .padding(.vertical)
            .shadow(color: .white, radius: 3, y: 0)
        }
        .scrollIndicators(.hidden)
        .navigationTitle("Messages")
    }
    // MARK: - View Properties
    @State private var colors: [Color] = [.red, .blue, .green, .yellow]
    
    // MARK: - Sample Card View
    @ViewBuilder func CardView(_ color: Color) -> some View {
        HStack(spacing: 16) {
            Circle()
                .frame(width: 48, height: 48)
            
            VStack(alignment: .leading, spacing: 4) {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 88, height: 8)
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 72, height: 8)
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 56, height: 8)
            }
            
            Spacer(minLength: 0)
        }
        .padding()
        .background(color.gradient, in: .rect)
    }
}

// MARK: - CustomSwipeAction
struct CustomSwipeAction<Content: View>: View {
    var cornerRadius: CGFloat = 0
    var direction: SwipeDirection = .trailing
    @ViewBuilder var content: Content
    @CustomActionBuilder var actions: [CustomAction]
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    content
                    /// optional (?!)
                        .rotationEffect(.init(degrees: direction == .leading ? -180 : 0))
                    /// To take full available Space
                        .containerRelativeFrame(.horizontal)
                        .background(sheme == .dark ? .black : .white)
                        .background {
                            if let firstAction = filteredActions.first {
                                Rectangle()
                                    .fill(firstAction.tint)
                                    .opacity(scrollOffset == .zero ? 0 : 1)
                            }
                        }
                        .id(viewID)
                        .transition(.identity)
                        .overlay {
                            GeometryReader {
                                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                                
                                Color.clear
                                    .preference(key: OffsetKey.self, value: minX)
                                    .onPreferenceChange(OffsetKey.self) {
                                        scrollOffset = $0
                                    }
                            }
                        }
                    // MARK: Action Buttons
                    ActionButtons {
                        withAnimation(.snappy) {
                            scrollViewProxy.scrollTo(
                                viewID,
                                anchor: direction == .trailing ? .topTrailing : .topLeading
                            )
                        }
                    }
                    .opacity(scrollOffset == .zero ? 0 : 1)
                }
                .scrollTargetLayout()
                .visualEffect { content, geometryProxy in
                    content
                    /// Just one side swipeAble
                        .offset(x: scrollOffet(geometryProxy))
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .background {
                // MARK: Last Action
                if let lastAction = filteredActions.last {
                    Rectangle()
                        .fill(lastAction.tint)
                        .opacity(scrollOffset == .zero ? 0 : 1)
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
            .rotationEffect(.init(degrees: direction == .leading ? 180 : 0))
        }
        .allowsHitTesting(isEnabled)
        .transition(CustomTransition())
    }
    // MARK: - View Properties
    /// Color Scheme for Background (?)
    @Environment(\.colorScheme) private var sheme
    /// Disable Button when pushed
    @State private var isEnabled: Bool = true
    /// Scroll Offset
    @State private var scrollOffset: CGFloat = .zero
    
    /// View Unique ID
    private let viewID = UUID()
    
    
    // MARK: - Action Buttons
    @ViewBuilder func ActionButtons(resetPosition: @escaping () -> ()) -> some View {
        /// Each Button will have 108 width
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(filteredActions.count) * 108, height: 108)
            .overlay(alignment: .center) {
                HStack(spacing: 0) {
                    ForEach(filteredActions) { button in
                        Button {
                            Task {
                                isEnabled = false
                                resetPosition()
                                /// Time the animation needs to complete before
                                try? await Task.sleep(for: .seconds(0.25))
                                button.action()
                                try? await Task.sleep(for: .seconds(2))
                                isEnabled = true
                            }
                        } label: {
                            Image(systemName: button.icon)
                                .font(button.iconFont)
                                .foregroundStyle(button.iconTint)
                                .frame(width: 108)
                                .frame(maxHeight: .infinity)
                                .contentShape(.rect)
                        }
                        .buttonStyle(.plain)
                        .background(button.tint)
                        .rotationEffect(.init(degrees: direction == .leading ? 180 : 0))
                    }
                }
            }
    }
    // MARK: scrollOffset
    private func scrollOffet(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        
        return (minX > 0 ? -minX : 0)
    }
    // MARK: filteredActions
    private var filteredActions: [CustomAction] {
        return actions.filter({ $0.isEnabled })
    }
}

// MARK: - Offset Key
/// Hide ButtonBackground when not swipped
struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// MARK: - Custom Transition
struct CustomTransition: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .mask {
                GeometryReader {
                    let size = $0.size
                    
                    Rectangle()
                        .offset(x: phase.isIdentity ? 0 : -size.width ,y: phase.isIdentity ? 0 : -size.height)
                }
                .containerRelativeFrame(.horizontal)
            }
    }
}

// MARK: - Swipe Direction
enum SwipeDirection {
    case leading
    case trailing
    
    var alignment: Alignment {
        switch self {
        case .leading: .leading
        case .trailing: .trailing
        }
    }
}

// MARK: - Custom Action Model
struct CustomAction: Identifiable {
    private(set) var id: UUID = .init()
    var tint: Color
    var icon: String
    var iconFont: Font = .largeTitle
    var iconTint: Color = .jSeco
    var cornerRadius: CGFloat = 8
    var isEnabled: Bool = true
    var action: () -> ()
}

// MARK: - @resultBuilder
@resultBuilder
struct CustomActionBuilder {
    static func buildBlock(_ components: CustomAction...) -> [CustomAction] {
        return components
    }
}


#Preview {
    CustomSwipeActionMain()
}


/*
 // MARK: - with Shadow & Buttons Seperate
 
 struct CustomSwipeActionHome: View {
     var body: some View {
         ScrollView(.vertical) {
             LazyVStack(spacing: 16) {
                 ForEach(colors, id: \.self) { color in
                     CustomSwipeAction(cornerRadius: 8, direction: .trailing) {
                         CardView(color)
                             .shadow(color: color, radius: 8)
                     } actions: {
                         CustomAction(tint: .red, icon: "trash") {
                             print("Delete")
                         }
                         CustomAction(tint: .red, icon: "trash.fill") {
                             print("Delete")
                         }
                     }
                     
                 }
             }
         }
         .scrollIndicators(.hidden)
         .navigationTitle("Messages")
     }
     // MARK: - View Properties
     @State private var colors: [Color] = [.red, .blue, .green, .yellow]
     
     // MARK: - Sample Card View
     @ViewBuilder func CardView(_ color: Color) -> some View {
         HStack(spacing: 16) {
             Circle()
                 .frame(width: 48, height: 48)
             
             VStack(alignment: .leading, spacing: 4) {
                 RoundedRectangle(cornerRadius: 16)
                     .frame(width: 88, height: 8)
                 RoundedRectangle(cornerRadius: 16)
                     .frame(width: 72, height: 8)
                 RoundedRectangle(cornerRadius: 16)
                     .frame(width: 56, height: 8)
             }
             
             Spacer(minLength: 0)
         }
         .padding()
         .background {
             RoundedRectangle(cornerRadius: 16, style: .continuous)
                 .fill(color.gradient)
                 .overlay {
                     RoundedRectangle(cornerRadius: 16, style: .continuous)
                         .stroke(style: StrokeStyle(lineWidth: 2))
                 }
         }
     }
 }

 // MARK: - CustomSwipeAction
 struct CustomSwipeAction<Content: View>: View {
     var cornerRadius: CGFloat = 0
     var direction: SwipeDirection = .trailing
     @ViewBuilder var content: Content
     @CustomActionBuilder var actions: [CustomAction]
     var body: some View {
         ScrollViewReader { scrollViewProxy in
             ScrollView(.horizontal) {
                 LazyHStack(spacing: 0) {
                     content
                         .padding()
                     /// To take full available Space
                         .containerRelativeFrame(.horizontal)
                     
                     ActionButtons()
                 }
                 .scrollTargetLayout()
                 .visualEffect { content, geometryProxy in
                     content
                     /// Just one side swipeAble
                         .offset(x: scrollOffet(geometryProxy))
                 }
             }
             .scrollIndicators(.hidden)
             .scrollTargetBehavior(.viewAligned)
             .clipShape(.rect)
         }

     }
     // MARK: - Action Buttons
     @ViewBuilder func ActionButtons() -> some View {
         /// Each Button will have 104 width
         Rectangle()
             .fill(.clear)
             .frame(width: CGFloat(actions.count) * 108, height: 88)
             .overlay(alignment: .center) {
                 HStack(spacing: 16) {
                     ForEach(actions) { button in
                         Button {} label: {
                             Image(systemName: button.icon)
                                 .font(button.iconFont)
                                 .foregroundStyle(button.iconTint)
                                 .frame(width: 56, height: 56)
                                 .padding()
                                 .shadow(color: .jPrime, radius: 3, y: 0)
                         }
                         .buttonStyle(.plain)
                         .background(button.tint)
                         .clipShape(.rect(cornerRadius: 8, style: .continuous))
                         .shadow(color: .jSeco, radius: 3, y: 3)
                     }
                 }
             }
     }
     
     private func scrollOffet(_ proxy: GeometryProxy) -> CGFloat {
         let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
         
         return direction == .trailing ? (minX > 0 ? -minX : 0) : (minX < 0 ? -minX : 0)
     }
 }

 // MARK: - Swipe Direction
 enum SwipeDirection {
     case leading
     case trailing
     
     var alignment: Alignment {
         switch self {
         case .leading: .trailing
         case .trailing: .leading
         }
     }
 }

 // MARK: - Custom Action Model
 struct CustomAction: Identifiable {
     private(set) var id: UUID = .init()
     var tint: Color
     var icon: String
     var iconFont: Font = .title
     var iconTint: Color = .jSeco
     var cornerRadius: CGFloat = 8
     var isEnabled: Bool = true
     var action: () -> ()
 }

 // MARK: - @resultBuilder
 @resultBuilder
 struct CustomActionBuilder {
     static func buildBlock(_ components: CustomAction...) -> [CustomAction] {
         return components
     }
     
 }
 */
