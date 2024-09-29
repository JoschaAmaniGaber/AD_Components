//
//  FloatingSheet.swift
//  AD_Components
//
//  Created by Joscha Amani Gaber on 28.09.24.
//

///  Tutorial by Kavsoft: https://www.youtube.com/watch?v=gxOqwo7bZYE

import SwiftUI

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

fileprivate extension UIView {
    var viewBeforeWindow: UIView? {
        if let superview, superview is UIWindow {
            return self
        }
        
        return superview?.viewBeforeWindow
    }
}
