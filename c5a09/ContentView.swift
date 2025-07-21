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
    @State private var distance: Int = 0
    @State private var gameScene = GameScene(size: UIScreen.main.bounds.size)
    
    var body: some View {
        ZStack {
            SpriteView(scene: gameScene)
                .ignoresSafeArea()
                .zIndex(0)
                .gesture(
                    DragGesture(minimumDistance: 20)
                        .onEnded { value in
                            let horizontal = value.translation.width
                            let vertical = value.translation.height
                            
                            let swipeGesture = UISwipeGestureRecognizer()
                            
                            if abs(horizontal) > abs(vertical) {
                                swipeGesture.direction = horizontal > 0 ? .right : .left
                            } else {
                                swipeGesture.direction = vertical > 0 ? .down : .up
                            }
                            
                            gameScene.handleSwipe(swipeGesture)
                        }
                )
            
            
            if !isGameStarted {
                LandingView(isGameStarted: $isGameStarted)
                    .transition(.scale)
                    .zIndex(1)
            }
            
            if isGameStarted && !isGameOver {
                VStack {
                    Text("Distance: \(distance) m")
                        .padding()
                        .background(.green.opacity(0.6))
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    
                    Button("Play Again") {
                        gameScene.resetGame()  // akan memicu ulang fungsi playAgain()
                    }
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.bottom)
                    
                    Spacer()
                }
                .padding(.top, 60)
                .frame(maxWidth: .infinity, alignment: .top)
                .zIndex(2)
            }
            
            if isGameOver {
                GameOverView(isGameOver: $isGameOver)
                    .zIndex(3)
                    .transition(.scale)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .distanceDidUpdate)) { notification in
            if let newValue = notification.userInfo?["distance"] as? Int {
                self.distance = newValue
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .gameOver)) { _ in
            withAnimation {
                isGameOver = true
            }
        }
    }
}

#Preview {
    ContentView()
}
