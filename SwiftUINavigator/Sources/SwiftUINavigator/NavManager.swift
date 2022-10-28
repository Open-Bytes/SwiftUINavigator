//
//  Navigator.swift
//  
//
//  Created by Shaban on 03/01/2022.
//

import SwiftUI

public class NavManager: ObservableObject {
    let transition: NavTransition

    var lastNavigationType = NavigationDirection.pop
    private let easeAnimation: Animation
    @Published var currentView: BackStackElement?
    @Published var presentSheet: Bool = false
    @Published var presentFullSheet: Bool = false
    @Published var presentFixedHeightSheet: Bool = false
    var onDismissSheet: (() -> Void)? = nil
    var sheet: AnyView? = nil
    var showDefaultNavBar: Bool = true
    var root: NavManager?
    var customSheetOptions = CustomSheetOptions(height: 0, isDismissable: false)

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
                transition: NavTransition) {
        self.root = root
        self.easeAnimation = easeAnimation
        self.showDefaultNavBar = showDefaultNavBar
        self.transition = transition
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
            presentSheet(
                    type: type,
                    showDefaultNavBar: showDefaultNavBar ?? false,
                    onDismiss: nil,
                    content: { element })
        }
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

    private func addNavBar<Element: View>(_ element: Element, showDefaultNavBar: Bool?) -> AnyView {
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

extension NavManager {

    public func presentSheet<Content: View>(
            type: SheetType,
            showDefaultNavBar: Bool,
            onDismiss: (() -> Void)?,
            content: () -> Content) {
        onDismissSheet = onDismiss
        switch type {
        case .normal:
            presentSheet(
                    content(),
                    type: type,
                    width: nil,
                    height: nil,
                    showDefaultNavBar: showDefaultNavBar)
        case .full:
            if #available(iOS 14.0, *) {
                presentSheet(
                        content(),
                        type: type,
                        width: nil,
                        height: nil,
                        showDefaultNavBar: showDefaultNavBar)
            }
        case let .fixedHeight(height, isDismissable):
            customSheetOptions = CustomSheetOptions(
                    height: height,
                    isDismissable: isDismissable)
            presentSheet(
                    content(),
                    type: type,
                    width: nil,
                    height: height,
                    showDefaultNavBar: showDefaultNavBar)
        case let .fixedHeightRatio(ratio, isDismissable):
            let ratioPercent = ratio / 100
            let height = UIScreen.screenHeight * ratioPercent
            customSheetOptions = CustomSheetOptions(
                    height: height,
                    isDismissable: isDismissable)
            presentSheet(
                    content(),
                    type: type,
                    width: nil,
                    height: height,
                    showDefaultNavBar: showDefaultNavBar)
        }
    }

    private func presentSheet<Content: View>(
            _ content: Content,
            type: SheetType,
            width: CGFloat?,
            height: CGFloat?,
            showDefaultNavBar: Bool) {
        sheet = sheetView(
                content,
                width: width,
                height: height,
                showDefaultNavBar: showDefaultNavBar
        ).eraseToAnyView()

        switch type {
        case .normal:
            presentSheet = true
        case .full:
            presentFullSheet = true
        case .fixedHeight,
             .fixedHeightRatio:
            #if os(macOS)
            presentFixedHeightSheet = true
            #else
            withAnimation(easeAnimation) {
                presentSheetController(
                        isDismissable: customSheetOptions.isDismissable,
                        content: sheet?.frame(height: customSheetOptions.height)
                )
            }
            #endif
        }
    }

    private func sheetView<Content: View>(
            _ content: Content,
            width: CGFloat?,
            height: CGFloat?,
            showDefaultNavBar: Bool) -> some View {
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
        let content = NavView(
                navigator: navigator,
                showDefaultNavBar: showDefaultNavBar,
                rootView: { content }
        )
                .frame(width: width, height: height)
        return addNavBar(content, showDefaultNavBar: showDefaultNavBar)
                .environmentObject(navigator)
    }
}

extension NavManager {

    public func dismissSheet(type: DismissSheetType?) {
        guard let type = type else {
            root?.presentSheet = false
            root?.presentFullSheet = false
            root?.presentFixedHeightSheet = false
            root?.sheet = nil
            dismissController()
            return
        }
        switch type {
        case .normal:
            root?.presentSheet = false
        case .full:
            root?.presentFullSheet = false
        case .fixedHeight:
            root?.presentFixedHeightSheet = false
            dismissController()
        }
        root?.sheet = nil
    }

    public func dismiss(to destination: DismissDestination) {
        dismissController()

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

    private func dismissController() {
        #if os(iOS)
        // For dismissing the custom sheet which is displayed in a controller
        UIApplication.shared.topController?.dismiss(animated: false)
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



