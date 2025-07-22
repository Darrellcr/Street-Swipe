//
//  Pocong.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 21/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class Pocong: GKEntity {
    init(texture: SKTexture, index: Int, crossingFrom: CrossingFrom, scene: GameScene, width: CGFloat, entityManager: EntityManager, onCollision: (() -> Void)? = nil) {
        super.init()
        
        let renderComponent = RenderComponent(texture: texture, zPosition: 8)
        addComponent(renderComponent)
        let sizeComponent = SizeComponent(width: width)
        addComponent(sizeComponent)
        let positionRelativeComponent = PositionRelativeComponent(index: index, offsetPct: 0.1, scene: scene, entityManager: entityManager)
        addComponent(positionRelativeComponent)
        let crossingComponent = CrossingComponent(crossingFrom: crossingFrom)
        addComponent(crossingComponent)
        let collisionComponent = CollisionComponent(onCollision: onCollision)
        addComponent(collisionComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
