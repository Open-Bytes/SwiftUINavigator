//
// Created by Shaban on 10/11/2022.
//

import SwiftUINavigator

public enum ChipGroupType: Hashable {
    case push
    case sheet(type: SheetType)
    case actionSheet
    case confirmationDialog

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .push:
            hasher.combine("push")
        case .sheet(let value):
            switch value {
            case .normal:
                hasher.combine("normal")
            case .full:
                hasher.combine("full")
            case let .fixedHeight(height, _, _):
                switch height {
                case .value:
                    hasher.combine("fixedHeight")
                case .ratio:
                    hasher.combine("fixedHeightRatio")
                }
            }
        case .actionSheet:
            hasher.combine("actionSheet")
        case .confirmationDialog:
            hasher.combine("confirmationDialog")
        }
    }

    public static func ==(lhs: ChipGroupType, rhs: ChipGroupType) -> Bool {
        switch (lhs, rhs) {
        case (.push, .push),
             (.sheet, .sheet):
            return true
        default:
            return false
        }
    }
}
