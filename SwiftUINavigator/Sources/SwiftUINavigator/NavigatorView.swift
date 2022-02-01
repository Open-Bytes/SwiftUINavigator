//
// Created by Shaban Kamel on 25/12/2021.
//

import SwiftUI

/// The alternative of SwiftUI NavigationView implementing
/// stack-based navigation with mote control and flexibility in handling
/// the navigation
public struct NavigatorView<Root>: View where Root: View {
    @ObservedObject private var manager: NavManager
    private var navigator: Navigator
    private let rootView: Root
    private let transition: NavigatorTransition
    @State var isPresentingSheet: Bool = false
    @State var isPresentingFullScreen: Bool = false
    /// Creates a NavigatorView.
    /// - Parameters:
    ///   - transition: The type of transition to apply between views in every push and pop operation.
    ///   - easeAnimation: The easing function to apply to every push and pop operation.
    ///   - showDefaultNavBar: if false, no nav bar will be displayed.
    ///   - rootView: The very first view in the Navigation.
    public init(
            transition: NavigatorTransitionType = .default,
            easeAnimation: Animation = .easeOut(duration: 0.2),
            showDefaultNavBar: Bool = true,
            @ViewBuilder rootView: () -> Root) {
        let navigator = Navigator.instance(
                easeAnimation: easeAnimation,
                showDefaultNavBar: showDefaultNavBar)
        self.init(navigator: navigator,
                transition: transition,
                showDefaultNavBar: showDefaultNavBar,
                rootView: rootView)
    }

    init(
            navigator: Navigator,
            transition: NavigatorTransitionType = .default,
            showDefaultNavBar: Bool,
            @ViewBuilder rootView: () -> Root) {
        self.navigator = navigator
        self.transition = transition.transition
        self.rootView = rootView()
        manager = navigator.manager
        manager.showDefaultNavBar = showDefaultNavBar
    }

    public var body: some View {
        ZStack {
            Group {
                BodyContent()
            }
                    .transition(transition.transition(of: manager.lastNavigationType))
                    .environmentObject(navigator)
        }
    }

    private func BodyContent() -> some View {
        Group {
            if #available(iOS 14.0, *) {
                SheetView()
                        .fullScreenCover(
                                isPresented: $manager.presentFullSheet,
                                onDismiss: {
                                    onDismissSheet()
                                }) {
                            LazyView(manager.sheet)
                        }
            } else {
                SheetView()
            }
        }
    }

    private func SheetView() -> some View {
        Content()
                .bottomSheet(
                        isPresented: $manager.presentCustomSheet,
                        height: manager.customSheetOptions.height,
                        minHeight: manager.customSheetOptions.minHeight,
                        isDismissable: manager.customSheetOptions.isDismissable,
                        onDismiss: {
                            onDismissSheet()
                        }) {
                    LazyView(manager.sheet)
                }
                .sheet(
                        isPresented: $manager.presentSheet,
                        onDismiss: {
                            onDismissSheet()
                        }) {
                    LazyView(manager.sheet)
                }
    }

    private func Content() -> some View {
        Group {
            if let view = manager.currentView {
                CurrentView(view)
            } else {
                RootView()
            }
        }
    }

    private func RootView() -> some View {
        rootView.id("ROOT")
    }

    private func CurrentView(_ view: BackStackElement) -> some View {
        view.wrappedElement.id(view.id)
    }

}

extension NavigatorView {

    private func onDismissSheet() {
        navigator.dismissSheet()
    }

}