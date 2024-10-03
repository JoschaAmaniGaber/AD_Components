//
//  FloatingSheetScreen.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 28.09.24.
//

///  Tutorial by Kavsoft: https://www.youtube.com/watch?v=gxOqwo7bZYE

import SwiftUI

struct FloatingSheetScreen: View {
    var body: some View {
        NavigationStack {
            VStack {
                Button("Show Sheet") {
                    showSheet.toggle()
                }
            }
            .navigationTitle("Floating Bottom Sheet")
        }
        .floatingBottomSheet(isPresented: $showSheet) {
            /** SampleView
             SheetView(
                title: "Replace Existing Folder",
                content: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod t.",
                image: .init(
                    content: "questionmark.folder.fill",
                    tint: .blue,
                    foregroundColor: .jWhite
                ),
                button1: .init(
                    content: "Replace",
                    tint: .blue,
                    foregroundColor: .jWhite
                ),
                button2: .init(
                    content: "Cancel",
                    tint: Color.red,
                    foregroundColor: Color.jWhite
                )
             )
             */
            Text("Hello, World!")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.background.shadow(.drop(radius: 8)), in: .rect(cornerRadius: 35))
                .padding(.horizontal)
                .padding(.top)
                .presentationDetents([.height(100), .height(336), .fraction(0.999)]) /// .large is not working
            .presentationBackgroundInteraction(.enabled(upThrough: .height(336)))
        }
    }
    @State private var showSheet: Bool = false
}

#Preview {
    FloatingSheetScreen()
}

// MARK: - ViewExtension Floating Bottom Sheet
extension View {
    // TODO: Understand for what @ViewBuilder is & the rest of this function
    @ViewBuilder
    func floatingBottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        onDismiss: @escaping () -> () = { },
        @ViewBuilder
        content: @escaping () -> Content) -> some View {
            self
                .sheet(isPresented: isPresented, onDismiss: onDismiss) {
                    content()
                        .presentationCornerRadius(21)
                        .presentationBackground(.clear)
                        .presentationDragIndicator(.hidden)
                        .background(SheetShadowRemover())
                }
    }
}

// MARK: - SheetShadowRemover
fileprivate struct SheetShadowRemover: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let uiSheetView = view.viewBeforeWindow {
                for view in uiSheetView.subviews {
                    view.layer.shadowColor = UIColor.clear.cgColor
                }
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}

// MARK: - UIView Extension
fileprivate extension UIView {
    var viewBeforeWindow: UIView? {
        if let superview, superview is UIWindow {
            return self
        }
        
        return superview?.viewBeforeWindow
    }
}

// MARK: - Sample View
struct SheetView: View {
    var title: String
    var content: String
    var image: Config
    var button1: Config
    var button2: Config?
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: image.content)
                .font(.title)
                .foregroundStyle(image.foregroundColor)
                .frame(width: 65, height: 65)
                .background(image.tint.gradient, in: .circle)
            
            Text(title)
                .font(.title3.bold())
            
            Text(content)
                .font(.callout)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .foregroundStyle(.gray)
            
            ButtonView(button1)
            
            if let button2 {
                ButtonView(button2)
            }
        }
        .padding([.horizontal, .bottom], 16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(.background)
                .padding(.top, 32)
        }
        .shadow(color: .jSeco.opacity(0.08), radius: 8)
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    func ButtonView(_ config: Config) -> some View {
        Button {
            
        } label: {
            Text(config.content)
                .fontWeight(.bold)
                .foregroundStyle(config.foregroundColor)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(config.tint.gradient, in: .rect(cornerRadius: 10))
        }

    }
    
    struct Config {
        var content: String
        var tint: Color
        var foregroundColor: Color
    }
}
