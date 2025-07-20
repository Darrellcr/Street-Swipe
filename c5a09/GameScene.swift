//
//  GameScene.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 11/07/25.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var entityManager: EntityManager!
    var lastUpdateTime: TimeInterval = 0
    let gameCamera = GameCamera()
    
    var frameIndex = 0
    var speedConstants = [
        [0, 0, 0, 0, 0, 0], // 0
        [1, 0, 0, 1, 0, 0], // 1: 20
        [1, 1, 0, 1, 0, 0], // 2: 30
        [1, 1, 0, 1, 1, 0], // 3: 40
        [1, 1, 1, 1, 1, 0], // 4: 50
        [1, 1, 1, 1, 1, 1], // 5: 60
        [2, 1, 1, 1, 1, 1], // 6: 70
        [2, 1, 1, 2, 1, 1], // 7: 80
        [2, 2, 1, 2, 1, 1], // 8: 90
        [2, 2, 1, 2, 2, 1], // 9: 100
        [2, 2, 2, 2, 2, 1], // 10: 110
        [2, 2, 2, 2, 2, 2], // 11: 120
        [3, 2, 2, 2, 2, 2], // 12: 130
        [3, 2, 2, 3, 2, 2], // 13: 140
        [3, 3, 2, 3, 2, 2], // 14: 150
        [3, 3, 2, 3, 3, 2], // 15: 160
        [3, 3, 3, 3, 3, 2], // 16: 170
        [3, 3, 3, 3, 3, 3], // 17: 180
    ]
    
    override func didMove(to view: SKView) {
        entityManager = EntityManager(scene: self)
        
        let backgroundBottom = BackgroundBottom.create(scene: self)
        entityManager.add(backgroundBottom)
        
        let backgroundTop = BackgroundTop.create(scene: self)
        entityManager.add(backgroundTop)

        let roadSegments = RoadSegment.createRoad(scene: self)
        for roadSegment in roadSegments {
            entityManager.add(roadSegment)
        }
        
        let playerCar = PlayerCar.create(scene: self)
        entityManager.add(playerCar)
    }
    
    func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            gameCamera.moveLeft()
        } else if gesture.direction == .right {
            gameCamera.moveRight()
        } else if gesture.direction == .up {
            RoadComponent.speedBeforePan = min(speedConstants.count - 1, RoadComponent.speed + 1)
        } else if gesture.direction == .down {
            RoadComponent.speedBeforePan = max(0, RoadComponent.speed - 1)
        }
    }
    
    func handlePan(_ gesture: UIPanGestureRecognizer, view: UIView) {
        let translation = gesture.translation(in: view)
//        let velocity = gesture.velocity(in: self.view)
        let dx = translation.x
        let dy = -translation.y
        
        switch gesture.state {
        case .began:
            RoadComponent.speedShift = 0
            gameCamera.xShift = 0
            panAction(dx, dy)
        case .changed:
            panAction(dx, dy)
        case .ended:
            panAction(dx, dy)
            RoadComponent.speedBeforePan = RoadComponent.speed
            RoadComponent.speedShift = 0
            gameCamera.xBeforePan = gameCamera.x
            gameCamera.xShift = 0
        default:
            break
        }
        
//        print("dx \(dx), dy \(dy)")
    }
    
    func panAction(_ dx: Double, _ dy: Double) {
        if abs(dx) > abs(dy) {
            let unit = 150.0 / Double(gameCamera.maxX)
            gameCamera.xShift = dx / unit
        } else {
            let unit = 380.0 / Double(speedConstants.count)
            RoadComponent.speedShift = Int(round(dy / unit))
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = (lastUpdateTime == 0) ? currentTime : currentTime - lastUpdateTime
        
//        gameCamera.updatePosition(segmentShift: speedConstants[RoadComponent.speed][frameIndex])
//        print(gameCamera.x)
        entityManager.update(deltaTime)
        
        frameIndex = (frameIndex + 1) % speedConstants[0].count
    }
}
