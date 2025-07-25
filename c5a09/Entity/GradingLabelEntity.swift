//
//  GradingLabelEntity.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 25/07/25.
//

import Foundation
import GameplayKit
import SpriteKit

// MARK: - Entity pembungkus (biar pemanggilan singkat)
final class GradingLabelEntity: GKEntity {
    init(grade: Grading,
         parent: SKNode,
         bounds: CGRect? = nil,
         totalDuration: TimeInterval = 0.6,
         fadeInDuration: TimeInterval = 0.1,
         settleDuration: TimeInterval = 0.08,
         holdBeforeFade: TimeInterval = 0.25,
         moveUpDistance: CGFloat = 80,
         fontName: String = "Mine Mouse Regular",
         fontSize: CGFloat = 48,
         onFinish: (() -> Void)? = nil) {

        super.init()

        let gradingLabelComponent = GradingLabelComponent(
            grade: grade,
            parent: parent,
            bounds: bounds,
            totalDuration: totalDuration,
            fadeInDuration: fadeInDuration,
            settleDuration: settleDuration,
            holdBeforeFade: holdBeforeFade,
            moveUpDistance: moveUpDistance,
            fontName: fontName,
            fontSize: fontSize,
            onFinish: onFinish
        )
        addComponent(gradingLabelComponent)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
