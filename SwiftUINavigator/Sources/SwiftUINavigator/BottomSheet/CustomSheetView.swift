//
// Created by Shaban on 25/05/2022.
//

import SwiftUI

#if os(iOS)
struct CustomSheetView<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode
    private var content: Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black.opacity(0.5).onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
            content
        }
                .edgesIgnoringSafeArea(.bottom)
    }
}


func presentSheetController<Content: View>(content: Content) {
    let view = CustomSheetView {
        content
    }
    let controller = UISheetController(rootView: view)
    UIApplication.shared.topController?.present(controller, animated: true)
}
#endif
