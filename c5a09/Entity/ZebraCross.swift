//
//  ZebraCross.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 21/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class ZebraCross: GKEntity {
    init(texture: SKTexture, numSegments: Int, index: Int, scene: GameScene, entityManager: EntityManager) {
        super.init()
        
        let renderComponent = RenderComponent(zPosition: 1)
        addComponent(renderComponent)
        let zebraCrossComponent = ZebraCrossComponent(texture: texture, numSegments: numSegments, index: index, scene: scene, entityManager: entityManager)
        addComponent(zebraCrossComponent)
        let zebraCrossCollisionComponent = ZebraCrossCollisionComponent() {
            GameState.shared.score += 100
            entityManager.add(GradingLabelEntity(grade: .bad, parent: scene))
            print("bad stop")
        } onGoodStop: {
            entityManager.add(GradingLabelEntity(grade: .good, parent: scene))
            GameState.shared.score += 250
            print("good stop")
        } onPerfectStop: {
            entityManager.add(GradingLabelEntity(grade: .perfect, parent: scene))
            GameState.shared.score += 500
            print("perfect stop")
        } onCollision: {
            scene.spawnPoliceAlert()
            print("tinu2")
        }
        addComponent(zebraCrossCollisionComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
