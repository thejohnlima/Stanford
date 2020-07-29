//
//  ContentView.swift
//  Memorize
//
//  Created by John Lima on 7/26/20.
//

import SwiftUI

struct ContentView: View {
  var viewModel: EmojiMemoryGame

  var body: some View {
    HStack {
      ForEach(viewModel.model.cards) { card in
        CardView(card: card).onTapGesture {
          viewModel.choose(card: card)
        }
      }
    }
    .padding()
    .foregroundColor(.orange)
    .font(.largeTitle)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      ContentView(viewModel: EmojiMemoryGame())
    }
  }
}
