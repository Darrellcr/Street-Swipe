//
//  Leaderboard.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 04/08/25.
//

import Foundation
import GameKit

class Leaderboard: ObservableObject {
    static let shared = Leaderboard()
    
    @Published var entries: [GKLeaderboard.Entry] = []
    @Published var localPlayerEntry: GKLeaderboard.Entry?
    @Published var playerCount: Int = 0
    
    private var leaderboard: GKLeaderboard?
    private let leaderboardID: String = "com.streetswipe.topscore"
    
    private func loadLeaderboard() async {
        guard leaderboard === nil else { return }
        do {
            let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [leaderboardID])
            guard leaderboards.count > 0 else { return }
            self.leaderboard = leaderboards.first!
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func loadData() async {
        if !GKLocalPlayer.local.isAuthenticated {
            await authenticateLocalPlayer()
        }
        await loadLeaderboard()
        guard let leaderboard else { return }
        do {
            let (playerEntry, entries, playerCount) = try await leaderboard.loadEntries(for: .global, timeScope: .allTime, range: .init(location: 1, length: 10))
            self.localPlayerEntry = playerEntry
            self.entries = entries
            self.playerCount = playerCount
        } catch {
            print(error)
        }
        
        print(entries)
    }
    
    @MainActor
    func authenticateLocalPlayer() async {
        let localPlayer = GKLocalPlayer.local
        
        await withCheckedContinuation { continuation in
            var resumed = false
            localPlayer.authenticateHandler = { viewController, error in
                if let viewController = viewController {
                    // Present the Game Center login UI if needed
//                    if let root = UIApplication.shared.windows.first?.rootViewController {
//                        root.present(viewController, animated: true) {
//                            continuation.resume()
//                        }
//                    } else {
//                        continuation.resume()
//                    }
//                    
                    if let windowScene = UIApplication.shared.connectedScenes
                        .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                       let root = windowScene.windows.first?.rootViewController {
                        root.present(viewController, animated: true) {
                            continuation.resume()
                            resumed = true
                        }
                    } else {
                        continuation.resume()
                        resumed = true
                    }
                    
                } else {
                    if let error = error {
                        print("Game Center auth failed: \(error.localizedDescription)")
                    } else if localPlayer.isAuthenticated {
                        print("Game Center authenticated as \(localPlayer.displayName)")
                    } else {
                        print("Game Center not available.")
                    }
                    if !resumed {
                        continuation.resume()
                        resumed = true                        
                    }
                }
            }
        }
    }
    
    func submitScore(_ score: Int) async {
        let localPlayer = GKLocalPlayer.local

        guard localPlayer.isAuthenticated else {
            print("🚫 Player not authenticated")
            return
        }
        
        do {
            try await GKLeaderboard.submitScore(score, context: 0, player: localPlayer, leaderboardIDs: [leaderboardID])
            print("✅ Score submitted: \(score) to leaderboard \(leaderboardID)")
        } catch {
            print("❌ Failed to submit score: \(error.localizedDescription)")
        }
    }
}
