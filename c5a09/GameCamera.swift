//
//  Camera.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 20/07/25.
//

import Foundation

class GameCamera {
    let maxX: Double = 0.3
    let minX: Double = -0.3
    private let targetPositions: [Double] = [-0.3, 0.0, 0.3]
    private var positionIndex = 1
    var xBeforePan: Double = 0.0
    var xShift: Double = 0.0
    var x: Double {
        min(maxX, max(minX, xBeforePan + xShift))
    }
    
    func moveLeft() {
        self.positionIndex = max(self.positionIndex - 1, 0)
    }
    
    func moveRight() {
        self.positionIndex = min(self.positionIndex + 1, 2)
    }
    
//    func updatePosition(segmentShift: Int) {
//        let normalizedShift = max(segmentShift, 1)
//        let numFramesNeeded = Int(12 / normalizedShift)
//        let moveDistance: Double = self.maxX / Double(numFramesNeeded)
//        
//        if self.positionIndex == 0 {
//            self.x = max(minX, self.x - moveDistance)
//        }
//        else if self.positionIndex == 2 {
//            self.x = min(maxX, self.x + moveDistance)
//        } else {
//            if self.x < 0.0 {
//                self.x = min(0.0, self.x + moveDistance)
//            }
//            else {
//                self.x = max(0.0, self.x - moveDistance)
//            }
//        }
//    }
}
