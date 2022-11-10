//
// Created by Shaban on 08/11/2022.
//

import SwiftUI

struct ActionSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    @available(macOS, unavailable)
    let sheet: () -> ActionSheet?

    func body(content: Content) -> some View {
        Group {
            #if os(macOS)
            content
            #else
            if let sheet = sheet() {
                content.actionSheet(isPresented: $isPresented) {
                    sheet
                }
            } else {
                content
            }
            #endif
        }
    }
}
