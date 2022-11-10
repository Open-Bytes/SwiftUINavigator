//
// Created by Shaban on 10/11/2022.
//

import SwiftUINavigator

public enum ChipGroupType {
    case push
    case sheet(type: SheetType)
    case actionSheet
    case confirmationDialog
    case alert
    case dialog
}
