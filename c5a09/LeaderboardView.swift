//
//  LeaderboardView.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 05/08/25.
//

import SwiftUI

struct LeaderboardView: View {
    @ObservedObject private var leaderboard = Leaderboard.shared
    @Binding var showLeaderboard: Bool
    
    var body: some View {
        ZStack {
            Image("leaderboard")
                .resizable()
                .scaledToFit()
                .frame(width: 360)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 10)
            
            VStack(alignment: .leading) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(leaderboard.entries, id: \.self) { entry in
                            HStack(spacing: 15) {
                                Text(entry.player.alias)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .font(.custom("DepartureMono-Regular", size: 18))
                                    .frame(width: 170, alignment: .leading)
                                
                                Text("\(entry.score)")
                                    .font(.custom("DepartureMono-Regular", size: 18))
                            }
                        }
                    }
                }
            }
            .padding(5)
            .frame(width: 300, height: 410, alignment: .topLeading)   // <- start at top
            .foregroundStyle(.white)
            .cornerRadius(16)
            .padding(.bottom, 100)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .bottom)
            
            Button("Close") {             // tap → hide overlay
                showLeaderboard = false   // toggles parent state
            }
        }
        //        .task {
        //            await leaderboard.authenticateLocalPlayer()
        //            await leaderboard.submitScore(100)
        //            await leaderboard.loadData()
        //            print(leaderboard.entries)
        //        }
    }
}
//
//#Preview {
//    LeaderboardView()
//}
