//
//  Collectible.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 30/09/25.
//

import Foundation
import GameplayKit
import SpriteKit

class Collectible: GKEntity {
    init(imageName: String, imageRows: Int, imageCols: Int, index: Int, offsetPct: CGFloat, scene: GameScene, width: CGFloat, entityManager: EntityManager, collisionBoxSize: CGSize? = nil, onCollision: ((CGPoint, GKEntity) -> Void)? = nil) {
        super.init()
        
        let renderComponent = RenderComponent(texture: SKTexture(imageNamed: imageName), zPosition: 100)
        addComponent(renderComponent)
        let spriteSheetComponent = SpriteSheetComponent(sheetName: imageName, columns: imageCols, rows: imageRows)
        addComponent(spriteSheetComponent)
        let positionRelativeComponent = PositionRelativeComponent(index: index, offsetPct: offsetPct, scene: scene, entityManager: entityManager)
        addComponent(positionRelativeComponent)
        let collectComponent = CollectComponent(customBoxSize: collisionBoxSize, onCollision: onCollision)
        addComponent(collectComponent)
        
        let sheet       = SKTexture(imageNamed: imageName)
        let sheetSize   = sheet.size()
        guard sheetSize != .zero else { return }
        
        let frameW = sheetSize.width / CGFloat(imageCols)
        let frameH = sheetSize.height
        let aspect = frameW / frameH
        
        let targetW: CGFloat = width
        let targetH: CGFloat = targetW / aspect
        
        let sizeComponent = SizeComponent(size: CGSize(width: targetW, height: targetH))
        addComponent(sizeComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
