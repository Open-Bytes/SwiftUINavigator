//
// Created by Shaban on 10/11/2022.
//

import Combine
import SwiftUI


class AlertManager: ObservableObject {
    @Published var isPresented: Bool = false {
        didSet {
            if !isPresented {
                alert = nil
            }
        }
    }
    @available(macOS, unavailable)
    var alert: Alert? = nil

    @available(macOS, unavailable)
    func present(_ alert: Alert) {
        self.alert = alert
        isPresented = true
    }

    @available(macOS, unavailable)
    func dismiss() {
        isPresented = false
        alert = nil
    }
}
