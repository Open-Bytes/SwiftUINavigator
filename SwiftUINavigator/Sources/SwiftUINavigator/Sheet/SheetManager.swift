//
// Created by Shaban on 08/11/2022.
//

import SwiftUI

class SheetManager: ObservableObject {
    var easeAnimation: Animation {
        navManager.easeAnimation
    }
    var transition: NavTransition {
        navManager.transition
    }
    var navManager: NavManager!

    @Published var presentSheet: Bool = false
    @Published var presentFullSheet: Bool = false
    @Published var presentFixedHeightSheet: Bool = false
    var onDismissSheet: (() -> Void)? = nil
    var sheet: AnyView? = nil
    var sheetArgs = SheetArguments(
            height: 0,
            isDismissable: false)
    private var fixedSheetPresenter: UIViewController? = nil

    func presentSheet<Content: View>(
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
        case .fixedHeight:
            presentSheet(
                    content(),
                    type: type,
                    width: nil,
                    height: nil,
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
        case let .fixedHeight(type, isDismissable, presenter):
            fixedSheetPresenter = presenter.controller
            presentFixedSheet(
                    height: type.height,
                    isDismissable: isDismissable,
                    presenter: presenter)
        }
    }

    private func presentFixedSheet(
            height: CGFloat,
            isDismissable: Bool,
            presenter: FixedSheetPresenter) {
        #if os(macOS)
        presentFixedHeightSheet = true
        #else
        withAnimation(easeAnimation) {
            presentSheetController(
                    presenter: presenter,
                    isDismissable: isDismissable,
                    content: sheet?.frame(height: height)
            )
        }
        #endif
    }

    private func sheetView<Content: View>(
            _ content: Content,
            width: CGFloat?,
            height: CGFloat?,
            showDefaultNavBar: Bool) -> some View {
        let manager = NavManager(
                root: navManager,
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
        return navManager.addNavBar(content, showDefaultNavBar: showDefaultNavBar)
                .environmentObject(navigator)
    }
}

extension SheetManager {

    func dismissSheet(type: DismissSheetType?) {
        guard let type = type else {
            presentSheet = false
            presentFullSheet = false
            presentFixedHeightSheet = false
            sheet = nil
            dismissFixedSheet()
            return
        }
        switch type {
        case .normal:
            presentSheet = false
        case .full:
            presentFullSheet = false
        case .fixedHeight:
            presentFixedHeightSheet = false
            dismissFixedSheet()
        }
        sheet = nil
    }

    private func dismissFixedSheet() {
        #if os(iOS)
        fixedSheetPresenter?.dismiss(animated: false)
        fixedSheetPresenter = nil
        #endif
    }
}