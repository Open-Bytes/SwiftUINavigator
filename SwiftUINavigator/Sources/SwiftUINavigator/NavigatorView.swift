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

    /// Creates a NavigatorView.
    /// - Parameters:
    ///   - transition: The type of transition to apply between views in every push and pop operation.
    ///   - easeAnimation: The easing function to apply to every push and pop operation.
    ///   - showDefaultNavBar: if false, no nav bar will be displayed.
    ///   - rootView: The very first view in the Navigation.
    public init(
            transition: NavigatorTransition = .default,
            easeAnimation: Animation = .easeOut(duration: 0.2),
            showDefaultNavBar: Bool = true,
            @ViewBuilder rootView: () -> Root) {
        let navigator = Navigator.instance(
                easeAnimation: easeAnimation,
                showDefaultNavBar: showDefaultNavBar,
                transition: transition)
        self.init(navigator: navigator,
                showDefaultNavBar: showDefaultNavBar,
                rootView: rootView)
    }

    init(
            navigator: Navigator,
            showDefaultNavBar: Bool,
            @ViewBuilder rootView: () -> Root) {
        self.navigator = navigator
        manager = navigator.manager
        self.rootView = rootView()
    }

    public var body: some View {
        ZStack {
            Group {
                BodyContent()
            }
                    .environmentObject(navigator)
                    .zIndex(1)
        }
    }

    private func BodyContent() -> some View {
        Group {
            #if os(macOS)
            SheetView()
            #else
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
            #endif
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
                    manager.sheet.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
    }

    private func Content() -> some View {
        Group {
            RootView()
            ForEach(Array(manager.stackItems.enumerated()), id: \.offset) { index, item in
                item.wrappedElement
                        .id(item.id)
                        .zIndex(Double(index + 1))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        manager.onDismissSheet?()
        manager.onDismissSheet = nil
    }

}