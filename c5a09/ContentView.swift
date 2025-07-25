//
//  ContentView.swift
//  c5a09
//

//  Created by Felicia Stevany Lewa on 15/07/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @State private var distance: Int = 0
    @StateObject private var gameScene = GameScene(size: UIScreen.main.bounds.size)
    @State private var isPanning: Bool = false
    
    @StateObject private var gameState = GameState.shared
    
    var body: some View {
        ZStack {
            SpriteView(scene: gameScene)
                .ignoresSafeArea()
                .zIndex(0)
                .gesture(
                    DragGesture(minimumDistance: 10)
                        .onChanged { value in
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
                            gameScene.handlePan(
                                translation: value.translation,
                                velocity: value.velocity,
                                state: .ended)
                            isPanning = false
                        }
                )
            
            
            if !GameState.shared.isRunning {
                Text("asdasd")
                LandingView(gameScene: gameScene)
                    .transition(.scale)
                    .zIndex(1)
            }
            if GameState.shared.isGameOver {
                GameOverView(gameScene: gameScene)
                    .zIndex(3)
                    .transition(.scale)
            }
        }
    }
}

#Preview {
    ContentView()
}
