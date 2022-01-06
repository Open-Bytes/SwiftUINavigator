//
// Created by Shaban Kamel on 27/12/2021.
//

import SwiftUI

struct LazyView<Content: View>: View {
    private let build: () -> Content

    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }

    var body: Content {
        build()
    }
}
