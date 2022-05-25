//
//  LargeNavigationBarView.swift
//  
//
//  Created by Shaban on 03/01/2022.
//

import SwiftUI

public struct LargeNavBar<Content: View>: View {
    public let titleView: AnyView?
    public let leadingView: AnyView?
    public let trailingView: AnyView?
    public let background: AnyView?
    public let content: Content
    @EnvironmentObject private var navigator: Navigator

    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                VStack(spacing: 12) {
                    HStack {
                        HStack {
                            BarLeadingView()
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            Spacer()
                            trailingView
                        }
                    }
                    HStack {
                        titleView.font(.largeTitle)
                        Spacer()
                    }
                }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(BarBackground())
                Divider()
                Spacer().frame(height: 0)
                content
            }
        }
    }

    private func BarBackground() -> some View {
        Group {
            background ?? AnyView(Color(.white).edgesIgnoringSafeArea(.top))
        }
    }

    private func BarLeadingView() -> some View {
        Group {
            if let view = leadingView {
                view
            } else {
                Button {
                    navigator.dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.backward").foregroundColor(.blue)
                        Text("Back").foregroundColor(.blue)
                    }.disableAnimation()
                }
            }
        }
    }
}

struct LargeNavigationBarViewModifier: ViewModifier {
    let titleView: (() -> AnyView)?
    let leadingView: (() -> AnyView)?
    let trailingView: (() -> AnyView)?
    let background: (() -> AnyView)?

    func body(content: Content) -> some View {
        LargeNavBar(
                titleView: titleView?(),
                leadingView: leadingView?(),
                trailingView: trailingView?(),
                background: background?(),
                content: content)
    }
}
