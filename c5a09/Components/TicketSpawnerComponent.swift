//
//  TicketSpawnerComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 13/01/26.
//

import GameplayKit

class TicketSpawnerComponent: GKComponent {
    private var spawnTimer: TimeInterval = 0.0
    private let baseCooldown: TimeInterval = 10.0
    private let cooldownVariationRange: Double = 10.0
    static var ticket: Collectible?
    private let roadLastIndex = RoadComponent.positions.count - 6
    
    private let scene: GameScene
    private let entityManager: EntityManager
    private var highwayComponent: HighwayComponent!
    
    init(scene: GameScene, entityManager: EntityManager) {
        self.scene = scene
        self.entityManager = entityManager
        
        super.init()
        resetSpawnTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        highwayComponent = entity!.component(ofType: HighwayComponent.self)
    }
    
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
//        if let positionRelativeComponent = Self.ticket?.component(ofType: PositionRelativeComponent.self) {
//            let index = positionRelativeComponent.index
//            print("index: \(index)")    
//        }
        
        removeOutOfScreenTicket()
        guard !HighwayComponent.onHighway && Self.ticket == nil else { return }
        
        spawnTimer -= seconds
        guard spawnTimer <= 0 else { return }
        spawnTicket()
        resetSpawnTimer()
    }
    
    private func spawnTicket() {
        Self.ticket = Collectible(
            imageName: "ticket-Sheet",
            imageRows: 1,
            imageCols: 3,
            index: roadLastIndex,
            offsetPct: CGFloat.random(in: 0...1),
            scene: scene,
            width: 180,
            entityManager: entityManager,
            collisionBoxSize: CGSize(width: 140, height: 150)
        ) { position, _ in
            let positionRelativeComponent = Self.ticket!.component(ofType: PositionRelativeComponent.self)!
            let index = positionRelativeComponent.index
            print("Ticket reached index: \(index)")
            self.highwayComponent.startHighway()
            self.despawnTicket()
        }
        
        entityManager.add(Self.ticket!)
    }
    
    private func despawnTicket() {
        guard let ticket = Self.ticket else { return }
        entityManager.remove(ticket)
        Self.ticket = nil
    }
    
    private func resetSpawnTimer() {
        spawnTimer = baseCooldown + .random(in: 0..<cooldownVariationRange)
    }
    
    private func removeOutOfScreenTicket() {
        guard let ticket = Self.ticket else { return }
        let positionRelativeComponent = ticket.component(ofType: PositionRelativeComponent.self)!
        if positionRelativeComponent.index <= 0 {
            despawnTicket()
        }
    }
    
    public func reset() {
        if let ticket = Self.ticket {
            entityManager.remove(ticket)
        }
        spawnTimer = 0
        Self.ticket = nil
    }
}
