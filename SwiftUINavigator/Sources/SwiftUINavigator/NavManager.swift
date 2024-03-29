//
//  Navigator.swift
//  
//
//  Created by Shaban on 03/01/2022.
//

import SwiftUI
import Combine

typealias CancelableBag = Set<AnyCancellable>

class NavManager: ObservableObject {
    private var bag: CancelableBag = CancelableBag()
    @Published var navigationType = NavigationDirection.none
    var lastNavigationType: NavigationDirection {
        get {
            navigationType
        }
        set(newValue) {
            navigationType = newValue
        }
    }
    private var root: NavManager?
    let options: NavViewOptions

    @Published var stackItems = [BackStackElement]()

    private var backStack = BackStack() {
        didSet {
            stackItems = backStack.elements
        }
    }

    @Published var sheetManager: SheetManager
    @Published var actionSheetManager: ActionSheetManager
    @Published var confirmationDialogManager: ConfirmationDialogManager
    @Published var alertManager: AlertManager
    @Published var dialogManager: DialogManager

    init(root: NavManager? = nil,
         options: NavViewOptions,
         sheetManager: SheetManager = SheetManager(),
         actionSheetManager: ActionSheetManager = ActionSheetManager(),
         confirmationDialogManager: ConfirmationDialogManager = ConfirmationDialogManager(),
         alertManager: AlertManager = AlertManager(),
         dialogManager: DialogManager = DialogManager()) {
        self.root = root
        self.options = options

        self.sheetManager = sheetManager
        self.actionSheetManager = actionSheetManager
        self.confirmationDialogManager = confirmationDialogManager
        self.alertManager = alertManager
        self.dialogManager = dialogManager

        sheetManager.navManager = self

        sheetManager.objectWillChange
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &bag)

        actionSheetManager.objectWillChange
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &bag)

        confirmationDialogManager.objectWillChange
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &bag)

        alertManager.objectWillChange
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &bag)

        dialogManager.objectWillChange
                .sink { [weak self] _ in
                    self?.objectWillChange.send()
                }
                .store(in: &bag)
    }
}

extension NavManager {

    func navigate<Element: View>(_ element: Element, type: NavType) {
        switch type {
        case let .push(id, addToBackStack, showDefaultNavBar):
            push(
                    element, withId: id,
                    addToBackStack: addToBackStack,
                    showDefaultNavBar: showDefaultNavBar)
        case .sheet(let type):
            sheetManager.presentSheet(
                    type: type,
                    content: { element })
        case let .dialog(dismissOnTouchOutside, presenter):
            presentDialog(
                    dismissOnTouchOutside: dismissOnTouchOutside,
                    presenter: presenter,
                    element.eraseToAnyView())
        }
    }

    func presentSheet<Content: View>(
            type: SheetType,
            content: () -> Content) {
        sheetManager.presentSheet(
                type: type,
                content: content)
    }

}

extension NavManager {

    func push<Element: View>(
            _ element: Element,
            withId identifier: String?,
            addToBackStack: Bool,
            showDefaultNavBar: Bool?) {
        lastNavigationType = .push
        let id = identifier == nil ? UUID().uuidString : identifier!

        let view = addNavBar(element, showDefaultNavBar: showDefaultNavBar).eraseToAnyView()
        let element = BackStackElement(
                id: id,
                wrappedElement: view,
                type: .screen,
                addToBackStack: addToBackStack)
        withAnimation(options.easeAnimation) {
            backStack.push(element)
        }
    }

    func addNavBar<Element: View>(_ element: Element, showDefaultNavBar: Bool?) -> AnyView {
        canShowDefaultNavBar(showDefaultNavBar) ?
                element.navBar().eraseToAnyView() :
                element.eraseToAnyView()
    }

    private func canShowDefaultNavBar(_ canShowInSingleView: Bool?) -> Bool {
        guard let canShowInSingleView = canShowInSingleView else {
            return options.showDefaultNavBar
        }
        return canShowInSingleView
    }

}

// MARK:- ConfirmationDialog

extension NavManager {

    func presentConfirmationDialog(
            titleKey: LocalizedStringKey,
            titleVisibility: ConfirmationDialogVisibility,
            content: AnyView) {
        confirmationDialogManager.present(
                titleKey: titleKey,
                titleVisibility: titleVisibility,
                content: content
        )
    }

    func dismissConfirmationDialog() {
        confirmationDialogManager.dismiss()
    }
}

// MARK:- ActionSheet

extension NavManager {

    @available(macOS, unavailable)
    func presentActionSheet(_ sheet: ActionSheet) {
        actionSheetManager.present(sheet)
    }

    @available(macOS, unavailable)
    func dismissActionSheet() {
        actionSheetManager.dismiss()
    }

}

// MARK:- Alert

extension NavManager {

    func presentAlert(_ alert: Alert) {
        alertManager.present(alert)
    }

    func dismissAlert() {
        alertManager.dismiss()
    }

}

// MARK:- Dialog

extension NavManager {

    private func parentManager() -> NavManager {
        guard let root = root?.parentManager() else {
            return self
        }
        return root.parentManager()
    }

}

extension NavManager {


    func presentDialog(
            dismissOnTouchOutside: Bool,
            presenter: DialogPresenter,
            _ dialog: AnyView) {
        let manager: DialogManager
        switch presenter {
        case .root:
            manager = parentManager().dialogManager
        case .last:
            manager = dialogManager
        }
        manager.present(dismissOnTouchOutside: dismissOnTouchOutside, dialog)
    }

    func dismissDialog() {
        dialogManager.dismiss()
        parentManager().dialogManager.dismiss()
    }

}

extension NavManager {

    func dismissSheet(type: DismissSheetType?) {
        sheetManager.dismissSheet(type: type)
        root?.sheetManager.dismissSheet(type: type)
    }

    func dismiss(type: DismissType) {
        lastNavigationType = .pop

        if type.isStackDismiss, backStack.isEmpty {
            dismissSheet(type: nil)
            return
        }

        withAnimation(options.easeAnimation) {
            switch type {
            case .toPreviousView:
                backStack.popToPrevious()
            case .toRootView:
                backStack.popToRoot()
            case .toView(let viewId):
                backStack.popToView(withId: viewId)
            case .sheet(let type):
                dismissSheet(type: type)
            case .dialog:
                dismissDialog()
            }
        }
    }
}

extension NavManager {

    enum NavigationDirection {
        case push
        case pop
        case none
    }

}



