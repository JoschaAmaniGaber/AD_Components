//
//  ContentView.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 25.09.24.
//



import SwiftUI

struct ContentView: View {
    @State var showSplashScreen: Bool = true
    var body: some View {
        ZStack {
            if showSplashScreen {
                SplashScreen()
                    .transition(CustomSplashTransition3D(isRoot: false)) 
            } else {
                NavigationStack {
                    AllTutorials()  
                }
                .transition(CustomSplashTransition3D(isRoot: true))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.jPrime)
        .ignoresSafeArea()
        .task {
            guard showSplashScreen else { return }
            try? await Task.sleep(for: .seconds(1.8))
            withAnimation(.smooth(duration: 2.8)) {
                showSplashScreen = false 
            }
        }
    }
    
    /// Only needed when not using NavigationStack or TabView
    private var safeArea: UIEdgeInsets {
        if let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets {
            return safeArea
        }
        
        return .zero
    }
}

#Preview {
    ContentView()
}
