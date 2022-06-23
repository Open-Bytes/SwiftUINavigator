//
// Created by Shaban on 23/06/2022.
//

import SwiftUI

public enum SheetType {
    case normal(width: CGFloat? = nil, height: CGFloat? = nil)
    @available(iOS 14.0, *)
    case full
    case fixedHeight(height: CGFloat, minHeight: CGFloat = 0, isDismissable: Bool = true)
}