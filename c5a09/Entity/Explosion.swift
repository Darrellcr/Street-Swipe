//
//  Explosion.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 24/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class Explosion: GKEntity {
    init(position: CGPoint) {
        super.init()
        let imageName    = "explosion"
        let sheetColumns = 11
        let sheetRows    = 1
        let renderComponent = RenderComponent(texture: SKTexture(imageNamed: imageName), zPosition: 100)
        renderComponent.node.position = position
        addComponent(renderComponent)
        let spriteSheetComponent = SpriteSheetComponent(sheetName: imageName, columns: sheetColumns, rows: sheetRows, updateTime: 0.07)
        addComponent(spriteSheetComponent)
        
        let sheet       = SKTexture(imageNamed: imageName)
        let sheetSize   = sheet.size()          // ambil sekali saja
        guard sheetSize != .zero else { return } // keluar jika gambar tak ada

        // ukuran 1 frame di dalam sheet
        let frameW = sheetSize.width  / CGFloat(sheetColumns)
        let frameH = sheetSize.height / CGFloat(sheetRows)
        let aspect = frameW / frameH               // w ÷ h

        // target tampilan
        let targetW: CGFloat = 180
        let targetH: CGFloat = targetW / aspect

        let sizeComponent = SizeComponent(size: CGSize(width: targetW, height: targetH))
        addComponent(sizeComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
