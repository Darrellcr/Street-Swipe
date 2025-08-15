//
//  LightComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 21/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class LightComponent: GKComponent {
    let lightNode: SKLightNode
    let position: CGPoint
    var boundingBox: SKShapeNode?
    var falloff: CGFloat = 3.5
    var node: SKSpriteNode!
    
    static let showBox = false
    
    init(lightNode: SKLightNode, position: CGPoint) {
        self.lightNode = lightNode
        self.position = position
        self.lightNode.falloff = falloff
        
        if Self.showBox {
            let radius: CGFloat = 50 // or dynamic from falloff
            boundingBox = SKShapeNode(circleOfRadius: radius)
            boundingBox?.strokeColor = .cyan
            boundingBox?.lineWidth = 1.0
            boundingBox?.zPosition = 1000 // Above lighted nodes
            boundingBox?.name = "debugLightBounds"
            lightNode.addChild(boundingBox!)
        }
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        
        guard let node = entity?.component(ofType: RenderComponent.self)?.node
        else {
            assert(false, "Missing required component: RenderComponent")
            return
        }
        
        self.node = node
        self.node.addChild(lightNode)

//        lightNode.position = CGPoint(x: 100, y: 347)
//        lightNode.position = CGPoint(x: 203, y: 347)
//        lightNode.position = CGPoint(x: 303, y: 347)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        lightNode.position = CGPoint(x: position.x, y: position.y)
//        print("scale \(node.xScale) \(node.yScale)")
        
        
        boundingBox?.position = .zero
        
        guard let positionRelativeComponent = entity?.component(ofType: PositionRelativeComponent.self)
        else { return }
        
        let scale = RoadComponent.scales[positionRelativeComponent.index]
        lightNode.falloff = max((falloff + 0.3) - scale * (3000.0 / CGFloat(positionRelativeComponent.index)), 1.8)
//        print(lightNode.falloff)
    }
}
