//
//  PoliceAlert.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 22/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class PoliceAlert: GKEntity {
    let IMAGE_NAME: String = "police-Sheet"
    
    init(size: CGSize? = nil, zPosition: CGFloat = 0, duration: CGFloat = 10.0, scene: GameScene? = nil, entityManager: EntityManager? = nil) {
        super.init()
        let renderComponent = RenderComponent(texture: SKTexture(imageNamed: IMAGE_NAME), zPosition: zPosition)
        addComponent(renderComponent)
        
        let spriteSheetComponent = SpriteSheetComponent(sheetName: IMAGE_NAME, columns: 2, rows: 1)
        addComponent(spriteSheetComponent)
        
        let positionComponent = PositionComponent(position: CGPoint(x: (scene?.size.width ?? 0) * 0.58, y: 205))
        addComponent(positionComponent)
        
        let sheet       = SKTexture(imageNamed: IMAGE_NAME)
        let sheetSize   = sheet.size()          // ambil sekali saja
        guard sheetSize != .zero else { return } // keluar jika gambar tak ada

        // ukuran 1 frame di dalam sheet
        let frameW = sheetSize.width  / 2
        let frameH = sheetSize.height 
        let aspect = frameW / frameH               // w ÷ h

        // target tampilan
        let targetW: CGFloat = 50
        let targetH: CGFloat = targetW / aspect

        let sizeComponent = SizeComponent(size: size ?? CGSize(width: targetW, height: targetH))
        addComponent(sizeComponent)
        
        let countDownComponent = CountDownComponent(duration: duration, entityManager: entityManager!)
        addComponent(countDownComponent)
    }
    
    init(image_name: String, size: CGSize? = nil, zPosition: CGFloat = 0, duration: CGFloat = 10.0, scene: GameScene? = nil, entityManager: EntityManager? = nil, zRotation: CGFloat = 0, yPosition: CGFloat = 0) {
        super.init()
        print(image_name)
        let renderComponent = RenderComponent(texture: SKTexture(imageNamed: image_name), zPosition: zPosition)
//        renderComponent.node.yScale *= -1
        renderComponent.node.zRotation = zRotation
        addComponent(renderComponent)
        
        let spriteSheetComponent = SpriteSheetComponent(sheetName: image_name, columns: 6, rows: 1)
        addComponent(spriteSheetComponent)
        
        let positionComponent = PositionComponent(position: CGPoint(x: (scene?.size.width ?? 0) * 0.5 , y: yPosition), anchorPoint: CGPoint(x: 0.5, y: 0.5))
        addComponent(positionComponent)
        
        let sheet       = SKTexture(imageNamed: image_name)
        let sheetSize   = sheet.size()          // ambil sekali saja
        guard sheetSize != .zero else { return } // keluar jika gambar tak ada

        // ukuran 1 frame di dalam sheet
        let frameW = sheetSize.width  / 6
        let frameH = sheetSize.height
        let aspect = frameW / frameH               // w ÷ h

        // target tampilan
        let targetW: CGFloat = 50
        let targetH: CGFloat = targetW / aspect

        let sizeComponent = SizeComponent(size: size ?? CGSize(width: targetW, height: targetH))
        addComponent(sizeComponent)
        
        let countDownComponent = CountDownComponent(duration: duration, entityManager: entityManager!)
        addComponent(countDownComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
