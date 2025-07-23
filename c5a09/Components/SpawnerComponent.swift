//
//  SpawnerComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 20/07/25.
//

import Foundation
import GameplayKit

class SpawnerComponent: GKComponent {
    let obstacleType: ObstacleType
    let entityManager: EntityManager
    let obstacleFactory: ObstacleFactory
    let scene: GameScene
    var obstacles: [GKEntity] = []
    var customSpawnCondition: ((_ obstacleCount: Int, _ lastObstacleIndex: Int) -> Bool)?
    
    init(obstacleType: ObstacleType, entityManager: EntityManager, obstacleFactory: ObstacleFactory, scene: GameScene, customSpawnCondition: ((_ obstacleCount: Int, _ lastObstacleIndex: Int) -> Bool)? = nil) {
        self.obstacleType = obstacleType
        self.entityManager = entityManager
        self.obstacleFactory = obstacleFactory
        self.scene = scene
        self.customSpawnCondition = customSpawnCondition
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        var spawnCondition: Bool
        let lastObstacleIndex = obstacles.count == 0
        ? 0
        : obstacles[obstacles.count - 1].component(ofType: PositionRelativeComponent.self)?.index
        
        if let customSpawnCondition {
            spawnCondition = customSpawnCondition(obstacles.count, lastObstacleIndex ?? 0)
        } else {
            spawnCondition = Double.random(in: 0...1) < 0.003 && RoadComponent.speed > 0 && obstacles.count < 3
        }
        
        if spawnCondition {
            let obstacle = obstacleFactory.create(obstacleType, scene: scene, entityManager: entityManager)

            entityManager.add(obstacle)
            obstacles.append(obstacle)
//            print("spawned obstacle")
        }
//        entityManager.toRemove.forEach { entity in
//            guard obstacles.contains(where: { $0 === entity }) else { return }
//        
//            obstacles.removeAll(where: { $0 === entity })
//        }
    }
}
