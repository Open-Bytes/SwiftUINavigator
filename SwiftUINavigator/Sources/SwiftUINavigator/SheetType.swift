//
// Created by Shaban on 23/06/2022.
//

import SwiftUI

public enum SheetType {
    case normal
    @available(iOS 14.0, *)
    case full
    case fixedHeight(
            height: CGFloat,
            isDismissable: Bool = true,
            presenter: FixedSheetPresenter = .rootController)
    case fixedHeightRatio(
            ratio: Double,
            isDismissable: Bool = true,
            presenter: FixedSheetPresenter = .rootController)
}


public enum FixedSheetPresenter {
    case rootController
    case topController
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
}


public enum DismissSheetType {
    case normal
    case full
    case fixedHeight
}