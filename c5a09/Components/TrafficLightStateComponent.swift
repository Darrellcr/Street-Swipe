//
//  TrafficLightStateComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 21/07/25.
//

import Foundation
import GameplayKit

class TrafficLightStateComponent: GKComponent {
    var state: TrafficLightState
    let positions: [TrafficLightState: CGPoint]
    let textures: [TrafficLightState: SKTexture]
    var lightNode: SKLightNode!
    var node: SKSpriteNode!
    
    let redDuration: TimeInterval
    let yellowDuration: TimeInterval
    var timer: Double
    
    init(state: TrafficLightState, positions: [TrafficLightState: CGPoint], textures: [TrafficLightState: SKTexture], redDuration: TimeInterval = 5.0, yellowDuration: TimeInterval = 1.5) {
        self.state = state
        self.positions = positions
        self.redDuration = redDuration
        self.yellowDuration = yellowDuration
        self.timer = redDuration + yellowDuration
        self.textures = textures
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didAddToEntity() {
        super.didAddToEntity()
        
        guard let lightComponent = entity?.component(ofType: LightComponent.self)
        else {
            assert(false, "Missing required component: LightComponent")
        }
        self.node = lightComponent.node
        self.lightNode = lightComponent.lightNode
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        timer = max(.zero, timer - seconds)

        if timer == .zero {
            state = .green
            lightNode.lightColor = .green
        } else if timer <= yellowDuration {
            state = .yellow
            lightNode.lightColor = .yellow
        } else {
            state = .red
            lightNode.lightColor = .red
        }
        
        node.texture = textures[state]!
        let position = positions[state]!
        lightNode.position = CGPoint(x: position.x, y: position.y)
    }
}
