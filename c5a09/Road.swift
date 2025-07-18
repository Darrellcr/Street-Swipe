//
//  Road.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 16/07/25.
//

import Foundation
import SpriteKit

class Road {
    private let image = "night road"
    private let numSegmentsPerRoad = 50
    private let numRepeat = 5
    private var totalSegment: Int { numSegmentsPerRoad * numRepeat }
    private let roadHeight: CGFloat = 0.777
    
    let node = SKNode()
    private let sceneSize: CGSize
    private(set) var segmentScales: [CGFloat] = []
    private(set) var segmentPositions: [CGPoint] = []
    private(set) var segmentSizes: [CGSize] = []
    private(set) var bottom = 0
    
    init(sceneSize: CGSize) {
        self.sceneSize = sceneSize
        
        let roadTexture = SKTexture(imageNamed: self.image)
        roadTexture.filteringMode = .nearest
        
        let roadSegmentTextures = createRoadSegmentTextures(roadTexture: roadTexture)
        createRoad(roadSegmentTextures: roadSegmentTextures)
    }
    
    private func createRoadSegmentTextures(roadTexture: SKTexture) -> [SKTexture] {
        var textures: [SKTexture] = []
        for i in 0..<numSegmentsPerRoad {
            let segmentY = CGFloat(i) * (1.0 / CGFloat(numSegmentsPerRoad))
            let texture = SKTexture(
                rect: CGRect(x: 0, y: segmentY, width: 1, height: 1.0 / CGFloat(numSegmentsPerRoad)),
                in: roadTexture
            )
            textures.append(texture)
        }
        
        return textures
    }
    
    private func createRoad(roadSegmentTextures: [SKTexture]) {
        var roadSegmentScales: [CGFloat] = []
        for i in 0..<totalSegment {
            let t = CGFloat(i) / CGFloat(numSegmentsPerRoad)
            let scale = 1.0 / (1.0 + pow(t + 0.4, 2) * 2.0)
            roadSegmentScales.append(scale)
        }
        self.segmentScales = roadSegmentScales
        let totalScales = roadSegmentScales.reduce(0, +)
        let unitHeight = sceneSize.height * roadHeight / totalScales
        
        var currentY: CGFloat = 0.0
        
        for i in 0..<totalSegment {
            let segmentIndex = i % numSegmentsPerRoad
            let segmentTexture = roadSegmentTextures[segmentIndex]
            
            let segment = SKSpriteNode(texture: segmentTexture)
            segment.anchorPoint = CGPoint(x: 0.5, y: 0.0)
            segment.position = CGPoint(x: self.sceneSize.width / 2, y: currentY)
            
            let scale = roadSegmentScales[i]
            let height = pow(scale, 1.2) * unitHeight
            segment.size = CGSize(width: 1400, height: height)
            segment.xScale = scale
            
            self.segmentPositions.append(segment.position)
            self.segmentSizes.append(segment.size)
            
            segment.name = "roadSegment"
            self.node.addChild(segment)
            

            currentY += height
        }
    }
    
    func update(gameCamera: GameCamera, segmentShift: Int) {
        var i = 0
        let numNode = self.segmentPositions.count
        
        self.node.enumerateChildNodes(withName: "roadSegment") { node, _ in
            guard let node = node as? SKSpriteNode else { return }
            var idx = (-self.bottom + i + 1) % numNode
            if idx < 0 {
                idx += numNode
            }
            node.position.y = self.segmentPositions[idx].y
            let roadShiftPct = -0.3 + ((gameCamera.x - gameCamera.minX) * 0.6 / (gameCamera.maxX - gameCamera.minX))
            
            node.xScale = self.segmentScales[idx]
            let roadShift = CGFloat(roadShiftPct) * node.size.width
            node.position.x = self.sceneSize.width / 2 - roadShift
            self.segmentPositions[idx].x = node.position.x
            node.size.height = self.segmentSizes[idx].height
            
            i += 1
        }
        
        bottom += segmentShift
        bottom %= numNode
    }
}
