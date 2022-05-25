//
// Created by Shaban on 25/05/2022.
//

import SwiftUI

#if os(iOS)
class UISheetController<Content>: UIHostingController<Content> where Content: View {
    override init(rootView: Content) {
        super.init(rootView: rootView)

        view.backgroundColor = .clear
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .coverVertical
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif

