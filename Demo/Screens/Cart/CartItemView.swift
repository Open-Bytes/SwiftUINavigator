//
//  ProductCartRow.swift
//  EcommerceTemplate
//
//  Created by Shaban on 03/01/2022.
//  Copyright © 2022 Shaban. All rights reserved.
//

import SwiftUI

struct CartItemView: View {
    let item: Product

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ProductImage()
            DescriptionView()
            Spacer()
        }
    }

    private func ProductImage() -> some View {
        item.image
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80, alignment: .center)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
    }

    private func DescriptionView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(item.title)")
                    .font(Font.system(size: 17, weight: .regular, design: .rounded))
            Text("$\(String.init(format: "%.2f", item.price))")
                    .font(Font.system(size: 17, weight: .bold, design: .rounded))
        }
    }
}

struct ProductCartRow_Previews: PreviewProvider {
    static var previews: some View {
        CartItemView(item: Fake.products[0])
    }
}
