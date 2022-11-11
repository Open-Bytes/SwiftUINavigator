//
// Created by Shaban Kamel on 25/12/2021.
//

import SwiftUI

struct BackStackElement: Identifiable, Equatable {
    let id: String
    let wrappedElement: AnyView
    // So far, we don't need this type. But we may need it in the future.
    let type: BackStackElementType
    let addToBackStack: Bool

    static func ==(lhs: BackStackElement, rhs: BackStackElement) -> Bool {
        lhs.id == rhs.id
    }
}

enum BackStackElementType {
    case screen
    case sheet
    case any
}

struct BackStack {
    var elements = [BackStackElement]()

    var isEmpty: Bool {
        elements.isEmpty
    }

    func peek() -> BackStackElement? {
        elements.last
    }

    mutating func push(_ element: BackStackElement) {
        guard currentElement(withId: element.id) == nil else {
            let error = "Duplicate identifier: \"\(element.id)\". You are trying to push a view with an identifier that already exists on the navigation stack."
            fatalError(error)
        }
        elements.append(element)
    }

    mutating func popToPrevious() {
        popToPrevious { item in
            // Remove this element as it's not added to back stack by user
            !item.addToBackStack
        }
    }

    mutating func popToPrevious(condition: (BackStackElement) -> Bool) {
        guard !elements.isEmpty else {
            return
        }
        var elements = elements
        // Remove last view to go back to the previous one
        elements.removeLast()
        // Ignore the elements that user doesn't want to add to back stack
        for view in elements {
            // Remove this element as it's not added to back stack by user
            if condition(view) {
                elements.removeLast()
                continue
            }
        }
        self.elements = elements
    }

    mutating func popToView(withId identifier: String) {
        var elements = elements
        for view in elements.reversed() {
            if view.id == identifier {
                break
            }
            elements.removeLast()
        }
        self.elements = elements
    }

    mutating func popToRoot() {
        elements.removeAll()
    }

    private func currentElement(withId id: String) -> BackStackElement? {
        elements.first {
            $0.id == id
        }
    }

    private var lastElementAddedToBackStack: BackStackElement? {
        elements.last {
            $0.addToBackStack
        }
    }
}
