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
//                            .frame(width: 360)
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 10)
            
            VStack(alignment: .leading) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
//                        Text("haha")
//                            .font(.custom("DepartureMono-Regular", size: 18))
//                        Text("haha")
//                            .font(.custom("DepartureMono-Regular", size: 18))
//                        Text("haha")
//                            .font(.custom("DepartureMono-Regular", size: 18))
//                        Text("haha")
//                            .font(.custom("DepartureMono-Regular", size: 18))
//                        Text("haha")
//                            .font(.custom("DepartureMono-Regular", size: 18))
//                        
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
                    .padding(5)
                }
//                .padding(5)
                //                .frame(width: 300, height: 300, alignment: .topLeading)   // <- start at top
                .foregroundStyle(.white)
                .cornerRadius(16)
//                .padding(.bottom, 100)
                .frame(maxWidth: .infinity,
                       maxHeight: UIScreen.main.bounds.height * 0.4,
                       alignment: .topLeading)
//                .frame(maxHeight: UIScreen.main.bounds.height * 0.4)
//                .background(Color.white.opacity(0.9))
                
                //                .padding(5)
                ////                .frame(width: 300, height: 300, alignment: .topLeading)   // <- start at top
                //                .foregroundStyle(.white)
                //                .cornerRadius(16)
                //                .padding(.bottom, 100)
                //                .frame(maxWidth: .infinity,
                //                       maxHeight: .infinity,
                //                       alignment: .topLeading)
                //                .background(Color.white.opacity(0.9))
                
                //                VStack {
                //                    ZStack {
                HStack {
                    Spacer()
                    Button(action : {
                        showLeaderboard = false
                    }) {
                        ZStack {
                            Image("close_button")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                            
                            Text("Close")
                                .foregroundStyle(Color.white)
                                .font(.custom("DepartureMono-Regular", size: 15))
                            
                        }
                    }
//                    .background(Color.white.opacity(0.9))
                    Spacer()
                }
                .padding(.vertical, 10)
                        
                        //            Button("Close") {             // tap → hide overlay
                        //                showLeaderboard = false   // toggles parent state
                        //            }
                        
//                        Text("Close")
//                            .foregroundStyle(Color.white)
//                            .font(.custom("DepartureMono-Regular", size: 15))
//                        
//                    }
            
            }
//            .background(Color.red.opacity(0.5))
//            .frame(width: 300, height: 400)
//            .frame(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height/2)
            .frame(width: UIScreen.main.bounds.width * 0.75)
//            .position(y: UIScreen.main.bounds.height/2)
            .offset(y: UIScreen.main.bounds.height * 0.09)
            
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
#Preview {
    LeaderboardView(showLeaderboard: .constant(true))
}
