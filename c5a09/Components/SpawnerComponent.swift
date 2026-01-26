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
        
        guard canSpawn() else { return }
        
        let obstacle = obstacleFactory.create(obstacleType, scene: scene, entityManager: entityManager)
        entityManager.add(obstacle)
        obstacles.append(obstacle)
    }
    
    private func canSpawn() -> Bool {
        guard scene.spawnerEnabled else { return false }
        
        let lastObstacleIndex = obstacles.count == 0
        ? 0
        : obstacles[obstacles.count - 1].component(ofType: PositionRelativeComponent.self)?.index
        
        guard let customSpawnCondition else {
            return Double.random(in: 0...1) < 0.003 && RoadComponent.speed > 0 && obstacles.count < 3
        }
        return customSpawnCondition(obstacles.count, lastObstacleIndex ?? 0)
    }
}
