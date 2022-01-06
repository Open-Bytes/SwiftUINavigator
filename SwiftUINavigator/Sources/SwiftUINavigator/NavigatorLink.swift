//
//  Created by Shaban on 03/01/2022.
//

import SwiftUI

/// The alternative of NavigationLink. It's a wrapper of Navigator.
/// When clicked, it will navigate to the destination view
/// with the specified navigation type.
public struct NavigatorLink<Destination: View, Label: View>: View {
    private let destination: () -> Destination
    private let type: NavigationType
    private let label: () -> Label
    @EnvironmentObject private var navigator: Navigator

    public init(
            destination: @escaping @autoclosure () -> Destination,
            type: NavigationType = .push(),
            label: @escaping () -> Label) {
        self.destination = destination
        self.type = type
        self.label = label
    }

    public var body: some View {
        label()
                .onTapGesture {
                    navigator.navigate(destination(), type: type)
                }
    }
}
