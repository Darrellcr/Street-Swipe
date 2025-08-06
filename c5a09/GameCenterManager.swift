//
//  GameCenterManager.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 04/08/25.
//

import Foundation
import GameKit

class GameCenterManager: NSObject, ObservableObject, GKGameCenterControllerDelegate {
    static let shared = GameCenterManager()

    @Published var isAuthenticated = false
    private override init() {}
    
    @MainActor
    func authenticate() {
        let player = GKLocalPlayer.local
        player.authenticateHandler = { viewController, error in
            if let vc = viewController {
                // Present Game Center login UI
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootVC = scene.windows.first?.rootViewController {
                    rootVC.present(vc, animated: true)
                }
            } else if player.isAuthenticated {
                self.isAuthenticated = true
                print("Game Center: Authenticated as \(player.alias)")
            } else {
                print("Game Center: Authentication failed - \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func submitScore(score: Int, leaderboardID: String) {
        Task {
            do {
                try await GKLeaderboard.submitScore(score, context: 0, player: GKLocalPlayer.local, leaderboardIDs: ["com.streetswipe.topscore"])
            } catch {
                
            }
        }
    }

    func presentLeaderboard(leaderboardID: String) {
        let gcVC = GKGameCenterViewController(leaderboardID: leaderboardID, playerScope: .global, timeScope: .allTime)
        gcVC.gameCenterDelegate = self

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = scene.windows.first?.rootViewController {
            rootVC.present(gcVC, animated: true)
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}
