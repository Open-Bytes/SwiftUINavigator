//
//  NavigationTransition.swift
//  
//
//  Created by Shaban on 03/01/2022.
//

import SwiftUI

/// Defines the supported transition types.
public enum NavigatorTransitionType {
    /// Transitions won't be animated.
    case none

    /// The default transition if you didn't pass one.
    case `default`

    /// Use a custom transition.
    case custom(push: AnyTransition, pop: AnyTransition)

    var transition: NavigatorTransition {
        switch self {
        case .none:
            return NavigatorTransition(push: .identity, pop: .identity)
        case .custom(let push, let pop):
            return NavigatorTransition(push: push, pop: pop)
        case .default:
            return NavigatorTransition.defaultTransition
        }
    }

    public static var defaultTransitions: NavigatorTransition {
        let push = AnyTransition.asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading))
        let pop = AnyTransition.asymmetric(
                insertion: .move(edge: .leading),
                removal: .move(edge: .trailing))
        return NavigatorTransition(push: push, pop: pop)
    }

}
public struct NavigatorTransition {
    public let push: AnyTransition
    public let pop: AnyTransition

    public init(push: AnyTransition, pop: AnyTransition) {
        self.push = push
        self.pop = pop
    }

    func transition(of type: Navigator.NavigationDirection) -> AnyTransition {
        switch type {
        case .push:
            return push
        case .pop:
            return pop
        case .none:
            return .identity
        }
    }

    /// A right-to-left slide transition on push, a left-to-right slide transition on pop.
    public static var defaultTransition: NavigatorTransition {
        let push = AnyTransition.asymmetric(
                insertion: .move(edge: .trailing),
                removal: .move(edge: .leading))
        let pop = AnyTransition.asymmetric(
                insertion: .move(edge: .leading),
                removal: .move(edge: .trailing))
        return NavigatorTransition(push: push, pop: pop)
    }
}

