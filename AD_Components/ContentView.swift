//
//  ContentView.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 25.09.24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        FloatingSheetScreen()
        Text("Tutorial by Kavsoft")
            .shadow(color: .purple, radius: 3)
            .bold()
            .fontWidth(.expanded)
    }
}

#Preview {
    ContentView()
}
