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
        addComponent(renderComponent)
        let positionComponent = PositionComponent(position: position, anchorPoint: anchorPoint)
        addComponent(positionComponent)

        guard let texture = renderComponent.node.texture else { return }
        
        let aspectRatio = texture.size().width / texture.size().height
        let height = width / aspectRatio
        let sizeComponent = SizeComponent(size: CGSize(width: width, height: height))
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
