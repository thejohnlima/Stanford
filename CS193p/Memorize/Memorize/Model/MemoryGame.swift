//
//  MemoryGame.swift
//  Memorize
//
//  Created by John Lima on 7/28/20.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
  var cards: [Card]

  var indexOfTheOneAndOnlyFaceUpCard: Int? {
    get {
      cards.indices.filter { cards[$0].isFaceUp }.only
    }
    set {
      cards.indices.forEach { index in
        cards[index].isFaceUp = index == newValue
      }
    }
  }

  init(pairsOfCards: Int, contentFactory: (Int) -> CardContent) {
    cards = []

    for index in 0 ..< pairsOfCards {
      let content = contentFactory(index)
      cards.append(Card(content: content, id: index * 2))
      cards.append(Card(content: content, id: index * 2 + 1))
    }
  }

  mutating func choose(card: Card) {
    let choosenIndex = cards.firstIndex { $0.id == card.id }

    if let choosenIndex: Int = choosenIndex,
       !cards[choosenIndex].isFaceUp,
       !cards[choosenIndex].isMatched {
      if let potencialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
        if cards[choosenIndex].content == cards[potencialMatchIndex].content {
          cards[choosenIndex].isMatched = true
          cards[potencialMatchIndex].isMatched = true
        }
        cards[choosenIndex].isFaceUp = true
      } else {
        indexOfTheOneAndOnlyFaceUpCard = choosenIndex
      }
    }
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
