//
//  GameScene.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 11/07/25.
//

import SpriteKit
import GameplayKit

extension CGFloat {
    func degreesToRadians() -> CGFloat {
        return self * .pi / 180
    }
}

struct StaticObstacle {
    var index: Int
    var sprite: SKSpriteNode
    var offsetPct: CGFloat = 0
}

struct DynamicObstacle {
    var index: Int
    var sprite: SKSpriteNode
    var offsetPct: CGFloat = 0
    var velocity: CGFloat = 0.01
    var direction: CGFloat = 1
}

class GameScene: SKScene {
    private let numSegments: Int = 50
    private var total: CGFloat = 0
    private var road = SKNode()
    private var playerCar = SKSpriteNode()
    private var roadSpeed = 3 // 1 segment down per update call
    private var nodePositions: [CGPoint] = []
    private var nodeHeights: [CGFloat] = []
    private var nodeScales: [CGFloat] = []
    private var bottom = 0
    private var staticObstacles: [StaticObstacle] = []
    private var dynamicObstacles: [DynamicObstacle] = []
    private var frameCount: Int = 0
    private var updateFramePer: Int = 4
    
    private var cameraX = 0.0
    private let cameraTargetPositions: [CGFloat] = [-0.35, 0.0, 0.35]
    private var cameraMovingLeft: Bool = false
    private var cameraMovingRight: Bool = false
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        print(self.size.width)
        
        let roadTexture = SKTexture(imageNamed: "road")
        roadTexture.filteringMode = .nearest
        
        self.addChild(playerCar)
        self.addChild(road)
        var yOffset: CGFloat = 0.0
        for i in 0..<3 {  // 👈 Add 3 stacked roads
            yOffset = addRoadSegments(startY: yOffset, replicaIndex: i, texture: roadTexture) - 1
        }
        
        let playerCarTexture = SKTexture(imageNamed: "car 2")
        let aspectRatio = playerCarTexture.size().width / playerCarTexture.size().height
        playerCar.texture = playerCarTexture
        let desiredWidth: CGFloat = 270
        let desiredHeight: CGFloat = desiredWidth / aspectRatio
        playerCar.size = CGSize(width: desiredWidth, height: desiredHeight)
        playerCar.position = CGPoint(x: self.size.width / 2, y: playerCar.size.height / 2)
        playerCar.zPosition = 100
        
        let boundingBox = SKNode()
        boundingBox.name = "boundingBox"
        boundingBox.position = CGPoint(x: playerCar.position.x, y: playerCar.position.y)
        boundingBox.userData = ["size": CGSize(width: 240, height: 140)]
        playerCar.addChild(boundingBox)
    }
    
    func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            cameraMovingLeft = true
            cameraMovingRight = false
        } else if gesture.direction == .right {
            cameraMovingRight = true
            cameraMovingLeft = false
        } else if gesture.direction == .up {
            updateFramePer -= 1
            updateFramePer = max(1, min(updateFramePer, 5))
        } else if gesture.direction == .down {
            updateFramePer += 1
            updateFramePer = max(1, min(updateFramePer, 5))
        }
    }
    
    func updateCameraPosition() {
        let maxX: CGFloat = 0.35
        let minX: CGFloat = -0.35
        let numFramesPerMove: Int = 20 + (updateFramePer - 1) * 5
        let moveDistance: CGFloat = maxX / CGFloat(numFramesPerMove)
        if cameraMovingLeft {
            cameraX -= moveDistance
        }
        if cameraMovingRight {
            cameraX += moveDistance
        }
        cameraX = max(minX, min(maxX, cameraX))
        let tolerance: CGFloat = 0.001
        if cameraTargetPositions.contains(where: { abs($0 - cameraX) < tolerance }) {
            cameraMovingLeft = false
            cameraMovingRight = false
        }
    }
    
    func addRoadSegments(startY: CGFloat, replicaIndex: Int, texture: SKTexture) -> CGFloat {
        var heightCurve: [CGFloat] = []
        let roadHeight = self.size.height * 0.5
        let baseWidth: CGFloat = self.size.width * 4
//        print("WIDTH = \(baseWidth)")
        
        for i in 0..<numSegments {
            let t = CGFloat(i + numSegments * replicaIndex) / CGFloat(numSegments)
            let scale = 1.0 / (1.0 + pow(t + 0.4, 2) * 2.0)
            heightCurve.append(scale)
        }

        total += heightCurve.reduce(0, +)
        let unitHeight = roadHeight / total + CGFloat(replicaIndex) * 2.5

        var currentY = startY

        for i in 0..<numSegments {
            let segmentY = CGFloat(i) * (1.0 / CGFloat(numSegments))
            let roadSegment = SKTexture(
                rect: CGRect(x: 0, y: segmentY - 1.0 / CGFloat(numSegments), width: 1, height: 1.0 / CGFloat(numSegments)), // FIX FOR DISCONTINUED ROAD
                in: texture
            )

            let node = SKSpriteNode(texture: roadSegment)
            node.anchorPoint = CGPoint(x: 0.5, y: 0)
            node.position = CGPoint(x: self.size.width / 2, y: currentY)
            self.nodePositions.append(node.position)
            
            let scale = heightCurve[i]
            let height = pow(scale, 1.2) * unitHeight
            node.size = CGSize(width: baseWidth, height: height)
            self.nodeHeights.append(height)
            node.xScale = scale
            self.nodeScales.append(scale)
            node.name = "roadSegment"
            road.addChild(node)

            currentY += height
        }

        return currentY // So you know where to start the next stack
    }
    
    func spawnStaticObstacle() {
//        print("Static object spawned")
        // ➊ pilih index segmen yang 3–4 layar di depan
        let spawnIndex = nodePositions.count - 1                           // segmen di depan pemain
        print(spawnIndex)
//        let spawnIndex = (bottom + ahead) % nodePositions.count
//        print(spawnIndex)

        // ➋ buat sprite
        let sprite = SKSpriteNode(imageNamed: "chicken")   // ganti dengan aset Anda
        let desiredWidth: CGFloat = 70
        let aspectRatio = sprite.size.height / sprite.size.width
        sprite.size = CGSize(width: desiredWidth, height: desiredWidth * aspectRatio)
        sprite.name = "obstacle"
        sprite.zPosition = 1                           // di atas jalan
        
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
        road.addChild(sprite)                          // layer sama dgn jalan
    }

    func spawnDynamicObstacle() {
//        print("Dynamic object spawned")
        // ➊ pilih index segmen yang 3–4 layar di depan
        let spawnIndex = nodePositions.count - 1                           // segmen di depan pemain
//        let spawnIndex = (bottom + ahead) % nodePositions.count
//        print(spawnIndex)

        // ➋ buat sprite
        let sprite = SKSpriteNode(imageNamed: "motor 2")   // ganti dengan aset Anda
        let desiredWidth: CGFloat = 100
        let aspectRatio = sprite.size.height / sprite.size.width
        sprite.size = CGSize(width: desiredWidth, height: desiredWidth * aspectRatio)
        sprite.name = "obstacle"
        sprite.zPosition = 2                           // di atas jalan
        
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
        road.addChild(sprite)
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
        
        print("CAR RECT = \(carRect)")
        print("OBS RECT = \(carRect)")


        // --- Overlap? ---------------------------------------------------------
        return carRect.intersects(obsRect)
    }
    
    func addDebugBox(to sprite: SKSpriteNode, color: SKColor = .red, scale: CGFloat = 1) {
        // hilangkan kotak lama agar tidak menumpuk
        sprite.childNode(withName: "debugBox")?.removeFromParent()

        // cari node pembawa data ukuran — di sini saya pakai nama "boundingBox"
        guard
            let bb   = sprite.childNode(withName: "boundingBox"),
            var size = bb.userData?["size"] as? CGSize
        else { return }
        
        size.width *= scale
        size.height *= scale
//        print("SIZE: \(size)")
//        print("BB POS: \(bb.position)")

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
    
    override func update(_ currentTime: TimeInterval) {
        self.enumerateChildNodes(withName: "debugBox") { node, _ in
            node.removeFromParent()
        }
        
        updateCameraPosition()
//        print(playerCar.position)
//        print(playerCar.size)
        playerCar.position = CGPoint(x: size.width / 2,
                                     y: playerCar.size.height / 2)
        addDebugBox(to: self.playerCar)
        
        var i = 0
        let numNode = self.nodePositions.count
        if frameCount == 0 {
            print("\n\n\nNEW FRAME \(frameCount)")

            var roadWidths: [CGFloat] = Array(repeating: 0.0, count: self.nodePositions.count)

            road.enumerateChildNodes(withName: "roadSegment") { node, _ in
                guard let node = node as? SKSpriteNode else { return }
                var idx = (-self.bottom + i + 1) % numNode
                if idx < 0 {
                    idx += numNode
                }
//                let shift = -0.3 + ((self.cameraX + 10) * 0.6 / 20)
                let roadSegmentShift = node.size.width * self.cameraX
                roadWidths[idx] = node.size.width
                self.nodePositions[idx].x = self.size.width / 2 - roadSegmentShift
                node.position = self.nodePositions[idx]
                
                node.size.height = self.nodeHeights[idx]
                node.xScale = self.nodeScales[idx]
                i += 1
            }
            
            if Double.random(in: 0...1) < 0.01 {
                spawnStaticObstacle()
            }
            
            if Double.random(in: 0...1) < 0.01,
               dynamicObstacles.count < 5,
               (dynamicObstacles.last == nil ||
                abs(dynamicObstacles.last!.index) <= 110) {

                spawnDynamicObstacle()
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
                
                print("STATIC \(idx) = \(segIdx)")
//                print("Static \(idx) = \(segIdx)")

                // ambil data cache segIdx
                let pos   = nodePositions[segIdx]
                let scale = nodeScales[segIdx]
                let roadWidth = roadWidths[segIdx]
//                let width = 1400 * nodeScales[segIdx]
//                let x = (self.size.width - width) / 2.0
    //            let xOffset = pos.x * CGFloat(obs.offsetPct) / 100.0

                // posisikan obstacle sedikit di atas segmen dasar
//                print("Static \(idx) = \(shift)")
                obs.sprite.position = CGPoint(x:  pos.x - (roadWidth / 2) + obs.offsetPct * roadWidth,
                                              y: pos.y)
//                print("Static pos x \(idx) = \(obs.sprite.position.x)")

                // lebarkan atau sempitkan sesuai lebar jalan di segmen itu
                obs.sprite.setScale(scale * 3)
                
                staticObstacles[idx].sprite.childNode(withName: "boundingBox")?.position = obs.sprite.position
                
                if isColliding(playerCar, obs.sprite, scale) && scale > 0.56 {
                    print("💥 Player hits STATIC obstacle!")
//                    updateFramePer = 1000000
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
                
                print("Dynamic \(idx) = \(segIdx)")
                
                if segIdx <= 10 {
                    obs.sprite.removeFromParent()
                    print("Want remove \(idx)")
                    dynamicObstacles.remove(at: idx)
                    print("Now remove \(idx)")
                    continue
                }

//                print("Dynamic \(idx) = \(segIdx)")

                // ambil data cache segIdx
                let pos   = nodePositions[segIdx]
                let scale = nodeScales[segIdx]
                let roadWidth = roadWidths[segIdx]
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
                
                if isColliding(playerCar, obs.sprite, scale) && scale > 0.56 {
                    print("💥 Player hits DYNAMIC obstacle!")
                    updateFramePer = 1000000
                    // handleCrash()  // buat fungsi sendiri untuk game-over, efek, dsb.
                    break                                               // satu hit cukup
                }
//                print("OFFSET = \(dynamicObstacles[idx].offsetPct)")
                addDebugBox(to: dynamicObstacles[idx].sprite, scale: scale)
            }
            
            if updateFramePer <= 3 {
                bottom += 1
                bottom %= numNode
            }
        }
        
        frameCount += 1
        frameCount %= updateFramePer
    }

}
