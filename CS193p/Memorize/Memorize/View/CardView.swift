//
//  CardView.swift
//  Memorize
//
//  Created by John Lima on 7/28/20.
//

import SwiftUI

struct CardView: View {
  var card: MemoryGame<String>.Card

  var body: some View {
    ZStack {
      if card.isFaceUp {
        RoundedRectangle(cornerRadius: 10).fill(Color.white)
        RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 3)
        Text(card.content)
      } else {
        RoundedRectangle(cornerRadius: 10).fill()
      }
    }
  }
}

struct CardView_Previews: PreviewProvider {
  static var previews: some View {
    let card = EmojiMemoryGame.createMemoryGame().cards.first!
    CardView(card: card)
  }
}
