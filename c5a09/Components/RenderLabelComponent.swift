//
//  RenderLabelComponent.swift
//  c5a09
//
//  Created by Felicia Stevany Lewa on 23/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class RenderLabelComponent: GKComponent {
    let label: SKLabelNode
    private(set) var labelTye: LabelType
    
    enum LabelType {
        case score
        case speed
        case highwayTimer
        case other
    }
    
    init(type: LabelType, text: Int, fontName: String = "DepartureMono-Regular", fontSize: CGFloat = 0, fontColor: UIColor = .white, position: CGPoint, zPosition: CGFloat = 100) {
        self.labelTye = type
        self.label = SKLabelNode(fontNamed: fontName)
        self.label.text = "\(text)"
        self.label.fontSize = fontSize
        self.label.fontColor = fontColor
        self.label.position = position
        self.label.zPosition = zPosition
        
        super.init()
        
        updateLabelText(with: text)
    }
    
    init(type: LabelType, text: String, fontName: String = "DepartureMono-Regular", fontSize: CGFloat = 0, fontColor: UIColor = .white, position: CGPoint, zPosition: CGFloat = 100) {
        self.labelTye = type
        self.label = SKLabelNode(fontNamed: fontName)
        self.label.fontSize = fontSize
        self.label.fontColor = fontColor
        self.label.position = position
        self.label.zPosition = zPosition
        
        super.init()
        
        updateLabelText(with: text)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLabelText(with newValue: Int) {
        switch labelTye {
        case .speed:
            let speedValue = newValue > 0 ? 10 * newValue + 10 : 0
            label.text = "\(speedValue)"
        default:
            label.text = "\(newValue)"
        }
    }
    
    func updateLabelText(with newValue: String) {
        label.text = newValue
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
//        let increment = speedConstants[RoadComponent.speed][Gamescene.frameIndex]
//        GameState.shared.score += increment
//        print("Score: \(GameState.shared.score)")
//        
//        scoreLabel.text = "\(GameState.shared.score)"
    }
}
