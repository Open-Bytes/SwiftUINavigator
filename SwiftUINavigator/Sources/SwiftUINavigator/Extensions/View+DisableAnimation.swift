//
// Created by Shaban on 25/05/2022.
//

import SwiftUI

extension View {
    func disableAnimation() -> some View {
        animation(nil, value: UUID())
    }
}
