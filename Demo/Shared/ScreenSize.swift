//
// Created by Shaban on 24/05/2022.
//

import SwiftUI

func screenHeight() -> CGFloat {
    #if os(macOS)
    NSScreen.main?.frame.height ?? 0
    #else
    UIScreen.main.bounds.height
    #endif
}

func screenWidth() -> CGFloat {
    #if os(macOS)
    NSScreen.main?.frame.width ?? 0
    #else
    UIScreen.main.bounds.width
    #endif
}