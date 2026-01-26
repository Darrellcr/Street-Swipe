//
//  HighwayComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 13/01/26.
//

import GameplayKit

class HighwayComponent: GKComponent {
    static var onHighway: Bool = false
    static var timer: TimeInterval = 0
    static let startingTime: TimeInterval = 6
    private var gate: HighwayGate?
    
    private let scene: GameScene
    private let entityManager: EntityManager
    
    init(scene: GameScene, entityManager: EntityManager) {
        self.scene = scene
        self.entityManager = entityManager
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard Self.timer > 0 else { return }
        Self.timer -= seconds
        HighwayTimer.setTime(Self.timer)
        Self.timer = max(Self.timer, 0)
        
        if Self.timer.isZero {
            endHighway()
            HighwayTimer.hideTimer(entityManager: self.entityManager)
        }
    }
    
    static func startTimer() {
        Self.timer = Self.startingTime
    }
    
    func startHighway() {
//        if (Traff)
        Self.onHighway = true
        spawnGate()
        disableSpawner()
    }
    
    func endHighway() {
        Self.onHighway = false
        RoadComponent.minimumSpeed = 0
        enableSpawner()
        despawnGate()
    }
    
    private func spawnGate() {
        gate = HighwayGate(scene: scene, entityManager: entityManager)
        entityManager.deferAdd(gate!)
    }
    
    private func despawnGate() {
        guard let gate else { return }
        entityManager.remove(gate)
        self.gate = nil
    }
    
    private func disableSpawner() {
        scene.spawnerEnabled = false
    }
    
    private func enableSpawner() {
        scene.spawnerEnabled = true
    }
    
    public func reset() {
        endHighway()
        Self.timer = 0
    }
}
