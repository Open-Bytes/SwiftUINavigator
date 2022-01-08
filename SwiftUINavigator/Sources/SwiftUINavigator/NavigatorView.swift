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
        case .child: return false
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
            @ViewBuilder rootView: () -> Root) {
        navigator = Navigator(easeAnimation: easeAnimation)
        self.rootView = rootView()
        self.transition = transition.transition
        type = .root
    }

    public init(
            navigator: Navigator,
            transition: NavigatorTransitionType = .default,
            easeAnimation: Animation = .easeOut(duration: 0.2),
            @ViewBuilder rootView: () -> Root) {
        self.rootView = rootView()
        self.navigator = navigator
        self.transition = transition.transition
        type = .child
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
                    .transition(transition.transition(of: navigator.navigationType))
                    .environmentObject(navigator)
        }
    }

    private func BodySheetContent() -> some View {
       Group {
           if #available(iOS 14.0, *) {
               Content()
                       .sheet(
                               isPresented: $navigator.presentSheet,
                               onDismiss: {
                                   navigator.dismissSheet()
                               }) {
                           LazyView(navigator.sheetView)
                       }
                       .fullScreenCover(
                               isPresented: $navigator.presentFullSheetView,
                               onDismiss: {
                                   navigator.dismissSheet()
                               }) {
                           LazyView(navigator.sheetView)
                       }
           } else {
               Content()
                       .sheet(
                               isPresented: $navigator.presentSheet,
                               onDismiss: {
                                   navigator.dismissSheet()
                               }) {
                           LazyView(navigator.sheetView)
                       }
           }
       }
    }

    private func Content() -> some View {
        Group {
            // Show sheet root in case this is the root navigator view & there's a sheet
            // presented
            if canShowSheets && navigator.isPresentingSheet {
                SheetRoot()
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

    enum ViewType {
        case root
        case child
    }

}
