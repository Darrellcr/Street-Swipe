//
//  Spawner.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 20/07/25.
//

import Foundation
import GameplayKit

class Spawner: GKEntity {
    init(for obstacleType: ObstacleType, entityManager: EntityManager, scene: GameScene, customSpawnCondition: ((_ obstacleCount: Int, _ lastObstacleIndex: Int) -> Bool)? = nil) {
        super.init()
        
        let spawnerComponent = SpawnerComponent(
            obstacleType: obstacleType,
            entityManager: entityManager,
            obstacleFactory: ObstacleFactory(),
            scene: scene,
            customSpawnCondition: customSpawnCondition
        )
        addComponent(spawnerComponent)
        let spawnerGCComponent = SpawnerGCComponent(entityManager: entityManager)
        addComponent(spawnerGCComponent)
    }
    
    init(entityManager: EntityManager, scene: GameScene) {
        super.init()

        let trafficLightSpawnerComponent = TrafficLightSpawnerComponent(
            entityManager: entityManager,
            obstacleFactory: ObstacleFactory(),
            scene: scene
        )
        addComponent(trafficLightSpawnerComponent)
        let spawnerGCComponent = SpawnerGCComponent(entityManager: entityManager)
        addComponent(spawnerGCComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
