//
//  GameState.swift
//  c5a09
//
//  Created by Felicia Stevany Lewa on 23/07/25.
//

import Foundation
import SwiftData

class GameState: ObservableObject {
    static let shared = GameState()
    
    @Published var score: Int = 0 {
        didSet {
            updateBestScoreIfNeeded()
        }
    }
    @Published var bestScore: Int = 0
    @Published var speed: Int = 0
    @Published var isGameOver: Bool = false
    @Published var isRunning: Bool = false
    
    var modelContext: ModelContext?

    func loadBestScore() {
        guard let context = modelContext else { return }
        let descriptor = FetchDescriptor<BestScoreRecord>()
        if let record = try? context.fetch(descriptor).first {
            print(record.score)
            self.bestScore = record.score
        }
    }

    func updateBestScoreIfNeeded() {
        guard let context = modelContext else {
            return }
        if score > bestScore {
            bestScore = score

            let descriptor = FetchDescriptor<BestScoreRecord>()
            if let existing = try? context.fetch(descriptor).first {
                existing.score = bestScore
            } else {
                let newRecord = BestScoreRecord(score: bestScore)
                context.insert(newRecord)
            }

            try? context.save()
        }
    }
    
    func reset() {
        score = 0
        bestScore = 0
        speed = 0
        isRunning = true
        isGameOver = false
    }
}
