//
//  AnimatedSideBar.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 03.10.24.
//

/// Tutorial by Kavsoft: https://www.youtube.com/watch?v=GlTJ8LK9mq4
/// Best Use Case is to have the NavigationStack starting here. If u have another NavigationStack before this you are not able to come to the SideBarMenu from every Screen

import SwiftUI

struct AnimatedSideBar: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        CustomAnimatedSideBar(
            rotatesWhenExpands: true,
            disablesInteraction: true,
            sideMenuWidth: 240,
            cornerRadius: 48,
            showMenu: $showMenu
        ) { safeArea in
            NavigationStack {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                    }
                    Text("Tutorial by Kavsoft")
                        .bold()
                        .fontWidth(.expanded)
                        .shadow(color: .purple, radius: 8, y: 8)
                    Spacer()
                    NavigationLink("Detail View") {
                        Text("Detail View")
                    }
                    Spacer()
                }
                //                    .padding(.top, safeArea.top * 2)
                .navigationTitle("Home")
                .toolbarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            showMenu.toggle()
                        } label: {
                            Image(systemName: showMenu ? "xmark" : "line.3.horizontal")
                                .foregroundStyle(.jSeco)
                                .contentTransition(.symbolEffect)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Go Back") {
                            dismiss()
                        }
                    }
                }
            }
            .background(.jPrime.opacity(0.9))
            
        } menuView: { safeArea in
            SideBarMenuView(safeArea)
        } background: {
            Image("image1").resizable().scaledToFill()
                .overlay {
                    Rectangle().opacity(0.53)
                }
        }
    }
    // MARK: - View Properties
    @State private var showMenu: Bool = false
    
    // MARK: - SideBarMenuView
    @ViewBuilder
    private func SideBarMenuView(_ safeArea: UIEdgeInsets) -> some View {
        VStack(alignment: .leading) {
            Text("Side Menu")
                .font(.largeTitle.bold())
                .padding(.bottom)
            
            SideBarButton(.home)
            SideBarButton(.bookmark)
            SideBarButton(.favorites)
            SideBarButton(.profile)
            
            Spacer(minLength: 0)
            
            SideBarButton(.logout)
        }
        .foregroundStyle(.jSeco)
        .padding(.horizontal)
        .padding(.vertical)
        .padding(.top, safeArea.top)
        .padding(.bottom, safeArea.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        // MARK: - DarkScheme
        .environment(\.colorScheme, .dark)
    }
    
    // MARK: - Side Bar Button
    @ViewBuilder
    private func SideBarButton(_ tab: SampleTab, onTap: @escaping () -> () = { }) -> some View {
        Button(action: { }, label: {
            HStack {
                Text(tab.title)
                    .font(.callout)
                
                Spacer(minLength: 0)
                
                Image(systemName: tab.rawValue)
                    .font(.title3)
                    .frame(width: 40)
            }
            .padding(.vertical)
            .contentShape(.rect)
            .foregroundStyle(tab.color)
        })
    }
    
    // MARK: - Sample Tab's
    enum SampleTab: String, CaseIterable {
        case home = "house.lodge.fill"
        case bookmark = "book"
        case favorites = "heart.fill"
        case profile = "person.crop.circle"
        case logout = "rectangle.portrait.and.arrow.forward"
        
        var title: String {
            switch self {
            case .home: return "Home"
            case .bookmark: return "Bookmark"
            case .favorites: return "Favorites"
            case .profile: return "Profile"
            case .logout: return "Logout"
            }
        }
        
        var color: Color {
            switch self {
            case .home: return .blue
            case .bookmark: return .yellow
            case .favorites: return .red
            case .profile: return .green
            case .logout: return .red
            }
        }
    }
}

// MARK: - Custom Animated SideBar
struct CustomAnimatedSideBar<Content: View, MenuView: View, Background: View>: View {
    /// Customization Options
    var rotatesWhenExpands: Bool = true
    var disablesInteraction: Bool = true
    var sideMenuWidth: CGFloat = 200
    var cornerRadius: CGFloat = 35
    @Binding var showMenu: Bool
    @ViewBuilder var content: (UIEdgeInsets) -> Content
    @ViewBuilder var menuView: (UIEdgeInsets) -> MenuView
    @ViewBuilder var background: Background
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets ?? .zero
            
            HStack(spacing: 0) {
                GeometryReader { _ in
                    menuView(safeArea)
                }
                .frame(width: sideMenuWidth)
                // MARK: - Clipping Menu Interaction Beyond it's Width
                .contentShape(.rect)
                
                GeometryReader { _ in
                    content(safeArea)
                }
                .frame(width: size.width)
                .overlay {
                    if disablesInteraction && progress > 0.5 {
                        Rectangle()
                            .fill(.black.opacity(progress * 0.2))
                            .onTapGesture {
                                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                                    reset()
                                }
                            }
                    }
                }
                .mask {
                    RoundedRectangle(cornerRadius: (progress * cornerRadius))
                }
                .scaleEffect(
                    rotatesWhenExpands ? 1 - (progress * 0.1) : 1,
                    anchor: .trailing)
                .rotation3DEffect(
                    .init(degrees: rotatesWhenExpands ? (progress * -15) : 0),
                    axis: (x: 0, y: 1, z: 0))
            }
            .frame(width: size.width + sideMenuWidth, height: size.height)
            .offset(x: -sideMenuWidth)
            .offset(x: offsetX)
            .contentShape(.rect)
            /// Use simultaneousGesture over gesture to avoid a slightly delay when dragging the content view
            .simultaneousGesture(dragGesture)
        }
        .background(background)
        .ignoresSafeArea()
        .onChange(of: showMenu, initial: true) { oldValue, newValue in
            withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                if newValue {
                    showSideBar()
                } else {
                    reset()
                }
            }
        }
    }
    // MARK: - View Properties
    @GestureState private var isDragging: Bool = false
    @State private var offsetX: CGFloat = 0
    @State private var lastOffsetX: CGFloat = 0
    /// Used to dim ContentView when SideBar is beeing dragged
    @State private var progress: CGFloat = 0
    
    // MARK: - DragGesture
    private var dragGesture: some Gesture {
        DragGesture()
            .updating($isDragging) { _, out, _ in
                out = true
            }.onChanged { value in
                guard value.startLocation.x > 10 else { return }
                /// This will limit the translation value from 0 to the side bar width, Thus, it will avoid over dragging the menu view
                let translationX = isDragging ? max(min(value.translation.width + lastOffsetX, sideMenuWidth), 0) : 0
                offsetX = translationX
                calculateProgress()
            }.onEnded { value in
                guard value.startLocation.x > 10 else { return }
                
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    /// How far you have to scroll till it stays
                    let velocityX = value.velocity.width / 8
                    let total = velocityX + offsetX
                    
                    if total > (sideMenuWidth * 0.6) {
                        showSideBar()
                    } else {
                        reset()
                    }
                }
            }
    }
    
    // MARK: - Show's Side Bar
    private func showSideBar() {
        offsetX = sideMenuWidth
        lastOffsetX = offsetX
        showMenu = true
        calculateProgress()
    }
    
    // MARK: - Reset's to it's Initial State
    private func reset() {
        offsetX = 0
        lastOffsetX = 0
        showMenu = false
        calculateProgress()
    }
    
    // MARK: - Convert's Offset into Series of progress ranging from 0 - 1
    private func calculateProgress() {
        progress = max(min(offsetX / sideMenuWidth, 1), 0)
    }
}

#Preview {
    //    NavigationStack {
    AnimatedSideBar()
    //    }
}
