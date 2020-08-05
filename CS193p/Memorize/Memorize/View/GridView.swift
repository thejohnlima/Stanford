//
//  GridView.swift
//  Memorize
//
//  Created by John Lima on 7/30/20.
//

import SwiftUI

struct GridView<Item, ItemView>: View where Item: Identifiable, ItemView: View {
  private var items: [Item]
  private var viewForItem: (Item) -> ItemView

  init(_ items: [Item], viewForItem: @escaping (Item) -> ItemView) {
    self.items = items
    self.viewForItem = viewForItem
  }

  var body: some View {
    GeometryReader { geometry in
      ForEach(items) { item in
        body(for: item, in: GridLayout(itemCount: items.count, in: geometry.size))
      }
    }
  }

  private func body(for item: Item, in layout: GridLayout) -> some View {
    let index: Int = items.firstIndex { $0.id == item.id }!
    return viewForItem(item)
      .frame(width: layout.itemSize.width, height: layout.itemSize.height)
      .position(layout.location(ofItemAt: index))
  }
}
