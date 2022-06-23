//
//  Navigator.swift
//  
//
//  Created by Shaban on 03/01/2022.
//

import SwiftUI

public class NavManager: ObservableObject {
    let transition: NavigatorTransition

    var lastNavigationType = NavigationDirection.pop
    private let easeAnimation: Animation
    @Published var currentView: BackStackElement?
    @Published var presentSheet: Bool = false
    @Published var presentFullSheet: Bool = false
    @Published var presentCustomSheet: Bool = false
    var onDismissSheet: (() -> Void)? = nil
    var sheet: AnyView? = nil
    var showDefaultNavBar: Bool = true
    var root: NavManager?
    var customSheetOptions = CustomSheetOptions(height: 0, minHeight: 0, isDismissable: false)

    @Published var stackItems = [BackStackElement]()

    private var backStack = BackStack() {
        didSet {
            currentView = backStack.peek()
            stackItems = backStack.views
        }
    }

    public init(root: NavManager? = nil,
                easeAnimation: Animation,
                showDefaultNavBar: Bool,
                transition: NavigatorTransition) {
        self.root = root
        self.easeAnimation = easeAnimation
        self.showDefaultNavBar = showDefaultNavBar
        self.transition = transition
    }
}

extension NavManager {

    public func navigate<Element: View>(
            _ element: Element,
            type: NavigationType,
            delay: TimeInterval,
            showDefaultNavBar: Bool?,
            onDismissSheet: (() -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.navigate(
                    element,
                    type: type,
                    showDefaultNavBar: showDefaultNavBar,
                    onDismissSheet: onDismissSheet)
        }
    }

    public func navigate<Element: View>(
            _ element: Element,
            type: NavigationType,
            showDefaultNavBar: Bool?,
            onDismissSheet: (() -> Void)?) {
        switch type {
        case let .push(id, addToBackStack):
            push(
                    element, withId: id,
                    addToBackStack: addToBackStack,
                    showDefaultNavBar: showDefaultNavBar)
        case let .sheet(width, height):
            presentSheet(element,
                    showDefaultNavBar: showDefaultNavBar ?? false,
                    width: width,
                    height: height,
                    onDismiss: onDismissSheet)
        case .fullSheet:
            if #available(iOS 14.0, *) {
                presentFullSheet(element, showDefaultNavBar: showDefaultNavBar,
                        onDismiss: onDismissSheet)
            } else {
                return
            }
        case let .customSheet(height, minHeight, isDismissable):
            presentCustomSheet(
                    element,
                    height: height,
                    minHeight: minHeight,
                    isDismissable: isDismissable,
                    showDefaultNavBar: showDefaultNavBar ?? false,
                    onDismiss: onDismissSheet)
        }
    }

}

extension NavManager {

    public func push<Element: View>(
            _ element: Element,
            withId identifier: String?,
            addToBackStack: Bool,
            showDefaultNavBar: Bool?,
            delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.push(
                    element,
                    withId: identifier,
                    addToBackStack: addToBackStack,
                    showDefaultNavBar: showDefaultNavBar)
        }
    }

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

    private func addNavBar<Element: View>(_ element: Element, showDefaultNavBar: Bool?) -> AnyView {
        canShowDefaultNavBar(showDefaultNavBar) ?
                AnyView(element.navBar()) :
                AnyView(element)
    }

    private func canShowDefaultNavBar(_ canShowInSingleView: Bool?) -> Bool {
        guard let canShowInSingleView = canShowInSingleView else {
            return showDefaultNavBar
        }
        return canShowInSingleView
    }

}

extension NavManager {

    public func presentSheet<Content: View>(
            _ content: Content,
            showDefaultNavBar: Bool,
            width: CGFloat?,
            height: CGFloat?,
            onDismiss: (() -> Void)?) {
        let view = addNavBar(content, showDefaultNavBar: showDefaultNavBar)
        presentSheet(view, type: .normal, width: width, height: height, onDismiss: onDismiss)
    }

    @available(iOS 14.0, *)
    public func presentFullSheet<Content: View>(
            _ content: Content,
            showDefaultNavBar: Bool?,
            onDismiss: (() -> Void)?) {
        let view = addNavBar(content, showDefaultNavBar: showDefaultNavBar)
        presentSheet(view, type: .full, width: nil, height: nil, onDismiss: onDismiss)
    }

    public func presentCustomSheet<Content: View>(
            _ content: Content,
            height: CGFloat,
            minHeight: CGFloat,
            isDismissable: Bool,
            showDefaultNavBar: Bool,
            onDismiss: (() -> Void)?) {
        let view = addNavBar(content, showDefaultNavBar: showDefaultNavBar)
        customSheetOptions = CustomSheetOptions(
                height: height,
                minHeight: minHeight,
                isDismissable: isDismissable)
        presentSheet(view, type: .custom, width: nil, height: nil, onDismiss: onDismiss)
    }

    private func presentSheet<Content: View>(
            _ content: Content,
            type: SheetType,
            width: CGFloat?,
            height: CGFloat?,
            onDismiss: (() -> Void)?) {
        onDismissSheet = onDismiss
        let manager = NavManager(
                root: self,
                easeAnimation: easeAnimation,
                showDefaultNavBar: showDefaultNavBar,
                transition: transition)
        let navigator = Navigator.instance(
                manager: manager,
                easeAnimation: easeAnimation,
                showDefaultNavBar: showDefaultNavBar,
                transition: transition)
        let navigatorView = NavView(
                navigator: navigator,
                showDefaultNavBar: showDefaultNavBar) {
            content
        }

        if let width = width, let height = height {
            sheet = navigatorView.frame(width: width, height: height).eraseToAnyView()
        } else {
            sheet = navigatorView.eraseToAnyView()
        }

        switch type {
        case .normal:
            presentSheet = true
        case .full:
            presentFullSheet = true
        case .custom:
            #if os(macOS)
            presentCustomSheet = true
            #else
            withAnimation(easeAnimation) {
                presentSheetController(content: content.environmentObject(navigator)
                )
            }
            #endif
        }
    }
}

extension NavManager {

    enum SheetType {
        case normal
        case full
        case custom
    }
}

extension NavManager {

    public func dismissSheet() {
        root?.presentSheet = false
        root?.presentFullSheet = false
        root?.presentCustomSheet = false
        root?.sheet = nil
        dismissController()
    }

    public func dismiss(
            to destination: DismissDestination,
            delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.dismiss(to: destination)
        }
    }

    public func dismiss(to destination: DismissDestination) {
        dismissController()

        lastNavigationType = .pop

        if backStack.isEmpty {
            dismissSheet()
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
            case .dismissSheet:
                dismissSheet()
            }
        }
    }

    private func dismissController() {
        #if os(iOS)
        // For dismissing the custom sheet which is displayed in a controller
        UIApplication.shared.topController?.dismiss(animated: true)
        #endif
    }
}

extension NavManager {

    enum NavigationDirection {
        case push
        case pop
        case none
    }

}



