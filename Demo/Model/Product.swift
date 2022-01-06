//
//  Product.swift
//  EcommerceTemplate
//
//  Created by Shaban on 03/01/2022.
//  Copyright © 2022 Shaban. All rights reserved.
//

import Foundation
import SwiftUI

struct Product {
    var uuid: String
    var image: Image
    var title: String
    var price: Double
    var description: String
    var reviews: [Review]

    var rating: Double {
        reviews.reduce(0) { res, review in
            res + review.rating
        }
    }
}

struct Review {
    var name: String
    var rating: Double
    var content: String
}
