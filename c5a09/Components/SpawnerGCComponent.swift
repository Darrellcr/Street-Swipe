//
//  SpawnerGCComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 23/07/25.
//

import Foundation
import GameplayKit

class SpawnerGCComponent: GKComponent {
    let entityManager: EntityManager
    
    init(entityManager: EntityManager) {
        self.entityManager = entityManager
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        clearObstacleReferences()
        clearTrafficLightReferences()
    }
    
    private func clearObstacleReferences() {
        guard let spawnerComponent = entity?.component(ofType: SpawnerComponent.self)
        else { return }
        
        entityManager.toRemove.forEach { entity in
            guard spawnerComponent.obstacles.contains(where: { $0 === entity }) else { return }
        
            spawnerComponent.obstacles.removeAll(where: { $0 === entity })
        }
    }
    
    private func clearTrafficLightReferences() {
        entityManager.toRemove.forEach { entity in
            if entity === TrafficLightSpawnerComponent.zebraCross {
                TrafficLightSpawnerComponent.zebraCross = nil
            } else if entity === TrafficLightSpawnerComponent.pocong {
                TrafficLightSpawnerComponent.pocong = nil
            } else if entity === TrafficLightSpawnerComponent.leftTrafficLight {
                TrafficLightSpawnerComponent.leftTrafficLight = nil
            } else if entity === TrafficLightSpawnerComponent.rightTrafficLight {
                TrafficLightSpawnerComponent.rightTrafficLight = nil
            }
        }
    }
}
