//
//  ProductsScreen.swift
//  EcommerceTemplate
//
//  Created by Shaban on 03/01/2022.
//  Copyright © 2022 Shaban. All rights reserved.
//

import SwiftUI
import SwiftUINavigator

class HomeVM: ObservableObject {
    @Published var navigationOption: NavType = .push()
    @Published var selectedNavigationOptions: [ChipGroup.Item] = []
}


struct HomeScreen: View {
    @ObservedObject var vm: HomeVM = HomeVM()
    var cart: Cart = .shared
    private let items: [Product]
    @EnvironmentObject private var navigator: Navigator

    init(items: [Product]) {
        self.items = items
    }

    var body: some View {
        VStack {
            NavigationOptionsView()
            Content()
        }
    }

    private func Content() -> some View {
        ScrollView(.vertical, showsIndicators: true) {
            HStack(alignment: .top, spacing: 10) {
                let items: [[Product]] = items.split()

                if !items.isEmpty {
                    ItemsView(items: items[0])
                }

                if items.count == 2 {
                    ItemsView(items: items[1])
                }

                if items.isEmpty {
                    NoProductsView()
                }
            }
                    .padding()
        }
                .padding(.bottom, 50)
    }

    private func NoProductsView() -> some View {
        VStack(alignment: .center, spacing: 4) {
            Spacer()
            Image(systemName: "bag.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color.gray)
                    .frame(width: 40, height: 40, alignment: .center)
                    .padding(.bottom, 20)
            Text("No Products To Display")
                    .font(Font.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.gray)
            Spacer()
        }
                .padding(.bottom, 10)
    }

    private func ItemsView(items: [Product]) -> some View {
        VStack(alignment: .center, spacing: 8) {
            ForEach(items, id: \.uuid) { item in
                NavLink(
                        destination: ProductDetailScreen(item: item),
                        type: vm.navigationOption,
                        showDefaultNavBar: true,
                        onDismissSheet: {
                            print("Sheet dismissed.")
                        }) {
                    // When this view is clicked, it will trigger the navigation
                    ProductItemView(item: item)
                }
                        .buttonStyle(PlainButtonStyle())

                // It's also possible to use Navigator object directly to navigate
                if false {
                    ProductItemView(item: item).onTapGesture {
                                navigator.navigate(
                                        type: vm.navigationOption,
                                        onDismissSheet: {
                                            print("Sheet dismissed.")
                                        }) {
                                    ProductDetailScreen(item: item)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }

}

extension HomeScreen {
    private func NavigationOptionsView() -> some View {
        ChipGroup(
                items: navigationOptions,
                selectedItems: $vm.selectedNavigationOptions
        ) { item in
            switch item.type {
            case .push:
                vm.navigationOption = .push()
                break
            case .sheet(let type):
                vm.navigationOption = .sheet(type: type)
            }
        }
    }

    private var navigationOptions: [ChipGroup.Item] {
        #if os(macOS)
        [
            ChipGroup.Item(type: .push, name: "Push"),
            ChipGroup.Item(type: .sheet(type: .normal), name: "Normal Sheet"),
            ChipGroup.Item(type: .sheet(type: .full), name: "Full Sheet"),

        ]
        #else
        [
            ChipGroup.Item(type: .push, name: "Push"),
            ChipGroup.Item(type: .sheet(type: .normal), name: "Normal Sheet"),
            ChipGroup.Item(type: .sheet(type: .fixedHeight(.value(screenHeight() / 2))), name: "Fixed Sheet"),
            ChipGroup.Item(type: .sheet(type: .fixedHeight(.ratio(70))), name: "Fixed Sheet (Ratio)"),
        ]
        #endif
    }

}

public enum ChipGroupType: Hashable {
    case push
    case sheet(type: SheetType)

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


