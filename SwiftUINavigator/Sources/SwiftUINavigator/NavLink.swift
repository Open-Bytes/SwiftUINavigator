//
//  Created by Shaban on 03/01/2022.
//

import SwiftUI

/// The alternative of NavigationLink. It's a wrapper of Navigator.
/// When clicked, it will navigate to the destination view
/// with the specified navigation type.
@available(*, deprecated, renamed: "NavLink")
public struct NavigatorLink<Destination: View, Label: View>: View {
    private let navLink: NavLink<Destination, Label>

    public init(
            destination: @escaping @autoclosure () -> Destination,
            type: NavType = .push(),
            showDefaultNavBar: Bool? = nil,
            onDismissSheet: (() -> Void)? = nil,
            label: @escaping () -> Label) {
        navLink = NavLink(
                destination: destination(),
                type: type,
                showDefaultNavBar: showDefaultNavBar,
                onDismissSheet: onDismissSheet,
                label: label)
    }

    public var body: some View {
        navLink
    }
}

/// The alternative of NavigationLink. It's a wrapper of Navigator.
/// When clicked, it will navigate to the destination view
/// with the specified navigation type.
public struct NavLink<Destination: View, Label: View>: View {
    private let destination: () -> Destination
    private let type: NavType
    private let showDefaultNavBar: Bool?
    private let label: () -> Label
    private let onDismissSheet: (() -> Void)?
    @EnvironmentObject private var navigator: Navigator

    public init(
            destination: @escaping @autoclosure () -> Destination,
            type: NavType = .push(),
            showDefaultNavBar: Bool? = nil,
            onDismissSheet: (() -> Void)? = nil,
            label: @escaping () -> Label) {
        self.destination = destination
        self.type = type
        self.showDefaultNavBar = showDefaultNavBar
        self.label = label
        self.onDismissSheet = onDismissSheet
    }

    public var body: some View {
        label()
                .onTapGesture {
                    navigator.navigate(
                            type: type,
                            showDefaultNavBar: showDefaultNavBar,
                            onDismissSheet: onDismissSheet) {
                        destination()
                    }
                }
    }
}
