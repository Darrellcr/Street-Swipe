//
//  Ambulance.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 23/07/25.
//

import Foundation
import SpriteKit
import GameplayKit

class Ambulance: GKEntity {
    init(ambulancePosition: AmbulancePosition, scene: GameScene, entityManager: EntityManager, onCollision: ((CGPoint) -> Void)? = nil) {
        super.init()
        
        let renderComponent = RenderComponent(texture: SKTexture(imageNamed: "obstacle_ambulance"), zPosition: 9)
        addComponent(renderComponent)
        
        let sizeComponent = SizeComponent(width: 260)
        addComponent(sizeComponent)
        
        let offsetPct: CGFloat
        switch ambulancePosition {
        case .left:
            offsetPct = 0.15
        case .middle:
            offsetPct = 0.5
        case .right:
            offsetPct = 0.85
        }
        let positionRelativeComponent = PositionRelativeComponent(index: 1, offsetPct: offsetPct, scene: scene, entityManager: entityManager)
        addComponent(positionRelativeComponent)
        
        let ambulanceSpeedComponent = AmbulanceSpeedComponent(scene: scene)
        addComponent(ambulanceSpeedComponent)
        
        let collisionComponent = CollisionComponent(customBoxSize: CGSize(width: 210, height: 210), onCollision: onCollision)
        addComponent(collisionComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
