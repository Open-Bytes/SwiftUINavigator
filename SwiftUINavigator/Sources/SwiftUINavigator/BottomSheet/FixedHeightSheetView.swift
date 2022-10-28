//
// Created by Shaban on 25/05/2022.
//

import SwiftUI

#if os(iOS)
struct FixedHeightSheetView<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode
    private var content: Content
    private let isDismissable: Bool
    private let presenter: FixedSheetPresenter
    @State private var isContentVisible: Bool = false

    init(presenter: FixedSheetPresenter, isDismissable: Bool, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.presenter = presenter
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
                            presenter.controller?.dismiss(animated: false)
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


func presentSheetController<Content: View>(
        presenter: FixedSheetPresenter,
        isDismissable: Bool,
        content: Content) {
    let view = FixedHeightSheetView(presenter: presenter, isDismissable: isDismissable) {
        content
    }
    let controller = SheetController(rootView: view)
    presenter.controller?.present(controller, animated: false)
}
#endif
