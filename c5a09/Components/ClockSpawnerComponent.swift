//
//  ClockSpawnerComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 13/01/26.
//

import GameplayKit

class ClockSpawnerComponent: GKComponent {
    private var timer: TimeInterval = 0.0
    private let baseCooldown: TimeInterval = 2.0
    private let cooldownVariationRange: TimeInterval = 2.0
    private let roadLastIndex = RoadComponent.positions.count - 6
    private var clocks: Set<GKEntity> = []
    
    private let timeAdded: TimeInterval = 2.5
    private let minimumDistanceBetweenClocks: Int = 100
    private var lastClockAdded: GKEntity? = nil
    
    private let scene: GameScene
    private let entityManager: EntityManager
    
    init(scene: GameScene, entityManager: EntityManager) {
        self.scene = scene
        self.entityManager = entityManager
        
        super.init()
        resetTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        removeOutOfScreenClocks()
        if HighwayComponent.timer <= 0 {
            removeAllClocks()
        }
        guard HighwayComponent.onHighway else { return }
        
        timer -= seconds
        guard canSpawn() else { return }
        spawnClock()
        resetTimer()
    }
    
    private func canSpawn() -> Bool {
        guard timer <= 0 && clocks.count < 3 else { return false }
        guard clocks.count > 0 else { return true }
        
        guard let lastPosition = lastClockAdded?.component(ofType: PositionRelativeComponent.self)?.index
        else { return true }
        
        let distance = abs(lastPosition - roadLastIndex)
        return distance >= minimumDistanceBetweenClocks
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
            HighwayComponent.timer += self.timeAdded
            self.despawnClock(entity)
        }
        entityManager.add(clock)
        clocks.insert(clock)
        lastClockAdded = clock
    }
    
    private func despawnClock(_ clock: GKEntity) {
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
            despawnClock(clock)
        }
    }
    
    private func removeAllClocks() {
        var toRemove = clocks
        for clock in toRemove {
            despawnClock(clock)
        }
    }
    
    public func reset() {
        for clock in clocks {
            entityManager.remove(clock)
        }
        clocks.removeAll()
        lastClockAdded = nil
        timer = 0
    }
}
