//
//  DynamicObstacle.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 21/07/25.
//

import Foundation
import SpriteKit
import GameplayKit

class DynamicObstacle: GKEntity {
    init(texture: SKTexture, index: Int, offsetPct: CGFloat, speed: Int, scene: GameScene, width: CGFloat, entityManager: EntityManager, collisionBoxSize: CGSize? = nil, canMoveSideways: Bool = false, onCollision: ((CGPoint) -> Void)? = nil) {
        super.init()
        
        let renderComponent = RenderComponent(texture: texture, zPosition: 9)
        addComponent(renderComponent)
        let sizeComponent = SizeComponent(width: width)
        addComponent(sizeComponent)
        let positionRelativeComponent = PositionRelativeComponent(index: index, offsetPct: offsetPct, scene: scene, entityManager: entityManager)
        addComponent(positionRelativeComponent)
        let speedComponent = SpeedComponent(speed: speed, scene: scene)
        addComponent(speedComponent)
        let collisionComponent = CollisionComponent(customBoxSize: collisionBoxSize, onCollision: onCollision)
        addComponent(collisionComponent)
        
        guard canMoveSideways else { return }
        let moveSidewaysComponent = MoveSidewaysComponent(speed: 0.005)
        addComponent(moveSidewaysComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
