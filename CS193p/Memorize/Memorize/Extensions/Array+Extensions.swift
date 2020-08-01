//
//  Array+Extensions.swift
//  Memorize
//
//  Created by John Lima on 8/1/20.
//

import Foundation

extension Array {
  var only: Element? {
    count == 1 ? first : nil
  }
}
