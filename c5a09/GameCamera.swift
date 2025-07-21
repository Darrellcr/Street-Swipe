//
//  GameCamera.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 14/07/25.
//

import Foundation

class GameCamera {
    let maxX: Double = 0.3
    let minX: Double = -0.3
    private let targetPositions: [Double] = [-0.3, 0.0, 0.3]
    private let tolerance: Double = 0.0001
    
    private(set) var x: Double = 0.0
    private var movingLeft: Bool = false
    private var movingRight: Bool = false
    
    func moveLeft() {
        self.movingLeft = true
        self.movingRight = false
    }
    
    func moveRight() {
        self.movingLeft = false
        self.movingRight = true
    }
    
    func updatePosition(updateFramePer: Int) {
        let numFramesNeeded = 20 + (updateFramePer - 1) * 5
        let moveDistance: Double = self.maxX / Double(numFramesNeeded)
        
        if self.movingLeft {
            self.x -= moveDistance
        }
        if self.movingRight {
            self.x += moveDistance
        }
        self.x = max(self.minX, min(self.x, self.maxX))
        
        if self.targetPositions.contains(where: { abs($0 - self.x) < self.tolerance }) {
            self.movingLeft = false
            self.movingRight = false
        }
    }
}
