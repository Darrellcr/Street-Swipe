//
//  SpeedBarComponent 2.swift
//  c5a09
//
//  Created by Felicia Stevany Lewa on 24/07/25.
//

import SwiftUI
import SpriteKit
import GameplayKit
import UIKit

class SpeedBarComponent: GKComponent {
    private let node: SKNode
    private var segments: [SKShapeNode] = []
    private let segmentSize: CGSize
    private let startX: CGFloat
    private let y: CGFloat
    private let groupSpacing: CGFloat
    
    init(node: SKNode, startX: CGFloat, y: CGFloat, segmentSize: CGSize, groupSpacing: CGFloat = 4) {
        self.node = node
        self.startX = startX
        self.y = y
        self.segmentSize = segmentSize
        self.groupSpacing = groupSpacing
        super.init()
        createSegments()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createSegments() {
        var currentX = startX

        for i in 0..<18 {
            let segment = SKShapeNode(rectOf: segmentSize)
            segment.fillColor = .gray // default warna
            segment.strokeColor = .clear
            segment.position = CGPoint(x: currentX, y: y)
            segment.zPosition = 101
            node.addChild(segment)
            segments.append(segment)

            currentX += segmentSize.width
            if i % 2 == 1 && i != 17 {
                currentX += groupSpacing
            }
        }
    }

    /// Update warna berdasarkan level speed (0-18)
    func updateSpeedLevel(to level: Int) {
        for (i, segment) in segments.enumerated() {
            if level == 0 {
                segment.fillColor = .clear  // Semua kosong jika level 0
            } else if i <= level {
                switch i {
                case 0..<6:
                    segment.fillColor = .speedLow
                case 6..<12:
                    segment.fillColor = .speedMid
                case 12..<18:
                    segment.fillColor = .speedHigh
                default:
                    segment.fillColor = .clear
                }
            } else {
                segment.fillColor = .clear
            }
        }
    }
}

extension Color {
    func toSKColor() -> SKColor {
        let uiColor = UIColor(self)  // Butuh import SwiftUI + UIKit
        return SKColor(cgColor: uiColor.cgColor)
    }
}

extension SKColor {
    static let speedLow = SKColor(red: 0.27, green: 0.38, blue: 0.47, alpha: 1.0)   // #446077
    static let speedMid = SKColor(red: 0.45, green: 0.60, blue: 0.63, alpha: 1.0)   // #729AA1
    static let speedHigh = SKColor(red: 0.79, green: 0.92, blue: 0.75, alpha: 1.0)  // #CAEBC0
}


