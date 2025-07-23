//
//  GameState.swift
//  c5a09
//
//  Created by Felicia Stevany Lewa on 23/07/25.
//

import Foundation

class GameState: ObservableObject {
    static let shared = GameState()
    
    @Published var score: Int = 0
    @Published var isGameOver: Bool = false
    @Published var isRunning: Bool = false  // <-- status apakah game sedang berjalan
    
    func reset() {
        score = 0
        isRunning = true
        isGameOver = false
    }
}
