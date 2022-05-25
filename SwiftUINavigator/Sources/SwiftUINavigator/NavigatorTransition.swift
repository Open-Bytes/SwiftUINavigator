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

    /// Use a custom transition.
    case custom(transition: AnyTransition)

    var transition: AnyTransition {
        switch self {
        case .none:
            return .identity
        case .custom(let transition):
            return transition
        case .default:
            return AnyTransition.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .trailing))
        }
    }
}

