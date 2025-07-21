//
//  TrafficLight.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 16/07/25.
//

import Foundation
import SpriteKit

struct TrafficLight {
    var index: Int
    var sprite: SKSpriteNode
    var offsetPct: CGFloat = 0
    var state: String = "red"
    var countDown: Int = 1000
    
    
}
