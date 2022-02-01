//
//  ProductDetailScreen.swift
//  EcommerceTemplate
//
//  Created by Shaban on 03/01/2022.
//  Copyright © 2022 Shaban. All rights reserved.
//

import SwiftUI
import SwiftUINavigator

struct ProductDetailScreen: View {
    @State var item: Product
    let cart: Cart = .shared
    let favorites: Favorites = .shared
    @State var isInCart: Bool = false
    @State var isFavorite: Bool = false
    @State private var showShareSheet = false
    @EnvironmentObject private var navigator: Navigator

    init(item: Product) {
        self.item = item
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 8) {
                ProductImage()

                TitleView()

                ButtonsView()

                DescriptionView()

                Divider()

                ReviewsTitleView()

                RatingView(
                        rating: item.rating,
                        primaryColor: Color.yellow,
                        secondaryColor: Color.gray
                )

                Divider()

                ReviewsView()
            }
                    .padding(.top, 16)
                    .padding(.bottom, 70)
        }
                .padding(.horizontal, 16)
                .background(Color.white)
                .sheet(isPresented: $showShareSheet) {
                    SharingSheet()
                }
                .onAppear(perform: {
                    setup()
                })
    }

    private func setup() {
        isInCart = cart.contains(item)
        isFavorite = favorites.contains(item)
    }

    private func SharingSheet() -> some View {
        Group {
            let text = "\(item.title)"
                    + " - "
                    + "$\(String(format: "%.2f", item.price))"
                    + " | "
                    + "\(item.description.prefix(100))"
                    + "..."
            ShareSheet(activityItems: [text])
        }
    }

    private func ProductImage() -> some View {
        item.image
                .resizable()
                .scaledToFill()
                .cornerRadius(15)
    }

    private func TitleView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(item.title)
                    .font(Font.system(size: 24, weight: .semibold, design: .rounded))
            Text("$\(String(format: "%.2f", item.price))")
                    .font(Font.system(size: 19, weight: .semibold, design: .rounded))
        }
    }

    private func ButtonsView() -> some View {
        HStack(alignment: .center, spacing: 0) {
            FavoriteButton()
            Spacer()
            ShareButton()
            Spacer()
            Spacer()
            SubmitButton()
        }
                .padding(.horizontal, 10)
                .padding(.vertical, 10)
    }

    private func FavoriteButton() -> some View {
        Button(action: {
            if isFavorite {
                favorites.remove(item)
                isFavorite = false
                return
            }
            favorites.add(item)
            isFavorite = true
        }) {
            if isFavorite {
                Image(systemName: "heart.fill")
                        .foregroundColor(Color.red)
                        .frame(width: 40, height: 40, alignment: .center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
            } else {
                Image(systemName: "heart")
                        .foregroundColor(Color.black)
                        .frame(width: 40, height: 40, alignment: .center)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
            }
        }
    }

    private func ShareButton() -> some View {
        Button(action: {
            self.showShareSheet = !showShareSheet
        }) {
            Image(systemName: "square.and.arrow.up")
                    .foregroundColor(Color.black)
                    .frame(width: 40, height: 40, alignment: .center)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
        }
    }

    private func SubmitButton() -> some View {
        Button(action: {
            guard cart.contains(item) else {
                cart.items.append(item)
                isInCart = true
                navigateToCartScreen()
                return
            }
            cart.remove(item)
            isInCart = false
        }) {
            if isInCart {
                RemoveFromCartButton()
            } else {
                AddToCartButton()
            }
        }
    }

    private func navigateToCartScreen() {
        navigator.navigate(CartScreen(), type: .customSheet(height: 500), showDefaultNavBar: true)
    }

    private func AddToCartButton() -> some View {
        HStack(alignment: .center, spacing: 20) {
            Text("ADD TO CART")
            Image(systemName: "cart.fill")
        }
                .padding(.horizontal, 40)
                .padding(.vertical, 10)
                .foregroundColor(Color.white)
                .font(Font.system(size: 17, weight: .semibold, design: .rounded))
                .background(Color(red: 111 / 255, green: 115 / 255, blue: 210 / 255))
                .cornerRadius(10)
    }

    private func RemoveFromCartButton() -> some View {
        HStack(alignment: .center, spacing: 20) {
            Text("IN YOUR CART")
            Image(systemName: "checkmark")
        }
                .padding(.horizontal, 40)
                .padding(.vertical, 10)
                .foregroundColor(Color.white)
                .font(Font.system(size: 17, weight: .semibold, design: .rounded))
                .background(Color.gray)
                .cornerRadius(10)
    }

    private func DescriptionView() -> some View {
        Text(item.description)
                .font(Font.system(size: 17, weight: .semibold, design: .rounded))
    }

    private func ReviewsTitleView() -> some View {
        VStack {
            Text("Reviews")
                    .font(Font.system(size: 19, weight: .semibold, design: .rounded))
            Text("\(item.reviews.count) review\(item.reviews.count == 1 ? "" : "s")")
                    .font(Font.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundColor(Color.gray)
        }
    }

    private func ReviewsView() -> some View {
        VStack {
            ForEach(item.reviews.indices) { i in
                HStack {
                    Text("\(item.reviews[i].name)")
                            .font(Font.system(size: 17, weight: .semibold, design: .rounded))
                    Spacer()
                    RatingView(
                            rating: item.reviews[i].rating,
                            primaryColor: Color.yellow,
                            secondaryColor: Color.gray)
                }
                Text("\(item.reviews[i].content)")
            }
        }
    }
}

struct ProductDetail_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailScreen(item: Fake.products[0])
    }
}
