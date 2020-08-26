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
  @State private var steadyStateZoomScale: CGFloat = 1
  @GestureState private var gestureZoomScale: CGFloat = 1
  @State private var steadyStatePanOffset: CGSize = .zero
  @GestureState private var gesturePanOffset: CGSize = .zero

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
      ZStack {
        Color.white.overlay(
          OptionalImage(uiImage: document.backgroundImage)
            .scaleEffect(zoomScale)
            .offset(panOffset)
        )
        .gesture(doubleTapToZoom(in: geometry.size))

        ForEach(document.emojis) { emoji in
          Text(emoji.text)
            .font(animatableWithSize: emoji.fontSize * zoomScale)
            .position(position(for: emoji, in: geometry.size))
        }
      }
      .clipped()
      .gesture(panGesture())
      .gesture(zoomGesture())
      .edgesIgnoringSafeArea([.horizontal, .bottom])
      .onDrop(of: ["public.image", "public.text"], isTargeted: nil) { providers, location in
        var location = geometry.convert(location, from: .global)
        location = CGPoint(x: location.x - geometry.size.width / 2, y: location.y - geometry.size.height / 2)
        location = CGPoint(x: location.x - panOffset.width, y: location.y - panOffset.height)
        location = CGPoint(x: location.x / zoomScale, y: location.y / zoomScale)
        return drop(providers, at: location)
      }
    }
  }

  private var zoomScale: CGFloat {
    steadyStateZoomScale * gestureZoomScale
  }

  private var panOffset: CGSize {
    (steadyStatePanOffset + gesturePanOffset) * zoomScale
  }

  private func zoomGesture() -> some Gesture {
    MagnificationGesture()
      .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, transaction in
        gestureZoomScale = latestGestureScale
      }
      .onEnded { finalGestureScale in
        steadyStateZoomScale *= finalGestureScale
      }
  }

  private func panGesture() -> some Gesture {
    DragGesture()
      .updating($gesturePanOffset) { latestDragGestureValue, gesturePanOffset, transaction in
        gesturePanOffset = latestDragGestureValue.translation / zoomScale
      }
      .onEnded { finalDragGestureValue in
        steadyStatePanOffset = steadyStatePanOffset + (finalDragGestureValue.translation / zoomScale)
      }
  }

  private func doubleTapToZoom(in size: CGSize) -> some Gesture {
    TapGesture(count: 2)
      .onEnded {
        withAnimation {
          zoomToFit(document.backgroundImage, in: size)
        }
      }
  }

  private func zoomToFit(_ image: UIImage?, in size: CGSize) {
    if let image = image, image.size.width > 0, image.size.height > 0 {
      let hZoom = size.width / image.size.width
      let vZoom = size.height / image.size.height
      steadyStatePanOffset = .zero
      steadyStateZoomScale = min(hZoom, vZoom)
    }
  }

  private func position(for emoji: EmojiArt.Emoji, in size: CGSize) -> CGPoint {
    var location = emoji.location
    location = CGPoint(x: location.x * zoomScale, y: location.y * zoomScale)
    location = CGPoint(x: location.x + size.width / 2, y: location.y + size.height / 2)
    location = CGPoint(x: location.x * panOffset.width, y: location.y * panOffset.height)
    return location
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
