//
//  DynamicObstacle.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 16/07/25.
//

import Foundation
import SpriteKit

struct DynamicObstacle {
    var index: Int
    var sprite: SKSpriteNode
    var offsetPct: CGFloat = 0
    var velocity: CGFloat = 0.01
    var direction: CGFloat = 1
    
    static func spawn() {
        
    }
}
