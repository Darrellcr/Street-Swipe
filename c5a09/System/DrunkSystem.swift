//
//  DrunkSystem.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 30/09/25.
//

import Foundation
import SpriteKit

class DrunkSystem {
    let scene: GameScene
    let entityManager: EntityManager
    let roadLastIndex = RoadComponent.positions.count - 6
    
    var alcohol: Collectible? = nil
    var drunkAlert: DrunkAlert? = nil
    var drunkState: Int = -1
    var drunkCoolDown: TimeInterval = 4
    var drunkCoolDownTimer: TimeInterval = 0
    var canSpawnAlcohol: Bool { return alcohol == nil && drunkAlert == nil }
    var shiftStrength: CGFloat = 3
    
    init(scene: GameScene, entityManager: EntityManager) {
        self.scene = scene
        self.entityManager = entityManager
    }
    
    func reset() {
        despawnAlcohol()
        despawnDrunkAlert()
        drunkState = -1
        drunkCoolDownTimer = 0
    }
    func spawnDrunkAlert() {
        drunkAlert = DrunkAlert(zPosition: 1000, scene: scene, entityManager: entityManager)
        entityManager.add(drunkAlert!)
    }
    func despawnDrunkAlert() {
        guard let alert = self.drunkAlert else { return }
        self.drunkAlert = nil
        entityManager.remove(alert)
    }
    func spawnAlcohol() {
        alcohol = Collectible(
            imageName: "beer-Sheet",
            imageRows: 1,
            imageCols: 3,
            index: roadLastIndex,
            offsetPct: CGFloat.random(in: 0...1),
            scene: scene,
            width: 180,
            entityManager: entityManager,
            collisionBoxSize: CGSize(width: 120, height: 200)
        ) { position, _ in
            print("Collect alchohol \(position)")
            self.spawnDrunkAlert()
            self.despawnAlcohol()
            self.drunkState = Int.random(in: 1...2)
            self.drunkCoolDownTimer = 3
            print("Set drunk state to \(self.drunkState)")
        }
        entityManager.add(alcohol!)
    }
    func despawnAlcohol() {
        guard let alcohol = self.alcohol else { return }
        self.alcohol = nil
        entityManager.remove(alcohol)
    }
    
    func update(_ deltaTime: CFTimeInterval) {
//        print("Can spawn: \(canSpawnAlcohol)")
        // Spawn alcohol
        if canSpawnAlcohol && Double.random(in: 0...1) < 0.005 {
            spawnAlcohol()
        }
        
        // Cooldown
        if drunkState != -1 {
            drunkCoolDownTimer -= deltaTime
            if drunkCoolDownTimer <= 0 {
                reset()
            }
        }
        
        // Drunk state
        if drunkState == 1 {
            let unit = 150.0 / Double(scene.gameCamera.maxX)
//            scene.gameCamera.xShift -= 2 / unit
            scene.gameCamera.xBeforePan -= shiftStrength / unit
        }
        if drunkState == 2 {
            let unit = 150.0 / Double(scene.gameCamera.maxX)
//            scene.gameCamera.xShift += 2 / unit
            scene.gameCamera.xBeforePan += shiftStrength / unit
        }
    }
}
