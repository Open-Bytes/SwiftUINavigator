//
// Created by Shaban Kamel on 25/12/2021.
//

import Foundation

public enum NavigationType {
    /// Regular navigation type.
    /// id: pass a custom ID to use when navigate back.
    /// addToBackStack: if false, the view won't be added to the back stack
    /// and won't be displayed when dismissing the view.
    case push(id: String? = nil, addToBackStack: Bool = true, showDefaultNavBar: Bool? = nil)
    /// Present a sheet
    case sheet
    /// Present a full sheet
    @available(iOS 14.0, *)
    case fullSheet
}