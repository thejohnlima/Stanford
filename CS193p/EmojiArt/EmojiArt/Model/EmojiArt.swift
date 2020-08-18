//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by John Lima on 8/17/20.
//

import Foundation

struct EmojiArt {
  var backgroundURL: URL?
  var emojis: [Emoji] = []

  private var uniqueEmojiId = 0
  
  struct Emoji: Identifiable {
    let id: Int
    let text: String
    var x: Int
    var y: Int
    var size: Int

    fileprivate init(id: Int, text: String, x: Int, y: Int, size: Int) {
      self.id = id
      self.text = text
      self.x = x
      self.y = y
      self.size = size
    }
  }

  mutating func addEmoji(_ text: String, x: Int, y: Int, size: Int) {
    uniqueEmojiId += 1
    emojis.append(Emoji(id: uniqueEmojiId, text: text, x: x, y: y, size: size))
  }
}
