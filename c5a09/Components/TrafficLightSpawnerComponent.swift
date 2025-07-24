//
//  TrafficLightSpawnerComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 22/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class TrafficLightSpawnerComponent: GKComponent {
    let entityManager: EntityManager
    let obstacleFactory: ObstacleFactory
    let scene: GameScene
    
    static var zebraCross: GKEntity?
    static var pocong: GKEntity?
    static var leftTrafficLight: GKEntity?
    static var rightTrafficLight: GKEntity?
    static var sfx: SKAudioNode?
    
    init(entityManager: EntityManager, obstacleFactory: ObstacleFactory, scene: GameScene) {
        self.entityManager = entityManager
        self.obstacleFactory = obstacleFactory
        self.scene = scene
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
//        entityManager.toRemove.forEach { entity in
//            if entity === Self.zebraCross {
//                Self.zebraCross = nil
//            } else if entity === Self.pocong {
//                Self.pocong = nil
//            } else if entity === Self.leftTrafficLight {
//                Self.leftTrafficLight = nil
//            } else if entity === Self.rightTrafficLight {
//                Self.rightTrafficLight = nil
//            }
//        }
        
        spawnZebraCross()
        spawnPocong()
        spawnTrafficLights()
        spawnSFX()
        
        guard let sfxNode = Self.sfx,
              let traficLightState = Self.leftTrafficLight?.component(ofType: TrafficLightStateComponent.self)?.state
        else { return }
        if traficLightState == .green {
            sfxNode.removeFromParent()
        }
    }
    
    private func spawnZebraCross() {
        guard Self.zebraCross == nil
                && Self.leftTrafficLight == nil
                && Self.rightTrafficLight == nil
                && Self.pocong == nil
//                && Double.random(in: 0...1) < 0.003
        else { return }
        
        Self.zebraCross = obstacleFactory.create(.zebraCross, scene: scene, entityManager: entityManager)
        entityManager.add(Self.zebraCross!)
    }
    
    private func spawnPocong() {
        guard let zebraCrossComponent = Self.zebraCross?.component(ofType: ZebraCrossComponent.self)
        else { return }
        guard zebraCrossComponent.index < RoadComponent.positions.count - Int(Double(zebraCrossComponent.numSegments) * 1.4)
                && Self.pocong == nil
        else { return }
        
        let spawnIndex = zebraCrossComponent.index + Int(Double(zebraCrossComponent.numSegments) * 1.4)
        Self.pocong = obstacleFactory.create(.pocong, scene: scene, entityManager: entityManager, index: spawnIndex)
        entityManager.add(Self.pocong!)
    }
    
    private func spawnTrafficLights() {
        guard let zebraCrossComponent = Self.zebraCross?.component(ofType: ZebraCrossComponent.self)
        else { return }
        guard zebraCrossComponent.index < RoadComponent.positions.count - Int(Double(zebraCrossComponent.numSegments) * 2.5)
                && Self.leftTrafficLight == nil && Self.rightTrafficLight == nil
        else { return }
        
        let spawnIndex = zebraCrossComponent.index + Int(Double(zebraCrossComponent.numSegments) * 2.5)
        Self.leftTrafficLight = obstacleFactory.create(.leftTrafficLight, scene: scene, entityManager: entityManager, index: spawnIndex)
        Self.rightTrafficLight = obstacleFactory.create(.rightTrafficLight, scene: scene, entityManager: entityManager, index: spawnIndex)
        entityManager.add(Self.leftTrafficLight!)
        entityManager.add(Self.rightTrafficLight!)
        
        guard let crossingComponent = Self.pocong?.component(ofType: CrossingComponent.self),
              let zebraCrossCollisionComponent = Self.zebraCross?.component(ofType: ZebraCrossCollisionComponent.self),
              let trafficLight = Self.leftTrafficLight as? TrafficLight
        else { return }
    
        crossingComponent.trafficLight = trafficLight
        zebraCrossCollisionComponent.trafficLight = trafficLight
    }
    
    func spawnSFX() {
        guard let trafficLight = Self.leftTrafficLight as? TrafficLight
        else { return }
        guard Self.sfx == nil else { return }
        print("spawn sfx")
        let crossingSfx = Bundle.main.url(forResource: "nyebrang beep beep", withExtension: "wav")
        let node = SKAudioNode(url: crossingSfx!)
        node.autoplayLooped = true
        node.run(SKAction.sequence([
            SKAction.changeVolume(to: 0.0, duration: 0.0),
            SKAction.play(),
            SKAction.changeVolume(to: 0.03, duration: 1.0)
        ]))
        node.name = "trafficLightSFX"
        Self.sfx = node
        scene.addChild(node)
    }
}
