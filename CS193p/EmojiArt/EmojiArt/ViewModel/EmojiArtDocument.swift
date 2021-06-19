//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by John Lima on 8/17/20.
//

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject {
  static let palette: String = "⭐️🌨🍎🌎⚾️🏀"

  @Published private(set) var backgroundImage: UIImage?
  @Published private var emojiArt: EmojiArt

  private var autosaveCancellable: AnyCancellable?
  private var fetchImageCancellable: AnyCancellable?

  var emojis: [EmojiArt.Emoji] {
    emojiArt.emojis
  }

  var backgroundURL: URL? {
    get { emojiArt.backgroundURL }
    set {
      emojiArt.backgroundURL = newValue?.imageURL
      fetchBackgroundImageData()
    }
  }

  init() {
    emojiArt = EmojiArt(json: UserDefaults.standard.data(forKey: Key.emojiArtDocumentUntitled.rawValue)) ?? EmojiArt()

    autosaveCancellable = $emojiArt.sink { emojiArt  in
      print("\(emojiArt.json?.utf8 ?? "nil")")
      UserDefaults.standard.setValue(emojiArt.json, forKey: Key.emojiArtDocumentUntitled.rawValue)
    }

    fetchBackgroundImageData()
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

  private func fetchBackgroundImageData() {
    backgroundImage = nil

    guard let url = emojiArt.backgroundURL else { return }

    fetchImageCancellable?.cancel()

    fetchImageCancellable = URLSession.shared.dataTaskPublisher(for: url)
      .map { data, _ in UIImage(data: data) }
      .receive(on: DispatchQueue.main)
      .replaceError(with: nil)
      .assign(to: \.backgroundImage, on: self)
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
