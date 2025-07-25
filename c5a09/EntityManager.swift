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
        let ambulanceSpeedSystem = GKComponentSystem(componentClass: AmbulanceSpeedComponent.self)
        let lightSystem = GKComponentSystem(componentClass: LightComponent.self)
        let trafficLightStateSystem = GKComponentSystem(componentClass: TrafficLightStateComponent.self)
        let spriteSheetSystem = GKComponentSystem(componentClass: SpriteSheetComponent.self)
        let alertPositionSystem = GKComponentSystem(componentClass: AlertPositionComponent.self)
        let crossingSystem = GKComponentSystem(componentClass: CrossingComponent.self)
        let zebraCrossSystem = GKComponentSystem(componentClass: ZebraCrossComponent.self)
        let collisionSystem = GKComponentSystem(componentClass: CollisionComponent.self)
        let zebraCrossCollisionSystem = GKComponentSystem(componentClass: ZebraCrossCollisionComponent.self)
        let trafficLightSpawnerSystem = GKComponentSystem(componentClass: TrafficLightSpawnerComponent.self)
        let spawnerGCSystem = GKComponentSystem(componentClass: SpawnerGCComponent.self)
        let playerCarSFXSystem = GKComponentSystem(componentClass: PlayerCarSFXComponent.self)
        let countDownSystem = GKComponentSystem(componentClass: CountDownComponent.self)
        let moveSidewaysSystem = GKComponentSystem(componentClass: MoveSidewaysComponent.self)
        let gradingLabelSystem = GKComponentSystem(componentClass: GradingLabelComponent.self)
        let renderlabeLSystem = GKComponentSystem(componentClass: RenderLabelComponent.self)
        return [
            countDownSystem,
            ambulanceSpeedSystem,
            positionSystem,
            sizeSystem,
            roadSystem,
            playerCarSFXSystem,
            spawnerSystem,
            trafficLightSpawnerSystem,
            zebraCrossSystem,
            zebraCrossCollisionSystem,
            crossingSystem,
            moveSidewaysSystem,
            positionRelativeSystem,
            collisionSystem,
            alertPositionSystem,
            lightSystem,
            trafficLightStateSystem,
            speedSystem,
            spriteSheetSystem,
            spawnerGCSystem,
            renderlabeLSystem,
            gradingLabelSystem,
            renderSystem
        ]
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
        if let playerSFXComponent = entity.component(ofType: PlayerCarSFXComponent.self) {
            scene.addChild(playerSFXComponent.accelerationNode)
            scene.addChild(playerSFXComponent.decelerationNode)
        }
        
        if let labelNode = entity.component(ofType: RenderLabelComponent.self)?.label {
            scene.addChild(labelNode)
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
    
    func reset() {
        let entityTypesToRemove: [GKEntity.Type] = [
            DynamicObstacle.self,
            ZebraCross.self,
            StaticObstacle.self,
            Pocong.self,
            ZebraCross.self,
            TrafficLight.self,
            Spawner.self,
            Explosion.self,
            Ambulance.self,
            AmbulanceAlert.self,
            PoliceAlert.self
        ]
        
        if let gameScene = scene as? GameScene {
            gameScene.ambulance = nil
            gameScene.ambulanceAlert = nil
            gameScene.policeAlert = nil
        }

        entities.forEach { entity in
            if entityTypesToRemove.contains(where: { t in type(of: entity).isSubclass(of: t) }) {
                remove(entity)
            }
        }
    }
}
