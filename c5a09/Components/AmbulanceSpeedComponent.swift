//
//  AmbulanceSpeedComponent.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 23/07/25.
//

import Foundation
import GameplayKit

class AmbulanceSpeedComponent: GKComponent {
    let scene: GameScene
    
    init(scene: GameScene) {
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
        
        let shift = scene.speedConstants[RoadComponent.speed][scene.frameIndex] + 1
        positionRelativeComponent.index = min(positionRelativeComponent.index + shift, RoadComponent.positions.count - 1)
    }
}
