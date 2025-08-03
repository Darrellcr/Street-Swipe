//
//  GameCamera.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 20/07/25.
//

import Foundation

class GameCamera {
    let maxX: Double = 0.3
    let minX: Double = -0.3

    var xBeforePan: Double = 0.0
    var xShift: Double = 0.0
    var x: Double {
        min(maxX, max(minX, xBeforePan + xShift))
    }
}
