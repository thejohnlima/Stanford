//
//  MemoryGame.swift
//  Memorize
//
//  Created by John Lima on 7/28/20.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
  private(set) var cards: [Card]

  private var indexOfTheOneAndOnlyFaceUpCard: Int? {
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

    cards.shuffle()
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
    var content: CardContent
    var id: Int

    var isFaceUp: Bool = false {
      didSet {
        guard isFaceUp else {
          return stopUsingBonusTime()
        }
        startUsingBonusTime()
      }
    }

    var isMatched: Bool = false {
      didSet {
        stopUsingBonusTime()
      }
    }

    /// Can be zero which means "No bonus available" for more this card
    var bonusTimeLimit: TimeInterval = 6

    /// The last time this card was turned face up (and is still face up)
    var lastFaceUpDate: Date?

    /// The accumulated time this card has been face up in the past
    /// (i.e. no incluiding the current time it's been face up if it is currently so)
    var pastFaceUpTime: TimeInterval = 0

    /// How much time left before the bonus opportunity runs out
    var bonusTimeRemaining: TimeInterval {
      max(0, bonusTimeLimit - faceUpTime)
    }

    /// Percentage of the bonus time remaining
    var bonusRemaining: Double {
      (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
    }

    /// Whether the card was matched during the bonus time period
    var hasEarnedBonus: Bool {
      isMatched && bonusTimeRemaining > 0
    }

    /// Whether the card is currently face up, unmatched and have not yet used up the bonus window
    var isConsumingBonusTime: Bool {
      isFaceUp && !isMatched && bonusTimeRemaining > 0
    }

    /// How long this card has never been face up
    private var faceUpTime: TimeInterval {
      if let lastFaceUpTime = lastFaceUpDate {
        return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpTime)
      }
      return pastFaceUpTime
    }

    /// Called when the card transitions to face up state
    private mutating func startUsingBonusTime() {
      guard isConsumingBonusTime, lastFaceUpDate == nil else { return }
      lastFaceUpDate = Date()
    }

    /// Called when the card goes back face down (or gets matched)
    private mutating func stopUsingBonusTime() {
      pastFaceUpTime = faceUpTime
      lastFaceUpDate = nil
    }
  }
}
