//
//  Speedometer.swift
//  c5a09
//
//  Created by Felicia Stevany Lewa on 18/07/25.
//

import Foundation
import SpriteKit

class Speedometer {
    private let image: String = "speedometer"
    //    private let width: CGFloat = UIScreen.main.bounds.width - 30
    
    private(set) var node = SKSpriteNode()
    
    private let speedLabel: SKLabelNode
    
    init(sceneSize: CGSize) {
        node = SKSpriteNode(imageNamed: "speedometer")
        node.size = CGSize(width: sceneSize.width, height: 60)
        node.position = CGPoint(x: sceneSize.width / 2, y: 50)
        node.zPosition = 100
        
        // Label angka speed
        speedLabel = SKLabelNode(fontNamed: "Mine Mouse Regular")
        speedLabel.fontSize = 30
        speedLabel.fontColor = .white
        speedLabel.position = CGPoint(x: -135, y: -15)
        speedLabel.zPosition = 101
        speedLabel.text = "0 km/h"
        
        node.addChild(speedLabel)
    }
    
    func updateSpeed(to value: Int) {
        speedLabel.text = "\(value)"
    }
}
