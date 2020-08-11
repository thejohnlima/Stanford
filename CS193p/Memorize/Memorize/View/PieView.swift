//
//  PieView.swift
//  Memorize
//
//  Created by John Lima on 8/5/20.
//

import SwiftUI

struct PieView: Shape {
  var startAngle: Angle
  var endAngle: Angle
  var clockwise: Bool

  var animatableData: AnimatablePair<Double, Double> {
    get {
      AnimatablePair(startAngle.radians, endAngle.radians)
    }
    set {
      startAngle = Angle.radians(newValue.first)
      endAngle = Angle.radians(newValue.second)
    }
  }

  func path(in rect: CGRect) -> Path {
    let center = CGPoint(x: rect.midX, y: rect.midY)
    let radius = min(rect.width, rect.height) / 2

    let start = CGPoint(
      x: center.x + radius * cos(CGFloat(startAngle.radians)),
      y: center.y + radius * sin(CGFloat(startAngle.radians))
    )

    var path = Path()
    path.move(to: center)
    path.addLine(to: start)

    path.addArc(
      center: center,
      radius: radius,
      startAngle: startAngle,
      endAngle: endAngle,
      clockwise: clockwise
    )

    return path
  }
}
