//
//  CountDownComponent.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 23/07/25.
//

import Foundation
import GameplayKit

enum CountDownState {
    case undone
    case done
}

class CountDownComponent: GKComponent {
    var duration: CGFloat = 0.0
    var state: CountDownState = .undone
    let entityManager: EntityManager!
    
    init(duration: CGFloat = 3.0, entityManager: EntityManager) {
        self.duration = duration
        self.entityManager = entityManager
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        duration -= CGFloat(seconds)
        if duration <= 0 {
            state = .done
            entityManager.remove(entity!)
        }
    }
}


