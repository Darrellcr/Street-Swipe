//
//  Background.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 16/07/25.
//

import Foundation
import SpriteKit

class Background {
    let node: SKSpriteNode
    
    init(sceneSize: CGSize) {
        let backgroundTexture = SKTexture(imageNamed: "night sky")
        node = SKSpriteNode(texture: backgroundTexture)
        node.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        node.position = CGPoint(x: 0.0, y: sceneSize.height)
        let backgroundAspectRatio = backgroundTexture.size().width / backgroundTexture.size().height
        node.size.width = sceneSize.width
        node.size.height = sceneSize.width / backgroundAspectRatio
        node.zPosition = 1 // Place behind everything
        node.lightingBitMask = 0b1 // React to light
        
    }
}
