//
// Created by Shaban on 25/05/2022.
//

import SwiftUI

#if os(iOS)
struct FixedHeightSheetView<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode
    private var content: Content
    private let isDismissable: Bool
    @State private var isContentVisible: Bool = false

    init(isDismissable: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.isDismissable = isDismissable
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            if isContentVisible {
                Color.black.opacity(0.0001)
                        .onTapGesture {
                            guard isDismissable else {
                                return
                            }
                            UIApplication.shared.topController?.dismiss(animated: false)
                        }
                        .animation(.easeInOut)
                content.transition(.move(edge: .bottom))
            }
        }
                .edgesIgnoringSafeArea(.bottom)
                .onAppear {
                    withAnimation {
                        isContentVisible = true
                    }
                }
    }
}


func presentSheetController<Content: View>(isDismissable: Bool, content: Content) {
    let view = FixedHeightSheetView(isDismissable: isDismissable) {
        content
    }
    let controller = SheetController(rootView: view)
    UIApplication.shared.topController?.present(controller, animated: false)
}
#endif
