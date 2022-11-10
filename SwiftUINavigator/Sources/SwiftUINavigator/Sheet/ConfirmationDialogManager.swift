//
// Created by Shaban on 09/11/2022.
//

import Combine
import SwiftUI

class ConfirmationDialogManager: ObservableObject {
    @Published var isPresented: Bool = false
    var titleKey: LocalizedStringKey = ""
    var titleVisibility: ConfirmationDialogVisibility = .automatic
    var content: AnyView? = nil

    func present(
            titleKey: LocalizedStringKey,
            titleVisibility: ConfirmationDialogVisibility,
            content: AnyView) {
        self.content = content
        self.titleKey = titleKey
        self.titleVisibility = titleVisibility
        isPresented = true
    }

    func dismiss() {
        isPresented = false
        content = nil
        titleKey = ""
        titleVisibility = .automatic
    }
}

