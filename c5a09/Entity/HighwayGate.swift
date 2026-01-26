//
//  HighwayGate.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 14/01/26.
//

import GameplayKit

class HighwayGate: GKEntity {
    private let scene: GameScene
    private let entityManager: EntityManager
    
    init(scene: GameScene, entityManager: EntityManager) {
        self.scene = scene
        self.entityManager = entityManager
        super.init()
        
        let renderComponent = RenderComponent(texture: SKTexture(imageNamed: "highway_entrance"), zPosition: 999, size: .init(width: 1713, height: 988))
        addComponent(renderComponent)
        let positionRelativeComponent = PositionRelativeComponent(
            index: RoadComponent.positions.count - 6,
            offsetPct: 0.5,
            scene: scene,
            entityManager: entityManager,
            anchor: .init(x: 0.5, y: .zero)
        )
        addComponent(positionRelativeComponent)
        let collectComponent = CollectComponent(
            customBoxSize: .init(width: 1713, height: 50),
            position: .init(x: 0.5, y: 2.5)
        ) { position, _ in
            self.removeObstacles()
            HighwayComponent.startTimer()
            HighwayTimer.showTimer(entityManager: self.entityManager, time: String(format: "%.1f", HighwayComponent.timer))
            self.raiseLowerSpeedLimit()
        }
        addComponent(collectComponent)
        
        let renderLabelComponent = RenderLabelComponent(type: .other, text: "↑ Highway", fontSize: 220, position: .init(x: 0, y: 640))
        renderComponent.node.addChild(renderLabelComponent.label)
        addComponent(renderLabelComponent)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func removeObstacles() {
        for spawner in scene.spawners {
            guard let spawnerComponent = spawner.component(ofType: SpawnerComponent.self)
            else { continue }
            for obstacle in spawnerComponent.obstacles {
                entityManager.remove(obstacle)
            }
            spawnerComponent.obstacles.removeAll()
        }
    }
    
    private func raiseLowerSpeedLimit() {
        RoadComponent.minimumSpeed = RoadComponent.maximumSpeed
        RoadComponent.speedBeforePan = max(RoadComponent.minimumSpeed, RoadComponent.speedBeforePan)
        RoadComponent.speedShift = 0
    }
    
    private func startTimer() {
        HighwayComponent.timer = 6
    }
}
