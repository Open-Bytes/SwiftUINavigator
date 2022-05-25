//
// Created by Shaban on 25/05/2022.
//

import SwiftUI

extension AnyTransition {

    static var bottomUp: AnyTransition {
        .asymmetric(
                insertion: .move(edge: .bottom),
                removal: .move(edge: .bottom))
    }
}