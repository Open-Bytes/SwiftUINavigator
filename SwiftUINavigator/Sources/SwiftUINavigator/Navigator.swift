//
// Created by Shaban Kamel on 28/01/2022.
//

import SwiftUI

public class Navigator: ObservableObject {
    let manager: NavManager

    init(manager: NavManager) {
        self.manager = manager
    }

    /// Navigates to a view.
    /// - Parameters:
    ///   - type: the type of navigation
    ///   - onDismissSheet: called when dismissed
    ///   - element: the view
    public func navigate<Element: View>(
            type: NavType = .push(),
            onDismissSheet: (() -> Void)? = nil,
            _ element: () -> Element) {
        manager.navigate(
                element(),
                type: type,
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
    ///   - onDismiss: called when dismissed.
    ///   - content: the view.
    public func presentSheet<Content: View>(
            type: SheetType,
            onDismiss: (() -> Void)? = nil,
            content: () -> Content) {
        manager.presentSheet(
                type: type,
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
    public func dismiss(type: DismissType = .toPreviousView) {
        manager.dismiss(type: type)
    }

}

public extension Navigator {

    /// Present confirmation dialog
    ///
    /// - Parameters:
    ///   - titleKey: key
    ///   - titleVisibility:  title visibility
    ///   - content: view
    @available(macCatalyst 15.0, *)
    @available(iOS 15.0, *)
    @available(macOS 12.0, *)
    func presentConfirmationDialog<Content: View>(
            titleKey: LocalizedStringKey,
            titleVisibility: Visibility = .automatic,
            content: () -> Content
    ) {
        manager.presentConfirmationDialog(
                titleKey: titleKey,
                titleVisibility: ConfirmationDialogVisibility.from(titleVisibility),
                content: content().eraseToAnyView()
        )
    }

    /// Dismiss confirmation dialog
    func dismissConfirmationDialog() {
        manager.dismissConfirmationDialog()
    }
}


public extension Navigator {

    /// Present action sheet
    ///
    /// - Parameter sheet: ActionSheet
    @available(macOS, unavailable)
    func presentActionSheet(_ sheet: () -> ActionSheet) {
        manager.presentActionSheet(sheet())
    }

    /// Dismiss action sheet
    @available(macOS, unavailable)
    func dismissActionSheet() {
        manager.dismissActionSheet()
    }

}

public extension Navigator {

    /// Present Alert
    ///
    /// - Parameter alert: Alert
    func presentAlert(_ alert: () -> Alert) {
        manager.presentAlert(alert())
    }

    /// Dismiss Alert
    func dismissAlert() {
        manager.dismissAlert()
    }

}

// MARK:- Dialog

public extension Navigator {

    func presentDialog<Content: View>(
            dismissOnTouchOutside: Bool = true,
            presenter: DialogPresenter = .root,
            _ view: () -> Content) {
        manager.presentDialog(
                dismissOnTouchOutside: dismissOnTouchOutside,
                presenter: presenter,
                view().eraseToAnyView())
    }

    func dismissDialog() {
        manager.dismissDialog()
    }

}