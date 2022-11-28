//
// Created by Shaban on 10/11/2022.
//

import SwiftUI

struct Dialog: ViewModifier {
    @Binding var isPresented: Bool
    let dismissOnTouchOutside: Bool
    let dialogContent: () -> AnyView?

    @State private var animate = false
    @State private var scaleAmount = amount

    private static var amount: Double {
        #if os(macOS)
        return 0.95
        #else
        return 1.05
        #endif
    }

    func body(content: Content) -> some View {
        ZStack {
            content
            if isPresented {
                ContentView()
            }
        }
    }

    private func ContentView() -> some View {
        Group {
            Rectangle()
                    .foregroundColor(.black.opacity(0.2))
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        guard dismissOnTouchOutside else {
                            return
                        }
                        isPresented = false
                    }
                    .opacity(animate ? 1.0 : 0.0)
            dialogContent()?
                    .background(Color.clear.shadow(color: Color(UIColor.gray), radius: 20))
                    .scaleEffect(scaleAmount)
                    .animation(Animation.easeInOut(duration: 0.2), value: scaleAmount)
        }
                .onAppear {
                    animateBackground(isUp: true)
                }
                .onDisappear {
                    animateBackground(isUp: false)
                }
    }

    private func animateBackground(isUp: Bool) {
        withAnimation(Animation.spring().speed(2)) {
            animate = isUp
            scaleAmount = isUp ? 1 : Self.amount
        }
    }

}

extension View {
    func dialog(
            isPresented: Binding<Bool>,
            dismissOnTouchOutside: Bool,
            @ViewBuilder dialogContent: @escaping () -> AnyView?
    ) -> some View {
        modifier(Dialog(isPresented: isPresented,
                dismissOnTouchOutside: dismissOnTouchOutside,
                dialogContent: dialogContent)
        )
    }
}