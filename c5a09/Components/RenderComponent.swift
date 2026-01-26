//
//  RenderComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 19/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class RenderComponent: GKComponent {
    let node: SKSpriteNode
    
    init(zPosition: CGFloat = 0) {
        node = SKSpriteNode()
        node.zPosition = zPosition
        
        super.init()
    }
    
    init(texture: SKTexture, zPosition: CGFloat = 0, size: CGSize? = nil) {
        texture.filteringMode = .nearest
        node = SKSpriteNode(texture: texture)
        node.zPosition = zPosition
        if let size {
            node.size = size
        }
        
        super.init()
    }
    
    init(color: UIColor, size: CGSize, position: CGPoint = .zero, zPosition: CGFloat = 0) {
        node = SKSpriteNode(color: color, size: size)
        node.zPosition = zPosition
        node.position = position
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)

        if let ambulance = entity as? Ambulance {
            if let positionRelativeComponent = ambulance.component(ofType: PositionRelativeComponent.self) {
                if positionRelativeComponent.index > 18 {
                    self.node.zPosition = 9
                }
            }
        }
    }
}
