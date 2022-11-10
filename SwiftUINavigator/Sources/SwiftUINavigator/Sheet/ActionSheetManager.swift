//
// Created by Shaban on 09/11/2022.
//

import Combine
import SwiftUI

class ActionSheetManager: ObservableObject {
    @Published var isPresented: Bool = false
    var sheet: ActionSheet? = nil

    func present(_ sheet: ActionSheet) {
        self.sheet = sheet
        isPresented = true
    }

    func dismiss() {
        isPresented = false
        sheet = nil
    }
}
