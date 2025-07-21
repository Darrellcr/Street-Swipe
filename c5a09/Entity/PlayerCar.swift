//
//  PlayerCar.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 19/07/25.
//

import Foundation
import SpriteKit
import GameplayKit

class PlayerCar: GKEntity {
    init(imageName: String, position: CGPoint? = nil, size: CGSize? = nil, zPosition: CGFloat = 0) {
        super.init()
        
        let renderComponent = RenderComponent(texture: SKTexture(imageNamed: imageName), zPosition: zPosition)
        addComponent(renderComponent)
        let positionComponent = PositionComponent(position: position ?? renderComponent.node.position,
                                                  anchorPoint: renderComponent.node.anchorPoint)
        addComponent(positionComponent)
        let sizeComponent = SizeComponent(size: size ?? renderComponent.node.size)
        addComponent(sizeComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func create(scene: SKScene) -> PlayerCar {
        let entity = PlayerCar(imageName: "car 2", zPosition: 11)
        
        guard let spriteTextureSize = entity.component(ofType: RenderComponent.self)?.node.texture?.size(),
              let sizeComponent = entity.component(ofType: SizeComponent.self),
              let positionComponent = entity.component(ofType: PositionComponent.self)
        else { return entity }
        
        let aspectRatio = spriteTextureSize.width / spriteTextureSize.height
        let width: CGFloat = 180
        let height: CGFloat = width / aspectRatio
        sizeComponent.size = CGSize(width: width, height: height)
        positionComponent.position = CGPoint(x: scene.size.width / 2, y: height * 1.75)
        
        return entity
    }
}
