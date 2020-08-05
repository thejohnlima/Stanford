//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by John Lima on 7/26/20.
//

import SwiftUI

struct EmojiMemoryGameView: View {
  @ObservedObject var viewModel: EmojiMemoryGame

  var body: some View {
    GridView(viewModel.model.cards) { card in
      CardView(card: card).onTapGesture {
        viewModel.choose(card: card)
      }
      .padding(5)
    }
    .padding()
    .foregroundColor(.orange)
    .font(.largeTitle)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let game = EmojiMemoryGame()
    game.choose(card: game.model.cards[0])
    return EmojiMemoryGameView(viewModel: game)
  }
}
