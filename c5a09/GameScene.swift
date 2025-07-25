//
//  GameScene.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 11/07/25.
//

import AVFoundation
import SpriteKit
import GameplayKit
import AVKit

class GameScene: SKScene, ObservableObject {
    var gameOverStop: Bool = false
    
    var entityManager: EntityManager!
    var lastUpdateTime: TimeInterval = 0
    let gameCamera = GameCamera()
    static var playerCar: PlayerCar!
    
    var ambulance: Ambulance? = nil
    var ambulanceAlert: AmbulanceAlert? = nil
    var policeAlert: PoliceAlert? = nil
    
    static var speedometer: Speedometer!
    static var scoreEntity: ScoreLabel!
    static var speedEntity: SpeedLabel!
    
    private let soundManager = SoundManager()
    
    let scoreLabel = SKLabelNode(fontNamed: "Mini Mouse Regular")
    
    var score: Int = 0
    
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
    
    static var crashAudioNode: SKAudioNode!
    static var gameOverAudioNode: SKAudioNode!
    
    func spawnPoliceAlert() {
        if policeAlert == nil {
            policeAlert = PoliceAlert(zPosition: 100, scene: self, entityManager: entityManager)
            entityManager.add(policeAlert!)
        }
        else {
            RoadComponent.speedBeforePan = 0
            RoadComponent.speedShift = 0
            GameState.shared.isGameOver = true
        }
    }
    
    override func didMove(to view: SKView) {
        //        soundManager.playBackgroundMusic()
        
        entityManager = EntityManager(scene: self)
        AudioManager.shared.attach(to: self)
        
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
        
        Self.speedometer = Speedometer.create(scene: self)
        entityManager.add(Self.speedometer)
        
        // BGM
//        let bgmUrl = Bundle.main.url(forResource: "street_swipe_full_BGM", withExtension: "wav")
//        let bgmNode = SKAudioNode(url: bgmUrl!)
//        bgmNode.autoplayLooped = true
//        addChild(bgmNode)
//        bgmNode.run(SKAction.sequence([SKAction.changeVolume(to: 0.4, duration: 0),
//                                       SKAction.play()]))
        
        let crashUrl = Bundle.main.url(forResource: "car crash", withExtension: "mp3")
        let crashSfx = SKAudioNode(url: crashUrl!)
        crashSfx.autoplayLooped = false
        addChild(crashSfx)
        Self.crashAudioNode = crashSfx
        
        let gameOverSoundUrl = Bundle.main.url(forResource: "game over", withExtension: "wav")
        let gameOverSoundNode = SKAudioNode(url: gameOverSoundUrl!)
        gameOverSoundNode.autoplayLooped = false
        addChild(gameOverSoundNode)
        Self.gameOverAudioNode = gameOverSoundNode
        
        let scorePosition = CGPoint(x: size.width / 2, y: size.height - 100)
        Self.scoreEntity = ScoreLabel(text: 0, fontName: "Mine Mouse Regular", position: scorePosition)
        entityManager.add(Self.scoreEntity)
        
        let speedPosition = CGPoint(x: size.width / 2 - 110, y: size.height - 815)
        Self.speedEntity = SpeedLabel(text: 0, fontName: "Mine Mouse Regular", position: speedPosition)
        entityManager.add(Self.speedEntity)
        
//        scoreLabel.fontName = "Mine Mouse Regular"
//        scoreLabel.fontSize = 35
//        scoreLabel.fontColor = .white
//        scoreLabel.position = CGPoint(x: size.width * 0.5, y: size.height - 100)
//        scoreLabel.zPosition = 1000
//        addChild(scoreLabel)

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
    
    func handlePan(translation: CGSize, velocity: CGSize, state: UIPanGestureRecognizer.State) {
        let dx = translation.width
        let dy = -translation.height

        guard let playerCarSFXComponent = Self.playerCar.component(ofType: PlayerCarSFXComponent.self)
        else { return }
        
        guard !gameOverStop else {
            playerCarSFXComponent.accelerationShouldPlay = false
            playerCarSFXComponent.decelerationShouldPlay = false
            return
        }
        
        switch state {
        case .began:
            RoadComponent.speedShift = 0
            gameCamera.xShift = 0
            panAction(dx, dy)
        case .changed:
            panAction(dx, dy)
            
            if abs(velocity.height) < 2 {
                playerCarSFXComponent.accelerationShouldPlay = false
                playerCarSFXComponent.decelerationShouldPlay = false
            } else if velocity.height > 0 {
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
        if GameState.shared.isGameOver { return }
        var unit = 150.0 / Double(gameCamera.maxX)
        gameCamera.xShift = dx / unit
        unit = 380.0 / Double(speedConstants.count)
        RoadComponent.speedShift = Int(round(dy / unit))
    }
    
    override func update(_ currentTime: TimeInterval) {
        let deltaTime = (lastUpdateTime == 0) ? 0 : currentTime - lastUpdateTime
        lastUpdateTime = currentTime
        
        guard GameState.shared.isRunning && !GameState.shared.isGameOver else {
            entityManager.update(deltaTime)
            frameIndex = (frameIndex + 1) % speedConstants[0].count
            return
        }
        
//        AMBULANCE SPAWNING
//        CASE 1: Start ambulance alert
        if ambulanceAlert == nil && ambulance == nil && Double.random(in: 0...1) <= 0.05 {
            let ambulancePosition: AmbulancePosition
            let randomzier = Double.random(in: 0...1)
            if randomzier <= 0.33 {
                ambulancePosition = .left
            } else if randomzier <= 0.67 {
                ambulancePosition = .middle
            } else {
                ambulancePosition = .right
            }
            
            ambulanceAlert = AmbulanceAlert(ambulancePosition: ambulancePosition, zPosition: 100, scene: self, entityManager: entityManager)
            entityManager.add(ambulanceAlert!)
            AudioManager.shared.play("ambulance siren.wav", 2)
        }
//        CASE 2: Alert is done & spawn ambulance
        if ambulanceAlert != nil && ambulanceAlert!.component(ofType: CountDownComponent.self)!.state == .done && ambulance == nil {
            let ambulancePosition: AmbulancePosition
            let offsetPct = ambulanceAlert!.component(ofType: AlertPositionComponent.self)!.offsetPct
            
            if offsetPct <= 0.15 {
                ambulancePosition = .left
            } else if offsetPct <= 0.5 {
                ambulancePosition = .middle
            } else {
                ambulancePosition = .right
            }
            
            ambulance = Ambulance(ambulancePosition: ambulancePosition, scene: self, entityManager: entityManager) { position in
                print("nabrak ambulance")
                guard let speedComponent = self.ambulance?.component(ofType: AmbulanceSpeedComponent.self)
                else { return }
                
                speedComponent.crashed = true
                
                let explosion = Explosion(position: position)
                self.entityManager.add(explosion)
                GameScene.crashAudioNode.run(SKAction.play())
                self.gameOver(crashSoundPlayed: true)
            }
            entityManager.add(ambulance!)
        }
//        CASE 3: Alert is done & ambulance already passed
        if ambulanceAlert != nil && ambulanceAlert!.component(ofType: CountDownComponent.self)!.state == .done && ambulance != nil && ambulance!.component(ofType: PositionRelativeComponent.self)!.index >= RoadComponent.positions.count - 5 {
            ambulanceAlert = nil
            ambulance = nil
        }

       
        
//        POLICE SPAWNING (NANTI DIGANTI)
//        CASE 1: Start police alert
//        if policeAlert == nil && Double.random(in: 0...1) <= 0.05 {
//            policeAlert = PoliceAlert(zPosition: 100, scene: self, entityManager: entityManager)
//            entityManager.add(policeAlert!)
//        }
//        CASE 2: Alert is done & reset
        if policeAlert != nil && policeAlert!.component(ofType: CountDownComponent.self)!.state == .done {
            policeAlert = nil
        }
        
        
        
//        gameCamera.updatePosition(segmentShift: speedConstants[RoadComponent.speed][frameIndex])
        //Update Scoring
        let increment = speedConstants[RoadComponent.speed][frameIndex]
        GameState.shared.score += increment
//        print("Score: \(GameState.shared.score)")
        
        // 2. Update label skor
        if let scoreLabelComponent = GameScene.scoreEntity.component(ofType: RenderLabelComponent.self) {
            scoreLabelComponent.updateLabelText(with: GameState.shared.score)
        }
        
        // 3. Update label kecepatan (misalnya dari GameState.shared.speed)
        if let speedLabelComponent = GameScene.speedEntity.component(ofType: RenderLabelComponent.self) {
            speedLabelComponent.updateLabelText(with: RoadComponent.speed)
        }
        
        if let speedBar = GameScene.speedometer.component(ofType: SpeedBarComponent.self) {
            speedBar.updateSpeedLevel(to: RoadComponent.speed)
        }
        
        //        gameCamera.updatePosition(segmentShift: speedConstants[RoadComponent.speed][frameIndex])
        entityManager.update(deltaTime)
        
        frameIndex = (frameIndex + 1) % speedConstants[0].count
    }
    
    func resetGame() {
        entityManager.reset()
//        distance = 0
//        timer = 0
//        isGameRunning = true
//        
//        NotificationCenter.default.post(name: .distanceDidUpdate, object: nil, userInfo: ["distance": distance])
    }
    
    func startGame() {
//        let chickenSpawner = Spawner(for: .chicken, entityManager: entityManager, scene: self)
//        entityManager.add(chickenSpawner)
        let truckSpawner = Spawner(for: .truck, entityManager: entityManager, scene: self) { obstacleCount, lastObstacleIndex in
            return Double.random(in: 0...1) < 0.006 && RoadComponent.speed > 4 && obstacleCount < 3 && lastObstacleIndex < 110
        }
        entityManager.add(truckSpawner)
        let carSpawner = Spawner(for: .car, entityManager: entityManager, scene: self) { obstacleCount, lastObstacleIndex in
            return Double.random(in: 0...1) < 1 && RoadComponent.speed > 4 && obstacleCount < 3 && lastObstacleIndex < 110
        }
        entityManager.add(carSpawner)
        let motorbikeSpawner = Spawner(for: .motorbike, entityManager: entityManager, scene: self) {obstacleCount,lastObstacleIndex in
            return Double.random(in: 0...1) < 0.006 && RoadComponent.speed > 2 && obstacleCount < 3 && lastObstacleIndex < 70
        }
        entityManager.add(motorbikeSpawner)
        let trafficLightSpawner = Spawner(entityManager: entityManager, scene: self)
        entityManager.add(trafficLightSpawner)
        
        gameCamera.xBeforePan = 0
        gameCamera.xShift = 0
        RoadComponent.speedBeforePan = 2
        gameOverStop = false
    }
    
    func gameOver(crashSoundPlayed: Bool = false) {
        GameScene.gameOverAudioNode.run(SKAction.sequence([
            SKAction.wait(forDuration: (crashSoundPlayed) ? 0.5 : 0.0),
            SKAction.play()
        ]))
        
        RoadComponent.speedBeforePan = 0
        RoadComponent.speedShift = 0
        gameOverStop = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            GameState.shared.isGameOver = true
        }
    }
}


//// Update scoring
//if !GameState.isGameOver {
//    let scoreIndex = min(RoadComponent.speed, speedConstants.count - 1)
//    let frameValues = speedConstants[RoadComponent.speed][frameIndex]
//    
//    let point = frameValues
//    GameState.score += point
//
////            scoreFrameIndex = (scoreFrameIndex + 1) % frameValues.count
