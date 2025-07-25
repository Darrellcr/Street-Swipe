//
//  SpeedLabel.swift
//  c5a09
//
//  Created by Felicia Stevany Lewa on 23/07/25.
//
import GameplayKit
import Foundation
import SpriteKit

class SpeedLabel: GKEntity {
    init(text: Int, fontName: String, fontSize: CGFloat = 30, fontColor: UIColor = .white, position: CGPoint, zPosition: CGFloat = 1000) {
        super.init()
        
        let renderLabelComponent = RenderLabelComponent(type: .speed, text: text, fontName: fontName, fontSize: fontSize, fontColor: fontColor, position: position, zPosition: zPosition)
        addComponent(renderLabelComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
    // Label angka speed
    //        speedLabel = SKLabelNode(fontNamed: "Mine Mouse Regular")
    //        speedLabel.fontSize = 30
    //        speedLabel.fontColor = .white
    //        speedLabel.position = CGPoint(x: -135, y: -15)
    //        speedLabel.zPosition = 101
    //        speedLabel.text = "0"
    //
    //        node.addChild(speedLabel)
//    func updateSpeed(to value: Int) {
//        let speedvalue = value > 0 ? 10 * value + 10 : 0
//        speedLabel.text = "\(speedvalue)"
//        
//        for i in 0..<speedSegments.count {
//            if i < value {
//                speedSegments[i].fillColor = .systemTeal // aktif
//            } else {
//                speedSegments[i].fillColor = .clear // mati
//            }
//        }
//
//    }
