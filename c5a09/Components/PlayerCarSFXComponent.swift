//
//  PlayerCarSFXComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 23/07/25.
//

import Foundation
import GameplayKit

class PlayerCarSFXComponent: GKComponent {
    let accelerationNode: SKAudioNode
    var accelerationShouldPlay: Bool = false
    private var accelerationIsPlaying: Bool = false
    
    let decelerationNode: SKAudioNode
    var decelerationShouldPlay: Bool = false
    private var decelerationIsPlaying: Bool = false
    
    init(accelerateSoundFilePath: String) {
        if let url = Bundle.main.url(forResource: "gas 2", withExtension: "wav") {
            accelerationNode = SKAudioNode(url: url)
        } else {
            accelerationNode = SKAudioNode()
        }
        if let url = Bundle.main.url(forResource: "rem", withExtension: "wav") {
            decelerationNode = SKAudioNode(url: url)
        } else {
            decelerationNode = SKAudioNode()
        }
        accelerationNode.autoplayLooped = false
        decelerationNode.autoplayLooped = false

        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        
        if accelerationShouldPlay && !accelerationIsPlaying {
            playAcceleration()
        } else if !accelerationShouldPlay && accelerationIsPlaying {
            stopAcceleration()
        }
        
        if decelerationShouldPlay && !decelerationIsPlaying && RoadComponent.speed > 0 {
            playDeceleration()
        } else if (!decelerationShouldPlay && decelerationIsPlaying) || RoadComponent.speed == 0 {
            stopDeceleration()
        }
    }
    
    func playAcceleration() {
        let setVolumeToZero = SKAction.changeVolume(to: 0.0, duration: 0)
        let play = SKAction.run {
            self.accelerationNode.run(SKAction.play())
        }
        let fadeIn1 = SKAction.changeVolume(to: 0.05, duration: 0.3)
        let fadeIn2 = SKAction.changeVolume(to: 0.4, duration: 0.5)
        let fadeIn3 = SKAction.changeVolume(to: 1.2, duration: 0.5)
        let sequence = SKAction.sequence([setVolumeToZero, play, fadeIn1, fadeIn2, fadeIn3])
        accelerationNode.run(sequence)
        accelerationIsPlaying = true
    }
    
    func stopAcceleration() {
        let fadeOut = SKAction.changeVolume(to: 0.0, duration: 0.2)
        let stop = SKAction.run {
            self.accelerationNode.run(SKAction.stop())
        }
        self.accelerationIsPlaying = false
        let sequence = SKAction.sequence([fadeOut, stop])
        accelerationNode.run(sequence)
    }
    
    func playDeceleration() {
        let sequence = SKAction.sequence([
            SKAction.changeVolume(to: 0.5, duration: 0),
            SKAction.play()
        ])
        decelerationNode.run(sequence)
        decelerationIsPlaying = true
    }
    
    func stopDeceleration() {
        let sequence = SKAction.sequence([
            SKAction.changeVolume(by: 0.0, duration: 0.3),
            SKAction.stop()
        ])
        decelerationNode.run(sequence)
        decelerationIsPlaying = false
    }
}
