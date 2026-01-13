//
//  Highway.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 13/01/26.
//

import GameplayKit
//import SpriteKit

class Highway: GKEntity {
    init(scene: GameScene, entityManager: EntityManager) {
        super.init()
        
        let highwayComponent = HighwayComponent()
        addComponent(highwayComponent)
        let ticketSpawnerComponent = TicketSpawnerComponent(scene: scene, entityManager: entityManager)
        addComponent(ticketSpawnerComponent)
        let clockSpawnerComponent = ClockSpawnerComponent(scene: scene, entityManager: entityManager)
        addComponent(clockSpawnerComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
