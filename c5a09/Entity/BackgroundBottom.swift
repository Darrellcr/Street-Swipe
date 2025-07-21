//
//  BackgroundBottom.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 19/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class BackgroundBottom: GKEntity {
    init(imageName: String, position: CGPoint, anchorPoint: CGPoint, width: CGFloat) {
        super.init()
        
        let renderComponent = RenderComponent(texture: SKTexture(imageNamed: imageName))
        renderComponent.node.lightingBitMask = TrafficLight.categoryBitMask
        addComponent(renderComponent)
        let positionComponent = PositionComponent(position: position, anchorPoint: anchorPoint)
        addComponent(positionComponent)
        let sizeComponent = SizeComponent(width: width)
        addComponent(sizeComponent)
    }
    
    init(color: UIColor, position: CGPoint, anchorPoint: CGPoint, size: CGSize) {
        super.init()
        
        let renderComponent = RenderComponent(color: color, size: size)
        addComponent(renderComponent)
        let positionComponent = PositionComponent(position: position, anchorPoint: anchorPoint)
        addComponent(positionComponent)
        let sizeComponent = SizeComponent(size: size)
        addComponent(sizeComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func create(scene: SKScene) -> BackgroundBottom {
        return BackgroundBottom(
            color: .black,
            position: .zero,
            anchorPoint: .zero,
            size: scene.size
        )
    }
}
