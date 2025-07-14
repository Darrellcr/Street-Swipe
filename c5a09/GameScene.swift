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
    private var roadSpeed = 3 // 1 segment down per update call
    private var nodePositions: [CGPoint] = []
    private var nodeHeights: [CGFloat] = []
    private var nodeScales: [CGFloat] = []
    private var bottom = 0
    private var staticObstacles: [StaticObstacle] = []
    private var dynamicObstacles: [DynamicObstacle] = []
    private var frameCount: Int = 0
    private var updateFramePer: Int = 3
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        
        let roadTexture = SKTexture(imageNamed: "road")
        roadTexture.filteringMode = .nearest
        
        self.addChild(road)

        var yOffset: CGFloat = 0.0
        for i in 0..<3 {  // 👈 Add 3 stacked roads
            yOffset = addRoadSegments(startY: yOffset, replicaIndex: i, texture: roadTexture) - 1
        }
        
        print(nodeScales)
    }
    
    func addRoadSegments(startY: CGFloat, replicaIndex: Int, texture: SKTexture) -> CGFloat {
        var heightCurve: [CGFloat] = []
        let roadHeight = self.size.height * 0.65
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
        print("Static object spawned")
        // ➊ pilih index segmen yang 3–4 layar di depan
        let ahead = nodePositions.count - 1                           // segmen di depan pemain
        let spawnIndex = (bottom + ahead) % nodePositions.count
        print(spawnIndex)

        // ➋ buat sprite
        let sprite = SKSpriteNode(imageNamed: "chicken")   // ganti dengan aset Anda
        let desiredWidth: CGFloat = 70
        let aspectRatio = sprite.size.height / sprite.size.width
        sprite.size = CGSize(width: desiredWidth, height: desiredWidth * aspectRatio)
        sprite.name = "obstacle"
        sprite.zPosition = 1                           // di atas jalan
        
        let offset = Double.random(in: 0...1)

        // ➌ cache
        staticObstacles.append(
            StaticObstacle(index: spawnIndex, sprite: sprite, offsetPct: offset)
        )
        road.addChild(sprite)                          // layer sama dgn jalan
    }

    func spawnDynamicObstacle() {
        print("Dynamic object spawned")
        // ➊ pilih index segmen yang 3–4 layar di depan
        let ahead = nodePositions.count - 1                           // segmen di depan pemain
        let spawnIndex = (bottom + ahead) % nodePositions.count
        print(spawnIndex)

        // ➋ buat sprite
        let sprite = SKSpriteNode(imageNamed: "motor")   // ganti dengan aset Anda
        let desiredWidth: CGFloat = 150
        let aspectRatio = sprite.size.height / sprite.size.width
        sprite.size = CGSize(width: desiredWidth, height: desiredWidth * aspectRatio)
        sprite.name = "obstacle"
        sprite.zPosition = 2                           // di atas jalan
        
        let offset = Double.random(in: 0...1)

        // ➌ cache
        dynamicObstacles.append(
            DynamicObstacle(index: spawnIndex, sprite: sprite, offsetPct: offset)
        )
        road.addChild(sprite)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if frameCount == 0 {
            var i = 0
            let numNode = self.nodePositions.count
            
            road.enumerateChildNodes(withName: "roadSegment") { node, _ in
                guard let node = node as? SKSpriteNode else { return }
                var idx = (-self.bottom + i + 1) % numNode
                if idx < 0 {
                    idx += numNode
                }
                node.position = self.nodePositions[idx]
                node.size.height = self.nodeHeights[idx]
                node.xScale = self.nodeScales[idx]
                i += 1
            }
            
            if Double.random(in: 0...1) < 0.01 {
                spawnStaticObstacle()
            }
            
            if Double.random(in: 0...1) < 0.01 {
                spawnDynamicObstacle()
            }
            
            if staticObstacles.count > 0{
                print("Static obs count: \(staticObstacles.count)")
            }
            
            // --- update every obstacle ---------------------------------
            for (idx, obs) in staticObstacles.enumerated().reversed() {
                
                // konversi index cache → index layar
                let segIdx = (obs.index - bottom + nodePositions.count) % nodePositions.count
                print("Static \(idx) = \(segIdx)")

                // ambil data cache segIdx
                let pos   = nodePositions[segIdx]
                let scale = nodeScales[segIdx] * 3
    //            let xOffset = pos.x * CGFloat(obs.offsetPct) / 100.0

                // posisikan obstacle sedikit di atas segmen dasar
                obs.sprite.position = CGPoint(x: self.size.width * ( (1.0 - scale) / 2.0 + scale * obs.offsetPct),
                                              y: pos.y)

                // lebarkan atau sempitkan sesuai lebar jalan di segmen itu
                obs.sprite.setScale(scale)
                
                if segIdx <= 1 {
                    obs.sprite.removeFromParent()
                    staticObstacles.remove(at: idx)
                }
            }
            
            for (idx, obs) in dynamicObstacles.enumerated().reversed() {
                
                // konversi index cache → index layar
                let segIdx = (obs.index - bottom + nodePositions.count) % nodePositions.count
                print("Dynamic \(idx) = \(segIdx)")

                // ambil data cache segIdx
                let pos   = nodePositions[segIdx]
                let scale = nodeScales[segIdx]  * 3
    //            let xOffset = pos.x * CGFloat(obs.offsetPct) / 100.0

                // posisikan obstacle sedikit di atas segmen dasar
                obs.sprite.position = CGPoint(x: self.size.width * ( (1.0 - scale) / 2.0 + scale * obs.offsetPct),
                                              y: pos.y)

                // lebarkan atau sempitkan sesuai lebar jalan di segmen itu
                obs.sprite.setScale(scale)
                
                dynamicObstacles[idx].offsetPct += obs.velocity * obs.direction
                if(dynamicObstacles[idx].offsetPct >= 1.0){
                    dynamicObstacles[idx].direction = -1.0
                } else if(dynamicObstacles[idx].offsetPct <= 0){
                    dynamicObstacles[idx].direction = 1.0
                }
                
                print("OFFSET = \(dynamicObstacles[idx].offsetPct)")
                
                if segIdx <= 1 {
                    obs.sprite.removeFromParent()
                    dynamicObstacles.remove(at: idx)
                }
            }
            
            bottom += 1
            bottom %= numNode
        }
        
        frameCount += 1
        frameCount %= updateFramePer
    }

}
