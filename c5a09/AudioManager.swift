//
//  AudioManager.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 25/07/25.
//

import Foundation
import SpriteKit
import AVFoundation

@MainActor
final class AudioManager {
    static let shared = AudioManager()

    private weak var scene: SKScene?   // set once so we can run SKActions
    private init() {}

    func attach(to scene: SKScene) {
        self.scene = scene
    }

    // 1 time
    func playOnce(_ name: String) {
        scene?.run(.playSoundFileNamed(name, waitForCompletion: false))
    }

    // X times
    func play(_ name: String,_ times: Int) {
        print("Playing \(name) \(times) times")
        guard times > 0 else { return }
        let sfx = SKAction.playSoundFileNamed(name, waitForCompletion: true)
        let rep = SKAction.repeat(sfx, count: times)
        scene?.run(rep)
    }

    // Loop (stoppable) — keep a node per key
    private var loops: [String: SKAudioNode] = [:]

    func playLoop(_ name: String, key: String, volume: Float = 1.0) {
        guard loops[key] == nil, let scene = scene else { return }
        let node = SKAudioNode(fileNamed: name)
        node.autoplayLooped = true
        node.isPositional = false
        node.run(.changeVolume(to: volume, duration: 0))
        scene.addChild(node)
        loops[key] = node
    }

    func stopLoop(key: String, fade: TimeInterval = 0.2) {
        guard let node = loops.removeValue(forKey: key) else { return }
        let fadeOut = SKAction.changeVolume(to: 0, duration: fade)
        let stop    = SKAction.run { node.removeFromParent() }
        node.run(.sequence([fadeOut, stop]))
    }
}

