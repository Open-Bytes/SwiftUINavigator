//
//  ShareSheet.swift
//  EcommerceTemplate
//
//  Created by Shaban on 03/01/2022.
//  Copyright © 2022 Shaban. All rights reserved.
//

import SwiftUI

struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (
            _ activityType: UIActivity.ActivityType?,
            _ completed: Bool,
            _ returnedItems: [Any]?,
            _ error: Error?) -> Void

    let activityItems: [Any]
    let applicationActivities: [UIActivity] = []
    let excludedActivityTypes: [UIActivity.ActivityType] = []
    let callback: Callback? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
                activityItems: activityItems,
                applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        controller.modalPresentationStyle = .none
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}
