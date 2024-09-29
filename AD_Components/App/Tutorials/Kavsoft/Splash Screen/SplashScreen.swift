//
//  SplashScreen.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 29.09.24.
//

/// Tutorial by Kavsoft: https://www.youtube.com/watch?v=hgNYPws1vE0

import SwiftUI

struct SplashScreenContentView: View {
    /// is only working, when this is the RootView (ContentView)
    @State var showSplashScreen: Bool = true
    var body: some View {
        ZStack {
            if showSplashScreen {
                SplashScreen()
                    .transition(CustomSplashTransition3D(isRoot: false))
            } else {
                InteractiveFloatingButton()
                    .transition(CustomSplashTransitionPullUp(isRoot: true))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.jPrime)
        .ignoresSafeArea()
        .task {
            guard showSplashScreen else { return }
            try? await Task.sleep(for: .seconds(0.5))
            withAnimation(.smooth(duration: 0.55)) {
                showSplashScreen = false
            }
        }
    }
    
    var safeArea: UIEdgeInsets {
        if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets {
            return safeArea
        }
        
        return .zero
    }
}

struct CustomSplashTransitionPullUp: Transition {
    var isRoot: Bool
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .offset(y: phase.isIdentity ? 0 : isRoot ? screenSize.height : -screenSize.height)
    }
    
    var screenSize: CGSize {
        if let screenSize = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
            return screenSize
        }
        
        return .zero
    }
}

struct CustomSplashTransition3D: Transition {
    var isRoot: Bool
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .rotation3DEffect(
                .init(
                    degrees: phase.isIdentity ? 0 : isRoot ? 90 : -90
                ),
                axis: (
                    x: 0,
                    y: 1,
                    z: 0
                ),
                anchor: isRoot ? .leading : .trailing)
            .offset(x: phase.isIdentity ? 0 : isRoot ? screenSize.width : -screenSize.width)
    }
    
    var screenSize: CGSize {
        if let screenSize = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
            return screenSize
        }
        
        return .zero
    }
}

struct SplashScreen: View {
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.jGreen)
            Image("LogoIcon")
                .resizable()
                .scaledToFit()
        }
    }
}

#Preview {
    SplashScreen()
}
