//
//  PositionRelative.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 19/07/25.
//

import Foundation
import GameplayKit

class PositionRelativeComponent: GKComponent {
    var index: Int
    var offsetPct: CGFloat
    let scene: GameScene
    let entityManager: EntityManager
    var zPosition: CGFloat = 0
    private var node: SKSpriteNode!
    
    init(index: Int, offsetPct: CGFloat, scene: GameScene, entityManager: EntityManager) {
        self.index = index
        self.offsetPct = offsetPct
        self.scene = scene
        self.entityManager = entityManager
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        
        guard let node = entity?.component(ofType: RenderComponent.self)?.node else {
            assert(false, "Missing required RenderComponent")
        }
        
        self.node = node
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        let roadPosition = RoadComponent.positions[index]
        let roadScale = RoadComponent.scales[index]
        let roadSize = RoadComponent.sizes[index]
        
        let roadStartX = roadPosition.x - (roadSize.width * 0.5)
        let offsetX = roadSize.width * offsetPct
        node.position = CGPoint(x: roadStartX + offsetX, y: roadPosition.y)
        
        let prevXScale = node.xScale
        node.setScale(min(1.2 * roadScale, 0.75))
        if prevXScale < 0 {
            node.xScale *= -1
        }
        
        let roadShift = scene.speedConstants[RoadComponent.speed][scene.frameIndex]
        index -= roadShift
        index = max(0, min(RoadComponent.positions.count - 1, index))
        if index <= 0 || index >= RoadComponent.positions.count - 5 {
            entityManager.remove(entity!)
        }
    }
}
