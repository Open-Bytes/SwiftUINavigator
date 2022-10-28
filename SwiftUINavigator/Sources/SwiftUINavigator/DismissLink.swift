//
// Created by Shaban Kamel on 27/12/2021.
//

import SwiftUI

/// DismissLink is a view which dismisses the current view when tapped.
/// It's a wapper for `Navigator.dismiss()`
public struct DismissLink<Label: View>: View {
    private let destination: DismissDestination
    private let label: () -> Label
    @EnvironmentObject private var navigator: Navigator

    public init(
            to destination: DismissDestination = .previous,
            label: @escaping () -> Label) {
        self.destination = destination
        self.label = label
    }

    public var body: some View {
        label()
                .onTapGesture {
                    navigator.dismiss(to: destination)
                }
    }
}

/// Defines the type of dismiss operation.
public enum DismissDestination {
    /// Navigate back to the previous view.
    case previous

    /// Navigate back to the root view (i.e. the first view added
    /// to the NavigatorView during the initialization process).
    case root

    /// Navigate back to a view identified by a specific ID.
    case view(withId: String)

    // Dismiss current presented sheet
    case dismissSheet(type: DismissSheetType? = nil)
}
