//
// Created by Shaban on 09/11/2022.
//

import Combine
import SwiftUI

class ActionSheetManager: ObservableObject {
    @available(macOS, unavailable)
    @Published var isPresented: Bool = false {
        didSet {
            if !isPresented {
                sheet = nil
            }
        }
    }
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
