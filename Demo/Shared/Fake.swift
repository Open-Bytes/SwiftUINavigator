//
// Created by Shaban Kamel on 25/12/2021.
// Copyright © 2022 Shaban. All rights reserved.
//

import SwiftUI

class Fake {
    private static let lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Leo vel fringilla est ullamcorper eget. Faucibus scelerisque eleifend donec pretium vulputate sapien. Luctus accumsan tortor posuere ac ut consequat semper."

    static var products: [Product] =
            [
                Product(uuid: "product01",
                        image: Image("product01"),
                        title: "Curology Shower Pack (3 Bottle Kit)",
                        price: 29.99,
                        description: lorem,
                        reviews: [Review(name: "John Smith", rating: 4.7, content: "Finally a great lens! so good! Best purchase I've made in a long time. Soooo slick!")]),
                Product(uuid: "product02",
                        image: Image("product02"),
                        title: "EF-2 24mm f/2.8 Standard Lens",
                        price: 99.00,
                        description: lorem,
                        reviews: [Review(name: "John Smith", rating: 3.7, content: "This is a great deal!! Best purchase I've made in a long time. Soooo slick!")]),
                Product(uuid: "product03",
                        image: Image("product03"),
                        title: "Casio Signature Gold Classic Watch",
                        price: 19.99,
                        description: lorem,
                        reviews: [Review(name: "John Smith", rating: 5.0, content: "This is a great deal!! Best purchase I've made in a long time. Soooo slick!")]),
                Product(uuid: "product04",
                        image: Image("product04"),
                        title: "HiTech GPS Smart Watch",
                        price: 499.95,
                        description: lorem,
                        reviews: [Review(name: "John Smith", rating: 5.0, content: "This is a great deal!! Best purchase I've made in a long time. Soooo slick!")]),
                Product(uuid: "product05",
                        image: Image("product05"),
                        title: "Adidas Classic",
                        price: 130.00,
                        description: lorem,
                        reviews: [Review(name: "John Smith", rating: 5.0, content: "This is a great deal!! Best purchase I've made in a long time. Soooo slick!")]),
                Product(uuid: "product06",
                        image: Image("product06"),
                        title: "Adidas Limited Edition Hu",
                        price: 130.00,
                        description: lorem,
                        reviews: [Review(name: "John Smith", rating: 5.0, content: "This is a great deal!! Best purchase I've made in a long time. Soooo slick!")])
            ]
}
