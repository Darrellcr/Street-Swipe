//
//  MoveSidewaysComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 25/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class MoveSidewaysComponent: GKComponent {
    var speed: CGFloat
    var moveRight: Bool = true
    
    init(speed: CGFloat) {
        self.speed = speed
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let positionRelativeComponent = entity?.component(ofType: PositionRelativeComponent.self)
        else { return }
        
        if moveRight {
            positionRelativeComponent.offsetPct += speed
        } else {
            positionRelativeComponent.offsetPct -= speed
        }
        
        if positionRelativeComponent.offsetPct >= 1 || positionRelativeComponent.offsetPct <= 0 {
            positionRelativeComponent.offsetPct = max(0, min(1, positionRelativeComponent.offsetPct))
            moveRight.toggle()
        }
    }
}
