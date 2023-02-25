//
// Created by Shaban on 08/11/2022.
//

import SwiftUI

class SheetManager: ObservableObject {
    var navManager: NavManager!

    @Published var presentSheet: Bool = false {
        didSet {
            if !presentSheet {
                onDismissSheet?()
                onDismissSheet = nil
            }
        }
    }
    @Published var presentFullSheet: Bool = false {
        didSet {
            if !presentFullSheet {
                onDismissSheet?()
                onDismissSheet = nil
            }
        }
    }
    @Published var presentFixedHeightSheet: Bool = false {
        didSet {
            if !presentFixedHeightSheet {
                onDismissSheet?()
                onDismissSheet = nil
            }
        }
    }
    private var onDismissSheet: (() -> Void)? = nil
    var sheet: AnyView? = nil
    var sheetArgs = SheetArguments(
            height: 0,
            isDismissable: false)
}

extension SheetManager {

    func presentSheet<Content: View>(
            type: SheetType,
            onDismiss: (() -> Void)?,
            content: () -> Content) {
        onDismissSheet = onDismiss
        switch type {
            #if os(iOS)
        case .normal:
            presentSheet(
                    content(),
                    type: type,
                    width: nil,
                    height: nil)
            #else
        case let .normal(width, height):
            presentSheet(
                    content(),
                    type: type,
                    width: width,
                    height: height)
            #endif

            #if os(iOS)
        case .full:
            if #available(iOS 14.0, *) {
                presentSheet(
                        content(),
                        type: type,
                        width: nil,
                        height: nil)
            }
            #endif

        case .fixedHeight:
            presentSheet(
                    content(),
                    type: type,
                    width: nil,
                    height: nil)
        }
    }

    private func presentSheet<Content: View>(
            _ content: Content,
            type: SheetType,
            width: CGFloat?,
            height: CGFloat?) {
        sheet = sheetView(
                content,
                width: width,
                height: height
        ).eraseToAnyView()

        switch type {
        case .normal:
            presentSheet = true

            #if os(iOS)
        case .full:
            presentFullSheet = true
            #endif

            #if os(iOS)
        case let .fixedHeight(type, isDismissable, presenter):
            FixedSheetPresenter.current = presenter
            presentFixedSheet(
                    height: type.height,
                    isDismissable: isDismissable,
                    presenter: presenter)
            #endif
        }
    }

    private func presentFixedSheet(
            height: CGFloat,
            isDismissable: Bool,
            presenter: FixedSheetPresenter) {
        presentFixedHeightSheet = true
        withAnimation(navManager.options.easeAnimation) {
            presentSheetController(
                    presenter: presenter,
                    isDismissable: isDismissable,
                    content: sheet?.frame(height: height)
            )
        }
    }

    private func sheetView<Content: View>(
            _ content: Content,
            width: CGFloat?,
            height: CGFloat?) -> some View {
        let navView = NavBuilder.navView(
                root: navManager,
                options: navManager.options,
                content: content)
        return navView.frame(width: width, height: height)
    }

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
        FixedSheetPresenter.current.controller?.dismiss(animated: false)
        FixedSheetPresenter.current = .rootController
        #endif
    }
}