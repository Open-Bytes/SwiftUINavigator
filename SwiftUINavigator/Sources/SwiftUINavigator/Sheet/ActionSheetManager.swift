//
// Created by Shaban on 09/11/2022.
//

import Combine
import SwiftUI

class ActionSheetManager: ObservableObject {
    @Published var isPresented: Bool = false
    @available(macOS, unavailable)
    var sheet: ActionSheet? = nil

    @available(macOS, unavailable)
    func present(_ sheet: ActionSheet) {
        self.sheet = sheet
        isPresented = true
    }

    @available(macOS, unavailable)
    func dismiss() {
        isPresented = false
        sheet = nil
    }
}
