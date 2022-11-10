//
// Created by Shaban Kamel on 06/01/2022.
//

import SwiftUI

#if os(macOS)
import AppKit


@main
struct MacAppApp: App {
    var body: some Scene {
        WindowGroup {
            DemoApp()
        }
    }
}

#else

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

}
#endif

