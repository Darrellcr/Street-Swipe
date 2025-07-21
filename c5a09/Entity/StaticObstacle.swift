//
//  StaticObstacle.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 20/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class StaticObstacle: GKEntity {
    init(texture: SKTexture, index: Int, offsetPct: CGFloat, scene: GameScene, width: CGFloat, entityManager: EntityManager) {
        super.init()
        
        let renderComponent = RenderComponent(texture: texture, zPosition: 9)
        addComponent(renderComponent)
        let sizeComponent = SizeComponent(width: width)
        addComponent(sizeComponent)
        let positionRelativeComponent = PositionRelativeComponent(index: index, offsetPct: offsetPct, scene: scene, entityManager: entityManager)
        addComponent(positionRelativeComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
