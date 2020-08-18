//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by John Lima on 8/17/20.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
  static let palette: String = "⭐️🌨🍎🌎⚾️🏀"

  @Published private var emojiArt = EmojiArt()
  @Published private(set) var backgroundImage: UIImage?

  var emojis: [EmojiArt.Emoji] {
    emojiArt.emojis
  }

  func addEmoji(_ emoji: String, at location: CGPoint, size: CGFloat) {
    emojiArt.addEmoji(emoji, x: Int(location.x), y: Int(location.y), size: Int(size))
  }

  func moveEmoji(_ emoji: EmojiArt.Emoji, by offset: CGSize) {
    if let index = emojiArt.emojis.firstIndex(matching: emoji) {
      emojiArt.emojis[index].x += Int(offset.width)
      emojiArt.emojis[index].y += Int(offset.height)
    }
  }

  func scaleEmoji(_ emoji: EmojiArt.Emoji, by scale: CGFloat) {
    if let index = emojiArt.emojis.firstIndex(matching: emoji) {
      emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrEven))
    }
  }

  func setBackgroundURL(_ url: URL?) {
    emojiArt.backgroundURL = url?.imageURL
    fetchBackgroundImageData()
  }

  private func fetchBackgroundImageData() {
    backgroundImage = nil

    if let url = emojiArt.backgroundURL {
      DispatchQueue.global(qos: .userInitiated).async {
        guard let imageData = try? Data(contentsOf: url) else { return }
        DispatchQueue.main.async { [weak self] in
          guard url == self?.emojiArt.backgroundURL else { return }
          self?.backgroundImage = UIImage(data: imageData)
        }
      }
    }
  }
}

extension EmojiArt.Emoji {
  var fontSize: CGFloat {
    CGFloat(size)
  }

  var location: CGPoint {
    CGPoint(x: CGFloat(x), y: CGFloat(y))
  }
}
