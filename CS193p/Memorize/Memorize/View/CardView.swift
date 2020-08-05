//
//  CardView.swift
//  Memorize
//
//  Created by John Lima on 7/28/20.
//

import SwiftUI

struct CardView: View {
  private let fontScaleFactor: CGFloat = 0.7

  var card: MemoryGame<String>.Card

  var body: some View {
    GeometryReader { geometry in
      body(for: geometry.size)
    }
  }

  @ViewBuilder
  func body(for size: CGSize) -> some View {
    if card.isFaceUp || !card.isMatched {
      ZStack {
        PieView(
          startAngle: Angle.degrees(0-90),
          endAngle: Angle.degrees(110-90),
          clockwise: true
        )
        .padding(5)
        .opacity(0.4)
        Text(card.content)
          .font(.system(size: min(size.width, size.height) * fontScaleFactor))
      }
      .cardify(isFaceUp: card.isFaceUp)
    }
  }
}

struct CardView_Previews: PreviewProvider {
  static var previews: some View {
    let game = EmojiMemoryGame()
    game.choose(card: game.model.cards[0])

    let card = game.model.cards[0]

    return CardView(card: card)
      .foregroundColor(.orange)
  }
}
