//
// Created by Shaban Kamel on 25/12/2021.
//

import SwiftUI

public enum NavigationType {
    /// Regular navigation type.
    /// id: pass a custom ID to use when navigate back.
    /// addToBackStack: if false, the view won't be added to the back stack
    /// and won't be displayed when dismissing the view.
    case push(id: String? = nil, addToBackStack: Bool = true)
    /// Present a sheet
    case sheet(width: CGFloat? = nil, height: CGFloat? = nil)
    /// Present a full sheet
    @available(iOS 14.0, *)
    case fullSheet

    /// Present a custom sheet
    case customSheet(height: CGFloat, minHeight: CGFloat = 0, isDragDismissable: Bool = true)
}