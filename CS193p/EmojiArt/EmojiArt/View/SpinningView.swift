//
//  SpinningView.swift
//  EmojiArt
//
//  Created by John Lima on 5/6/21.
//

import SwiftUI

struct SpinningView: ViewModifier {
  @State var isVisible = false

  func body(content: Content) -> some View {
    content
      .rotationEffect(Angle(degrees: isVisible ? 360 : 0))
      .animation(.linear(duration: 1).repeatForever(autoreverses: false))
      .onAppear { isVisible = true }
  }
}

extension View {
  func spinning() -> some View {
    modifier(SpinningView())
  }
}
