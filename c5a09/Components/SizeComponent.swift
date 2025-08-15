//
//  SizeComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 19/07/25.
//

import Foundation
import GameplayKit

class SizeComponent: GKComponent {
    var size: CGSize
    private var node: SKSpriteNode!
    
    init(size: CGSize) {
        self.size = size
        
        super.init()
    }
    
    init(width: CGFloat) {
        self.size = CGSize(width: width, height: .zero)
        
        super.init()
    }
    
    override init() {
        self.size = .zero
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        super.didAddToEntity()
        
        guard let node = entity?.component(ofType: RenderComponent.self)?.node
        else {
            assert(false, "RenderComponent not set")
            return
        }
        self.node = node
        
        guard let texture = node.texture else { return }
        if size == .zero {
            size = texture.size()
        }
        if size.height == .zero {
            let aspectRatio = texture.size().width / texture.size().height
            let height = size.width / aspectRatio
            size.height = height
        }
        
        self.node.size = self.size
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        
        guard entity?.component(ofType: PositionRelativeComponent.self) == nil else { return }
        
        self.node.size = self.size
    }
}
