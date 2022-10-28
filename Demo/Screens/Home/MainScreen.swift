//
//  HomeScreen.swift
//  EcommerceTemplate
//
//  Created by Shaban on 03/01/2022.
//  Copyright © 2022 Shaban. All rights reserved.
//

import SwiftUI
import SwiftUINavigator

struct MainScreen: View {
    @State var cart: Cart = .shared

    var body: some View {
        AppTabBar(
                tabs: [
                    TabItem(image: Image(systemName: "house.fill")) {
                        HomeScreen(items: Fake.products).eraseToAnyView
                    },
                    TabItem(image: Image(systemName: "cart.fill")) {
                        CartScreen().eraseToAnyView
                    },
                    TabItem(image: Image(systemName: "heart.fill")) {
                        HomeScreen(items: Favorites.shared.items).eraseToAnyView
                    },
                    TabItem(image: Image(systemName: "gear")) {
                        SettingsScreen().eraseToAnyView
                    }
                ])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}

extension View {
    var eraseToAnyView: AnyView {
        AnyView(self)
    }
}
