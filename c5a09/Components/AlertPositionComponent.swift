//
//  AlertPositionComponent.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 22/07/25.
//

import Foundation
import GameplayKit

class AlertPositionComponent: GKComponent {
    let ROAD_INDEX = 11
    var offsetPct: CGFloat
    let scene: GameScene?
    private var node: SKSpriteNode!
    
    init(offsetPct: CGFloat, scene: GameScene? = nil) {
        self.offsetPct = offsetPct
        self.scene = scene
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        
        guard let node = entity?.component(ofType: RenderComponent.self)?.node else {
            assert(false, "Missing required RenderComponent")
        }
        
        self.node = node
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        let roadPosition = RoadComponent.positions[ROAD_INDEX]
        let roadSize = RoadComponent.sizes[ROAD_INDEX]
        
        let roadStartX = roadPosition.x - (roadSize.width * 0.5)
        let offsetX = roadSize.width * offsetPct
        node.position = CGPoint(x: roadStartX + offsetX, y: roadPosition.y)
    }
}
