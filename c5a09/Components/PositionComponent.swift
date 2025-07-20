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
    
    init(position: CGPoint, anchorPoint: CGPoint = .zero) {
        self.position = position
        self.anchorPoint = anchorPoint
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //
    }
}
