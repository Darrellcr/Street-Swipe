//
//  EntityManage.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 19/07/25.
//

import Foundation
import GameplayKit

class EntityManager {
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()

    lazy var componentSystems: [GKComponentSystem] = {
        let roadSystem = GKComponentSystem(componentClass: RoadComponent.self)
        let positionRelativeSystem = GKComponentSystem(componentClass: PositionRelativeComponent.self)
        let spawnerSystem = GKComponentSystem(componentClass: SpawnerComponent.self)
        let positionSystem = GKComponentSystem(componentClass: PositionComponent.self)
        let sizeSystem = GKComponentSystem(componentClass: SizeComponent.self)
        let renderSystem = GKComponentSystem(componentClass: RenderComponent.self)
        let speedSystem = GKComponentSystem(componentClass: SpeedComponent.self)
        let lightSystem = GKComponentSystem(componentClass: LightComponent.self)
        let trafficLightStateSystem = GKComponentSystem(componentClass: TrafficLightStateComponent.self)
        let crossingSystem = GKComponentSystem(componentClass: CrossingComponent.self)
        let zebraCrossSystem = GKComponentSystem(componentClass: ZebraCrossComponent.self)
        let collisionSystem = GKComponentSystem(componentClass: CollisionComponent.self)
        let trafficLightSpawnerSystem = GKComponentSystem(componentClass: TrafficLightSpawnerComponent.self)
        let spawnerGCSystem = GKComponentSystem(componentClass: SpawnerGCComponent.self)
        return [
            positionSystem,
            sizeSystem,
            roadSystem,
            spawnerSystem,
            trafficLightSpawnerSystem,
            zebraCrossSystem,
            collisionSystem,
            crossingSystem,
            positionRelativeSystem,
            lightSystem,
            trafficLightStateSystem,
            speedSystem,
            spawnerGCSystem,
            renderSystem]
    }()
    
    let scene: SKScene
    
    init(scene: SKScene) {
        self.scene = scene
    }
    
    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.component(ofType: RenderComponent.self)?.node {
            scene.addChild(spriteNode)
        }
        
        for componentSystem in componentSystems {
            componentSystem.addComponent(foundIn: entity)
        }
    }
    
    func remove(_ entity: GKEntity) {
        if let spriteNode = entity.component(ofType: RenderComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        
        entities.remove(entity)
        toRemove.insert(entity)
    }
    
    func update(_ deltaTime: CFTimeInterval) {
        for componentSystem in componentSystems {
            componentSystem.update(deltaTime: deltaTime)
        }
        
        for entity in toRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponent(foundIn: entity)
            }
        }
        
        toRemove.removeAll()
    }
}
