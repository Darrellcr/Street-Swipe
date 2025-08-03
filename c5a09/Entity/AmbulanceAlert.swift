//
//  AmbulanceAlert.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 22/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

enum AmbulancePosition {
    case left
    case middle
    case right
}

class AmbulanceAlert: GKEntity {
    let IMAGE_NAME: String = "ambulance-Sheet"

    
    init(size: CGSize? = nil, ambulancePosition: AmbulancePosition = .middle, zPosition: CGFloat = 0, duration: CGFloat = 6.0, scene: GameScene? = nil, entityManager: EntityManager? = nil) {
        super.init()
        
        let renderComponent = RenderComponent(texture: SKTexture(imageNamed: IMAGE_NAME), zPosition: zPosition)
        addComponent(renderComponent)
        
        let spriteSheetComponent = SpriteSheetComponent(sheetName: IMAGE_NAME, columns: 2, rows: 1)
        addComponent(spriteSheetComponent)
        
        let offsetPct: CGFloat
        switch ambulancePosition {
        case .left:
            offsetPct = 0.15
        case .middle:
            offsetPct = 0.5
        case .right:
            offsetPct = 0.85
        }
        let alertPositionComponent = AlertPositionComponent(offsetPct: offsetPct, scene: scene)
        addComponent(alertPositionComponent)
        
        let sheet       = SKTexture(imageNamed: IMAGE_NAME)
        let sheetSize   = sheet.size()          // ambil sekali saja
        guard sheetSize != .zero else { return } // keluar jika gambar tak ada

        // ukuran 1 frame di dalam sheet
        let frameW = sheetSize.width  / 2
        let frameH = sheetSize.height
        let aspect = frameW / frameH               // w ÷ h

        // target tampilan
        let targetW: CGFloat = 60
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
