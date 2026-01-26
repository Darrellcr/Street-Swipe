//
//  Highway.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 13/01/26.
//

import GameplayKit
//import SpriteKit

class Highway: GKEntity {
    private let highwayComponent: HighwayComponent
    private let ticketSpawnerComponent: TicketSpawnerComponent
    private let clockSpawnerComponent: ClockSpawnerComponent
    
    init(scene: GameScene, entityManager: EntityManager) {
        highwayComponent = HighwayComponent(scene: scene, entityManager: entityManager)
        ticketSpawnerComponent = TicketSpawnerComponent(scene: scene, entityManager: entityManager)
        clockSpawnerComponent = ClockSpawnerComponent(scene: scene, entityManager: entityManager)

        super.init()
        addComponent(highwayComponent)
        addComponent(ticketSpawnerComponent)
        addComponent(clockSpawnerComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reset() {
        highwayComponent.reset()
        ticketSpawnerComponent.reset()
        clockSpawnerComponent.reset()
    }
}
