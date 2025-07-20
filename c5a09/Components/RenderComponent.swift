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
    
    init(texture: SKTexture) {
        node = SKSpriteNode(texture: texture)
        
        super.init()
    }
    
    init(color: UIColor, size: CGSize) {
        node = SKSpriteNode(color: color, size: size)
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let sizeComponent = entity?.component(ofType: SizeComponent.self)
        else { return }
        node.size = sizeComponent.size
        
        guard let positionComponent = entity?.component(ofType: PositionComponent.self)
        else { return }
        node.anchorPoint = positionComponent.anchorPoint
        node.position = positionComponent.position
    }
}
