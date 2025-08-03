//
//  BackgroundTop.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 19/07/25.
//

import Foundation
import GameplayKit

class BackgroundTop: GKEntity {
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func create(scene: SKScene) -> BackgroundTop {
        return BackgroundTop(
            imageName: "night sky",
            position: CGPoint(x: 0, y: scene.size.height),
            anchorPoint: CGPoint(x: 0, y: 1),
            width: scene.size.width
        )
    }
}
