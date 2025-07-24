//
//  HighScoreState.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 24/07/25.
//

import Foundation
import SwiftData

@MainActor
final class HighScoreStore {
    static let shared = HighScoreStore()

    let container: ModelContainer
    let context: ModelContext

    private init() {
        // You can also pass a custom ModelConfiguration if you want
        // an app group / shared container, etc.
        let schema = Schema([HighScore.self])
        container = try! ModelContainer(for: schema)
        context = ModelContext(container)
    }

    // Fetch (or create if not there yet)
    func current() -> HighScore {
        let descriptor = FetchDescriptor<HighScore>(
            sortBy: [SortDescriptor(\.value, order: .reverse)]
        )
        if let hs = try? context.fetch(descriptor).first {
            return hs
        } else {
            let hs = HighScore(value: 0)
            context.insert(hs)
            try? context.save()
            return hs
        }
    }
    
    // Remove every HighScore row (and recreate an empty one set to 0 if you like)
    func reset(seedTo value: Int = 0) {
        let descriptor = FetchDescriptor<HighScore>()
        if let all = try? context.fetch(descriptor) {
            all.forEach { context.delete($0) }
        }
        // (optional) create a fresh record so `current()` never has to insert later
        let hs = HighScore(value: value)
        context.insert(hs)

        try? context.save()
    }

    /// Submit a new score. Returns `true` if it became the new high score.
    @discardableResult
    func submit(_ score: Int) -> Bool {
        let hs = current()
        guard score > hs.value else { return false }
        hs.value = score
        hs.updatedAt = .now
        try? context.save()
        return true
    }

    func bestValue() -> Int {
        current().value
    }
}

