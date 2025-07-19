//
//  PlayerCar.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 17/07/25.
//

import Foundation
import SpriteKit

class PlayerCar {
    private let image: String = "car 2"
    private let width: CGFloat = 270
    private let showBoundingBox: Bool = true
    
    private(set) var node = SKSpriteNode()
    
    init(sceneSize: CGSize) {
        let playerCarTexture = SKTexture(imageNamed: "car 2")
        let aspectRatio = playerCarTexture.size().width / playerCarTexture.size().height
        node.texture = playerCarTexture
        let desiredWidth: CGFloat = 220
        let desiredHeight: CGFloat = desiredWidth / aspectRatio
        node.size = CGSize(width: desiredWidth, height: desiredHeight)
        node.position = CGPoint(x: sceneSize.width / 2, y: node.size.height * 1.6)
        node.zPosition = 100
        
        if showBoundingBox {
            let boundingBox = SKNode()
            boundingBox.name = "boundingBox"
            boundingBox.position = CGPoint(x: node.position.x, y: node.position.y)
            boundingBox.userData = ["size": CGSize(width: 240, height: 140)]
            node.addChild(boundingBox)
        }
    }
}
