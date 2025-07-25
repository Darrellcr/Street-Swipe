//
//  ZebraCrossCollisionComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 22/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

class ZebraCrossCollisionComponent: GKComponent {
    let onBadStop: () -> Void
    let onGoodStop: () -> Void
    let onPerfectStop: () -> Void
    let onCollision: () -> Void
    
    private let hapticManager = HapticManager()
    var trafficLight: TrafficLight?
    var hasCollided: Bool = false
    var hasStopped: Bool = false
    static let stopIndex: Int = 100
    static let badStopIndex: Int = 37
    static let goodStopIndex: Int = 28
    static let perfectStopIndex: Int = 22
    
    init(onBadStop: @escaping () -> Void,
         onGoodStop: @escaping () -> Void,
         onPerfectStop: @escaping () -> Void,
         onCollision: @escaping () -> Void) {
        self.onBadStop = onBadStop
        self.onGoodStop = onGoodStop
        self.onPerfectStop = onPerfectStop
        self.onCollision = onCollision
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard let zebraCrossComponent = entity?.component(ofType: ZebraCrossComponent.self),
              let trafficLightState = trafficLight?.component(ofType: TrafficLightStateComponent.self)?.state
        else { return }
        
        guard trafficLightState == .red
        else { return }
        let zebraCrossPosition = zebraCrossComponent.index
        if zebraCrossPosition > Self.stopIndex { return }
        if zebraCrossPosition < Self.perfectStopIndex && !hasCollided {
            hasCollided = true
            onCollision()
            
            // haptic
//            let feedback = UINotificationFeedbackGenerator()
//                feedback.prepare()
//                feedback.notificationOccurred(.error)
            
            hapticManager.playCrashHaptic(duration: 0.2)
        }
        
        guard !hasStopped && RoadComponent.speed == 0 else { return }
        hasStopped = true
        if zebraCrossPosition >= Self.badStopIndex {
            onBadStop()
        } else if zebraCrossPosition >= Self.goodStopIndex {
            onGoodStop()
        } else if zebraCrossPosition >= Self.perfectStopIndex {
            onPerfectStop()
        }
    }
}
