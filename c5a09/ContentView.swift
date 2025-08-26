//
//  ContentView.swift
//  c5a09
//

//  Created by Felicia Stevany Lewa on 15/07/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @State private var distance: Int = 0
    @StateObject private var gameScene = GameScene(size: UIScreen.main.bounds.size)
    @State private var isPanning: Bool = false
    
    @ObservedObject private var leaderboard = Leaderboard.shared
    @ObservedObject private var gameState = GameState.shared
    
    var body: some View {
        ZStack {
            SpriteView(scene: gameScene)
                .ignoresSafeArea()
                .zIndex(0)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            guard gameState.isRunning && !gameState.isGameOver else { return }
                            
                            if !isPanning {
                                isPanning = true
                                gameScene.handlePan(
                                    translation: value.translation,
                                    velocity: value.velocity,
                                    state: .began)
                                return
                            }
                            
                            gameScene.handlePan(
                                translation: value.translation,
                                velocity: value.velocity,
                                state: .changed)
                        }
                        .onEnded { value in
                            guard gameState.isRunning && !gameState.isGameOver else { return }
                            
                            gameScene.handlePan(
                                translation: value.translation,
                                velocity: value.velocity,
                                state: .ended)
                            isPanning = false
                        }
                )
                .onChange(of: scenePhase, initial: false) {
                    switch scenePhase {
                    case .active:
                        GameScene.hornAudioNode.run(SKAction.stop())
                    default:
                        break
                    }
                }
            
            if !gameState.isRunning {
                LandingView(gameScene: gameScene)
                    .transition(.scale)
                    .zIndex(1)
            }
            if gameState.isGameOver {
                GameOverView(gameScene: gameScene)
                    .zIndex(3)
                    .transition(.scale)
            }
        }
        .task {
            GameState.shared.modelContext = modelContext
            GameState.shared.loadBestScore()
            await leaderboard.authenticateLocalPlayer()
//            await leaderboard.submitScore(100)
            await leaderboard.loadData()
            print(leaderboard.entries)
        }
    }
}

#Preview {
    ContentView()
}
