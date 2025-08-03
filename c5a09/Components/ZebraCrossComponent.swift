//
//  ZebraCrossComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 21/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class ZebraCrossComponent: GKComponent {
    let texture: SKTexture
    let numSegments: Int
    var index: Int
    let scene: GameScene
    let entityManager: EntityManager
    
    init(texture: SKTexture, numSegments: Int, index: Int, scene: GameScene, entityManager: EntityManager) {
        self.texture = texture
        self.numSegments = numSegments
        self.index = index
        self.scene = scene
        self.entityManager = entityManager
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        let numSegmentsShown = min(RoadComponent.positions.count - index, numSegments)
        let gameCamera = scene.gameCamera
        guard let parentNode = entity?.component(ofType: RenderComponent.self)?.node
        else { return }
        
        parentNode.removeAllChildren()
        for i in 0..<numSegmentsShown {
            guard index + i >= 0 else { continue }
            let position = RoadComponent.positions[index + i]
//            let scale = RoadComponent.scales[index + i]
            let size = RoadComponent.sizes[index + i]
            
            let node = SKSpriteNode(texture: texture)
            node.anchorPoint = CGPoint(x: 0.5, y: 0)
            node.position.y = position.y
            node.size = size
            
            let horizontalShiftPct = -0.3 + ((gameCamera.x - gameCamera.minX) * 0.6 / (gameCamera.maxX - gameCamera.minX))
            let roadShift = CGFloat(horizontalShiftPct) * size.width
            let positionX = scene.size.width / 2 - roadShift
            node.position.x = positionX
            parentNode.addChild(node)
        }
        if index + numSegmentsShown - 1 < 0 {
            entityManager.remove(entity!)
        }
        
        let shift = scene.speedConstants[RoadComponent.speed][scene.frameIndex]
        index -= shift
    }
}
