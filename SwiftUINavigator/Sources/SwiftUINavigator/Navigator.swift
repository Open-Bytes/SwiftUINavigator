//
//  Navigator.swift
//  
//
//  Created by Shaban on 03/01/2022.
//

import SwiftUI

public class Navigator: ObservableObject {
    var navigationType = NavigationDirection.push
    /// Customizable animation to apply in pop and push transitions
    private let easeAnimation: Animation
    @Published var sheetRoot: BackStackElement?
    @Published var currentView: BackStackElement?
    @Published var presentSheet: Bool = false
    @Published var presentFullSheetView: Bool = false
    var sheetView: AnyView? = nil

    private var backStack = BackStack() {
        didSet {
            currentView = backStack.peek()
        }
    }
    var isPresentingSheet: Bool {
        presentSheet || presentFullSheetView
    }

    public init(easeAnimation: Animation) {
        self.easeAnimation = easeAnimation
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
            type: NavigationType = .push()) {
        switch type {
        case let .push(id, addToBackStack):
            self.push(element, withId: id, addToBackStack: addToBackStack)
        case .sheet:
            self.presentSheet(element)
        case .fullSheet:
            if #available(iOS 14.0, *) {
                self.presentFullSheet(element)
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

    /// Navigates to a view.
    /// - Parameters:
    ///   - element: The destination view.
    ///   - identifier: The ID of the destination view (used to easily come back to it if needed).
    public func push<Element: View>(
            _ element: Element,
            withId identifier: String? = nil,
            addToBackStack: Bool = true) {
        withAnimation(easeAnimation) {
            navigationType = .push
            let id = identifier == nil ? UUID().uuidString : identifier!
            let element = BackStackElement(
                    id: id,
                    wrappedElement: AnyView(element),
                    type: isPresentingSheet ? .sheet : .screen,
                    addToBackStack: addToBackStack)
            backStack.push(element)
        }
    }

    public func presentSheet<Content: View>(_ content: Content) {
        createSheetView(content)
        presentSheet = true
    }

    @available(iOS 14.0, *)
    public func presentFullSheet<Content: View>(_ content: Content) {
        createSheetView(content)
        presentFullSheetView = true
    }

    private func createSheetView<Content: View>(_ content: Content) {
        if let tmp = currentView {
            sheetRoot = BackStackElement(
                    id: tmp.id,
                    wrappedElement: tmp.wrappedElement,
                    type: tmp.type,
                    addToBackStack: tmp.addToBackStack)
        }

        // Pass self as a Navigator to allow dismissing from the sheet
        sheetView = AnyView(NavigatorView(navigator: self) {
            content
        })
        let element = BackStackElement(
                id: UUID().uuidString,
                wrappedElement: AnyView(content),
                type: .sheet,
                addToBackStack: true)
        backStack.push(element)
    }

}

extension Navigator {

    public func dismissSheet() {
        sheetRoot = nil
        backStack.popSheet()
        presentSheet = false
        presentFullSheetView = false
        sheetView = nil
    }

    /// Pop back stack.
    /// - Parameter to: The destination type of the transition operation.
    public func dismiss(
            to destination: DismissDestination = .previous,
            delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.dismiss(to: destination)
        }
    }

    public func dismiss(to destination: DismissDestination = .previous) {
        withAnimation(easeAnimation) {
            navigationType = isPresentingSheet ? .none : .pop

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

        // Dismiss the sheet only if there are no elements in back stack to allow navigating back
        // inside the sheet
        if backStack.isEmpty {
            dismissSheet()
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


