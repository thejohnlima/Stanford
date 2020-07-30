//
//  CardView.swift
//  Memorize
//
//  Created by John Lima on 7/28/20.
//

import SwiftUI

struct CardView: View {
  private let cornerRadius: CGFloat = 10
  private let edgeLineWidth: CGFloat = 3
  private let fontScaleFactor: CGFloat = 0.75

  var card: MemoryGame<String>.Card

  var body: some View {
    GeometryReader { geometry in
      ZStack {
        if card.isFaceUp {
          RoundedRectangle(cornerRadius: cornerRadius).fill(Color.white)
          RoundedRectangle(cornerRadius: cornerRadius).stroke(lineWidth: edgeLineWidth)
          Text(card.content)
        } else {
          RoundedRectangle(cornerRadius: cornerRadius).fill()
        }
      }
      .font(.system(size: min(geometry.size.width, geometry.size.height) * fontScaleFactor))
    }
  }
}

struct CardView_Previews: PreviewProvider {
  static var previews: some View {
    let card = EmojiMemoryGame.createMemoryGame().cards.first!
    CardView(card: card)
  }
}
