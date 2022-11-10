//
// Created by Shaban on 10/11/2022.
//

import Combine
import SwiftUI


class DialogManager: ObservableObject {
    @Published var isPresented: Bool = false {
        didSet {
            if !isPresented {
                view = nil
            }
        }
    }
    var view: AnyView? = nil
    var dismissOnTouchOutside: Bool = true

    func present(dismissOnTouchOutside: Bool, _ view: AnyView) {
        self.dismissOnTouchOutside = dismissOnTouchOutside
        self.view = view
        withAnimation(.spring().speed(2)) {
            isPresented = true
        }
    }

    func dismiss() {
        isPresented = false
        view = nil
    }
}
