//
// Created by Shaban on 10/11/2022.
//

import SwiftUI

struct FullScreenCoverModifier: ViewModifier {
    @Binding var isPresented: Bool
    @available(macOS, unavailable)
    let view: () -> AnyView?

    func body(content: Content) -> some View {
        Group {
            #if os(macOS)
            content
            #else
            if #available(iOS 14.0, *) {
                content
                        .fullScreenCover(isPresented: $isPresented) {
                            view()?.lazyView
                        }
            } else {
                content
            }
            #endif
        }
    }
}

