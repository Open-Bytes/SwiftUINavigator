//
// Created by Shaban on 08/11/2022.
//

import SwiftUI

struct ActionSheetModifier: ViewModifier {
    @Binding var isPresented: Bool
    let sheet: () -> ActionSheet?

    func body(content: Content) -> some View {
        if let sheet = sheet() {
            content.actionSheet(isPresented: $isPresented) {
                sheet
            }
        } else {
            content
        }
    }
}
