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
            isDismissable: Bool = true)
    case fixedHeightRatio(
            ratio: Double,
            isDismissable: Bool = true)
}

public enum DismissSheetType {
    case normal
    case full
    case fixedHeight
}