//
// Created by Shaban on 23/06/2022.
//

import SwiftUI

public enum SheetType {
    #if os(macOS)
    case normal(width: CGFloat, height: CGFloat)
    #else
    case normal
    #endif

    #if os(iOS)
    @available(iOS 14.0, *)
    case full
    #endif

    @available(macOS, unavailable)
    case fixedHeight(
            FixedHeightType,
            isDismissable: Bool = true,
            presenter: FixedSheetPresenter = .rootController)
}

public enum FixedHeightType {
    case value(CGFloat)
    case ratio(Double)

    public var height: CGFloat {
        switch self {
        case .value(let value):
            return value
        case .ratio(let value):
            var ratio = value
            if value > 100 {
                ratio = 100
            }
            if value < 1 {
                ratio = 1
            }
            let percent = ratio / 100
            let height = screenHeight() * percent
            return height
        }
    }
}

public enum FixedSheetPresenter {
    case rootController
    case topController
    #if os(iOS)
    case controller(UIViewController)

    public var controller: UIViewController? {
        switch self {
        case .rootController:
            return UIApplication.shared.rootController
        case .topController:
            return UIApplication.shared.topViewController()
        case .controller(let controller):
            return controller
        }
    }
    #endif
}

public enum DismissSheetType {
    case normal
    case full
    case fixedHeight
}