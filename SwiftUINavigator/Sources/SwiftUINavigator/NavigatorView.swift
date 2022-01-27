//
// Created by Shaban Kamel on 25/12/2021.
//

import SwiftUI

/// The alternative of SwiftUI NavigationView implementing
/// stack-based navigation with mote control and flexibility in handling
/// the navigation
public struct NavigatorView<Root>: View where Root: View {
    @ObservedObject private var navigator: Navigator
    private let rootView: Root
    private let transition: NavigatorTransition

    /// Creates a NavigatorView.
    /// - Parameters:
    ///   - transitionType: The type of transition to apply between views in every push and pop operation.
    ///   - animation: The easing function to apply to every push and pop operation.
    ///   - rootView: The very first view in the Navigation.
    public init(
            transition: NavigatorTransitionType = .default,
            easeAnimation: Animation = .easeOut(duration: 0.2),
            showDefaultNavBar: Bool = true,
            @ViewBuilder rootView: () -> Root) {
        self.transition = transition.transition
        navigator = Navigator(easeAnimation: easeAnimation, showDefaultNavBar: showDefaultNavBar)
        self.rootView = rootView()
    }

    init(
            navigator: Navigator,
            transition: NavigatorTransitionType = .default,
            showDefaultNavBar: Bool,
            @ViewBuilder rootView: () -> Root) {
        self.navigator = navigator
        self.transition = transition.transition
        navigator.showDefaultNavBar = showDefaultNavBar
        self.rootView = rootView()
    }

    public var body: some View {
        ZStack {
            Group {
                BodyContent()
            }
                    .transition(transition.transition(of: navigator.lastNavigationType))
                    .environmentObject(navigator)
        }
    }


    private func BodyContent() -> some View {
        Group {
            if #available(iOS 14.0, *) {
                SheetView()
                        .fullScreenCover(
                                isPresented: $navigator.presentFullSheetView,
                                onDismiss: {
                                    onDismissSheet()
                                }) {
                            LazyView(navigator.sheet)
                        }
            } else {
                SheetView()
            }
        }
    }

    private func SheetView() -> some View {
        Content()
                .sheet(
                        isPresented: $navigator.presentSheet,
                        onDismiss: {
                            onDismissSheet()
                        }) {
                    LazyView(navigator.sheet)
                }
    }

    private func Content() -> some View {
        Group {
            if let view = navigator.currentView {
                CurrentView(view)
            } else {
                RootView()
            }
        }
    }

    private func RootView() -> some View {
        rootView
                .id("ROOT")
                .environmentObject(navigator)
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