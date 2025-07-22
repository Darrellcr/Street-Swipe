//
//  Alert.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 22/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class Alert: GKEntity {
    init(imageName: String, sheetColumns: Int, sheetRows: Int, size: CGSize? = nil, zPosition: CGFloat = 0, offsetPct: CGFloat = 0.5, scene: GameScene? = nil) {
        super.init()
        
        let renderComponent = RenderComponent(texture: SKTexture(imageNamed: imageName), zPosition: zPosition)
        addComponent(renderComponent)
        
        let spriteSheetComponent = SpriteSheetComponent(sheetName: imageName, columns: sheetColumns, rows: sheetRows)
        addComponent(spriteSheetComponent)
        
        let alertPositionComponent = AlertPositionComponent(offsetPct: offsetPct, scene: scene)
        addComponent(alertPositionComponent)
        
        let sheet       = SKTexture(imageNamed: imageName)
        let sheetSize   = sheet.size()          // ambil sekali saja
        guard sheetSize != .zero else { return } // keluar jika gambar tak ada

        // ukuran 1 frame di dalam sheet
        let frameW = sheetSize.width  / CGFloat(sheetColumns)
        let frameH = sheetSize.height / CGFloat(sheetRows)
        let aspect = frameW / frameH               // w ÷ h

        // target tampilan
        let targetW: CGFloat = 60
        let targetH: CGFloat = targetW / aspect

        let sizeComponent = SizeComponent(size: size ?? CGSize(width: targetW, height: targetH))
        addComponent(sizeComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
