//
//  Speedometer.swift
//  c5a09
//
//  Created by Felicia Stevany Lewa on 23/07/25.
//

import GameplayKit
import Foundation
import SpriteKit

class Speedometer: GKEntity {
    //    private let width: CGFloat = UIScreen.main.bounds.width - 30
    
    //    private(set) var node = SKSpriteNode()
    //    
    //    private let speedLabel: SKLabelNode
    //    
    init(imageName: String, position: CGPoint? = nil, size: CGSize? = nil, zPosition: CGFloat = 0) {
        super.init()
        
        let renderComponent = RenderComponent(texture: SKTexture(imageNamed: imageName), zPosition: zPosition)
        addComponent(renderComponent)
        let positionComponent = PositionComponent(position: position ?? renderComponent.node.position,
                                                  anchorPoint: renderComponent.node.anchorPoint)
        addComponent(positionComponent)
        let sizeComponent = SizeComponent(size: size ?? renderComponent.node.size)
        addComponent(sizeComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func create(scene: SKScene) -> Speedometer {
        let entity = Speedometer(imageName: "speedometer", zPosition: 100)
        
        guard let spriteTextureSize = entity.component(ofType: RenderComponent.self)?.node.texture?.size(),
              let sizeComponent = entity.component(ofType: SizeComponent.self),
              let positionComponent = entity.component(ofType: PositionComponent.self)
        else { return entity }
        
        let aspectRatio = spriteTextureSize.width / spriteTextureSize.height
        let width: CGFloat = scene.size.width - 60
        let height: CGFloat = width / aspectRatio
        sizeComponent.size = CGSize(width: width, height: height)
        positionComponent.position = CGPoint(x: scene.size.width / 2, y: 50)
        
        return entity
    }
}
    
//    init(sceneSize: CGSize) {
//        node = SKSpriteNode(imageNamed: "speedometer")
//        node.size = CGSize(width: sceneSize.width, height: 70)
//        node.position = CGPoint(x: sceneSize.width / 2, y: 50)
//        node.zPosition = 100
//        
//        // Label angka speed
//        speedLabel = SKLabelNode(fontNamed: "Mine Mouse Regular")
//        speedLabel.fontSize = 30
//        speedLabel.fontColor = .white
//        speedLabel.position = CGPoint(x: -135, y: -15)
//        speedLabel.zPosition = 101
//        speedLabel.text = "0"
//        
//        node.addChild(speedLabel)
//    }
    
    
//    var speedSegments: [SKShapeNode] = []
//
//    func createSpeedSegments(startX: CGFloat, y: CGFloat, segmentSize: CGSize, groupSpacing: CGFloat = 4) {
//        // Hapus sebelumnya
//        for s in speedSegments {
//            s.removeFromParent()
//        }
//        speedSegments.removeAll()
//        
//        var currentX = startX
//
//        // Tambah 18 segmen
//        for i in 0..<18 {
//            let segment = SKShapeNode(rectOf: segmentSize)
//            
//            switch i {
//            case 0..<6:
//                segment.fillColor = .darkGray
//            case 6..<12:
//                segment.fillColor = .blue
//            case 12..<18:
//                segment.fillColor = .cyan
//            default:
//                segment.fillColor = .gray
//            }
////            segment.fillColor = .gray
//            segment.strokeColor = .clear
//            segment.position = CGPoint(
//                x: currentX,
//                y: y
//            )
//            segment.zPosition = 1
//            node.addChild(segment)
//            speedSegments.append(segment)
//            
//            // Tambahkan width segment
//            currentX += segmentSize.width
//            
//            // Jika sudah 2 bar, tambahkan jarak lebih besar
//            if i % 2 == 1 && i != 17 {
//                currentX += groupSpacing
//            }
//        }
//    }
