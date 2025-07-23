//
//  CrossingComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 21/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class CrossingComponent: GKComponent {
    let crossingFrom: CrossingFrom
    var delaySeconds: TimeInterval
    let speed: CGFloat
    
    var trafficLight: TrafficLight?
    static let minOffset: CGFloat = -0.5
    static let maxOffset: CGFloat = 1.42
    
    init(crossingFrom: CrossingFrom, delaySeconds: TimeInterval = 1, speed: CGFloat = 0.01) {
        self.crossingFrom = crossingFrom
        self.delaySeconds = delaySeconds
        self.speed = speed
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        
        guard let positionRelativeComponent = entity?.component(ofType: PositionRelativeComponent.self)
        else { return }
        positionRelativeComponent.offsetPct = (crossingFrom == .left) ? Self.minOffset : Self.maxOffset
        
        guard crossingFrom == .right else { return }
        guard let node = entity?.component(ofType: RenderComponent.self)?.node
        else { return }
        
        node.xScale *= -1
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let trafficLight,
              let trafficLightState = trafficLight.component(ofType: TrafficLightStateComponent.self)?.state
        else { return }
        guard trafficLightState == .green else { return }
        
        guard delaySeconds == .zero else {
            delaySeconds = max(delaySeconds - seconds, .zero)
            return
        }
        
        guard let positionRelativeComponent = entity?.component(ofType: PositionRelativeComponent.self)
        else { return }
        
        switch crossingFrom {
        case .left:
            positionRelativeComponent.offsetPct = min(positionRelativeComponent.offsetPct + speed, Self.maxOffset)
        case .right:
            positionRelativeComponent.offsetPct = max(positionRelativeComponent.offsetPct - speed, Self.minOffset)
        }
    }
}

enum CrossingFrom {
    case left
    case right
}
