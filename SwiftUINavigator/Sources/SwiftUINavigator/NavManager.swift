//
//  Navigator.swift
//  
//
//  Created by Shaban on 03/01/2022.
//

import SwiftUI
import Combine

public typealias CancelableBag = Set<AnyCancellable>

public class NavManager: ObservableObject {
    private var bag: CancelableBag = CancelableBag()
    let transition: NavTransition
    var lastNavigationType = NavigationDirection.pop
    let easeAnimation: Animation
    @Published var currentView: BackStackElement?
    private var root: NavManager?
    private var showDefaultNavBar: Bool = true

    @Published var stackItems = [BackStackElement]()

    private var backStack = BackStack() {
        didSet {
            currentView = backStack.peek()
            stackItems = backStack.views
        }
    }

    @Published var sheetManager = SheetManager()
    @Published var actionSheetManager = ActionSheetManager()
    @Published var confirmationDialogManager = ConfirmationDialogManager()
    @Published var alertManager = AlertManager()

    public init(root: NavManager? = nil,
                easeAnimation: Animation,
                showDefaultNavBar: Bool,
                transition: NavTransition) {
        self.root = root
        self.easeAnimation = easeAnimation
        self.showDefaultNavBar = showDefaultNavBar
        self.transition = transition
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
    }
}

extension NavManager {

    public func navigate<Element: View>(
            _ element: Element,
            type: NavType,
            showDefaultNavBar: Bool?,
            onDismissSheet: (() -> Void)?) {
        switch type {
        case let .push(id, addToBackStack):
            push(
                    element, withId: id,
                    addToBackStack: addToBackStack,
                    showDefaultNavBar: showDefaultNavBar)
        case .sheet(let type):
            sheetManager.presentSheet(
                    type: type,
                    showDefaultNavBar: showDefaultNavBar ?? false,
                    onDismiss: nil,
                    content: { element })
        }
    }

    func presentSheet<Content: View>(
            type: SheetType,
            showDefaultNavBar: Bool,
            onDismiss: (() -> Void)?,
            content: () -> Content) {
        sheetManager.presentSheet(
                type: type,
                showDefaultNavBar: showDefaultNavBar,
                onDismiss: onDismiss,
                content: content)
    }

}

extension NavManager {

    public func push<Element: View>(
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
        withAnimation(easeAnimation) {
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
            return showDefaultNavBar
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

extension NavManager {

    public func dismissSheet(type: DismissSheetType?) {
        root?.sheetManager.dismissSheet(type: type)
    }

    public func dismiss(to destination: DismissDestination) {
        lastNavigationType = .pop

        if backStack.isEmpty {
            dismissSheet(type: nil)
            return
        }

        withAnimation(easeAnimation) {
            switch destination {
            case .root:
                backStack.popToRoot()
            case .view(let viewId):
                backStack.popToView(withId: viewId)
            case .previous:
                backStack.popToPrevious()
            case .dismissSheet(let type):
                dismissSheet(type: type)
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



