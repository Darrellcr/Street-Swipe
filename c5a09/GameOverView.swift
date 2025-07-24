//
//  GameOverView.swift
//  c5a09
//
//  Created by Felicia Stevany Lewa on 15/07/25.
//
import SwiftUI

struct GameOverView: View {
    @State private var isPressed = false
    @State private var isAnimating = false
    
    @State private var animateTop = false
    @State private var animateBottom = false
    
    private let soundManager = SoundManager()
    
    @State private var gameScene = GameScene(size: UIScreen.main.bounds.size)
    

    var body: some View {
        ZStack {
            Color.black.opacity(0.5) // background yang menyeluruh
                .ignoresSafeArea()
            
            Image("game over")
                .resizable()
                .scaledToFit()
                .frame(width: 280)
                .offset(x: 0, y: -160)

            Image("score box")
                .resizable()
                .scaledToFit()
                .frame(width: 350)
            
            HStack {
                VStack(alignment: . leading, spacing: 10) {
                    Image("score")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90)
                    
                    Text("\(GameState.shared.score)")
                        .font(.custom("Mine Mouse Regular", size: 25))
                        .foregroundColor(.white)
                    
                    Image("best")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70)
                    
                    Text("\(GameState.shared.bestScore)")
                        .font(.custom("Mine Mouse Regular", size: 25))
                        .foregroundColor(.white)
                }
                
                Spacer()
                
                ZStack {
                    Image("engine start bg")
                        .resizable()
                        .frame(width: 110, height: 110)
                        .animation(.easeOut(duration: 1.5), value: animateBottom)
                    
                    Button(action: {
                        soundManager.playTapSound()
                        isPressed = true
                        isAnimating = true
                        
                        GameState.shared.reset()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isPressed = false
                            isAnimating = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                animateTop = true
                                animateBottom = true
                                GameState.shared.isRunning = true
                                GameState.shared.isGameOver = false
                                
                            }
                        }
                    }) {
                        Image("engine start button")
                            .resizable()
                            .frame(width: isAnimating ? 100 : 110, height: isAnimating ? 100 : 110)
                            .animation(.easeOut(duration: 1.5), value: animateBottom)
                    }
                }
            }
            .padding(.horizontal, 70)
        }
    }
}
#Preview {
    GameOverView()
}
