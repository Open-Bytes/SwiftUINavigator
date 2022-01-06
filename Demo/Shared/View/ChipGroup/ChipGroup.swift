//
// Created by Shaban Kamel on 27/12/2021.
//

import Foundation

import SwiftUI


public struct ChipGroup: View {
    private let items: [Item]
    private let onItemTapped: (Item) -> Void
    @State var selected = false
    @Binding private var selectedItems: [ChipGroup.Item]
    private let selectionType: SelectionType

    public init(items: [Item],
                selectionType: SelectionType = .single,
                selectedItems: Binding<[ChipGroup.Item]>,
                onItemTapped: @escaping (Item) -> Void) {
        self.items = items
        self.selectionType = selectionType
        _selectedItems = selectedItems
        self.onItemTapped = onItemTapped
    }

    public var body: some View {
        FlexibleView(
                availableWidth: UIScreen.main.bounds.width - 120,
                data: items,
                spacing: 15,
                alignment: .leading
        ) { (item: Item) in
            Button(action: {
                selectItem(item)
                onItemTapped(item)
            }, label: {
                Text(item.name)
                        .padding(.all, 5)
                        .foregroundColor(selectedItems.contains(item) ? Color.white : Color.gray)
            })
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background(
                            Capsule()
                                    .fill(selectedItems.contains(item) ? Color.green : Color.gray.opacity(0.2))
                    )
        }
                .padding(.horizontal, 30)
                .padding(.leading, 5)
                .padding(.trailing, 10)
    }

    private func selectItem(_ item: Item) {
        switch selectionType {
        case .single:
            selectedItems.removeAll()
            selectedItems.append(item)
        case .multi:
            if selectedItems.contains(item) {
                selectedItems.removeAll {
                    $0.id == item.id
                }
                return
            }

            selectedItems.append(item)
        }
    }
}

extension ChipGroup {

    public struct Item: Identifiable, Hashable {
        public let id: String
        public let name: String
    }

    public enum SelectionType {
        case single
        case multi
    }

}
