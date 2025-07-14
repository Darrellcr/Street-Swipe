//
//  Road.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 12/07/25.
//

import Foundation
import SpriteKit

class Road: SKNode {
    private let imageName = "road"
    private let numSegmentsPerRoad = 150
    private let totalSegments = 450
    private let roadHeight: CGFloat = 0.8
    
    private let sceneSize: CGSize
    
    private var segmentY: [CGFloat] = []
    private var segmentHeights: [CGFloat] = []
    private var segmentScales: [CGFloat] = []
    private var bottom = 0
    
    init(sceneSize: CGSize) {
        self.sceneSize = sceneSize
        
        super.init()
        
        let roadTexture = SKTexture(imageNamed: imageName)
        roadTexture.filteringMode = .nearest
        let roadSegmentTextures = createRoadSegmentTextures(roadTexture: roadTexture)
        
        self.createRoad(
            roadSegmentTextures: roadSegmentTextures,
            numSegments: numSegmentsPerRoad * 4,
            roadHeight: sceneSize.height * self.roadHeight
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createRoadSegmentTextures(roadTexture: SKTexture) -> [SKTexture] {
        var roadSegments: [SKTexture] = []
        for i in 0..<numSegmentsPerRoad {
            let segmentY = CGFloat(i) * (1.0 / CGFloat(numSegmentsPerRoad))
            let roadSegment = SKTexture(
                rect: CGRect(x: 0, y: segmentY, width: 1, height: 1.0 / CGFloat(numSegmentsPerRoad)),
                in: roadTexture
            )
            roadSegments.append(roadSegment)
        }
        
        return roadSegments
    }
    
    private func createRoad(roadSegmentTextures: [SKTexture], numSegments: Int, roadHeight: CGFloat) {
        var roadSegmentScales: [CGFloat] = []
        for i in 0..<numSegments {
            let t = CGFloat(i) / CGFloat(numSegmentsPerRoad)
            let scale = 1.0 / (1.0 + pow(t + 0.4, 2) * 2.0)
            roadSegmentScales.append(scale)
        }
        
        let totalScales = roadSegmentScales.reduce(0, +)
        let unitHeight = roadHeight / totalScales
        
        var currentY: CGFloat = 0.0
        for i in 0..<numSegments {
            let segmentIndex = i % numSegmentsPerRoad
            let segmentTexture = roadSegmentTextures[segmentIndex]
            
            let segment = SKSpriteNode(texture: segmentTexture)
            segment.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            segment.position = CGPoint(x: self.sceneSize.width / 2, y: currentY)
            self.segmentY.append(segment.position.y)
            
            let scale = roadSegmentScales[i]
            let height = pow(scale, 1.2) * unitHeight
            segment.size = CGSize(width: 1400, height: height)
            self.segmentHeights.append(height)
            segment.xScale = scale
            self.segmentScales.append(scale)
            segment.name = "roadSegment"
            self.addChild(segment)

            currentY += height
        }
    }
    
    func update(speed: Int, gameCamera: GameCamera) {
        var i = 0
        let numNode = self.segmentY.count
        
        self.enumerateChildNodes(withName: "roadSegment") { node, _ in
            guard let node = node as? SKSpriteNode else { return }
            var idx = (-self.bottom + i + 1) % numNode
            if idx < 0 {
                idx += numNode
            }
            node.position.y = self.segmentY[idx]
            let roadShift = -0.3 + ((gameCamera.x - gameCamera.minX) * 0.6 / (gameCamera.maxX - gameCamera.minX))
            
            node.position.x = self.sceneSize.width / 2 - node.size.width * roadShift
            node.size.height = self.segmentHeights[idx]
            node.xScale = self.segmentScales[idx]
            i += 1
        }
        
        bottom += speed
        bottom %= numNode
    }
}
