//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by John Lima on 8/17/20.
//

import SwiftUI

@main
struct EmojiArtApp: App {
  var body: some Scene {
    WindowGroup {
      EmojiArtDocumentView(document: EmojiArtDocument())
    }
  }
}
