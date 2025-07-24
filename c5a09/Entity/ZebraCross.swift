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
            print("bad stop")
        } onGoodStop: {
            print("good stop")
        } onPerfectStop: {
            print("perfect stop")
        } onCollision: {
            print("tinu2")
        }
        addComponent(zebraCrossCollisionComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
