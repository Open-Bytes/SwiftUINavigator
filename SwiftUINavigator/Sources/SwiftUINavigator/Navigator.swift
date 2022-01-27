//
//  Navigator.swift
//  
//
//  Created by Shaban on 03/01/2022.
//

import SwiftUI

public class Navigator: ObservableObject {
    var lastNavigationType = NavigationDirection.push
    private let easeAnimation: Animation
    @Published var currentView: BackStackElement?
    @Published var presentSheet: Bool = false
    @Published var presentFullSheetView: Bool = false
    var sheet: AnyView? = nil
    var showDefaultNavBar: Bool = true
    private var root: Navigator?

    private var backStack = BackStack() {
        didSet {
            currentView = backStack.peek()
        }
    }

    public init(root: Navigator? = nil,
                easeAnimation: Animation,
                showDefaultNavBar: Bool = true) {
        self.easeAnimation = easeAnimation
        self.showDefaultNavBar = showDefaultNavBar
        self.root = root
    }
}

extension Navigator {

    /// Navigates to a view.
    /// - Parameters:
    ///   - element: The destination view.
    ///   - identifier: The ID of the destination view (used to easily come back to it if needed).
    public func navigate<Element: View>(
            _ element: Element,
            type: NavigationType = .push(),
            delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.navigate(element, type: type)
        }
    }

    /// Navigates to a view.
    /// - Parameters:
    ///   - element: The destination view.
    ///   - identifier: The ID of the destination view (used to easily come back to it if needed).
    public func navigate<Element: View>(
            _ element: Element,
            type: NavigationType = .push(),
            showDefaultNavBar: Bool? = nil) {
        switch type {
        case let .push(id, addToBackStack):
            self.push(
                    element, withId: id,
                    addToBackStack: addToBackStack,
                    showDefaultNavBar: showDefaultNavBar)
        case .sheet:
            self.presentSheet(element, showDefaultNavBar: showDefaultNavBar ?? false)
        case .fullSheet:
            if #available(iOS 14.0, *) {
                self.presentFullSheet(element, showDefaultNavBar: showDefaultNavBar)
            } else {
                return
            }
        }
    }

    /// Navigates to a view.
    /// - Parameters:
    ///   - element: The destination view.
    ///   - identifier: The ID of the destination view (used to easily come back to it if needed).
    public func push<Element: View>(
            _ element: Element,
            withId identifier: String? = nil,
            delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.push(element, withId: identifier)
        }
    }

}

extension Navigator {

    /// Navigates to a view.
    /// - Parameters:
    ///   - element: The destination view.
    ///   - identifier: The ID of the destination view (used to easily come back to it if needed).
    public func push<Element: View>(
            _ element: Element,
            withId identifier: String? = nil,
            addToBackStack: Bool = true,
            showDefaultNavBar: Bool? = nil) {
        withAnimation(easeAnimation) {
            lastNavigationType = .push
            let id = identifier == nil ? UUID().uuidString : identifier!

            let view = addNavBar(element, showDefaultNavBar: showDefaultNavBar)
            let element = BackStackElement(
                    id: id,
                    wrappedElement: view,
                    type: .screen,
                    addToBackStack: addToBackStack)
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

extension Navigator {

    public func presentSheet<Content: View>(_ content: Content, showDefaultNavBar: Bool = false) {
        let view = addNavBar(content, showDefaultNavBar: showDefaultNavBar)
        presentSheet(view, type: .normal)
    }

    @available(iOS 14.0, *)
    public func presentFullSheet<Content: View>(_ content: Content, showDefaultNavBar: Bool? = nil) {
        let view = addNavBar(content, showDefaultNavBar: showDefaultNavBar)
        presentSheet(view, type: .full)
    }

    private func presentSheet<Content: View>(_ content: Content, type: SheetType) {
        let root = root ?? self
        let navigator = Navigator(
                root: root,
                easeAnimation: easeAnimation,
                showDefaultNavBar: showDefaultNavBar)
        let navigatorView = NavigatorView(
                navigator: navigator,
                showDefaultNavBar: showDefaultNavBar) {
            content
        }
        root.sheet = AnyView(navigatorView)

        switch type {
        case .normal:
            root.presentSheet = true
        case .full:
            root.presentFullSheetView = true
        }
    }

}

extension Navigator {

    enum SheetType {
        case normal
        case full
    }
}

extension Navigator {

    public func dismissSheet() {
        root?.dismissSheet()
        presentSheet = false
        presentFullSheetView = false
        sheet = nil
    }

    /// Navigate back to a view in the back stack
    /// - Parameters:
    ///   - destination: the view to dismiss to
    ///   - delay: time to navigate after
    public func dismiss(
            to destination: DismissDestination = .previous,
            delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.dismiss(to: destination)
        }
    }

    public func dismiss(to destination: DismissDestination = .previous) {
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

}

extension Navigator {

    enum NavigationDirection {
        case push
        case pop
        case none
    }

}


