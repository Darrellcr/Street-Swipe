//
//  DrunkAlert.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 29/09/25.
//

import Foundation
import GameplayKit
import SpriteKit

class DrunkAlert: GKEntity {
    let IMAGE_NAME: String = "drunk_notif-Sheet"
    var entityManager: EntityManager? = nil
    
    init(size: CGSize? = nil, zPosition: CGFloat = 0, scene: GameScene? = nil, entityManager: EntityManager? = nil) {
        super.init()
        self.entityManager = entityManager
        
        let renderComponent = RenderComponent(texture: SKTexture(imageNamed: IMAGE_NAME), zPosition: zPosition)
        addComponent(renderComponent)
        
        let spriteSheetComponent = SpriteSheetComponent(sheetName: IMAGE_NAME, columns: 3, rows: 1)
        addComponent(spriteSheetComponent)
        
        let positionComponent = PositionComponent(position: CGPoint(x: (scene?.size.width ?? 0) * 0.5, y: 230), anchorPoint: CGPoint(x: 0.5, y: 0.5))
        addComponent(positionComponent)
        
        let sheet       = SKTexture(imageNamed: IMAGE_NAME)
        let sheetSize   = sheet.size()          // ambil sekali saja
        guard sheetSize != .zero else { return } // keluar jika gambar tak ada
        
        // ukuran 1 frame di dalam sheet
        let frameW = sheetSize.width  / 3
        let frameH = sheetSize.height
        let aspect = frameW / frameH               // w ÷ h
        
        // target tampilan
        let targetW: CGFloat = 50
        let targetH: CGFloat = targetW / aspect
        
        let sizeComponent = SizeComponent(size: size ?? CGSize(width: targetW, height: targetH))
        addComponent(sizeComponent)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
