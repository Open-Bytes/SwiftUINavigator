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
    var alert: Alert? = nil

    func present(_ alert: Alert) {
        self.alert = alert
        isPresented = true
    }

    func dismiss() {
        isPresented = false
        alert = nil
    }
}
