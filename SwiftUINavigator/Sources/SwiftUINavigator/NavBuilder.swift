//
// Created by Shaban on 12/11/2022.
//

import SwiftUI

struct NavViewOptions {
    var easeAnimation: Animation = .easeOut
    var transition: NavTransition = .default
    var showDefaultNavBar: Bool = true
}

struct NavBuilder {
    static func navView<Content: View>(
            root: NavManager?,
            options: NavViewOptions,
            content: Content) -> some View {
        let manager = Self.manager(root: root, options: options)
        let navigator = Self.navigator(manager: manager)
        return NavView(
                transition: options.transition,
                easeAnimation: options.easeAnimation,
                showDefaultNavBar: false,
                rootView: { content }
        ).environmentObject(navigator)
    }

    static func navViewContent<Content: View>(
            options: NavViewOptions,
            content: () -> Content) -> NavViewContent<Content> {
        let manager = manager(root: nil, options: options)
        let navigator = navigator(manager: manager)
        return NavViewContent(
                navigator: navigator,
                manager: manager,
                rootView: content)
    }

    static func manager(root: NavManager?, options: NavViewOptions) -> NavManager {
        NavManager(root: root, options: options)
    }

    static func navigator(manager: NavManager) -> Navigator {
        Navigator(manager: manager)
    }
}
