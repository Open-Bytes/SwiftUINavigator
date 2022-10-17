//
// Created by Shaban on 25/05/2022.
//

import SwiftUI

#if os(iOS)
class SheetController<Content>: UIHostingController<Content> where Content: View {
    override init(rootView: Content) {
        super.init(rootView: rootView)

//        view.backgroundColor = .clear

        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .coverVertical
    }

    @available(*, unavailable)
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(
                withDuration: 0.5,
                delay: 0.0,
                options: .curveEaseOut,
                animations: {
                    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                }, completion: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        UIView.animate(
                withDuration: 0.5,
                delay: 0.0,
                options: .curveEaseOut,
                animations: {
                    self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
                }, completion: nil)
    }
}
#endif

