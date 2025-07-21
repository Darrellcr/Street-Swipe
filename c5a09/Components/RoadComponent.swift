//
//  RoadPositionComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 19/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class RoadComponent: GKComponent {
    var index: Int
    let scene: GameScene
    
    static var speedBeforePan: Int = 2
    static var speedShift: Int = 0
    static var speed: Int {
        max(min(speedBeforePan + speedShift, 17), 0)
    }
    static var scales: [CGFloat] = []
    static var positions: [CGPoint] = []
    static var sizes: [CGSize] = []
    
    init(index: Int, scene: GameScene) {
        self.index = index
        self.scene = scene
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        let totalRoadSegments: Int = RoadComponent.scales.count
        let indexShift = scene.speedConstants[Self.speed][scene.frameIndex]
        let gameCamera = scene.gameCamera

        let size = RoadComponent.sizes[index]
        entity?.component(ofType: SizeComponent.self)?.size = size
        
        entity?.component(ofType: PositionComponent.self)?.position.y = RoadComponent.positions[index].y
        let horizontalShiftPct = -0.3 + ((gameCamera.x - gameCamera.minX) * 0.6 / (gameCamera.maxX - gameCamera.minX))
        let roadShift = CGFloat(horizontalShiftPct) * size.width
        let positionX = scene.size.width / 2 - roadShift
        entity?.component(ofType: PositionComponent.self)?.position.x = positionX
        RoadComponent.positions[index].x = positionX
        
        index -= indexShift
        if index < 0 {
            index += totalRoadSegments
        }
    }
}
