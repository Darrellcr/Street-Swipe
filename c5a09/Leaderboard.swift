//
//  Leaderboard.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 05/08/25.
//

import SwiftUI
import GameKit

struct LeaderboardTestView: View {
    // CHANGE THIS to your real leaderboard ID
    private let leaderboardID = "high_score"

    @State private var score: Int = 0
    @State private var status: String = "Not submitted yet"
    @State private var isAuthenticated = GKLocalPlayer.local.isAuthenticated

    var body: some View {
        VStack(spacing: 16) {
            Text("Leaderboard Test")
                .font(.title).bold()

            // Auth status
            HStack(spacing: 8) {
                Circle().fill(isAuthenticated ? .green : .red)
                    .frame(width: 10, height: 10)
                Text(isAuthenticated ? "Game Center: Signed In" : "Game Center: Not Signed In")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // Current score
            VStack(spacing: 4) {
                Text("Current Score")
                    .font(.headline)
                Text("\(score)")
                    .font(.system(size: 48, weight: .heavy, design: .rounded))
                    .monospacedDigit()
            }
            .padding(.vertical, 8)

            // Controls
            HStack {
                Button("-10") { score = max(0, score - 10) }
                Button("-1")  { score = max(0, score - 1)  }
                Spacer()
                Button("+1")  { score += 1  }
                Button("+10") { score += 10 }
            }
            .buttonStyle(.borderedProminent)

            // Submit + Show leaderboard
            HStack {
                Button("Submit Score") {
                    if GKLocalPlayer.local.isAuthenticated {
                        GameCenterHelper.shared.submit(score: score, to: leaderboardID)
                        status = "Submitted \(score) to \(leaderboardID)"
                    } else {
                        status = "Not signed in to Game Center"
                    }
                }
                .buttonStyle(.borderedProminent)

                Button("Show Leaderboard") {
                    GameCenterHelper.shared.presentLeaderboard(id: leaderboardID)
                }
                .buttonStyle(.bordered)
            }

            // Quick actions
            HStack {
                Button("Reset Score") { score = 0 }
                Button("Random Score") { score = Int.random(in: 0...5000) }
            }
            .buttonStyle(.bordered)

            // Status line
            Text(status)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.top, 8)

            Spacer()
        }
        .padding()
        .task {
            // Kick off Game Center auth bubble once
            GameCenterHelper.shared.configure()
            // Refresh auth flag after handler runs (tiny delay)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                isAuthenticated = GKLocalPlayer.local.isAuthenticated
            }
        }
    }
}

#Preview {
    LeaderboardTestView()
}
