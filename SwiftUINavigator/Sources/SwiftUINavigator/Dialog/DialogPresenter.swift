//
// Created by Shaban on 07/12/2022.
//

import Foundation

public enum DialogPresenter {
    /// The first declared NavView will present the dialog
    /// This is important if you have multiple NavViews in the app
    /// and the last NavView is not matching the full screen size and this will lead to displaying
    /// the dialog in a small portion of the screen.
    /// By default it's displayed by the root.
    case root

    /// Last declared NavView will display the dialog.
    case last
}