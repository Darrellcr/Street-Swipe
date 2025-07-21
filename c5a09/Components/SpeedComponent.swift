//
//  SpeedComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 21/07/25.
//

import Foundation
import GameplayKit

class SpeedComponent: GKComponent {
    var speed: Int
    let scene: GameScene
    
    init(speed: Int, scene: GameScene) {
        self.speed = speed
        self.scene = scene
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let positionRelativeComponent = entity?.component(ofType: PositionRelativeComponent.self)
        else { return }
        
        
        let speedDifference = abs(RoadComponent.speed - speed)
        let adjustedSpeed = speedDifference == 1 ? 2: speed
        
        let shift = scene.speedConstants[adjustedSpeed][scene.frameIndex]
        positionRelativeComponent.index = min(positionRelativeComponent.index + shift, RoadComponent.positions.count - 1)
    }
}
