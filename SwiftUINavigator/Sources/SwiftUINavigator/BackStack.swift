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
    private var views = [BackStackElement]()

    var isEmpty: Bool {
        views.isEmpty
    }

    var isSheetEmpty: Bool {
        guard let last = peek() else {
            return false
        }
        return last.type == .sheet ? true : false
    }


    func peekScreen() -> BackStackElement? {
        views.last {
            $0.type == .screen
        }
    }

    func peek() -> BackStackElement? {
        views.last
    }

    mutating func push(_ element: BackStackElement) {
        guard currentElement(withId: element.id) == nil else {
            let error = "Duplicate identifier: \"\(element.id)\". You are trying to push a view with an identifier that already exists on the navigation stack."
            fatalError(error)
        }
        views.append(element)
    }

    mutating func popSheet() {
        popToPrevious { item in
            item.type == .sheet
        }
    }

    mutating func popToPrevious() {
        popToPrevious { item in
            // Remove this element as it's not added to back stack by user
            !item.addToBackStack
        }
    }

    mutating func popToPrevious(condition: (BackStackElement) -> Bool) {
        guard !views.isEmpty else {
            return
        }
        var elements = views
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
        views = elements
    }

    mutating func popToView(withId identifier: String) {
        var elements = views
        for view in elements {
            if view.id == identifier {
                elements.removeAll {
                    $0.id == identifier
                }
                break
            }
            elements.removeLast()
        }
        views = elements
    }

    mutating func popToRoot() {
        views.removeAll()
    }

    private func currentElement(withId id: String) -> BackStackElement? {
        views.first {
            $0.id == id
        }
    }

    private var lastElementAddedToBackStack: BackStackElement? {
        views.last {
            $0.addToBackStack
        }
    }
}
