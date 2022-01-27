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
    private var canShowSheets: Bool {
        switch type {
        case .root: return true
        case .sheet: return false
        }
    }
    private let type: ViewType

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
        type = .root
    }

    public init(
            navigator: Navigator,
            transition: NavigatorTransitionType = .default,
            showDefaultNavBar: Bool,
            @ViewBuilder rootView: () -> Root) {
        self.navigator = navigator
        self.transition = transition.transition
        navigator.showDefaultNavBar = showDefaultNavBar
        self.rootView = rootView()
        type = .sheet
    }

    public var body: some View {
        ZStack {
            Group {
                if canShowSheets {
                    BodySheetContent()
                } else {
                    Content()
                }
            }
                    .transition(transition.transition(of: navigator.lastNavigationType))
                    .environmentObject(navigator)
        }
    }


    private func BodySheetContent() -> some View {
        Group {
            if #available(iOS 14.0, *) {
                SheetView()
                        .fullScreenCover(
                                isPresented: $navigator.presentFullSheetView,
                                onDismiss: {
                                    onDismissSheet()
                                }) {
                            LazyView(navigator.sheetView)
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
                    LazyView(navigator.sheetView)
                }
    }

    private func Content() -> some View {
        Group {
            // Show sheet root in case this is the root navigator view & there's a sheet
            // presented
            if type.isRoot && navigator.isPresentingSheet {
                SheetRoot()
            }
            // This case when the sheet is dismissing. We should keep the last view as is until
            // it's dismissed.
            else if type.isSheet, !navigator.isPresentingSheet, let view = navigator.lastView {
                CurrentView(view)
            } else if let view = navigator.currentView {
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

    private func SheetRoot() -> some View {
        Group {
            if let view = navigator.sheetRoot {
                CurrentView(view)
            } else {
                RootView()
            }
        }
    }

}

extension NavigatorView {

    private func onDismissSheet() {
        guard navigator.isPresentingSheet else {
            return
        }
        navigator.dismissSheet()
    }

}

extension NavigatorView {

    enum ViewType {
        case root
        case sheet

        var isRoot: Bool {
            self == .root
        }

        var isSheet: Bool {
            self == .sheet
        }
    }

}
