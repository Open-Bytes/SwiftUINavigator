//
// Created by Shaban Kamel on 29/01/2022.
//

import SwiftUI

fileprivate enum Constants {
    static let snapRatio: CGFloat = 0.25
}

public struct CustomSheetOptions {
    let presenter: FixedSheetPresenter
    let height: CGFloat
    let isDismissable: Bool
}

/// A customizable bottom sheet.
/// You can control the height, minHeight, and dismissing of the sheet.
public struct BottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    private let onDismiss: (() -> Void)?
    private let content: Content

    @GestureState private var translation: CGFloat = 0

    private let height: CGFloat
    private let isDismissable: Bool

    private var offset: CGFloat {
        isPresented ? 0 : height
    }

    public init(
            isPresented: Binding<Bool>,
            height: CGFloat,
            isDismissable: Bool,
            onDismiss: (() -> Void)?,
            @ViewBuilder content: () -> Content
    ) {
        self.height = height
        self.isDismissable = isDismissable
        self.onDismiss = onDismiss
        self.content = content()
        self._isPresented = isPresented
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                content.disableAnimation()
            }
                    .frame(width: geometry.size.width, height: height, alignment: .top)
                    .frame(height: geometry.size.height, alignment: .bottom)
                    .offset(y: max(offset + translation, 0))
                    .animation(.interactiveSpring())
                    .gesture(DraggingGesture())
                    .onDataChange(of: isPresented) { value in
                        guard !value else {
                            return
                        }
                        onDismiss?()
                    }
        }
    }

    private func DraggingGesture() -> some Gesture {
        DragGesture()
                .updating(self.$translation) { value, state, _ in
                    guard isDismissable else {
                        return
                    }
                    state = value.translation.height
                }
                .onEnded { value in
                    guard isDismissable else {
                        return
                    }
                    let snapDistance = height * Constants.snapRatio
                    guard abs(value.translation.height) > snapDistance else {
                        return
                    }
                    isPresented = value.translation.height < 0
                }
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheet(
                isPresented: .constant(true),
                height: 500,
                isDismissable: true,
                onDismiss: nil) {
            Rectangle().fill(Color.red)
        }
                .edgesIgnoringSafeArea(.all)
    }
}

public extension View {
    /// A modifier to present a customizable bottom sheet
    ///
    /// - Parameters:
    ///   - isPresented: if true, the sheet will be displayed
    ///   - height: the height of the sheet
    ///   - minHeight: the min height. When dragged down, this height will be used
    ///   - isDismissable: if true, the user can drag the sheet to dismiss
    ///   - onDismiss: called when the sheet is dismissed
    ///   - content: the content view
    /// - Returns: a view
    func bottomSheet<Content: View>(
            isPresented: Binding<Bool>,
            height: CGFloat,
            isDismissable: Bool = true,
            onDismiss: (() -> Void)? = nil,
            @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            BottomSheet(
                    isPresented: isPresented,
                    height: height,
                    isDismissable: isDismissable,
                    onDismiss: onDismiss
            ) {
                content()
            }
                    .edgesIgnoringSafeArea(.all)
        }
    }
}
