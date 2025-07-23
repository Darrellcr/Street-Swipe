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
        node.size = CGSize(width: sceneSize.width, height: 70)
        node.position = CGPoint(x: sceneSize.width / 2, y: 50)
        node.zPosition = 100
        
        // Label angka speed
        speedLabel = SKLabelNode(fontNamed: "Mine Mouse Regular")
        speedLabel.fontSize = 30
        speedLabel.fontColor = .white
        speedLabel.position = CGPoint(x: -135, y: -15)
        speedLabel.zPosition = 101
        speedLabel.text = "0"
        
        node.addChild(speedLabel)
    }
    
//    var leftBars: [SKShapeNode] = []
//    var rightBars: [SKShapeNode] = []
//
//    func createBarSegments(in parent: SKNode, startX: CGFloat, y: CGFloat, segmentSize: CGSize, spacing: CGFloat, count: Int) {
//        leftBars.removeAll()
//        rightBars.removeAll()
//        
//        for i in 0..<count {
//            let leftHalf = SKShapeNode(rectOf: CGSize(width: segmentSize.width / 2, height: segmentSize.height))
//            leftHalf.fillColor = .gray
//            leftHalf.strokeColor = .clear
//            leftHalf.position = CGPoint(x: startX + CGFloat(i) * (segmentSize.width + spacing) - segmentSize.width / 4,
//                                        y: y)
//            
//            let rightHalf = SKShapeNode(rectOf: CGSize(width: segmentSize.width / 2, height: segmentSize.height))
//            rightHalf.fillColor = .gray
//            rightHalf.strokeColor = .clear
//            rightHalf.position = CGPoint(x: startX + CGFloat(i) * (segmentSize.width + spacing) + segmentSize.width / 4,
//                                         y: y)
//            
//            parent.addChild(leftHalf)
//            parent.addChild(rightHalf)
//            
//            leftBars.append(leftHalf)
//            rightBars.append(rightHalf)
//        }
//    }

    
    func updateSpeed(to value: Int) {
        let speedvalue = value > 0 ? 10 * value + 10 : 0
        speedLabel.text = "\(speedvalue)"
        
        // Misalnya: 1 bar terisi tiap +10 kecepatan
        //        let filledSegments = min(value, leftBars.count)
        
        //        for i in 0..<leftBars.count {
        //            if value >= (i * 2 + 2) {
        //                // Full bar aktif
        //                leftBars[i].fillColor = .green
        //                rightBars[i].fillColor = .green
        //            } else if value == (i * 2 + 1) {
        //                // Hanya kiri aktif (half bar)
        //                leftBars[i].fillColor = .green
        //                rightBars[i].fillColor = .gray
        //            } else {
        //                // Tidak aktif
        //                leftBars[i].fillColor = .gray
        //                rightBars[i].fillColor = .gray
        //            }
        //        }
        for i in 0..<speedSegments.count {
            if i < value {
                speedSegments[i].fillColor = .systemTeal // aktif
            } else {
                speedSegments[i].fillColor = .clear // mati
            }
        }

    }
    
    var speedSegments: [SKShapeNode] = []

    func createSpeedSegments(startX: CGFloat, y: CGFloat, segmentSize: CGSize, groupSpacing: CGFloat = 4) {
        // Hapus sebelumnya
        for s in speedSegments {
            s.removeFromParent()
        }
        speedSegments.removeAll()
        
        var currentX = startX

        // Tambah 18 segmen
        for i in 0..<18 {
            let segment = SKShapeNode(rectOf: segmentSize)
            
            switch i {
            case 0..<6:
                segment.fillColor = .darkGray
            case 6..<12:
                segment.fillColor = .blue
            case 12..<18:
                segment.fillColor = .cyan
            default:
                segment.fillColor = .gray
            }
//            segment.fillColor = .gray
            segment.strokeColor = .clear
            segment.position = CGPoint(
                x: currentX,
                y: y
            )
            segment.zPosition = 1
            node.addChild(segment)
            speedSegments.append(segment)
            
            // Tambahkan width segment
            currentX += segmentSize.width
            
            // Jika sudah 2 bar, tambahkan jarak lebih besar
            if i % 2 == 1 && i != 17 {
                currentX += groupSpacing
            }
        }
    }

}
