//
//  GameCenterHelper.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 05/08/25.
//

import GameKit
import UIKit

final class GameCenterHelper: NSObject, GKGameCenterControllerDelegate {
    static let shared = GameCenterHelper()
    private override init() {}

    var isAuthenticated: Bool { GKLocalPlayer.local.isAuthenticated }

    func configure() {
        GKAccessPoint.shared.isActive = true
        GKAccessPoint.shared.location = .topLeading  // optional bubble

        GKLocalPlayer.local.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "Authentication failed")
                return
            }
            
            self.topVC()?.present(vc!, animated: true, completion: nil)
        }
    }

    func submit(score: Int, to leaderboardID: String) {
        guard isAuthenticated else { return }
        GKLeaderboard.submitScore(score,
                                  context: 0,
                                  player: GKLocalPlayer.local,
                                  leaderboardIDs: [leaderboardID]) { error in
            if let error { print("Submit score error:", error) }
        }
    }

    func presentLeaderboard(id: String) {
        let gcVC = GKGameCenterViewController(leaderboardID: id,
                                              playerScope: .global,
                                              timeScope: .allTime)
        gcVC.gameCenterDelegate = self
        topVC()?.present(gcVC, animated: true)
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }

    private func topVC() -> UIViewController? {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        let win = scenes.first?.keyWindow
        var top = win?.rootViewController
        while let presented = top?.presentedViewController { top = presented }
        return top
    }
}

private extension UIWindowScene {
    var keyWindow: UIWindow? { windows.first { $0.isKeyWindow } }
}

