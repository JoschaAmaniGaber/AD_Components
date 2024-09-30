import SwiftUI

// Remember to download FontSettings.swift

struct WWDC24AnimatedTextView: View {
    var text = "Hello, World!"
    var animation: Animation = .easeInOut
    var targetFontSize: CGFloat = 40
    var minimumFontSize: CGFloat = 30
    var targetFontWeight: Font.Weight = .semibold
    var minimumFontWeight: Font.Weight = .ultraLight
    var targetFontWidth: Font.Width = .expanded
    var minimumFontWidth: Font.Width = .compressed
    var delayBetweenSwitch: Double = 3
    var delayBetweenCharacter: Double = 2
    
    var toggle: Bool = false // Animation is triggered when this value is changed
    
    @StateObject private var fontSettings: FontSettings // Uses the FontSettings class
    
    init(_ text: String, toggle: Bool, animation: Animation = .easeInOut, targetFontSize: CGFloat = 40, minimumFontSize: CGFloat = 30, targetFontWeight: Font.Weight = .semibold, minimumFontWeight: Font.Weight = .ultraLight, targetFontWidth: Font.Width = .expanded, minimumFontWidth: Font.Width = .compressed, delayBetweenSwitch: Double = 3, delayBetweenCharacter: Double = 2) {
        self.text = text
        self.toggle = toggle
        self.animation = animation
        self.targetFontSize = targetFontSize
        self.minimumFontSize = minimumFontSize
        self.targetFontWeight = targetFontWeight
        self.minimumFontWeight = minimumFontWeight
        self.targetFontWidth = targetFontWidth
        self.minimumFontWidth = minimumFontWidth
        self.delayBetweenSwitch = delayBetweenSwitch
        self.delayBetweenCharacter = delayBetweenCharacter
        _fontSettings = StateObject(wrappedValue: FontSettings(text: text, targetFontSize: targetFontSize, targetFontWeight: targetFontWeight, targetFontWidth: targetFontWidth))
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(characterIndices(text: text), id: \.index) { item in
                    Text(item.character)
                        .font(.system(size: fontSettings.fontSizes[item.index]))
                        .fontWidth(fontSettings.fontWidths[item.index])
                        .fontWeight(fontSettings.fontWeights[item.index])
                }
                .geometryGroup() // Make sure the characters are aligned when animation is playing
            }
        }
        .onChange(of: toggle) {
            toggleWholeAnimation()
        }
    }
    
    // Helper function to get characters and their indices
    func characterIndices(text: String) -> [(character: String, index: Int)] {
        var result: [(character: String, index: Int)] = []
        for (index, character) in text.enumerated() {
            result.append((String(character), index))
        }
        return result
    }
    
    // Whole bold-thin-bold animation toggle
    func toggleWholeAnimation() {
        Task {
            // First part of animation, the text will go thinner
            toggleAnimation()
            
            // Delay between two animations
            try? await Task.sleep(nanoseconds: 0_100_000_000 * UInt64(delayBetweenSwitch))
            
            // Second part of animation, the text will go to the original state
            toggleAnimation()
        }
    }
    
    // Toggle text to the opposite state
    func toggleAnimation() {
        Task {
            for index in fontSettings.fontWidths.indices {
                // Delay between each character
                try? await Task.sleep(nanoseconds: 0_100_000_000 * UInt64(delayBetweenCharacter) / UInt64(text.count))
                
                // Make text size, width and weight to the opposite
                withAnimation(animation) {
                    fontSettings.fontSizes[index] = fontSettings.fontSizes[index] == minimumFontSize ? targetFontSize : minimumFontSize
                    fontSettings.fontWidths[index] = fontSettings.fontWidths[index] == minimumFontWidth ? targetFontWidth : minimumFontWidth
                    fontSettings.fontWeights[index] = fontSettings.fontWeights[index] == minimumFontWeight ? targetFontWeight : minimumFontWeight
                }
            }
        }
    }
}

// MARK: - FontSettings

/// A class to manage font settings for a given text, including font sizes, weights, and widths for each character.
class FontSettings: ObservableObject {
    @Published var fontSizes: [CGFloat] // Stores the font size for each character
    @Published var fontWeights: [Font.Weight] // Stores the font weight for each character
    @Published var fontWidths: [Font.Width] // Stores the font width for each character

    init(text: String, targetFontSize: CGFloat, targetFontWeight: Font.Weight, targetFontWidth: Font.Width) {
        // Initializes the font size, weight, and width for each character
        self.fontSizes = Array(repeating: targetFontSize, count: 100)
        self.fontWeights = Array(repeating: targetFontWeight, count: 100)
        self.fontWidths = Array(repeating: targetFontWidth, count: 100)
    }
}

// MARK: - Preview
// Preview with parameter controls
#Preview("WWDC24AnimatedText") {
    @Previewable @State var text = "HELLO WORLD!"
    
    // Animation parameters
    @Previewable @State var animation: Animation = .bouncy
    @Previewable @State var targetFontSize: CGFloat = 30
    @Previewable @State var minimumFontSize: CGFloat = 30
    @Previewable @State var targetFontWeight: Font.Weight = .semibold
    @Previewable @State var minimumFontWeight: Font.Weight = .ultraLight
    @Previewable @State var targetFontWidth: Font.Width = .expanded
    @Previewable @State var minimumFontWidth: Font.Width = .compressed
    @Previewable @State var delayBetweenSwitch: Double = 3
    @Previewable @State var delayBetweenCharacter: Double = 2
    
    // Trigger the animation
    @Previewable @State var toggle = true
    
    ZStack {
        WWDC24AnimatedTextView(text, toggle: toggle, animation: animation, targetFontSize: targetFontSize, minimumFontSize: minimumFontSize, targetFontWeight: targetFontWeight, minimumFontWeight: minimumFontWeight, targetFontWidth: targetFontWidth, minimumFontWidth: minimumFontWidth, delayBetweenSwitch: delayBetweenSwitch, delayBetweenCharacter: delayBetweenCharacter)
        
        VStack {
            Spacer()
            Button("Toggle") {
                toggle.toggle()
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(height: .infinity)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    
    List {
        VStack(alignment: .leading) {
            Label("Target Font Size: \(targetFontSize.formatted())", systemImage: "textformat.size.larger")
            Slider(value: $targetFontSize, in: CGFloat(30)...CGFloat(60), step: 5)
        }
        
        VStack(alignment: .leading) {
            Label("Minimum Font Size: \(minimumFontSize.formatted())", systemImage: "textformat.size.smaller")
            Slider(value: $minimumFontSize, in: CGFloat(0)...CGFloat(60), step: 5)
        }
        
        HStack {
            Label("Animation", systemImage: "cursorarrow.motionlines")
            Spacer()
            Picker("Animation", selection: $animation) {
                Text("None")
                    .tag(Animation.linear(duration: 0))
                
                Text("Linear")
                    .tag(Animation.linear)
                
                Text("Ease-In")
                    .tag(Animation.easeIn)
                
                Text("Ease-Out")
                    .tag(Animation.easeOut)
                
                Text("Ease-In-Out")
                    .tag(Animation.easeInOut)
                
                Text("Bouncy")
                    .tag(Animation.bouncy)
                
                Text("Snappy")
                    .tag(Animation.snappy)
                
                Text("Smooth")
                    .tag(Animation.smooth)
                
                Text("Spring")
                    .tag(Animation.spring)
                
                Text("Interactive Spring")
                    .tag(Animation.interactiveSpring)
                
                Text("Interpolating Spring")
                    .tag(Animation.interpolatingSpring)
            }
            .labelsHidden()
        }
        
        HStack {
            Label("Target Font Weight", systemImage: "circle.fill")
            Spacer()
            Picker("Target Font Weight", selection: $targetFontWeight) {
                Text("Heavy")
                    .tag(Font.Weight.heavy)
                
                Text("Black")
                    .tag(Font.Weight.semibold)
                
                Text("Bold")
                    .tag(Font.Weight.semibold)
                
                Text("Semibold")
                    .tag(Font.Weight.semibold)
                
                Text("Medium")
                    .tag(Font.Weight.medium)
                
                Text("Regular")
                    .tag(Font.Weight.regular)
                
                Text("Thin")
                    .tag(Font.Weight.thin)
                
                Text("Ultralight")
                    .tag(Font.Weight.ultraLight)
            }
            .labelsHidden()
        }
        
        HStack {
            Label("Minimum Font Weight", systemImage: "circle")
            Spacer()
            Picker("Minimum Font Weight", selection: $minimumFontWeight) {
                Text("Heavy")
                    .tag(Font.Weight.heavy)
                
                Text("Black")
                    .tag(Font.Weight.semibold)
                
                Text("Bold")
                    .tag(Font.Weight.semibold)
                
                Text("Semibold")
                    .tag(Font.Weight.semibold)
                
                Text("Medium")
                    .tag(Font.Weight.medium)
                
                Text("Regular")
                    .tag(Font.Weight.regular)
                
                Text("Thin")
                    .tag(Font.Weight.thin)
                
                Text("Ultralight")
                    .tag(Font.Weight.ultraLight)
            }
            .labelsHidden()
        }
        
        HStack {
            Label("Target Font Width", systemImage: "rectangle.portrait.arrowtriangle.2.outward")
            Spacer()
            Picker("Target Font Width", selection: $targetFontWidth) {
                Text("Expanded")
                    .tag(Font.Width.expanded)
                
                Text("Standard")
                    .tag(Font.Width.standard)
                
                Text("Condensed")
                    .tag(Font.Width.condensed)
                
                Text("Compressed")
                    .tag(Font.Width.compressed)
            }
            .labelsHidden()
        }
        
        HStack {
            Label("Minimum Font Width", systemImage: "rectangle.portrait.arrowtriangle.2.inward")
            Spacer()
            Picker("Minimum Font Width", selection: $minimumFontWidth) {
                Text("Expanded")
                    .tag(Font.Width.expanded)
                
                Text("Standard")
                    .tag(Font.Width.standard)
                
                Text("Condensed")
                    .tag(Font.Width.condensed)
                
                Text("Compressed")
                    .tag(Font.Width.compressed)
            }
            .labelsHidden()
        }
        
        HStack {
            Label("Delay Between Switch: \(delayBetweenSwitch.formatted())", systemImage: "circle")
            Slider(value: $delayBetweenSwitch, in: 1...5, step: 1)
        }
        
        HStack {
            Label("Delay Between Character: \(delayBetweenCharacter.formatted())", systemImage: "circle")
            Slider(value: $delayBetweenCharacter, in: 1...5, step: 1)
        }
    }
}
