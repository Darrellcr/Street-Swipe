//
//  ClockSpawnerComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 13/01/26.
//

import GameplayKit

class ClockSpawnerComponent: GKComponent {
    private var timer: TimeInterval = 0.0
    private let baseCooldown: TimeInterval = 3.0
    private let cooldownVariationRange: TimeInterval = 1.0
    private let roadLastIndex = RoadComponent.positions.count - 6
    private var clocks: Set<GKEntity> = []
    
    private let scene: GameScene
    private let entityManager: EntityManager
    private var highwayComponent: HighwayComponent!
    
    init(scene: GameScene, entityManager: EntityManager) {
        self.scene = scene
        self.entityManager = entityManager
        
        super.init()
        resetTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        highwayComponent = entity!.component(ofType: HighwayComponent.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
//        guard highwayComponent.onHighway else { return }
        
        timer -= seconds
        guard timer <= 0 else { return }
        spawnClock()
        resetTimer()
    }
    
    private func spawnClock() {
        let clock = Collectible(
            imageName: "clock-Sheet",
            imageRows: 1,
            imageCols: 3,
            index: roadLastIndex,
            offsetPct: CGFloat.random(in: 0...1),
            scene: scene,
            width: 180,
            entityManager: entityManager,
            collisionBoxSize: CGSize(width: 150, height: 170)
        ) { position, entity in
            print("Collect clock \(position)")
//            self.spawnDrunkAlert()
//            self.despawnAlcohol()
//            self.drunkState = Int.random(in: 1...2)
//            self.drunkCoolDownTimer = 3
//            print("Set drunk state to \(self.drunkState)")
            self.despawnTicket(entity)
        }
        entityManager.add(clock)
        clocks.insert(clock)
    }
    
    private func despawnTicket(_ clock: GKEntity) {
        entityManager.remove(clock)
        clocks.remove(clock)
    }
    
    private func resetTimer() {
        timer = baseCooldown + .random(in: 0..<cooldownVariationRange)
    }
    
    private func removeOutOfScreenClocks() {
        var toRemove: [GKEntity] = []
        for clock in clocks {
            let positionRelativeComponent = clock.component(ofType: PositionRelativeComponent.self)!
            if positionRelativeComponent.index <= 0 {
                toRemove.append(clock)
            }
        }
        for clock in toRemove {
            despawnTicket(clock)
        }
    }
}
