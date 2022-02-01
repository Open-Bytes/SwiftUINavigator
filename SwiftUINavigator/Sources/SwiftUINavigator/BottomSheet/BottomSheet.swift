//
// Created by Shaban Kamel on 29/01/2022.
//

import SwiftUI

fileprivate enum Constants {
    static let snapRatio: CGFloat = 0.25
}

public struct CustomSheetOptions {
    let height: CGFloat
    let minHeight: CGFloat
    let isDismissable: Bool
}

public struct BottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    private let onDismiss: (() -> Void)?
    private let content: Content

    @GestureState private var translation: CGFloat = 0

    private let height: CGFloat
    private let minHeight: CGFloat
    private let isDismissable: Bool

    private var offset: CGFloat {
        isPresented ? 0 : height - minHeight
    }

    public init(
            isPresented: Binding<Bool>,
            height: CGFloat,
            minHeight: CGFloat,
            isDismissable: Bool,
            onDismiss: (() -> Void)?,
            @ViewBuilder content: () -> Content
    ) {
        self.height = height
        self.minHeight = minHeight
        self.isDismissable = isDismissable
        self.onDismiss = onDismiss
        self.content = content()
        self._isPresented = isPresented
    }

    public var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                content
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
                minHeight: 0,
                isDismissable: true,
                onDismiss: nil) {
            Rectangle().fill(Color.red)
        }.edgesIgnoringSafeArea(.all)
    }
}

public extension View {
    func bottomSheet<Content: View>(
            isPresented: Binding<Bool>,
            height: CGFloat,
            minHeight: CGFloat,
            isDismissable: Bool,
            onDismiss: (() -> Void)? = nil,
            @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            BottomSheet(
                    isPresented: isPresented,
                    height: height,
                    minHeight: minHeight,
                    isDismissable: isDismissable,
                    onDismiss: onDismiss
            ) {
                content()
            }.edgesIgnoringSafeArea(.all)
        }
    }
}
