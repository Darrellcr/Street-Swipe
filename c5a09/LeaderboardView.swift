//
//  LeaderboardView.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 05/08/25.
//

import SwiftUI

struct LeaderboardView: View {
    @ObservedObject private var leaderboard = Leaderboard.shared
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }.task {
            await leaderboard.authenticateLocalPlayer()
            await leaderboard.submitScore(100)
            await leaderboard.loadData()
            print(leaderboard.entries)
        }
    }
}

#Preview {
    LeaderboardView()
}
