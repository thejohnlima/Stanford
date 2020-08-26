//
//  OptionalImage.swift
//  EmojiArt
//
//  Created by John Lima on 8/26/20.
//

import SwiftUI

struct OptionalImage: View {
  var uiImage: UIImage?

  var body: some View {
    Group {
      if let image = uiImage {
        Image(uiImage: image)
      }
    }
  }
}
