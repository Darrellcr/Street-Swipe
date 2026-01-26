//
//  ScoreLabel.swift
//  c5a09
//
//  Created by Felicia Stevany Lewa on 23/07/25.
//

import GameplayKit
import Foundation
import SpriteKit

class ScoreLabel: GKEntity {
    init(text: Int, fontName: String, fontSize: CGFloat = 35, fontColor: UIColor = .white, position: CGPoint, zPosition: CGFloat = 10) {
        super.init()
        
        let renderLabelComponent = RenderLabelComponent(type: .score, text: text, fontName: fontName, fontSize: fontSize, fontColor: fontColor, position: position, zPosition: zPosition)
        addComponent(renderLabelComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
