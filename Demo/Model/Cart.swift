//
// Created by Shaban Kamel on 26/12/2021.
// Copyright © 2022 Shaban. All rights reserved.
//

import Foundation

class Cart {
    static let shared = Cart()

    var items: [Product] = []

    var total: Double {
        items.reduce(0) { (res, prod) -> Double in
            res + prod.price
        }
    }

    func add(_ item: Product) {
        items.append(item)
    }

    func remove(_ item: Product) {
        items.removeAll { (prod) -> Bool in
            prod.uuid == item.uuid
        }
    }

    func contains(_ item: Product) -> Bool {
        items.contains(where: {
            $0.uuid == item.uuid
        })
    }
}
