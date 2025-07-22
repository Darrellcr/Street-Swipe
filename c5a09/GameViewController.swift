//
//  GameViewController.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 11/07/25.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let scene = GameScene(size: view.bounds.size)
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
            
//            let directions: [UISwipeGestureRecognizer.Direction] = [.up, .down, .left, .right]
//            for direction in directions {
//                let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
//                swipe.direction = direction
//                view.addGestureRecognizer(swipe)
//            }
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            view.addGestureRecognizer(panGesture)
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
//    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
//        if let skView = self.view as? SKView,
//           let gameScene = skView.scene as? GameScene {
//            gameScene.handleSwipe(gesture)
//        }
//    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        if let skView = self.view as? SKView,
           let gameScene = skView.scene as? GameScene {
            gameScene.handlePan(gesture, view: view)
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
