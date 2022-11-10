//
// Created by Shaban on 25/05/2022.
//

import SwiftUI

#if os(iOS)
extension UIApplication {

    var rootController: UIViewController? {
        mainWindow?.rootViewController
    }

    func topViewController(controller: UIViewController? = UIApplication.shared.mainWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController, let selected = tabController.selectedViewController {
            return topViewController(controller: selected)
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }

    var mainWindow: UIWindow? {
        UIApplication.shared.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .map({ $0 as? UIWindowScene })
                .compactMap({ $0 })
                .first?.windows
                .filter({ $0.isKeyWindow }).last
    }

    var bottomAnchor: CGFloat {
        mainWindow?.safeAreaInsets.bottom ?? 0
    }

    var topAnchor: CGFloat {
        mainWindow?.safeAreaInsets.top ?? 0
    }
}
#endif
