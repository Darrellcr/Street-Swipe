//
//  RoadSegment.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 19/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class RoadSegment: GKEntity {
    init(texture: SKTexture, position: CGPoint, anchorPoint: CGPoint, size: CGSize, index: Int, scene: GameScene) {
        super.init()
        
        let renderComponent = RenderComponent(texture: texture)
        renderComponent.node.lightingBitMask = TrafficLight.categoryBitMask
        addComponent(renderComponent)
        let positionComponent = PositionComponent(position: position, anchorPoint: anchorPoint)
        addComponent(positionComponent)
        let sizeComponent = SizeComponent(size: size)
        addComponent(sizeComponent)
        let roadComponent = RoadComponent(index: index, scene: scene)
        addComponent(roadComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func createTextures(roadTexture: SKTexture, numSegmentsPerRoad: Int) -> [SKTexture] {
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
    
    class func createRoad(scene: GameScene) -> [RoadSegment] {
        let numSegmentsPerRoad = 50
        let numRepeat = 6
        let totalSegments = numSegmentsPerRoad * numRepeat
        let roadHeight: CGFloat = 0.862
        
        let roadTexture = SKTexture(imageNamed: "night road")
        let roadSegmentTextures = createTextures(roadTexture: roadTexture, numSegmentsPerRoad: numSegmentsPerRoad)
        
        for i in 0..<totalSegments {
            let t = CGFloat(i) / CGFloat(numSegmentsPerRoad)
            let scale = 1.0 / (1.0 + pow(t + 0.4, 2) * 2.0)
            RoadComponent.scales.append(scale)
        }
        
        let totalScales = RoadComponent.scales.reduce(0, +)
        let unitHeight = scene.size.height * roadHeight / totalScales
        
        var currentY: CGFloat = -50.0
        var segments: [RoadSegment] = []
        for i in 0..<totalSegments {
            let segmentIndex = i % numSegmentsPerRoad
            let segmentTexture = roadSegmentTextures[segmentIndex]
            
            let segmentNode = SKSpriteNode(texture: segmentTexture)
            let anchorPoint = CGPoint(x: 0.5, y: 0.0)
            let position = CGPoint(x: scene.size.width / 2, y: currentY)
            
            let scale = RoadComponent.scales[i]
            let height = pow(scale, 1.2) * unitHeight
            segmentNode.size = CGSize(width: 1400, height: height)
            segmentNode.xScale = scale
            
            let segment = RoadSegment(
                texture: segmentTexture,
                position: position,
                anchorPoint: anchorPoint,
                size: segmentNode.size,
                index: i,
                scene: scene
            )
            segments.append(segment)
            
            RoadComponent.positions.append(position)
            RoadComponent.sizes.append(segmentNode.size)
            
            currentY += height
        }
        
        return segments
    }
}
