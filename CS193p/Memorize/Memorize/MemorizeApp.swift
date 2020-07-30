//
//  MemorizeApp.swift
//  Memorize
//
//  Created by John Lima on 7/26/20.
//

import SwiftUI

@main
struct MemorizeApp: App {
  var body: some Scene {
    WindowGroup {
      EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
  }
}
