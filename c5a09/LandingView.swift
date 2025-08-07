//
//  LandingView.swift
//  c5a09
//
//  Created by Felicia Stevany Lewa on 15/07/25.
//

import SpriteKit
import AVFoundation
import SwiftUI

struct LandingView: View {
    @ObservedObject var gameScene: GameScene
    
    @State private var isPressed = false
    @State private var isAnimating = false
    @State private var startSound: AVAudioPlayer?
    
    @State private var animateTop = false
    @State private var animateBottom = false
    @State private var showLeaderboard = false
    
    static let soundManager = SoundManager()
    static let hapticManager = HapticManager()
    
    let logoFrames = loadExplosionFrames(from: "logoAnimation", frameCount: 35)
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        
        Self.soundManager.playBackgroundMusic()
    }
    
    var body: some View {
        ZStack {
            
            VStack() {
                Image("rear")
                    .resizable()
                    .scaledToFit()
                    .offset(y: animateTop ? -UIScreen.main.bounds.height : 0)
                    .animation(.easeOut(duration: 2), value: animateTop)
                //                    .position(x: UIScreen.main.bounds.width / 2 + 25, y: 100)
                
                Spacer()
                
                Image("dashboard")
                    .resizable()
                    .scaledToFit()
                //                    .frame(width: UIScreen.main.bounds.width + 50, height: 380)
                    .offset(y: animateBottom ? UIScreen.main.bounds.height : 0)
                    .animation(.easeOut(duration: 2), value: animateBottom)
            }
            
            ExplosionAnimationView(frames: logoFrames)
                .position(x: UIScreen.main.bounds.width / 2 - 90, y: UIScreen.main.bounds.height / 2 - 60)
            
            ZStack {
                Image("engine start bg")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 180)
                    .offset(y: animateBottom ? UIScreen.main.bounds.height - 180 : 0)
                    .animation(.easeOut(duration: 1.5), value: animateBottom)
                
                VStack {
                    Button(action: {
                        Self.soundManager.playTapSound()
                        isPressed = true
                        isAnimating = true
                        
                        //                        let feedback = UINotificationFeedbackGenerator()
                        //                        feedback.prepare()
                        //                        feedback.notificationOccurred(.error)
                        
                        Self.hapticManager.playCrashHaptic(duration: 0.3)
                        
                        gameScene.startGame()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            isPressed = false
                            isAnimating = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                animateTop = true
                                animateBottom = true
                                GameState.shared.isRunning = true
                            }
                        }
                    }) {
                        Image("engine start button")
                            .resizable()
                            .frame(width: isAnimating ? 110 : 120, height: isAnimating ? 110 : 120)
                            .position(x: 45, y: 45)
                            .offset(y: animateBottom ? UIScreen.main.bounds.height - 180 : 0)
                            .animation(.easeOut(duration: 1.5), value: animateBottom)
                    }
                }
                .frame(width: 90, height: 90)
                
                //                .background(Color.white)
                .clipShape(.circle)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height - 180)
            }
            
            Button {
                showLeaderboard = true
                print(showLeaderboard)
            } label: {
                Text("Leaderboard")
                    .frame(width: 300, height: 150)
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(20)
            }
        }
        .ignoresSafeArea()
        
        if (showLeaderboard) {
            LeaderboardView(showLeaderboard: $showLeaderboard)
        }
    }
}

func loadExplosionFrames(from imageName: String, frameCount: Int) -> [UIImage] {
    guard let sheet = UIImage(named: imageName)?.cgImage else { return [] }
    
    let width = sheet.width / frameCount
    let height = sheet.height
    
    var frames: [UIImage] = []
    
    for i in 0..<frameCount {
        let rect = CGRect(x: width * i, y: 0, width: width, height: height)
        if let frame = sheet.cropping(to: rect) {
            frames.append(UIImage(cgImage: frame))
        }
    }
    
    return frames
}



#Preview {
    LandingView(gameScene: GameScene(size: UIScreen.main.bounds.size))
}

