//
//  GradingLabelComponent.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 25/07/25.
//

import SpriteKit
import GameplayKit

enum Grading {
    case perfect, good, bad

    var text: String {
        switch self {
        case .perfect: return "PERFECT!"
        case .good:    return "GOOD"
        case .bad:     return "BAD"
        }
    }

    var color: SKColor {
        switch self {
        case .perfect: return .systemYellow   // gold
        case .good:    return .white
        case .bad:     return .red
        }
    }

    var baseScale: CGFloat {
        switch self {
        case .perfect: return 1.0
        case .good:    return 0.9
        case .bad:     return 0.8
        }
    }
}

// MARK: - Helper untuk default bounds
private extension SKNode {
    var defaultSceneBounds: CGRect {
        return CGRect(x: 50, y: 400, width: 293, height: 200) // fallback dev
    }
}

// MARK: - Single component (random spawn + anim + auto-remove)
final class GradingLabelComponent: GKComponent {
    // Konfigurasi
    private let text: String
    private let color: SKColor
    private let fontName: String
    private let fontSize: CGFloat
    private let baseScale: CGFloat

    private let bounds: CGRect
    private weak var parent: SKNode?
    private let onFinish: (() -> Void)?

    // timing
    private let totalDuration: TimeInterval
    private let fadeInDuration: TimeInterval
    private let settleDuration: TimeInterval
    private let holdBeforeFade: TimeInterval
    private let moveUpDistance: CGFloat

    // runtime
    private var elapsed: TimeInterval = 0
    private var label: SKLabelNode!

    init(grade: Grading,
         parent: SKNode,
         bounds: CGRect? = nil,
         // durasi default bisa diubah dari param
         totalDuration: TimeInterval = 1.0,
         fadeInDuration: TimeInterval = 0.1,
         settleDuration: TimeInterval = 0.08,
         holdBeforeFade: TimeInterval = 0.25,
         moveUpDistance: CGFloat = 80,
         fontName: String = "DepartureMono-Regular",
         fontSize: CGFloat = 48,
         onFinish: (() -> Void)? = nil) {

        self.text = grade.text
        self.color = grade.color
        self.baseScale = grade.baseScale

        self.fontName = fontName
        self.fontSize = fontSize

        self.parent = parent
        self.bounds = bounds ?? parent.defaultSceneBounds
        self.onFinish = onFinish

        self.totalDuration   = totalDuration
        self.fadeInDuration  = fadeInDuration
        self.settleDuration  = settleDuration
        self.holdBeforeFade  = holdBeforeFade
        self.moveUpDistance  = moveUpDistance

        super.init()
        buildNode()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func buildNode() {
        let x = CGFloat.random(in: bounds.minX...bounds.maxX)
        let y = CGFloat.random(in: bounds.minY...bounds.maxY)

        let label = SKLabelNode(fontNamed: fontName)
        label.text = text
        label.fontColor = color
        label.fontSize = fontSize
        label.position = CGPoint(x: x, y: y)
        label.zPosition = 1_000
        label.alpha = 0
        label.setScale(0.2)

        parent?.addChild(label)
        self.label = label
    }

    override func update(deltaTime seconds: TimeInterval) {
        guard let label = label else { return }

        elapsed += seconds
        let t = elapsed

        // 1) Fade in + pop
        if t <= fadeInDuration {
            let k = t / fadeInDuration
            label.alpha = CGFloat(k)
            let s = 0.2 + (baseScale - 0.2) * CGFloat(k)
            label.setScale(s)
        }
        // 2) Settle bounce
        else if t <= fadeInDuration + settleDuration {
            let k = (t - fadeInDuration) / settleDuration
            let from = baseScale
            let to   = baseScale * 0.95
            let s    = from + (to - from) * CGFloat(k)
            label.setScale(s)
            label.alpha = 1
        }
        // 3) Move up + (delayed) fade out
        else {
            label.alpha = 1
            // naik linear per-frame
            label.position.y += moveUpDistance * CGFloat(seconds / totalDuration)

            if t >= holdBeforeFade {
                let fadeT = min((t - holdBeforeFade) / (totalDuration - holdBeforeFade), 1.0)
                label.alpha = 1 - CGFloat(fadeT)
            }
        }

        if elapsed >= totalDuration {
            label.removeFromParent()
            onFinish?()
            // lepaskan komponen dari entity
            entity?.removeComponent(ofType: GradingLabelComponent.self)
        }
    }
}

