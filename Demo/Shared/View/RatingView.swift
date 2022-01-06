//
//  RatingBlock.swift
//  EcommerceTemplate
//
//  Created by Shaban on 03/01/2022.
//  Copyright © 2022 Shaban. All rights reserved.
//

import SwiftUI

struct RatingView: View {

    var rating: Double
    var primaryColor: Color
    var secondaryColor: Color

    var body: some View {
        HStack(alignment: .center, spacing: 3) {
            ForEach(0..<5) { value in
                ratingImage(for: Double(value))
            }
        }
    }

    private func ratingImage(for value: Double) -> some View {
        guard rating > value else {
            return Image(systemName: "star")
                    .foregroundColor(secondaryColor)
        }
        if rating < value + 1 {
            return      Image(systemName: "star.lefthalf.fill")
                    .foregroundColor(primaryColor)
        }
        return Image(systemName: "star.fill")
                .foregroundColor(primaryColor)
    }
}

struct RatingBlock_Previews: PreviewProvider {

    static var rating: Double = 3.7
    static var primary: Color = Color.yellow
    static var secondary: Color = Color.gray
    static var previews: some View {
        RatingView(rating: rating, primaryColor: primary, secondaryColor: secondary)
    }
}
