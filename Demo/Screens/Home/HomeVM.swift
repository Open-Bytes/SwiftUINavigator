//
// Created by Shaban on 10/11/2022.
//

import SwiftUINavigator

class HomeVM: ObservableObject {
    @Published var navigationOption: NavType = .push()
    @Published var selectedNavigationOptions: [ChipGroup.Item] = []

    lazy var navigationOptions: [ChipGroup.Item] = {
        #if os(macOS)
        [
            ChipGroup.Item(type: .push, name: "Push"),
            ChipGroup.Item(type: .sheet(type: .normal(width: 500, height: 500)), name: "Normal Sheet"),
            ChipGroup.Item(type: .actionSheet, name: "Action Sheet", isSelectable: false),
            ChipGroup.Item(type: .confirmationDialog, name: "Confirmation Dialog", isSelectable: false)
        ]
        #else
        [
            ChipGroup.Item(type: .push, name: "Push"),
            ChipGroup.Item(type: .sheet(type: .normal), name: "Normal Sheet"),
            ChipGroup.Item(type: .sheet(type: .fixedHeight(.value(screenHeight() / 2))), name: "Fixed Sheet"),
            ChipGroup.Item(type: .sheet(type: .fixedHeight(.ratio(70))), name: "Fixed Sheet (Ratio)"),
            ChipGroup.Item(type: .actionSheet, name: "Action Sheet", isSelectable: false),
            ChipGroup.Item(type: .confirmationDialog, name: "Confirmation Dialog", isSelectable: false)
        ]
        #endif
    }()

}
