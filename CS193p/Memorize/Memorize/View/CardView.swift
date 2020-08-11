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

  @State private var animatedBonusRemaining: Double = 0

  var body: some View {
    GeometryReader { geometry in
      body(for: geometry.size)
    }
  }

  @ViewBuilder
  func body(for size: CGSize) -> some View {
    if card.isFaceUp || !card.isMatched {
      ZStack {
        Group {
          if card.isConsumingBonusTime {
            PieView(
              startAngle: Angle.degrees(0-90),
              endAngle: Angle.degrees(-animatedBonusRemaining * 360 - 90),
              clockwise: true
            )
            .onAppear {
              startBonusTimeAnimation()
            }
          } else {
            PieView(
              startAngle: Angle.degrees(0-90),
              endAngle: Angle.degrees(-card.bonusRemaining * 360 - 90),
              clockwise: true
            )
          }
        }
        .padding(5)
        .opacity(0.4)
        .transition(.scale)

        Text(card.content)
          .font(.system(size: min(size.width, size.height) * fontScaleFactor))
          .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
          .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
      }
      .cardify(isFaceUp: card.isFaceUp)
      .transition(.scale)
    }
  }

  private func startBonusTimeAnimation() {
    animatedBonusRemaining = card.bonusRemaining

    withAnimation(.linear(duration: card.bonusTimeRemaining)) {
      animatedBonusRemaining = 0
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
