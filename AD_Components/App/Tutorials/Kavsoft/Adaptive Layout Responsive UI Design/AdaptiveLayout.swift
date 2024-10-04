//
//  AdaptiveLayout.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 03.10.24.
//

/// Tutorial by Kavsoft: https://www.youtube.com/watch?v=zmwFgkP4KhM
import SwiftUI

// MARK: - Home
struct Home_AL: View {
    var body: some View {
        AdaptiveView { size, isLandsacpe in
            //            if panGesture == nil { panGesture = gesture }
            let sideBarWidth: CGFloat = isLandsacpe ? 240 : 260
            let layout = isLandsacpe ? AnyLayout(HStackLayout(spacing: 0)) : AnyLayout(ZStackLayout(alignment: .leading))
            
            NavigationStack(path: $navigationPath) {
                layout {
                    SideBarView_AL(path: $navigationPath) {
                        toggleSideBar()
                    }
                    .frame(width: sideBarWidth)
                    .offset(x: isLandsacpe ? 0 : -sideBarWidth)
                    .offset(x: isLandsacpe ? 0 : offset)
                    
                    TabView(selection: $activeTab) {
                        Tab(TabState.home.rawValue, systemImage: TabState.home.symbolImage, value: .home) {
                            Text("Home")
                        }
                        
                        Tab(TabState.search.rawValue, systemImage: TabState.search.symbolImage, value: .search) {
                            Text("Search")
                        }
                        
                        Tab(TabState.notifications.rawValue, systemImage: TabState.notifications.symbolImage, value: .notifications) {
                            Text("Notifications")
                        }
                        
                        Tab(TabState.profile.rawValue, systemImage: TabState.profile.symbolImage, value: .profile) {
                            Text("Profile")
                        }
                    }
                    .tabViewStyle(.tabBarOnly)
                    .overlay {
                        Rectangle()
                            .fill(.jSeco.opacity(0.25))
                            .ignoresSafeArea()
                            .opacity(isLandsacpe ? 0 : progress)
                    }
                    .offset(x: isLandsacpe ? 0 : offset)
                }
                .gesture(
                    CustomGesture(isEnabled: !isLandsacpe) { gesture in
                        let state = gesture.state
                        let translation = gesture.translation(in: gesture.view).x + lastDragOffset
                        let velocity = gesture.velocity(in: gesture.view).x
                        
                        if state == .began || state == .changed {
                            /// onChanged
                            offset = max(min(translation, sideBarWidth), 0)
                            /// Storing Drag Progress, for fading tab view when dragging
                            progress = max(min(offset / sideBarWidth, 1), 0)
                        } else {
                            /// onEnded
                            withAnimation(.snappy(duration: 0.5, extraBounce: 0)) {
                                if (velocity + offset) > (sideBarWidth * 0.6) {
                                    /// Expand Fully
                                    offset = sideBarWidth
                                    progress = 1
                                } else {
                                    /// Reset to zero
                                    offset = 0
                                    progress = 0
                                }
                                
                                /// Saving last DragOffset
                                lastDragOffset = offset
                            }
                        }
                    }
                )
                .navigationDestination(for: String.self) { value in
                    Text("Hello, This is Detail \(value) View")
                        .navigationTitle(value)
                }
            }
           /*             .gesture(DragGesture()
                            .onChanged { value in
                                let translation = value.translation.width + lastDragOffset
                                offset = max(min(translation, sideBarWidth), 0)
                                /// Storing Drag Progress, for fading tab view when dragging
                                progress = max(min(offset / sideBarWidth, 1), 0)
                            } .onEnded { value in
                                let velocity = value.velocity.width / 3
            
                                withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                                    if (velocity + offset) > (sideBarWidth * 0.5) {
                                        /// Expand Fully
                                        offset = sideBarWidth
                                        progress = 1
                                    } else {
                                        /// Reset to zero
                                        offset = 0
                                        progress = 0
                                    }
            
                                    /// Saving last DragOffset
                                    lastDragOffset = offset
                                }
                            }
                        ) */
        }
    }
    // MARK: - View Properties
    @State private var activeTab: TabState = .home
    
    // MARK: - Gesture Properties
    @State private var offset: CGFloat = 0
    @State private var lastDragOffset: CGFloat = 0
    @State private var progress: CGFloat = 0
    
    // MARK: - NavigationPath
    @State private var navigationPath: NavigationPath = .init()
    
    @State private var panGesture: UIPanGestureRecognizer?
    
    private func toggleSideBar() {
        withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
            progress = 0
            offset = 0
            lastDragOffset = 0
        }
    }
}

// MARK: - Tabs
enum TabState: String, CaseIterable {
    case home = "Home"
    case search = "Search"
    case notifications = "Notifications"
    case profile = "Profile"
    
    var symbolImage: String {
        switch self {
        case .home: return "house.lodge"
        case .search: return "magnifyingglass"
        case .notifications: return "bell"
        case .profile: return "person.crop.circle"
        }
    }
}


// MARK: - SideBarView
struct SideBarView_AL: View {
    @Binding var path: NavigationPath
    var toogleSideBar: () -> ()
    var body: some View {
        GeometryReader {
            let safeArea = $0.safeAreaInsets
            let isSidesHavingValues = safeArea.leading != 0 || safeArea.trailing != 0
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 8) {
                    Image(.image1)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 60, height: 60)
                        .clipShape(.circle)
                    
                    Text("Amani Dunia Apps")
                        .font(.callout)
                        .fontWeight(.semibold)
                    
                    Text("@AmaniDuniaApps")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 4) {
                        Text("x.xX")
                            .fontWeight(.semibold)
                        
                        Text("Following")
                            .font(.caption)
                            .foregroundStyle(.gray)
                        
                        Text("x.xX")
                            .fontWeight(.semibold)
                            .padding(.leading, 4)
                        
                        Text("Followers")
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    .font(.callout)
                    .lineLimit(1)
                    .padding(.top, 8)
                    
                    // MARK: - Side Bar Navigation Items
                    VStack(alignment: .leading, spacing: 24) {
                        ForEach(SideBarAction.allCases, id: \.rawValue) { action in
                            SideBarActionButton(value: action) {
                                toogleSideBar()
                                path.append(action.rawValue)
                            }
                        }
                    }
                    .padding(.top, 24)
                }
                .padding(.vertical)
                .padding(.horizontal, isSidesHavingValues ? 0 : 16)
            }
            .scrollClipDisabled()
            .scrollIndicators(.hidden)
            .background {
                Rectangle()
                    .fill(.background)
                    .overlay(alignment: .trailing) {
                        Rectangle()
                            .fill(.gray.opacity(0.35))
                            .frame(width: 4)
                    }
                    .ignoresSafeArea()
            }
        }
    }
    // MARK: - SideBarActionButton
    @ViewBuilder
    private func SideBarActionButton(value: SideBarAction, action: @escaping () -> () ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: value.symbolImage)
                    .font(.title3)
                    .frame(width: 48)
                
                Text(value.rawValue)
                    .fontWeight(.semibold)
                
                Spacer(minLength: 0)
            }
        }
        .foregroundStyle(.red)
        .padding(.vertical, 8)
        .contentShape(.rect)
    }
    
    
}

// MARK: - Side Bar Actions
enum SideBarAction: String, CaseIterable {
    case communities = "Communities"
    case bookmarks = "Bookmarks"
    case lists = "Lists"
    case messages = "Messages"
    case monetization = "Monetization"
    case settings = "Settings"
    
    var symbolImage: String {
        switch self {
        case .communities: return "person.3"
        case .bookmarks: return "bookmark"
        case .lists: return "list.bullet.clipboard"
        case .messages: return "message.badge.waveform"
        case .monetization: return "banknote"
        case .settings: return "gearshape"
        }
    }
}

// MARK: - Custom Gesture
struct CustomGesture: UIGestureRecognizerRepresentable {
    var isEnabled: Bool
    var handle: (UIPanGestureRecognizer) -> ()
    
    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer()
        return gesture
    }
    
    func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
        recognizer.isEnabled = isEnabled
    }
    
    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        handle(recognizer)
    }
}

// MARK: - AdaptiveView
struct AdaptiveView<Content: View>: View {
    var showsSideBarOniPadPortrait: Bool = true
    @ViewBuilder var content: (CGSize, Bool) -> Content
    @Environment(\.horizontalSizeClass) var hClass
    var body: some View {
        GeometryReader {
            let size = $0.size
            let isLandscape = size.width > size.height || (hClass == .regular && showsSideBarOniPadPortrait)
            
            content(size, isLandscape)
        }
    }
}

#Preview {
    Home_AL()
}
