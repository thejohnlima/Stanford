//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by John Lima on 8/17/20.
//

import SwiftUI

struct EmojiArtDocumentView: View {
  private let defaultEmojiSize: CGFloat = 40

  @ObservedObject var document: EmojiArtDocument

  var body: some View {
    ScrollView(.horizontal) {
      HStack {
        ForEach(EmojiArtDocument.palette.map { String($0) }, id: \.self) { emoji in
          Text(emoji)
            .font(.system(size: defaultEmojiSize))
            .onDrag {
              NSItemProvider(object: emoji as NSString)
            }
        }
      }
    }
    .padding(.horizontal)

    GeometryReader { geometry in
      Color.white.overlay(
        Group {
          if let image = document.backgroundImage {
            Image(uiImage: image)
          }
        }
      )
      .edgesIgnoringSafeArea([.horizontal, .bottom])
      .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
        var location = geometry.convert(location, from: .global)
        location = CGPoint(x: location.x - geometry.size.width / 2, y: location.y - geometry.size.height / 2)
        return drop(providers, at: location)
      }

      ForEach(document.emojis) { emoji in
        Text(emoji.text)
          .font(font(for: emoji))
          .position(position(for: emoji, in: geometry.size))
      }
    }
  }

  private func font(for emoji: EmojiArt.Emoji) -> Font {
    .system(size: emoji.fontSize)
  }

  private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
    CGPoint(x: emoji.location.x + size.width / 2, y: emoji.location.y + size.height / 2)
  }

  private func drop(_ providers: [NSItemProvider], at location: CGPoint) -> Bool {
    var found = providers.loadObjects(ofType: URL.self) { url in
      document.setBackgroundURL(url)
    }

    if !found {
      found = providers.loadObjects(ofType: String.self) { string in
        document.addEmoji(string, at: location, size: defaultEmojiSize)
      }
    }

    return found
  }
}
