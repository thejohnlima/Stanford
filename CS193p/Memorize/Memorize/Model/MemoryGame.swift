//
//  MemoryGame.swift
//  Memorize
//
//  Created by John Lima on 7/28/20.
//

import Foundation

struct MemoryGame<CardContent> {
  var cards: [Card]

  init(pairsOfCards: Int, contentFactory: (Int) -> CardContent) {
    cards = []

    for index in 0 ..< pairsOfCards {
      let content = contentFactory(index)
      cards.append(Card(content: content, id: index * 2))
      cards.append(Card(content: content, id: index * 2 + 1))
    }
  }

  mutating func choose(card: Card) {
    print("Card chosen: \(card)")
    let choosenIndex = cards.firstIndex { $0.id == card.id }! as Int
    cards[choosenIndex].isFaceUp = !cards[choosenIndex].isFaceUp
  }
}

extension MemoryGame {
  struct Card: Identifiable {
    var isFaceUp: Bool = false
    var isMatched: Bool = false
    var content: CardContent
    var id: Int
  }
}
