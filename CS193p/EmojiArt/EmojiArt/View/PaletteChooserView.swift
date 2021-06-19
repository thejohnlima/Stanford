//
//  PaletteChooserView.swift
//  EmojiArt
//
//  Created by John Lima on 6/19/21.
//

import SwiftUI

struct PaletteChooserView: View {
  @ObservedObject var document: EmojiArtDocument
  @Binding var chosenPalette: String

  var body: some View {
    HStack {
      Stepper(onIncrement: {
        chosenPalette = document.palette(after: chosenPalette)
      }, onDecrement: {
        chosenPalette = document.palette(before: chosenPalette)
      }, label: {
        EmptyView()
      })

      Text(document.paletteNames[chosenPalette] ?? "")
    }
    .fixedSize(horizontal: true, vertical: false)
  }
}

struct PaletteChooserView_Previews: PreviewProvider {
  static var previews: some View {
    PaletteChooserView(document: EmojiArtDocument(), chosenPalette: .constant(""))
  }
}
