//
// Created by Shaban Kamel on 27/12/2021.
//

import Foundation

import SwiftUI
import SwiftUINavigator

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
        VStack {
            ForEach(items) { item in
                Button(action: {
                    selectItem(item)
                    onItemTapped(item)
                }, label: {
                    Text(item.name)
                            .padding(.all, 5)
                            .foregroundColor(isSelected(item) ? Color.white : Color.gray)
                })
                        .padding(.horizontal, 10)
                        .padding(.vertical, 3)
                        .background(
                                Capsule()
                                        .fill(isSelected(item) ? Color.green : Color.gray.opacity(0.2))
                        )
            }
        }
    }

    private func isSelected(_ item: Item) -> Bool {
        selectedItems.first {
            $0.id == item.id
        } != nil
    }

    private func selectItem(_ item: Item) {
        guard item.isSelectable else {
            return
        }
        switch selectionType {
        case .single:
            selectedItems.removeAll()
            selectedItems.append(item)
        case .multi:
            if isSelected(item) {
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

    public struct Item: Identifiable {
        public let id: String = UUID().uuidString
        public let type: ChipGroupType
        public let name: String
        public var isSelectable: Bool = true
    }

    public enum SelectionType {
        case single
        case multi
    }

}