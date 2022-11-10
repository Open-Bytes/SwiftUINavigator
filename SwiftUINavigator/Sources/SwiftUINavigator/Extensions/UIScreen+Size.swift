//
// Created by Shaban on 25/10/2022.
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif

//extension UIScreen {
//    #if os(watchOS)
//    static let screenSize = WKInterfaceDevice.current().screenBounds.size
//    static let screenWidth = screenSize.width
//    static let screenHeight = screenSize.height
//    #elseif os(iOS) || os(tvOS)
//    static let screenSize = UIScreen.main.bounds.size
//    static let screenWidth = screenSize.width
//    static let screenHeight = screenSize.height
//    #elseif os(macOS)
//    static let screenSize = NSScreen.main?.visibleFrame.size
//    static let screenWidth = screenSize.width
//    static let screenHeight = screenSize.height
//    #endif
//    static let middleOfScreen = CGPoint(x: screenWidth / 2, y: screenHeight / 2)
//}

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
