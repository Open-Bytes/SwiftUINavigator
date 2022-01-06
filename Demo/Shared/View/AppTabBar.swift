//
//  TCTabBar.swift
//  EcommerceTemplate
//
//  Created by Shaban on 03/01/2022.
//  Copyright © 2022 Shaban. All rights reserved.
//

import SwiftUI

struct TabItem<CONTENT: View>: Identifiable {
    let id = UUID().uuidString
    let content: () -> CONTENT
    let image: Image

    init(image: Image, @ViewBuilder content: @escaping () -> CONTENT) {
        self.image = image
        self.content = content
    }
}

struct AppTabBar: View {
    @State var selectedTab: String? = nil
    let tabs: [TabItem<AnyView>]

    var body: some View {
        ZStack(alignment: .center) {
            Content()
            Tabs()
        }
    }

    private func Content() -> some View {
        tabs.first {
            $0.id == selectedId
        }?.content()
    }

    private func Tabs() -> some View {
        VStack {
            Spacer()
            VStack(alignment: .center, spacing: 0) {
                Divider()
                TabItem()
            }
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: -2)

        }.edgesIgnoringSafeArea(.bottom)
    }

    private func TabItem() -> some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
            let selected = selectedId
            ForEach(tabs) { item in
                item.image
                        .foregroundColor(item.id == selected ? Color.black : Color.gray.opacity(0.7))
                        .onTapGesture {
                            self.selectedTab = item.id
                        }
                Spacer()
            }
        }
                .padding(.top, 20)
                .padding(.bottom, 50)
    }

    private var selectedId: String {
        guard let selected = selectedTab else {
            return tabs[0].id
        }
        return selected
    }
}