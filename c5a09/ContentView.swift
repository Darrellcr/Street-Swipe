//
//  ContentView.swift
//  c5a09
//
//  Created by Felicia Stevany Lewa on 15/07/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @State private var isGameStarted = false
    @State private var isGameOver = false
    
    private let soundManager = SoundManager()
    @State private var gameScene = GameScene(size: UIScreen.main.bounds.size)
    
    var body: some View {
        ZStack {
            SpriteView(scene: gameScene)
                .ignoresSafeArea()
                .zIndex(0)
            
            if !GameState.shared.isRunning {
                LandingView()
                    .transition(.scale)
                    .zIndex(1)
            }
            
            if GameState.shared.isGameOver {
                GameOverView()
                    .zIndex(3)
                    .transition(.scale)
            }
        }
    }
}

#Preview {
    ContentView()
}

//            if GameState.shared.isRunning && !GameState.shared.isGameOver {
//                VStack {
//                    Text("Score: \(distance)")
//                        .padding()
//                        .background(.green.opacity(0.6))
//                        .font(.custom("Mine Mouse Regular", size: 20))
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//
//                    Button("Play Again") {
//                        GameState.shared.reset() // akan memicu ulang fungsi
//
//                    }
//                    .padding()
//                    .background(Color.red)
//                    .foregroundColor(.white)
//                    .cornerRadius(12)
//                    .padding(.bottom)
//
//                    Spacer()
//                }
//                .padding(.top, 60)
//                .frame(maxWidth: .infinity, alignment: .top)
//                .zIndex(2)
//            }

//        .onReceive(NotificationCenter.default.publisher(for: .gameOver)) { _ in
//            withAnimation {
//                isGameOver = true
//            }
//        }
