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

class GameScene: SKScene {
    private let numSegments: Int = 150
    private var total: CGFloat = 0
    private var road = SKNode()
    private var roadSpeed = 1 // 1 segment down per update call
    private var nodePositions: [CGPoint] = []
    private var nodeHeights: [CGFloat] = []
    private var nodeScales: [CGFloat] = []
    private var bottom = 0
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        
        let roadTexture = SKTexture(imageNamed: "road")
        roadTexture.filteringMode = .nearest
        
        self.addChild(road)

        var yOffset: CGFloat = 0.0
        for i in 0..<3 {  // 👈 Add 3 stacked roads
            yOffset = addRoadSegments(startY: yOffset, replicaIndex: i, texture: roadTexture) - 1
        }
    }
    
    func addRoadSegments(startY: CGFloat, replicaIndex: Int, texture: SKTexture, baseWidth: CGFloat = 1400) -> CGFloat {
        var heightCurve: [CGFloat] = []
        let roadHeight = self.size.height * 0.65

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
                rect: CGRect(x: 0, y: segmentY, width: 1, height: 1.0 / CGFloat(numSegments)),
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
    
    override func update(_ currentTime: TimeInterval) {
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
        
        bottom += 1
        bottom %= numNode
    }

}
