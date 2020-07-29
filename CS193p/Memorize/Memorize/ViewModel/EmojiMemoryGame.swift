//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by John Lima on 7/28/20.
//

import SwiftUI

class EmojiMemoryGame {
  private(set) var model: MemoryGame<String> = createMemoryGame()

  func choose(card: MemoryGame<String>.Card) {
    model.choose(card: card)
  }

  static func createMemoryGame() -> MemoryGame<String> {
    let emojis = ["👻", "🎃", "🕷"]
    return MemoryGame<String>(pairsOfCards: emojis.count) { index in
      emojis[index]
    }
  }
}
