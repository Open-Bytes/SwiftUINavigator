//
//  ProductCell.swift
//  EcommerceTemplate
//
//  Created by Shaban on 03/01/2022.
//  Copyright © 2022 Shaban. All rights reserved.
//

import SwiftUI

struct ProductItemView: View {
    var item: Product

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            item.image
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(10)

            Text(item.title)
                    .font(Font.system(size: 15, weight: .regular, design: .rounded))
            Text("$\(String(format: "%.2f", item.price))")
                    .font(Font.system(size: 15, weight: .heavy, design: .rounded))
        }
                .aspectRatio(contentMode: .fit)

    }
}

struct ProductCell_Previews: PreviewProvider {
    static var previews: some View {
        ProductItemView(item: Fake.products[0])
    }
}

