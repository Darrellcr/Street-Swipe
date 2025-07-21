//
//  SpawnerFactory.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 20/07/25.
//

import Foundation
import GameplayKit

class ObstacleFactory {
    func create(_ type: ObstacleType, scene: GameScene, entityManager: EntityManager) -> GKEntity {
        let roadLastIndex = RoadComponent.positions.count - 1
        let offsetPct: CGFloat = CGFloat.random(in: 0...1)
        var entity: GKEntity
        switch type {
        case .chicken:
            entity = StaticObstacle(
                texture: SKTexture(imageNamed: "chicken"),
                index: roadLastIndex,
                offsetPct: offsetPct,
                scene: scene,
                width: 210,
                entityManager: entityManager
            )
        case .motorbike:
            entity = DynamicObstacle(
                texture: SKTexture(imageNamed: "motor"),
                index: roadLastIndex,
                offsetPct: offsetPct,
                speed: 1,
                scene: scene,
                width: 300,
                entityManager: entityManager
            )
        case .leftTrafficLight:
            entity = TrafficLight(
                texture: SKTexture(imageNamed: "L red light"),
                index: roadLastIndex,
                offsetPct: -0.12,
                scene: scene,
                width: 900,
                entityManager: entityManager,
                positions: [
                    .red: CGPoint(x: 100, y: 347),
                    .yellow: CGPoint(x: 203, y: 347),
                    .green: CGPoint(x: 303, y: 347)
                ],
                textures: [
                    .red: SKTexture(imageNamed: "L red light"),
                    .yellow: SKTexture(imageNamed: "L yellow light"),
                    .green: SKTexture(imageNamed: "L green light")
                ]
            )
        case .rightTrafficLight:
            entity = TrafficLight(
                texture: SKTexture(imageNamed: "red light"),
                index: roadLastIndex,
                offsetPct: 1.6,
                scene: scene,
                width: 900,
                entityManager: entityManager,
                positions: [
                    .red: CGPoint(x: -220, y: 347),
                    .yellow: CGPoint(x: -220, y: 247),
                    .green: CGPoint(x: -220, y: 147)
                ],
                textures: [
                    .red: SKTexture(imageNamed: "red light"),
                    .yellow: SKTexture(imageNamed: "yellow light"),
                    .green: SKTexture(imageNamed: "green light")
                ]
            )
        }
        
        return entity
    }
}

enum ObstacleType {
    case chicken
    case motorbike
    case leftTrafficLight
    case rightTrafficLight
}
