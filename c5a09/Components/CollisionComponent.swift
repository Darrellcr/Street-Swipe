//
//  CollisionComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 22/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class CollisionComponent: GKComponent {
    var customBoxSize: CGSize?
    var onCollision: ((CGPoint) -> Void)?
    var collided: Bool = false
    
    static let playerCarIndexTop = 28
    static let playerCarIndexBottom = 14
    static let showCollisionBox = true
    
    init(customBoxSize: CGSize? = nil, onCollision: ((CGPoint) -> Void)? = nil) {
        self.customBoxSize = customBoxSize
        self.onCollision = onCollision
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        
        guard let node = entity?.component(ofType: RenderComponent.self)?.node
        else { return }
        
        var rect: CGRect = node.calculateAccumulatedFrame()
        if let customBoxSize {
            let origin = CGPoint(x: customBoxSize.width * -0.5, y: customBoxSize.height * -0.5)
            rect = CGRect(origin: origin, size: customBoxSize)
        }
        
        let collisionBox = SKShapeNode(rect: rect)
        collisionBox.strokeColor = .red
        collisionBox.lineWidth = (Self.showCollisionBox) ? 3 : 0
        collisionBox.zPosition = 999  // High enough to always be visible
        collisionBox.name = "debugCollisionBox"
        node.addChild(collisionBox)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let node = entity?.component(ofType: RenderComponent.self)?.node,
              let collisionBox = node.childNode(withName: "debugCollisionBox") as? SKShapeNode,
              let positionRelativeComponent = entity?.component(ofType: PositionRelativeComponent.self),
              let playerCarNode = GameScene.playerCar.component(ofType: RenderComponent.self)?.node
        else { return }
        
        let entityIndex = positionRelativeComponent.index
        playerCarNode.size.width *= 0.75
        guard !collided
                && entityIndex <= Self.playerCarIndexTop
                && entityIndex >= Self.playerCarIndexBottom
                && playerCarNode.intersects(collisionBox)
        else {
            playerCarNode.size.width *= 1 / 0.75
            return
        }
        playerCarNode.size.width *= 1 / 0.75
        guard let onCollision else { return }
        
        onCollision(node.position)
        RoadComponent.speedBeforePan = 0
        RoadComponent.speedShift = 0
        
        collided = true
        
        if let speedComponent = entity?.component(ofType: SpeedComponent.self) {
            speedComponent.speed = 0
        }
        if let crossingComponent = entity?.component(ofType: CrossingComponent.self) {
            crossingComponent.speed = 0
        }
        if let moveSidewaysComponent = entity?.component(ofType: MoveSidewaysComponent.self) {
            moveSidewaysComponent.speed = 0
        }
    }
}
