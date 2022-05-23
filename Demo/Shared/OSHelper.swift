//
// Created by Shaban on 19/05/2022.
//

import Foundation

struct OSHelper {

    static func isMac() -> Bool {
        #if os(macOS)
        return true
        #else
        return false
        #endif
    }
}
