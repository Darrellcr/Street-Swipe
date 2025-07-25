//
//  ZebraCross.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 21/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class ZebraCross: GKEntity {
    init(texture: SKTexture, numSegments: Int, index: Int, scene: GameScene, entityManager: EntityManager) {
        super.init()
        
        let perfectStopAudio = SKAudioNode(url: Bundle.main.url(forResource: "perfect", withExtension: "wav")!)
        perfectStopAudio.autoplayLooped = false
        let goodStopAudio = SKAudioNode(url: Bundle.main.url(forResource: "good", withExtension: "wav")!)
        goodStopAudio.autoplayLooped = false
        let badStopAudio = SKAudioNode(url: Bundle.main.url(forResource: "bad", withExtension: "wav")!)
        badStopAudio.autoplayLooped = false
        let collisionAudio = SKAudioNode(url: Bundle.main.url(forResource: "langgar lampu merah", withExtension: "wav")!)
        collisionAudio.autoplayLooped = false
        scene.addChild(perfectStopAudio)
        scene.addChild(goodStopAudio)
        scene.addChild(badStopAudio)
        scene.addChild(collisionAudio)
        
        let renderComponent = RenderComponent(zPosition: 1)
        addComponent(renderComponent)
        let zebraCrossComponent = ZebraCrossComponent(texture: texture, numSegments: numSegments, index: index, scene: scene, entityManager: entityManager)
        addComponent(zebraCrossComponent)
        let zebraCrossCollisionComponent = ZebraCrossCollisionComponent() {
            GameState.shared.score += 100
            entityManager.add(GradingLabelEntity(grade: .bad, parent: scene))
            badStopAudio.run(SKAction.play())
            print("bad stop")
        } onGoodStop: {
            entityManager.add(GradingLabelEntity(grade: .good, parent: scene))
            GameState.shared.score += 250
            goodStopAudio.run(SKAction.play())
            print("good stop")
        } onPerfectStop: {
            entityManager.add(GradingLabelEntity(grade: .perfect, parent: scene))
            GameState.shared.score += 500
            perfectStopAudio.run(SKAction.play())
            print("perfect stop")
        } onCollision: {
            scene.spawnPoliceAlert()
            collisionAudio.run(SKAction.play())
            guard !GameState.shared.isGameOver else { return }
            let playSound = SKAction.playSoundFileNamed("police siren.wav", waitForCompletion: true)
            let repeatSound = SKAction.repeat(playSound, count: 2)
            renderComponent.node.run(repeatSound)
            print("tinu2")
        }
        addComponent(zebraCrossCollisionComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
