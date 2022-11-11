//
// Created by Shaban Kamel on 27/12/2021.
//

import SwiftUI

/// DismissLink is a view which dismisses the current view when tapped.
/// It's a wapper for `Navigator.dismiss()`
public struct DismissLink<Label: View>: View {
    private let type: DismissType
    private let label: () -> Label
    @EnvironmentObject private var navigator: Navigator

    public init(
            type: DismissType = .toPreviousView,
            label: @escaping () -> Label) {
        self.type = type
        self.label = label
    }

    public var body: some View {
        label()
                .onTapGesture {
                    navigator.dismiss(type: type)
                }
    }
}

/// Defines the type of dismiss operation.
public enum DismissType {
    /// Navigate back to the previous view.
    case toPreviousView

    /// Navigate back to the root view (i.e. the first view added
    /// to the NavigatorView during the initialization process).
    case toRootView

    /// Navigate back to a view identified by a specific ID.
    case toView(withId: String)

    // Dismiss current presented sheet
    case sheet(type: DismissSheetType? = nil)

    case dialog
}
