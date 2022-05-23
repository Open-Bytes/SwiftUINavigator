//
//  InlineNavigationBarView.swift
//  
//
//  Created by Shaban on 03/01/2022.
//

import SwiftUI

public struct NavBar<Content: View>: View {
    public let titleView: AnyView?
    public let leadingView: AnyView?
    public let trailingView: AnyView?
    public let background: AnyView?
    public let content: Content
    @EnvironmentObject private var navigator: Navigator

    public var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                HStack {
                    HStack {
                        BarLeadingView()
                        Spacer()
                    }.frame(width: geometry.size.width * 0.25)
                    Spacer()
                    titleView
                    Spacer()
                    HStack {
                        Spacer()
                        trailingView
                    }.frame(width: geometry.size.width * 0.25)
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
                    }
                }
            }
        }
    }

    private func BarBackground() -> some View {
        Group {
            // TODO: uncomment
//            if let view = background {
//                view
//            } else {
//                Color(.secondarySystemBackground).edgesIgnoringSafeArea(.top)
//            }
        }
    }
}

public enum NavBarStyle {
    case normal
    case large
}

struct NavBarViewModifier: ViewModifier {
    let titleView: (() -> AnyView)?
    let leadingView: (() -> AnyView)?
    let trailingView: (() -> AnyView)?
    let background: (() -> AnyView)?

    func body(content: Content) -> some View {
        NavBar(titleView: titleView?(),
                leadingView: leadingView?(),
                trailingView: trailingView?(),
                background: background?(),
                content: content)
    }
}

public extension View {
    func navBar(
            style: NavBarStyle = .normal,
            titleView: (() -> AnyView)? = nil,
            leadingView: (() -> AnyView)? = nil,
            trailingView: (() -> AnyView)? = nil,
            background: (() -> AnyView)? = nil
    ) -> some View {
        Group {
            switch style {
            case .normal:
                modifier(NavBarViewModifier(
                        titleView: titleView,
                        leadingView: leadingView,
                        trailingView: trailingView,
                        background: background))
            case .large:
                modifier(LargeNavigationBarViewModifier(
                        titleView: titleView,
                        leadingView: leadingView,
                        trailingView: trailingView,
                        background: background))
            }
        }

    }
}
