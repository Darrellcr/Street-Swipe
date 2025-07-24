//
//  SpawnerFactory.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 20/07/25.
//

import Foundation
import GameplayKit

class ObstacleFactory {
    func create(_ type: ObstacleType, scene: GameScene, entityManager: EntityManager, index: Int? = nil) -> GKEntity {
        let roadLastIndex = RoadComponent.positions.count - 1
        let offsetPct: CGFloat = CGFloat.random(in: 0...1)
        var entity: GKEntity
        switch type {
        case .chicken:
            entity = StaticObstacle(
                texture: SKTexture(imageNamed: "chicken"),
                index: index ?? roadLastIndex,
                offsetPct: offsetPct,
                scene: scene,
                width: 170,
                entityManager: entityManager,
                collisionBoxSize: CGSize(width: 140, height: 154)
            ) { position in
                print("nabrak ayam")
                self.spawnExplosion(position: position, entityManager: entityManager)
                scene.gameOver()
            }
        case .motorbike:
            entity = DynamicObstacle(
                texture: SKTexture(imageNamed: "motor"),
                index: index ?? roadLastIndex,
                offsetPct: offsetPct,
                speed: 1,
                scene: scene,
                width: 300,
                entityManager: entityManager,
                collisionBoxSize: CGSize(width: 144, height: 220)
            ) { position in
                print("nabrak motor")
                self.spawnExplosion(position: position, entityManager: entityManager)
                scene.gameOver()
            }
        case .leftTrafficLight:
            entity = TrafficLight(
                texture: SKTexture(imageNamed: "L red light"),
                index: index ?? roadLastIndex,
                offsetPct: -0.2,
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
                index: index ?? roadLastIndex,
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
        case .pocong:
            entity = Pocong(
                texture: SKTexture(imageNamed: "pocong"),
                index: index ?? roadLastIndex,
                crossingFrom: (Double.random(in: 0...1) < 0.5) ? .right : .left,
                scene: scene,
                width: 90,
                entityManager: entityManager
            ) { position in
                print("nabrak pocong")
                self.spawnExplosion(position: position, entityManager: entityManager)
                scene.gameOver()
            }
        case .zebraCross:
            entity = ZebraCross(
                texture: SKTexture(imageNamed: "zebra cross"),
                numSegments: 17,
                index: index ?? roadLastIndex,
                scene: scene,
                entityManager: entityManager
            )
        }
        
        return entity
    }
    
    private func spawnExplosion(position: CGPoint, entityManager: EntityManager) {
        let explosion = Explosion(position: position)

        entityManager.add(explosion)
    }
}

enum ObstacleType {
    case chicken
    case motorbike
    case leftTrafficLight
    case rightTrafficLight
    case pocong
    case zebraCross
}

