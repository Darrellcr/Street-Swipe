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
    private let numSegments: Int = 50
    private var total: CGFloat = 0
    private var roadSpeed = 3 // 1 segment down per update call
    private var staticObstacles: [StaticObstacle] = []
    private var dynamicObstacles: [DynamicObstacle] = []
    private var zebraCrossLength: Int = 15
    private var zebraCrossPosition: Int = -15
    private var frameCount: Int = 0
    private var updateFramePer: Int = 4
    
    private var trafficLight: TrafficLight?
    
    private let gameCamera = GameCamera()
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
    var backgroundMusicPlayer: AVAudioPlayer?
    
    private var isGameRunning: Bool = false
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        
        playBackgroundMusic()
        
        let roadTexture = SKTexture(imageNamed: "road")
        roadTexture.filteringMode = .nearest
        
        addChild(background.node)
        addChild(road.node)
        addChild(playerCar.node)

//        speedometer.node.position = CGPoint(x: size.width - 100, y: 100)
        addChild(speedometer.node)

    }
    
    func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left && updateFramePer != 4{
            gameCamera.moveLeft()
        } else if gesture.direction == .right && updateFramePer != 4{
            gameCamera.moveRight()
        } else if gesture.direction == .up {
            updateFramePer -= 1
            updateFramePer = max(1, min(updateFramePer, 5))
            isGameRunning = true
        } else if gesture.direction == .down {
            updateFramePer += 1
            updateFramePer = max(1, min(updateFramePer, 5))
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
    
    func spawnTrafficLight() {
        let spawnIndex = road.segmentPositions.count - 1
        let sprite = SKSpriteNode(imageNamed: "red light")
        let desiredWidth: CGFloat = 400
        let aspectRatio: CGFloat = sprite.size.height / sprite.size.width
        sprite.size = CGSize(width: desiredWidth, height: desiredWidth * aspectRatio)
//        sprite.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        sprite.name = "trafficlight"
        sprite.lightingBitMask = 0b0001
        sprite.zPosition = 4
        
        let offset = -0.15
        let countDown = Int.random(in: 250...500)
        self.trafficLight = TrafficLight(index: spawnIndex, sprite: sprite, offsetPct: offset, state: "red", countDown: countDown)

        road.node.addChild(sprite)
        
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
        
//        print("CAR RECT = \(carRect)")
//        print("OBS RECT = \(carRect)")


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
        if updateFramePer != 4 {
            guard isGameRunning else { return }
            
            timer += 1.0 / 60.0 // assuming update runs ~60 fps
            
            if timer >= 3.0 {
                distance += 100
                timer = 0
                
                NotificationCenter.default.post(name: .distanceDidUpdate, object: nil, userInfo: ["distance": distance])
            }
        }

        // Update speedometer
        speedometer.updateSpeed(to: 90)

        
//        Update traffic light
        trafficLight?.countDown -= 1
        if trafficLight?.countDown ?? 0 <= 0 {
            trafficLight?.state = "green"
            trafficLight?.sprite.texture = SKTexture(imageNamed: "green light")
        }
        else if(trafficLight?.countDown ?? 0 <= 150) {
            trafficLight?.state = "yellow"
            trafficLight?.sprite.texture = SKTexture(imageNamed: "yellow light")
        }
        
        if updateFramePer >= 1000 { return }
        self.gameCamera.updatePosition(updateFramePer: updateFramePer)
        
        if frameCount == 0 {
            
            self.enumerateChildNodes(withName: "debugBox") { node, _ in
                node.removeFromParent()
            }
            road.node.enumerateChildNodes(withName: "zebraCross") { node, _ in
                node.removeFromParent()
            }
            addDebugBox(to: playerCar.node)

            if updateFramePer <= 3 {
                road.update(gameCamera: gameCamera)
            }
            

            if Double.random(in: 0...1) < 0.01 && staticObstacles.count < 1 {
                spawnStaticObstacle()
            }
            
            if zebraCrossPosition <= -zebraCrossLength && Double.random(in: 0...1) < 0.01 {
                zebraCrossPosition = road.segmentPositions.count - 1
            }
            if zebraCrossPosition == road.segmentPositions.count - 2*zebraCrossLength {
                spawnTrafficLight()
            }
            // --- update every obstacle ---------------------------------
            for (idx, obs) in staticObstacles.enumerated().reversed() {
                
                // konversi index cache → index layar
                let segIdx = obs.index
                staticObstacles[idx].index -= 1
                
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
                print("Static \(idx) = \(obs.sprite.position.x)")
//                print("Static pos x \(idx) = \(obs.sprite.position.x)")

                // lebarkan atau sempitkan sesuai lebar jalan di segmen itu
                obs.sprite.setScale(scale * 3)
                
                staticObstacles[idx].sprite.childNode(withName: "boundingBox")?.position = obs.sprite.position
                
                if isColliding(playerCar.node, obs.sprite, scale) && scale > 0.56 {
                    print("💥 Player hits STATIC obstacle!")
                    updateFramePer = 1000000
                    // handleCrash()  // buat fungsi sendiri untuk game-over, efek, dsb.
                    break                                               // satu hit cukup
                }
                
                addDebugBox(to: staticObstacles[idx].sprite, scale: scale)
            }
            
            
            
            for (idx, obs) in dynamicObstacles.enumerated().reversed() {
                
                // konversi index cache → index layar
                let segIdx = obs.index
                if Double.random(in: 0...1) < 0.3 {
                    dynamicObstacles[idx].index -= 1
                }
                
//                print("Dynamic \(idx) = \(segIdx)")
                
                if segIdx <= 10 {
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
                
                if isColliding(playerCar.node, obs.sprite, scale) && scale > 0.56 {
                    print("💥 Player hits DYNAMIC obstacle!")
                    updateFramePer = 1000000
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
                zebraCrossPosition -= 1
            }
            
            
            if let trafficLight {
                let segIdx = trafficLight.index
                self.trafficLight?.index -= 1
                
                if segIdx <= 10 {
                    trafficLight.sprite.removeFromParent()
                    self.trafficLight = nil
                } else {
                    let pos   = road.segmentPositions[segIdx]
                    let scale = road.segmentScales[segIdx]
                    let roadWidth = road.segmentSizes[segIdx].width
                    
                   
                    
                    trafficLight.sprite.position = CGPoint(x:  pos.x - (roadWidth / 2) + trafficLight.offsetPct * roadWidth, y: pos.y)
                    trafficLight.sprite.setScale(scale * 3)
                }
            }
            
            if zebraCrossPosition <= 2 && zebraCrossPosition > -zebraCrossLength && trafficLight?.state == "red" {
                print("🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓🦓")
                updateFramePer = 10000
            }
            
        }
        
        frameCount += 1
        frameCount %= updateFramePer
    }
    
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "bgm", withExtension: "mp3") else {
            print("Music file not found")
            return
        }
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1 // Loop forever
            backgroundMusicPlayer?.volume = 0.5
            backgroundMusicPlayer?.play()
        } catch {
            print("Error loading music: \(error)")
        }
    }
}


extension Notification.Name {
    static let distanceDidUpdate = Notification.Name("distanceDidUpdate")
    static let gameOver = Notification.Name("gameOver")
}
