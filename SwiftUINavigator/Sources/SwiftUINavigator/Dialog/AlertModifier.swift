//
// Created by Shaban on 10/11/2022.
//

import Foundation

import SwiftUI

struct AlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let alert: () -> Alert?

    func body(content: Content) -> some View {
        Group {
            if let alert = alert() {
                content.alert(isPresented: $isPresented) {
                    alert
                }
            } else {
                content
            }
        }
    }
}
