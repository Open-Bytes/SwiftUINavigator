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
    ///   - delay: time to navigate after
    ///   - showDefaultNavBar: if false, no nav bar will be displayed.
    ///   - onDismissSheet: called when dismissed
    ///   - element: the view
    public func navigate<Element: View>(
            type: NavType = .push(),
            delay: TimeInterval,
            showDefaultNavBar: Bool?,
            onDismissSheet: (() -> Void)? = nil,
            _ element: () -> Element) {
        manager.navigate(
                element(),
                type: type,
                delay: delay,
                showDefaultNavBar: showDefaultNavBar,
                onDismissSheet: onDismissSheet)
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
    ///   - identifier: The ID of the destination view (used to easily come back to it if needed).
    ///   - addToBackStack: if false, the view won't be added to the back stack
    ///   - showDefaultNavBar: if false, no nav bar will be displayed.
    ///   - delay: the interval to delay before triggering the navigation
    ///   - element: The destination view.
    public func push<Element: View>(
            withId identifier: String? = nil,
            addToBackStack: Bool = true,
            showDefaultNavBar: Bool? = nil,
            delay: TimeInterval,
            _ element: () -> Element) {
        manager.push(
                element(),
                withId: identifier,
                addToBackStack: addToBackStack,
                showDefaultNavBar: showDefaultNavBar,
                delay: delay)
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

    /// Present a normal sheet
    /// - Parameters:
    ///   - content: the view
    ///   - showDefaultNavBar: if false, no nav bar will be displayed.

    @available(*, deprecated, message: "Use presentSheet(type: showDefaultNavBar: onDismiss: content)")
    public func presentSheet<Content: View>(
            showDefaultNavBar: Bool = false,
            width: CGFloat? = nil,
            height: CGFloat? = nil,
            onDismiss: (() -> Void)? = nil,
            _ content: () -> Content) {
        manager.presentSheet(
                content(),
                showDefaultNavBar: showDefaultNavBar,
                width: width,
                height: height,
                onDismiss: onDismiss)
    }

    /// Present a custom sheet
    /// - Parameters:
    ///   - height:
    ///   - minHeight: the minimum height
    ///   - isDismissable: whether to dismiss or not
    ///   - showDefaultNavBar: if false, no nav bar will be displayed.
    ///   - onDismiss: called when dismissed
    ///   - content: the view
    @available(*, deprecated, message: "Use presentSheet(type: showDefaultNavBar: onDismiss: content)")
    public func presentCustomSheet<Content: View>(
            height: CGFloat,
            minHeight: CGFloat = 0,
            isDismissable: Bool = true,
            showDefaultNavBar: Bool = false,
            onDismiss: (() -> Void)? = nil,
            _ content: () -> Content) {
        manager.presentCustomSheet(
                content(),
                height: height,
                minHeight: minHeight,
                isDismissable: isDismissable,
                showDefaultNavBar: showDefaultNavBar,
                onDismiss: onDismiss)
    }

    /// Present a full sheet
    /// - Parameters:
    ///   - showDefaultNavBar: if false, no nav bar will be displayed.
    ///   - onDismiss: called when dismissed
    ///   - content: the view
    @available(*, deprecated, message: "Use presentSheet(type: showDefaultNavBar: onDismiss: content)")
    @available(iOS 14.0, *)
    public func presentFullSheet<Content: View>(
            showDefaultNavBar: Bool? = nil,
            onDismiss: (() -> Void)? = nil,
            _ content: () -> Content) {
        manager.presentFullSheet(
                content(),
                showDefaultNavBar: showDefaultNavBar,
                onDismiss: onDismiss)
    }

    /// Dismiss the current displayed sheet
    public func dismissSheet() {
        manager.dismissSheet()
    }

    /// Dismiss the current displayed view.
    /// If a sheet is displayed and there's no a view in its back stack,
    /// the sheet will be dismissed.
    /// - Parameters:
    ///   - destination: the option for the view to dismiss to
    ///   - delay: time to dismiss after
    public func dismiss(
            to destination: DismissDestination = .previous,
            delay: TimeInterval) {
        manager.dismiss(to: destination, delay: delay)
    }

    /// Dismiss the current displayed view.
    /// If a sheet is displayed and there's no a view in its back stack,
    /// the sheet will be dismissed.
    /// - Parameter destination: the option for the view to dismiss to
    public func dismiss(to destination: DismissDestination = .previous) {
        manager.dismiss(to: destination)
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
        switch type {
        case let .normal(width, height):
            manager.presentSheet(
                    content(),
                    showDefaultNavBar: showDefaultNavBar,
                    width: width,
                    height: height,
                    onDismiss: onDismiss)
        case .full:
            if #available(iOS 14.0, *) {
                manager.presentFullSheet(
                        content(),
                        showDefaultNavBar: showDefaultNavBar,
                        onDismiss: onDismiss)
            }
        case let .fixedHeight(height, minHeight, isDismissable):
            manager.presentCustomSheet(
                    content(),
                    height: height,
                    minHeight: minHeight,
                    isDismissable: isDismissable,
                    showDefaultNavBar: showDefaultNavBar,
                    onDismiss: onDismiss
            )
        }
    }
}
