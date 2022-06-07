//
//  NavigationTransition.swift
//  
//
//  Created by Shaban on 03/01/2022.
//

import SwiftUI

/// Defines the supported transition types.
public enum NavigatorTransition {
    /// Transitions won't be animated.
    case none

    /// The default transition if you didn't pass one.
    case `default`

    /// Use a custom transition for push & pop.
    case custom(push: AnyTransition, pop: AnyTransition)

    var transition: (push: AnyTransition, pop: AnyTransition) {
        switch self {
        case .none:
            return (push: .identity, pop: .identity)
        case let .custom(push, pop):
            return (push: push, pop: pop)
        case .default:
            return (
                    push: AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)),
                    pop: AnyTransition.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing))
            )
        }
    }
}

