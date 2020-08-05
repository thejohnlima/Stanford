//
//  CardifyView.swift
//  Memorize
//
//  Created by John Lima on 8/5/20.
//

import SwiftUI

struct CardifyView: ViewModifier {
  private let cornerRadius: CGFloat = 10
  private let edgeLineWidth: CGFloat = 3

  var isFaceUp: Bool

  func body(content: Content) -> some View {
    ZStack {
      if isFaceUp {
        RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
        RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
        content
      } else {
        RoundedRectangle(cornerRadius: cornerRadius).fill()
      }
    }
  }
}

extension View {
  func cardify(isFaceUp: Bool) -> some View {
    modifier(CardifyView(isFaceUp: isFaceUp))
  }
}
