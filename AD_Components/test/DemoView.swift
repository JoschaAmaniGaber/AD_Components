//
//  Test.swift
//  Tests_App_Navigation
//
//  Created by Joscha Amani Gaber on 12.10.24.
//

import SwiftUI

struct DemoView: View {
    
    let size: CGPoint = CGPoint(x: 300, y: 200)
    
    var shader: Shader {
        let shaderLibrary = ShaderLibrary.default
        return Shader(function: ShaderFunction(library: shaderLibrary, name: "demoShader"), arguments: [.float2(self.size)])
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
            Text("Hello, distortionEffect!")
        }
        .frame(width: size.x, height: size.y)
        .background(Color.blue.opacity(0.1))
        .distortionEffect(self.shader, maxSampleOffset: CGSize(width: 500, height: 500))
        .overlay(Rectangle().stroke(Color.blue)) // adding stroke so we see bounds of our view
    }
}

struct ShiftTransitionModifier: ViewModifier {
    let size: CGPoint = CGPoint(x: 300, y: 200)
    var effectValue: CGFloat = 0
    
    var shader: Shader {
        let shaderLibrary = ShaderLibrary.default
        return Shader(function: ShaderFunction(library: shaderLibrary, name: "demoShader"), arguments: [.float2(self.size), .float(self.effectValue)])
    }
    
    func body(content: Content) -> some View {
        content
            .frame(width: self.size.x, height: self.size.y)
            .distortionEffect(self.shader, maxSampleOffset: CGSize(width: 500, height: 500))
    }
}

#Preview {
    DemoView()
}
