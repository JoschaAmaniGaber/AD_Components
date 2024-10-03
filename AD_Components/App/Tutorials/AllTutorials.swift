//
//  File.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 03.10.24.
//

import SwiftUI

struct AllTutorials: View {
    var body: some View {
        List {
            ForEach(WhoDidIt.allCases) { who in
                Section(header: Text(who.rawValue)) {
                    who.tutorials
                    
                }
                .foregroundStyle(who.color.gradient)
            }
        }
        .navigationTitle("All Tutorials")
    }
}

#Preview {
    NavigationStack {
        AllTutorials()
    }
    .fontWidth(.expanded)
}

enum WhoDidIt: String, CaseIterable, Identifiable {
    var id: Self { self }
    
    case designCode = "Design Code"
    case kavsoft = "Kavsoft"
    case everythingSwiftUI = "Everything SwiftUI"
    case swiftOdyssey = "Swift Odyssey"
    
    var color: Color {
        switch self {
        case .designCode: .indigo
        case .kavsoft: .purple
        case .everythingSwiftUI: .mint
        case .swiftOdyssey: .orange
        }
    }
    @ViewBuilder
    var tutorials: some View {
        switch self {
        case .designCode:
            DesignCodeTutorials().foregroundStyle(color.gradient)
        case .kavsoft:
            KavsoftsTutorials().foregroundStyle(color.gradient)
        case .everythingSwiftUI:
            NavigationLink(destination: CircularScrollWheelPicker()) {
                Text("Circular Scroll Wheel Picker")
                    .foregroundStyle(color.gradient)
            }
        case .swiftOdyssey:
            NavigationLink(destination: IsometricAnimation()) {
            Text("Isomteric Animation")
                .foregroundStyle(color.gradient)
            }
        default : Text("Empty").foregroundStyle(color.gradient)
        }
    }
}
