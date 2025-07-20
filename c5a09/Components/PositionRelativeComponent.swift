//
//  ZPerspectiveComponent.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 19/07/25.
//

import Foundation

class ZPerspectiveComponent {
    var zIndex: Int = 0
    
    init(zIndex: Int) {
        self.zIndex = zIndex
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
