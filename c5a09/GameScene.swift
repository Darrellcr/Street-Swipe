//
//  GameScene.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 11/07/25.
//

import AVFoundation
import SpriteKit
import GameplayKit

extension CGFloat {
    func degreesToRadians() -> CGFloat {
        return self * .pi / 180
    }
}

class GameScene: SKScene {
    private var staticObstacles: [StaticObstacle] = []
    private var dynamicObstacles: [DynamicObstacle] = []
    private var zebraCrossLength: Int = 15
    private var zebraCrossPosition: Int = -15
    
    private var speedIndex: Int = 0
    private var speedFrameIndex: Int = 0
    private let speedConstants: [[Int]] = [
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
    
    private var trafficLight: TrafficLight?
    
    private let gameCamera = GameCamera()
    private let soundManager = SoundManager()
    private let background: Background
    let road: Road
    let playerCar: PlayerCar
    let speedometer: Speedometer
    
    override init(size: CGSize) {
        self.background = Background(sceneSize: size)
        self.road = Road(sceneSize: size)
        self.playerCar = PlayerCar(sceneSize: size)
        self.speedometer = Speedometer(sceneSize: size)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var distance: Int = 0
    var timer: TimeInterval = 0
    
    private var isGameRunning: Bool = false
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        soundManager.playBackgroundMusic()
        
        addChild(background.node)
        background.node.zPosition = -1
        addChild(road.node)
        addChild(playerCar.node)
        addChild(speedometer.node)
        
        let segmentSize = CGSize(width: 11.2, height: 18)
        let groupSpacing: CGFloat = 4
        let totalSegments = 18
        let totalWidth = CGFloat(totalSegments) * (segmentSize.width + groupSpacing)
        let startX = (size.width - totalWidth) / 2 - 106
//        + segmentSize.width / 2
        let yPosition: CGFloat = -16.7
        
        speedometer.createSpeedSegments(startX: startX, y: yPosition, segmentSize: segmentSize, groupSpacing: groupSpacing)
        
//        speedometer.updateSpeedSegments(value: 7)

    }
    
    func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            gameCamera.moveLeft()
        } else if gesture.direction == .right {
            gameCamera.moveRight()
        } else if gesture.direction == .up {
            speedIndex = min(speedIndex + 1, speedConstants.count - 1)
            isGameRunning = true
        } else if gesture.direction == .down {
            speedIndex = max(speedIndex - 1, 0)
        }
    }
    
    func spawnStaticObstacle() {
        //        print("Static object spawned")
        // ➊ pilih index segmen yang 3–4 layar di depan
        let spawnIndex = road.segmentPositions.count - 1                           // segmen di depan pemain
//        let spawnIndex = (bottom + ahead) % nodePositions.count
//        print(spawnIndex)

        // ➋ buat sprite
        let sprite = SKSpriteNode(imageNamed: "chicken")   // ganti dengan aset Anda
        let desiredWidth: CGFloat = 70
        let aspectRatio = sprite.size.height / sprite.size.width
        sprite.size = CGSize(width: desiredWidth, height: desiredWidth * aspectRatio)
        sprite.name = "obstacle"
        sprite.zPosition = 2                           // di atas jalan
        
        let boundingBox = SKNode()
        boundingBox.name = "boundingBox"
        boundingBox.position = CGPoint(x: sprite.position.x, y: sprite.position.y)
        boundingBox.userData = ["size": CGSize(width: 100, height: 100)]
        sprite.addChild(boundingBox)
        
        let offset = Double.random(in: 0...1)
        
        // ➌ cache
        staticObstacles.append(
            StaticObstacle(index: spawnIndex, sprite: sprite, offsetPct: offset)
        )
        road.node.addChild(sprite)                          // layer sama dgn jalan
    }
    
    func spawnDynamicObstacle() {
        //        print("Dynamic object spawned")
        // ➊ pilih index segmen yang 3–4 layar di depan
        let spawnIndex = road.segmentPositions.count - 1                           // segmen di depan pemain
//        let spawnIndex = (bottom + ahead) % nodePositions.count
//        print(spawnIndex)

        // ➋ buat sprite
        let sprite = SKSpriteNode(imageNamed: "motor 2")   // ganti dengan aset Anda
        let desiredWidth: CGFloat = 100
        let aspectRatio = sprite.size.height / sprite.size.width
        sprite.size = CGSize(width: desiredWidth, height: desiredWidth * aspectRatio)
        sprite.name = "obstacle"
        sprite.zPosition = 3                           // di atas jalan
        
        let boundingBox = SKNode()
        boundingBox.name = "boundingBox"
        boundingBox.position = CGPoint(x: sprite.position.x, y: sprite.position.y)
        boundingBox.userData = ["size": CGSize(width: 100, height: 130)]
        sprite.addChild(boundingBox)
        
        let offset = Double.random(in: 0...1)
        
        // ➌ cache
        dynamicObstacles.append(
            DynamicObstacle(index: spawnIndex, sprite: sprite, offsetPct: offset)
        )
        road.node.addChild(sprite)
    }
    

    /// deteksi overlap 2 sprite (pakai kotak kustom jika ada)
    private func isColliding(_ car: SKSpriteNode,
                             _ obstacle: SKSpriteNode,
                             _ scale: CGFloat) -> Bool {

        // --- Ambil bounding-box mobil -----------------------------------------
        guard
            let carBB   = car.childNode(withName: "boundingBox"),
            let carSize = carBB.userData?["size"] as? CGSize
        else { return false }

        let carOrigin = CGPoint(x: carBB.position.x - carSize.width  * 0.5,
                                y: carBB.position.y - carSize.height * 0.5)
        let carRect   = CGRect(origin: carOrigin, size: carSize)

        // --- Ambil bounding-box obstacle & terapkan skala ---------------------
        guard
            let obsBB      = obstacle.childNode(withName: "boundingBox"),
            let baseObs    = obsBB.userData?["size"] as? CGSize
        else { return false }

        let obsSize   = CGSize(width:  baseObs.width  * scale,
                               height: baseObs.height * scale)
        let obsOrigin = CGPoint(x: obsBB.position.x - obsSize.width  * 0.5,
                                y: obsBB.position.y - obsSize.height * 0.5)
        let obsRect   = CGRect(origin: obsOrigin, size: obsSize)


        // --- Overlap? ---------------------------------------------------------
        return carRect.intersects(obsRect)
    }
    
    func addDebugBox(to sprite: SKNode, color: SKColor = .red, scale: CGFloat = 1) {
        // hilangkan kotak lama agar tidak menumpuk
        sprite.childNode(withName: "debugBox")?.removeFromParent()

        // cari node pembawa data ukuran — di sini saya pakai nama "boundingBox"
        guard
            let bb   = sprite.childNode(withName: "boundingBox"),
            var size = bb.userData?["size"] as? CGSize
        else { return }
        
        size.width *= scale
        size.height *= scale

        // gambar rect terpusat
        let box = SKShapeNode(rectOf: size)           // otomatis anchor di tengah
        box.strokeColor   = color
        box.lineWidth     = 1
        box.isAntialiased = false
        box.zPosition     = 999
        box.name          = "debugBox"

        // posisikan sesuai offset bb (mis. bb.position = (0,10))
        box.position = bb.position
        self.addChild(box)
    }
    
    func resetGame() {
        distance = 0
        timer = 0
        isGameRunning = true
        
        NotificationCenter.default.post(name: .distanceDidUpdate, object: nil, userInfo: ["distance": distance])
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Update Scoring
        guard isGameRunning else { return }
        
        timer += 1.0 / 60.0 // assuming update runs ~60 fps
        
        if timer >= 3.0 {
            distance += 100
            timer = 0
            
            NotificationCenter.default.post(name: .distanceDidUpdate, object: nil, userInfo: ["distance": distance])
        }
        
        // Update speedometer
        speedometer.updateSpeed(to: speedIndex)
        
        //        print(playerCar.position)
        //        print(playerCar.size)
        let segmentShift = speedConstants[speedIndex][speedFrameIndex]
        //        print("Segment shift: \(segmentShift)")
        
        
        self.gameCamera.updatePosition(segmentShift: segmentShift)
        
        self.enumerateChildNodes(withName: "debugBox") { node, _ in
            node.removeFromParent()
        }
        road.node.enumerateChildNodes(withName: "zebraCross") { node, _ in
            node.removeFromParent()
        }
        addDebugBox(to: playerCar.node)
        
        road.update(gameCamera: gameCamera, segmentShift: segmentShift)
        
        if Double.random(in: 0...1) < 0.01 && staticObstacles.count < 1 {
            spawnStaticObstacle()
        }
        
        if Double.random(in: 0...1) < 0.01,
           dynamicObstacles.count < 5,
           (dynamicObstacles.last == nil ||
            abs(dynamicObstacles.last!.index) <= 110) {
            
            spawnDynamicObstacle()
        }
        
        // Spawn zebra cross
        if zebraCrossPosition <= -zebraCrossLength && Double.random(in: 0...1) < 0.01 {
            zebraCrossPosition = road.segmentPositions.count - 1
        }
        // Spawn traffic light
        if zebraCrossPosition == road.segmentPositions.count - 2*zebraCrossLength && self.trafficLight == nil {
            self.trafficLight = TrafficLight.spawn(road: road)
        }
        // --- update every obstacle ---------------------------------
        for (idx, obs) in staticObstacles.enumerated().reversed() {
            
            // konversi index cache → index layar
            let segIdx = obs.index
            staticObstacles[idx].index -= segmentShift
            
            if segIdx <= 10 {
                obs.sprite.removeFromParent()
                staticObstacles.remove(at: idx)
                continue
            }
            
            //                print("STATIC \(idx) = \(segIdx)")
            
            // ambil data cache segIdx
            let pos   = road.segmentPositions[segIdx]
            let scale = road.segmentScales[segIdx]
            let roadWidth = road.segmentSizes[segIdx].width
            //                let width = 1400 * nodeScales[segIdx]
            //                let x = (self.size.width - width) / 2.0
            //            let xOffset = pos.x * CGFloat(obs.offsetPct) / 100.0
            
            // posisikan obstacle sedikit di atas segmen dasar
            //                print("Static \(idx) = \(shift)")
            obs.sprite.position = CGPoint(x:  pos.x - (roadWidth / 2) + obs.offsetPct * roadWidth,
                                          y: pos.y)
            //            print("Static \(idx) = \(obs.sprite.position.x)")
            //                print("Static pos x \(idx) = \(obs.sprite.position.x)")
            
            // lebarkan atau sempitkan sesuai lebar jalan di segmen itu
            obs.sprite.setScale(scale * 3)
            
            staticObstacles[idx].sprite.childNode(withName: "boundingBox")?.position = obs.sprite.position
            
            if isColliding(playerCar.node, obs.sprite, scale) && obs.index <= 24 && obs.index >= 14 {
                //                print("💥 Player hits STATIC obstacle!")
                //                speedIndex = 0
                // handleCrash()  // buat fungsi sendiri untuk game-over, efek, dsb.
                break                                               // satu hit cukup
            }
            
            addDebugBox(to: staticObstacles[idx].sprite, scale: scale)
        }
        
        
        for (idx, obs) in dynamicObstacles.enumerated().reversed() {
            
            // konversi index cache → index layar
            
            //            if Double.random(in: 0...1) < 0.3 {
            //                dynamicObstacles[idx].index -= segmentShift
            //            }
            //
            let MOTOR_SPEED_INDEX = 1
            var speed_diff = abs(Int(speedIndex) - MOTOR_SPEED_INDEX)
            if speed_diff == 1{
                speed_diff = 2
            }
            let sign = MOTOR_SPEED_INDEX > speedIndex ? 1 : -1
            
            dynamicObstacles[idx].index += sign * speedConstants[speed_diff][speedFrameIndex]
            let segIdx = obs.index
            
            //                print("Dynamic \(idx) = \(segIdx)")
            
            if segIdx <= 10 || segIdx >= road.segmentPositions.count {
                obs.sprite.removeFromParent()
                //                    print("Want remove \(idx)")
                dynamicObstacles.remove(at: idx)
                //                    print("Now remove \(idx)")
                continue
            }
            
            //                print("Dynamic \(idx) = \(segIdx)")
            
            // ambil data cache segIdx
            let pos   = road.segmentPositions[segIdx]
            let scale = road.segmentScales[segIdx]
            let roadWidth = road.segmentSizes[segIdx].width
            //            let xOffset = pos.x * CGFloat(obs.offsetPct) / 100.0
            
            // posisikan obstacle sedikit di atas segmen dasar
            obs.sprite.position = CGPoint(x: pos.x - (roadWidth / 2) + obs.offsetPct * roadWidth,
                                          y: pos.y)
            
            // lebarkan atau sempitkan sesuai lebar jalan di segmen itu
            obs.sprite.setScale(scale * 2)
            
            dynamicObstacles[idx].offsetPct += obs.velocity * obs.direction
            if(dynamicObstacles[idx].offsetPct >= 1.0){
                dynamicObstacles[idx].direction = -1.0
            } else if(dynamicObstacles[idx].offsetPct <= 0){
                dynamicObstacles[idx].direction = 1.0
            }
            
            dynamicObstacles[idx].sprite.childNode(withName: "boundingBox")?.position = obs.sprite.position
            
            if isColliding(playerCar.node, obs.sprite, scale) && obs.index <= 24 && obs.index >= 14 {
                //                print("💥 Player hits DYNAMIC obstacle!")
                //                speedIndex = 0
                // handleCrash()  // buat fungsi sendiri untuk game-over, efek, dsb.
                break                                               // satu hit cukup
            }
            //                print("OFFSET = \(dynamicObstacles[idx].offsetPct)")
            addDebugBox(to: dynamicObstacles[idx].sprite, scale: scale)
        }
        
        if zebraCrossPosition > -zebraCrossLength {
            for i in 0..<zebraCrossLength {
                let index = i + zebraCrossPosition
                
                if 0 <= index && index < road.segmentPositions.count {
                    let node = SKSpriteNode(imageNamed: "zebra cross")
                    let baseWidth: CGFloat = self.size.width * 4
                    
                    node.anchorPoint = CGPoint(x: 0.5, y: 0)
                    node.position = road.segmentPositions[index]
                    node.size = CGSize(width: baseWidth, height: road.segmentSizes[index].height)
                    node.xScale = road.segmentScales[index]
                    node.name = "zebraCross"
                    node.zPosition = 2
                    road.node.addChild(node)
                }
            }
            zebraCrossPosition -= segmentShift
        }
        
        
        if let trafficLight {
            let segIdx = trafficLight.index
            self.trafficLight?.index -= segmentShift
            
            if segIdx <= 10 {
                trafficLight.leftSide.removeFromParent()
                trafficLight.rightSide.removeFromParent()
                self.trafficLight = nil
            } else {
                let pos   = road.segmentPositions[segIdx]
                let scale = road.segmentScales[segIdx]
                let roadWidth = road.segmentSizes[segIdx].width
                
               
                let roadStartX = pos.x - (roadWidth / 2)
                trafficLight.leftSide.position = CGPoint(x: roadStartX + trafficLight.leftOffset * roadWidth, y: pos.y)
                trafficLight.leftSide.setScale(scale * 3)
                trafficLight.rightSide.position = CGPoint(x: roadStartX + trafficLight.rightOffset * roadWidth, y: pos.y)
                trafficLight.rightSide.setScale(scale * 3)
                
                trafficLight.falloff = max(3.8 - scale * (3000.0 / CGFloat(segIdx)), 2.0)
            }
        }
        
        if zebraCrossPosition <= 50 && zebraCrossPosition > -zebraCrossLength && trafficLight?.state == .red {
//            print("\(zebraCrossPosition) 🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓")
//            
//            if zebraCrossPosition >= 36 {
//                print("BAD")
//            } else if zebraCrossPosition >= 28 {
//                print("GOOD")
//            } else if zebraCrossPosition >= 23 {
//                print("PERFECT")
//            } else {
//                print("BUSTED")
//            }
        }
            
        speedFrameIndex = (speedFrameIndex + 1) % speedConstants[speedIndex].count
    }
}


extension Notification.Name {
    static let distanceDidUpdate = Notification.Name("distanceDidUpdate")
    static let gameOver = Notification.Name("gameOver")
}
