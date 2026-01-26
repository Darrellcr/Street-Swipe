//
//  HighwayTimer.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 16/01/26.
//

import GameplayKit

class HighwayTimer: GKEntity {
    private(set) static var shared: HighwayTimer? = nil
    
    private init(_ time: String = "55.5") {
        super.init()
        
        let renderComponent = RenderComponent(color: .black, size: .init(width: 62, height: 30), position: .init(x: 341, y: 62), zPosition: 3)
        addComponent(renderComponent)
        let renderLabelComponent = RenderLabelComponent(type: .highwayTimer, text: time, fontSize: 20, position: .init(x: 0, y: -8), zPosition: 4)
        renderComponent.node.addChild(renderLabelComponent.label)
        addComponent(renderLabelComponent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func showTimer(entityManager: EntityManager, time: String) {
        guard shared == nil else { return }
        shared = HighwayTimer(time)
        entityManager.add(shared!)
    }
    
    static func hideTimer(entityManager: EntityManager) {
        guard let shared else { return }
        entityManager.remove(shared)
        Self.shared = nil
    }
    
    static func setTime(_ time: TimeInterval) {
        guard let shared else { return }
        guard let renderLabelComponent = shared.component(ofType: RenderLabelComponent.self)
        else { return }
        
        renderLabelComponent.updateLabelText(with: String(format: "%.1f", time))
    }
}
