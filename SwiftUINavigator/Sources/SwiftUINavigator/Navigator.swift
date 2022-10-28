//
// Created by Shaban Kamel on 28/01/2022.
//

import SwiftUI

public class Navigator: ObservableObject {
    let manager: NavManager

    public init(manager: NavManager) {
        self.manager = manager
    }

    static func instance(
            manager: NavManager? = nil,
            easeAnimation: Animation,
            showDefaultNavBar: Bool,
            transition: NavTransition
    ) -> Navigator {
        let manager = manager ?? NavManager(
                easeAnimation: easeAnimation,
                showDefaultNavBar: showDefaultNavBar,
                transition: transition)
        return Navigator(manager: manager)
    }

    /// Navigates to a view.
    /// - Parameters:
    ///   - type: the type of navigation
    ///   - showDefaultNavBar: if false, no nav bar will be displayed.
    ///   - onDismissSheet: called when dismissed
    ///   - element: the view
    public func navigate<Element: View>(
            type: NavType = .push(),
            showDefaultNavBar: Bool? = nil,
            onDismissSheet: (() -> Void)? = nil,
            _ element: () -> Element) {
        manager.navigate(
                element(),
                type: type,
                showDefaultNavBar: showDefaultNavBar,
                onDismissSheet: onDismissSheet)
    }

    /// Navigates to a view.
    /// - Parameters:
    ///   - element: The destination view.
    ///   - identifier: The ID of the destination view (used to easily come back to it if needed).
    ///   - addToBackStack: if false, the view won't be added to the back stack
    ///   - showDefaultNavBar: if false, no nav bar will be displayed.
    public func push<Element: View>(
            withId identifier: String? = nil,
            addToBackStack: Bool = true,
            showDefaultNavBar: Bool? = nil,
            _ element: () -> Element) {
        manager.push(element(),
                withId: identifier,
                addToBackStack: addToBackStack,
                showDefaultNavBar: showDefaultNavBar)
    }

    /// Present a sheet
    /// - Parameters:
    ///   - type: the type of the sheet.
    ///   - showDefaultNavBar: if false, no nav bar will be displayed.
    ///   - onDismiss: called when dismissed.
    ///   - content: the view.
    public func presentSheet<Content: View>(
            type: SheetType,
            showDefaultNavBar: Bool = false,
            onDismiss: (() -> Void)? = nil,
            content: () -> Content) {
        manager.presentSheet(
                type: type,
                showDefaultNavBar: showDefaultNavBar,
                onDismiss: onDismiss,
                content: content)
    }

    /// Dismiss the current displayed sheet
    public func dismissSheet(type: DismissSheetType? = nil) {
        manager.dismissSheet(type: type)
    }

    /// Dismiss the current displayed view.
    /// If a sheet is displayed and there's no a view in its back stack,
    /// the sheet will be dismissed.
    /// - Parameter destination: the option for the view to dismiss to
    public func dismiss(to destination: DismissDestination = .previous) {
        manager.dismiss(to: destination)
    }
}