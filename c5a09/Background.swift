//
//  Background.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 16/07/25.
//

import Foundation
import SpriteKit

class Background {
    let node = SKNode()
    
    init(sceneSize: CGSize) {
        let backgroundTexture = SKTexture(imageNamed: "night sky")
        let background = SKSpriteNode(texture: backgroundTexture)
        background.anchorPoint = CGPoint(x: 0.0, y: 1.0)
        background.position = CGPoint(x: 0.0, y: sceneSize.height)
        let backgroundAspectRatio = backgroundTexture.size().width / backgroundTexture.size().height
        background.size.width = sceneSize.width
        background.size.height = sceneSize.width / backgroundAspectRatio
        background.zPosition = 2 // Place behind everything
        background.lightingBitMask = TrafficLight.categoryBitMask // React to light
        
        node.addChild(background)
        
        let baseBackground = SKSpriteNode(color: .black, size: sceneSize)
        baseBackground.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        baseBackground.position = CGPoint(x: 0.0, y: 0.0)
        baseBackground.lightingBitMask = TrafficLight.categoryBitMask 
        baseBackground.zPosition = 1
        node.addChild(baseBackground)
    }
}
