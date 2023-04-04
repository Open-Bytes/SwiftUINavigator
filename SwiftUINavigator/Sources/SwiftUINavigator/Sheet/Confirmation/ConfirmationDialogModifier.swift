//
// Created by Shaban on 09/11/2022.
//

import SwiftUI

public enum ConfirmationDialogVisibility: Hashable, CaseIterable {
    case automatic
    case visible
    case hidden

    @available(macCatalyst 15.0, *)
    @available(iOS 15.0, *)
    @available(macOS 12.0, *)
    var original: Visibility {
        switch self {
        case .automatic:
            return .automatic
        case .visible:
            return .visible
        case .hidden:
            return .hidden
        }
    }

    @available(macCatalyst 15.0, *)
    @available(iOS 15.0, *)
    @available(macOS 12.0, *)
    static func from(_ visibility: Visibility) -> ConfirmationDialogVisibility {
        switch visibility {
        case .automatic:
            return .automatic
        case .visible:
            return .visible
        case .hidden:
            return .hidden
        }
    }
}

struct ConfirmationDialogModifier: ViewModifier {
    private let titleKey: LocalizedStringKey
    @Binding private var isPresented: Bool
    private let titleVisibility: ConfirmationDialogVisibility
    private let actions: () -> AnyView

    init(_ titleKey: LocalizedStringKey,
         isPresented: Binding<Bool>,
         titleVisibility: ConfirmationDialogVisibility = .automatic,
         actions: @escaping () -> AnyView) {
        self.titleKey = titleKey
        _isPresented = isPresented
        self.titleVisibility = titleVisibility
        self.actions = actions
    }

    func body(content: Content) -> some View {
        Group {
            if #available(iOS 15.0, macOS 12.0, *) {
                content
                        .confirmationDialog(
                                titleKey,
                                isPresented: $isPresented,
                                titleVisibility: titleVisibility.original,
                                actions: actions)
            } else {
                content
            }
        }
    }
}
