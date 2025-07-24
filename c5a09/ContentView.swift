//
//  ContentView.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 24/07/25.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @State private var isGameStarted = false
//    @State private var isGameOver = false
    @State private var distance: Int = 0
    @StateObject private var gameScene = GameScene(size: UIScreen.main.bounds.size)
    @State private var isPanning: Bool = false
    
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
            
            
            if !isGameStarted {
                LandingView(isGameStarted: $isGameStarted, gameScene: gameScene)
                    .transition(.scale)
                    .zIndex(1)
            }
            
//            if isGameStarted && !isGameOver {
//                VStack {
//                    Text("Score: \(distance)")
//                        .padding()
//                        .background(.green.opacity(0.6))
//                        .font(.custom("Mini Mouse Regular", size: 20))
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                    
//                    Button("Play Again") {
//                        isGameOver = true
////                        isGameStarted = false
//                        
//                        gameScene.resetGame()  // akan memicu ulang fungsi
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
            
            if gameScene.isGameOver {
                GameOverView(isGameStarted: $isGameStarted, gameScene: gameScene)
                    .zIndex(3)
                    .transition(.scale)
            }
        }
//        .onReceive(NotificationCenter.default.publisher(for: .distanceDidUpdate)) { notification in
//            if let newValue = notification.userInfo?["distance"] as? Int {
//                self.distance = newValue
//            }
//        }
//        .onReceive(NotificationCenter.default.publisher(for: .gameOver)) { _ in
//            withAnimation {
//                isGameOver = true
//            }
//        }
    }
}

#Preview {
    ContentView()
}
