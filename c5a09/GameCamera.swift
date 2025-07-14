//
//  GameCamera.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 14/07/25.
//

import Foundation

class GameCamera {
    var x: CGFloat = 0.0
    let maxX: CGFloat = 10.0
    let minX: CGFloat = -10.0
    
    func moveLeft(_ distance: CGFloat) {
        x = max(x - distance, minX)
    }
    
    func moveRight(_ distance: CGFloat) {
        x = min(x + distance, maxX)
    }
}
