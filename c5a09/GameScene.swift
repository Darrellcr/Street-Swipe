//
//  GameScene.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 11/07/25.
//

import SpriteKit
import GameplayKit
import AVKit

class GameScene: SKScene {
    var entityManager: EntityManager!
    var lastUpdateTime: TimeInterval = 0
    let gameCamera = GameCamera()
    static var playerCar: PlayerCar!
    
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
        
        Self.playerCar = PlayerCar.create(scene: self)
        entityManager.add(Self.playerCar)
        
        
        /* OBSTACLES */
        let chickenSpawner = Spawner(for: .chicken, entityManager: entityManager, scene: self)
        entityManager.add(chickenSpawner)
        let motorbikeSpawner = Spawner(for: .motorbike, entityManager: entityManager, scene: self) {obstacleCount,lastObstacleIndex in 
            return Double.random(in: 0...1) < 0.003 && RoadComponent.speed > 1 && obstacleCount < 3 && lastObstacleIndex < 110
        }
        entityManager.add(motorbikeSpawner)
        let trafficLightSpawner = Spawner(entityManager: entityManager, scene: self)
        entityManager.add(trafficLightSpawner)
        
//        let zebraCrossSpawner = Spawner(for: .zebraCross, entityManager: entityManager, scene: self) { obstacleCount, _ in
//            return RoadComponent.speed > 1 && obstacleCount < 1
//        }
//        entityManager.add(zebraCrossSpawner)
//        let leftTrafficLightSpawner = Spawner(for: .leftTrafficLight, entityManager: entityManager, scene: self) { obstacleCount, _ in
//            return RoadComponent.speed > 1 && obstacleCount < 1
//        }
//        entityManager.add(leftTrafficLightSpawner)
//        let rightTrafficLightSpawner = Spawner(for: .rightTrafficLight, entityManager: entityManager, scene: self) { obstacleCount, _ in
//            return RoadComponent.speed > 1 && obstacleCount < 1
//        }
//        entityManager.add(rightTrafficLightSpawner)
//        let pocongSpawner = Spawner(for: .pocong, entityManager: entityManager, scene: self) { osbtacleCount, _ in
//            return RoadComponent.speed > 1 && osbtacleCount < 1
//        }
//        entityManager.add(pocongSpawner)
        
        let alert = Alert(imageName: "police-Sheet", sheetColumns: 2, sheetRows: 1, zPosition: 100, offsetPct: 0.15, scene: self)
        entityManager.add(alert)
        let alert2 = Alert(imageName: "ambulance-Sheet", sheetColumns: 2, sheetRows: 1, zPosition: 100, offsetPct: 0.5, scene: self)
        entityManager.add(alert2)
        let alert3 = Alert(imageName: "police-Sheet", sheetColumns: 2, sheetRows: 1, zPosition: 100, offsetPct: 0.85, scene: self)
        entityManager.add(alert3)
        
        
        // BGM
//        let bgmUrl = Bundle.main.url(forResource: "street_swipe_BGM1_no_vocal", withExtension: "wav")
//        let bgmNode = SKAudioNode(url: bgmUrl!)
//        bgmNode.autoplayLooped = true
//        addChild(bgmNode)
//        bgmNode.run(SKAction.sequence([SKAction.changeVolume(to: 0.01, duration: 0),
//                                       SKAction.play()]))
    }
    
//    func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
//        if gesture.direction == .left {
//            gameCamera.moveLeft()
//        } else if gesture.direction == .right {
//            gameCamera.moveRight()
//        } else if gesture.direction == .up {
//            RoadComponent.speedBeforePan = min(speedConstants.count - 1, RoadComponent.speed + 1)
//        } else if gesture.direction == .down {
//            RoadComponent.speedBeforePan = max(0, RoadComponent.speed - 1)
//        }
//    }
    
    func handlePan(_ gesture: UIPanGestureRecognizer, view: UIView) {
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: self.view)
        let dx = translation.x
        let dy = -translation.y
        
        guard let playerCarSFXComponent = Self.playerCar.component(ofType: PlayerCarSFXComponent.self)
        else { return }
        
        switch gesture.state {
        case .began:
            RoadComponent.speedShift = 0
            gameCamera.xShift = 0
            panAction(dx, dy)
        case .changed:
            panAction(dx, dy)
            
            if abs(velocity.y) < 2 {
                playerCarSFXComponent.accelerationShouldPlay = false
                playerCarSFXComponent.decelerationShouldPlay = false
            } else if velocity.y > 0 {
                // handle pan downward
                playerCarSFXComponent.decelerationShouldPlay = true
                playerCarSFXComponent.accelerationShouldPlay = false
            } else {
                // handle pan upward
                playerCarSFXComponent.accelerationShouldPlay = true
                playerCarSFXComponent.decelerationShouldPlay = false
            }
        case .ended:
            panAction(dx, dy)
            RoadComponent.speedBeforePan = RoadComponent.speed
            RoadComponent.speedShift = 0
            gameCamera.xBeforePan = gameCamera.x
            gameCamera.xShift = 0
            
            playerCarSFXComponent.accelerationShouldPlay = false
            playerCarSFXComponent.decelerationShouldPlay = false
        default:
            break
        }
    }
    
    func panAction(_ dx: Double, _ dy: Double) {
        var unit = 150.0 / Double(gameCamera.maxX)
        gameCamera.xShift = dx / unit
        unit = 380.0 / Double(speedConstants.count)
        RoadComponent.speedShift = Int(round(dy / unit))
    }
    
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = (lastUpdateTime == 0) ? 0 : currentTime - lastUpdateTime
        lastUpdateTime = currentTime

//        gameCamera.updatePosition(segmentShift: speedConstants[RoadComponent.speed][frameIndex])
        entityManager.update(deltaTime)
        
        frameIndex = (frameIndex + 1) % speedConstants[0].count
    }
}
