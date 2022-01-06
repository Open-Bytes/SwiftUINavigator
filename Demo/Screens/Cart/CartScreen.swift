//
//  CartScreen.swift
//  EcommerceTemplate
//
//  Created by Shaban on 03/01/2022.
//  Copyright © 2022 Shaban. All rights reserved.
//

import SwiftUI
import SwiftUINavigator

struct CartScreen: View {
    @State var items: Cart = .shared
    @State private var isEditing: Bool = false

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Header()

            ScrollView(.vertical, showsIndicators: true) {
                ItemsView()
                FooterView()
                CheckoutButton()
            }
        }
                .navBar(
                        style: .normal,
                        leadingView: {
                            DismissLink {
                                HStack {
                                    Image(systemName: "chevron.backward").foregroundColor(.blue)
                                    Text("Back").foregroundColor(.blue)
                                }
                            }.buttonStyle(PlainButtonStyle())
                                    .eraseToAnyView
                        }
                )
    }

    private func Header() -> some View {
        ZStack {
            HeaderTitle()
            HStack {
                Spacer()
                EditButton()
            }
        }.padding(.bottom, 10)
    }

    private func HeaderTitle() -> some View {
        VStack(alignment: .center, spacing: 4) {
            Text("Your Cart")
                    .font(Font.system(size: 16, weight: .bold, design: .rounded))
            Text("\(items.items.count) Item\(items.items.count == 1 ? "" : "s")")
                    .font(Font.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.gray)
        }
    }

    private func EditButton() -> some View {

        Button(action: {
            withAnimation {
                self.isEditing = !isEditing
            }
        }) {
            if isEditing {
                Text("Done")
                        .font(Font.system(size: 16, weight: .bold, design: .rounded))
                        .padding(.trailing, 20)
            } else {
                Image(systemName: "ellipsis")
                        .padding(.trailing, 20)
            }

        }.foregroundColor(Color(red: 111 / 255, green: 115 / 255, blue: 210 / 255))
    }

    private func ItemsView() -> some View {
        ForEach(items.items, id: \.uuid) { item in
            HStack {
                CartItemView(item: item)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)

                if isEditing {
                    Button(action: {
                        items.items.removeAll { (prod) -> Bool in
                            prod.uuid == item.uuid
                        }
                    }) {
                        Image(systemName: "trash.fill")
                                .padding(.trailing, 20)
                    }.foregroundColor(Color.red)
                }
            }
        }
    }

    private func FooterView() -> some View {
        HStack(alignment: .center, spacing: 12) {
            ShippingView()
            TotalView()
            Spacer()
        }
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
    }

    private func ShippingView() -> some View {
        VStack(alignment: .center, spacing: 4) {
            Image("Shipping_Icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20, alignment: .center)
            Text("FREE")
                    .font(Font.system(size: 14, weight: .semibold, design: .rounded))
        }
                .frame(width: 60, height: 60, alignment: .center)
                .background(Color(red: 124 / 255, green: 234 / 255, blue: 156 / 255))
                .cornerRadius(10)
    }

    private func TotalView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Total:")
                    .foregroundColor(Color.gray)
                    .font(Font.system(size: 14, weight: .semibold, design: .default))
            Text("$\(String(format: "%.2f", items.total))")
                    .font(Font.system(size: 20, weight: .heavy, design: .rounded))
        }
    }

    private func CheckoutButton() -> some View {
        Button(action: {
        }) {
            if items.items.isEmpty {
                NoItemsView()
            } else {
                ConfirmButton()
            }
        }
                .padding(.top, 20)
                .padding(.bottom, 100)
    }

    private func ConfirmButton() -> some View {
        HStack(alignment: .center, spacing: 12) {
            Text("Confirm Transaction")
            Image(systemName: "arrow.right")
        }
                .frame(width: .infinity, height: 60, alignment: .center)
                .foregroundColor(Color.white)
                .font(Font.system(size: 17, weight: .semibold, design: .rounded))
                .padding(.horizontal, 20)
                .background(Color(red: 111 / 255, green: 115 / 255, blue: 210 / 255))
                .cornerRadius(10)
    }

    private func NoItemsView() -> some View {
        HStack(alignment: .center, spacing: 12) {
            Text("Cart Empty")
            Image(systemName: "xmark")
        }
                .frame(width: .infinity, height: 60, alignment: .center)
                .foregroundColor(Color.white)
                .font(Font.system(size: 17, weight: .semibold, design: .rounded))
                .padding(.horizontal, 20)
                .background(Color.gray)
                .cornerRadius(10)
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartScreen()
    }
}
