//
//  GameScene.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 11/07/25.
//

import SpriteKit
import GameplayKit

extension CGFloat {
    func degreesToRadians() -> CGFloat {
        return self * .pi / 180
    }
}

class GameScene: SKScene {
    private let road: Road
    private let gameCamera = GameCamera()
    private var roadSpeed = 1
    
    override init(size: CGSize) {
        self.road = Road(sceneSize: size)
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        self.addChild(road)
    }
    
    func handleHorizontalSwipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .left {
            gameCamera.moveLeft(1.0)
        }
        else if gesture.direction == .right {
            gameCamera.moveRight(1.0)
        }
        print(gameCamera.x)
    }
    
    override func update(_ currentTime: TimeInterval) {

        road.update(speed: roadSpeed, gameCamera: gameCamera)
    }

}
