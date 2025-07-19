//
//  TrafficLight.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 16/07/25.
//

import Foundation
import SpriteKit

enum TrafficLightState {
    case red, yellow, green
}

class TrafficLight {
    var index: Int
    var leftSide: SKSpriteNode
    var leftOffset: CGFloat
    var rightSide: SKSpriteNode
    var rightOffset: CGFloat
    var state: TrafficLightState = TrafficLightState.red {
        didSet {
            switch state {
            case .red:
                changeRed()
            case .yellow:
                changeYellow()
            case .green:
                changeGreen()
            }
        }
    }
    var leftLight: SKLightNode
    var rightLight: SKLightNode
    var countDown: Int = 1000
    
    var falloff: CGFloat = 3.5 {
        didSet {
            self.leftLight.falloff = self.falloff
            self.rightLight.falloff = self.falloff
        }
    }
    
    static let categoryBitMask: UInt32 = 0b0001
    static let showLightNodeBoundingBox = true
    
    private init(
        index: Int,
        leftSide: SKSpriteNode,
        leftOffset: CGFloat,
        rightSide: SKSpriteNode,
        rightOffset: CGFloat
    ) {
        self.index = index
        self.leftSide = leftSide
        self.leftSide.lightingBitMask = Self.categoryBitMask
        self.leftOffset = leftOffset
        self.rightSide = rightSide
        self.rightSide.lightingBitMask = Self.categoryBitMask
        self.rightOffset = rightOffset
        
        self.leftLight = SKLightNode()
        self.leftLight.ambientColor = .white
        self.leftLight.categoryBitMask = Self.categoryBitMask
        self.leftLight.falloff = self.falloff
        self.leftLight.zPosition = 1000
        self.leftSide.addChild(self.leftLight)
        
        self.rightLight = SKLightNode()
        self.rightLight.ambientColor = .white
        self.rightLight.lightColor = .red
        self.rightLight.categoryBitMask = Self.categoryBitMask
        self.rightLight.falloff = self.falloff
        self.rightLight.zPosition = 1000
        self.rightSide.addChild(self.rightLight)
        
        let boundingBox1 = SKNode()
        boundingBox1.name = "boundingBox"
        boundingBox1.position = CGPoint(x: leftSide.position.x, y: leftSide.position.y)
        boundingBox1.userData = ["size": CGSize(width: 100, height: 100)]
        leftSide.addChild(boundingBox1)
        
        let boundingBox2 = SKNode()
        boundingBox2.name = "boundingBox"
        boundingBox2.position = CGPoint(x: rightSide.position.x, y: rightSide.position.y)
        boundingBox2.userData = ["size": CGSize(width: 100, height: 100)]
        rightSide.addChild(boundingBox2)
        
        if Self.showLightNodeBoundingBox {
            let c1 = SKShapeNode(circleOfRadius: 20)
            c1.fillColor = .clear
            c1.strokeColor = .cyan
            c1.lineWidth = 2
            c1.zPosition = 1000
            c1.position = self.leftLight.position
            c1.name = "lightNode"
            self.leftSide.addChild(c1)
            
            let c2 = SKShapeNode(circleOfRadius: 20)
            c2.fillColor = .clear
            c2.strokeColor = .cyan
            c2.lineWidth = 2
            c2.zPosition = 1000
            c2.position = self.rightLight.position
            c2.name = "lightNode"
            self.rightSide.addChild(c2)
        }
    }
    
    static func spawn(road: Road) -> TrafficLight {
        let spawnIndex = road.segmentPositions.count - 1
//        let spawnIndex = 120
        
        let leftSide = TrafficLight.spawnLShaped()
        let rightSide = TrafficLight.spawnIShaped()
        
        let trafficLight = TrafficLight(
            index: spawnIndex,
            leftSide: leftSide,
            leftOffset: -0.12,
            rightSide: rightSide,
            rightOffset: 1.7
        )
        
        road.node.addChild(trafficLight.leftSide)
        road.node.addChild(trafficLight.rightSide)
        
        return trafficLight
    }
    
    static func spawnLShaped() -> SKSpriteNode {
        let texture = SKTexture(imageNamed: "L red light")
        let sprite = SKSpriteNode(texture: texture)
        let width: CGFloat = 400
        let aspectRatio: CGFloat = sprite.size.height / sprite.size.width
        let height: CGFloat = width * aspectRatio
        sprite.size = CGSize(width: width, height: height)
        sprite.name = "LTrafficLight"
        sprite.zPosition = 4
        
        return sprite
    }
    
    static func spawnIShaped() -> SKSpriteNode {
        let texture = SKTexture(imageNamed: "red light")
        let sprite = SKSpriteNode(texture: texture)
        let width: CGFloat = 400
        let aspectRatio: CGFloat = sprite.size.height / sprite.size.width
        let height: CGFloat = width * aspectRatio
        sprite.size = CGSize(width: width, height: height)
        sprite.name = "LTrafficLight"
        sprite.zPosition = 4
        
        return sprite
    }
    
    func changeRed() {
        self.leftSide.texture = SKTexture(imageNamed: "L red light")
        self.rightSide.texture = SKTexture(imageNamed: "red light")
        
        self.leftLight.lightColor = .red
        self.rightLight.lightColor = .red
        
//        self.rightLight.position = CGPoint
        self.leftLight.position = CGPoint(x: self.leftSide.size.width * 0.4, y: self.leftSide.size.height * 1.36)
        self.rightLight.position = CGPoint(x: self.rightSide.size.width * -0.865, y: self.rightSide.size.height * 1.37)
        
        self.leftSide.childNode(withName: "lightNode")?.position = CGPoint(
            x: self.leftLight.position.x, y: self.leftLight.position.y)
        self.rightSide.childNode(withName: "lightNode")?.position = CGPoint(
            x: self.rightLight.position.x, y: self.rightLight.position.y)
        
    }
    
    func changeYellow() {
        self.leftSide.texture = SKTexture(imageNamed: "L yellow light")
        self.rightSide.texture = SKTexture(imageNamed: "yellow light")
        
        self.leftLight.lightColor = .yellow
        self.rightLight.lightColor = .yellow
        
        self.leftLight.position = CGPoint(x: self.leftSide.size.width * 0.8, y: self.leftSide.size.height * 1.36)
        self.rightLight.position = CGPoint(x: self.rightSide.size.width * -0.865, y: self.rightSide.size.height * 0.976)
        
        self.leftSide.childNode(withName: "lightNode")?.position = CGPoint(
            x: self.leftLight.position.x, y: self.leftLight.position.y)
        self.rightSide.childNode(withName: "lightNode")?.position = CGPoint(
            x: self.rightLight.position.x, y: self.rightLight.position.y)
    }
    
    func changeGreen() {
        self.leftSide.texture = SKTexture(imageNamed: "L green light")
        self.rightSide.texture = SKTexture(imageNamed: "green light")
        
        self.leftLight.lightColor = .green
        self.rightLight.lightColor = .green
        
        self.leftLight.position = CGPoint(x: self.leftSide.size.width * 1.2, y: self.leftSide.size.height * 1.36)
        self.rightLight.position = CGPoint(x: self.rightSide.size.width * -0.865, y: self.rightSide.size.height * 0.582)
        
        self.leftSide.childNode(withName: "lightNode")?.position = CGPoint(
            x: self.leftLight.position.x, y: self.leftLight.position.y)
        self.rightSide.childNode(withName: "lightNode")?.position = CGPoint(
            x: self.rightLight.position.x, y: self.rightLight.position.y)
    }
}
