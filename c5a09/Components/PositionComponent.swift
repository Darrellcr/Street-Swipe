//
//  PositionComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 19/07/25.
//

import Foundation
import GameplayKit

class PositionComponent: GKComponent {
    var position: CGPoint
    var anchorPoint: CGPoint
    private var node: SKSpriteNode!
    
    init(position: CGPoint, anchorPoint: CGPoint = .zero) {
        self.position = position
        self.anchorPoint = anchorPoint
        
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
        }
        
        self.node = node
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        node.position = position
        node.anchorPoint = anchorPoint
    }
}
