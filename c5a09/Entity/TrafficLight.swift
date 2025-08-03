//
//  TrafficLight.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 21/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class TrafficLight: GKEntity {
    static let categoryBitMask: UInt32 = 0x1
    
    init(texture: SKTexture, index: Int, offsetPct: CGFloat, scene: GameScene, width: CGFloat, entityManager: EntityManager, positions: [TrafficLightState: CGPoint], textures: [TrafficLightState: SKTexture]) {
        super.init()
        
        let renderComponent = RenderComponent(texture: texture, zPosition: 8)
        addComponent(renderComponent)
        let sizeComponent = SizeComponent(width: width)
        addComponent(sizeComponent)
        let positionRelativeComponent = PositionRelativeComponent(index: index, offsetPct: offsetPct, scene: scene, entityManager: entityManager)
        addComponent(positionRelativeComponent)
        
        let lightNode = SKLightNode()
        lightNode.categoryBitMask = TrafficLight.categoryBitMask
        lightNode.ambientColor = .white
        lightNode.lightColor = .red
        let lightComponent = LightComponent(
            lightNode: lightNode,
            position: .zero
        )
        addComponent(lightComponent)
        
        let trafficLightStateComponent = TrafficLightStateComponent(
            state: .red,
            positions: positions,
            textures: textures
        )
        addComponent(trafficLightStateComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum TrafficLightState {
    case red
    case yellow
    case green
}
