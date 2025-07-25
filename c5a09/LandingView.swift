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
    
    static let soundManager = SoundManager()
    
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
                    .frame(width: UIScreen.main.bounds.width + 50, height: 380)
                    .offset(y: animateBottom ? UIScreen.main.bounds.height : 0)
                    .animation(.easeOut(duration: 2), value: animateBottom)
                
            }
            
            ExplosionAnimationView(frames: logoFrames)
                .position(x: UIScreen.main.bounds.width / 2 - 65, y: UIScreen.main.bounds.height / 2 - 60)
            
            Image("engine start bg")
                .resizable()
                .frame(width: 120, height: 120)
                .position(x: UIScreen.main.bounds.width / 2 + 25, y: UIScreen.main.bounds.height - 180)
                .offset(y: animateBottom ? UIScreen.main.bounds.height - 180 : 0)
                .animation(.easeOut(duration: 1.5), value: animateBottom)
            
            VStack {
                Spacer()
                Button(action: {
                    Self.soundManager.playTapSound()
                    isPressed = true
                    isAnimating = true
                    
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
                        .position(x: UIScreen.main.bounds.width / 2 + 25, y: UIScreen.main.bounds.height - 188)
                        .offset(y: animateBottom ? UIScreen.main.bounds.height - 180 : 0)
                        .animation(.easeOut(duration: 1.5), value: animateBottom)
                }
            
            }
        }
        .ignoresSafeArea()
    }
//    func playTapSound() {
//        guard let url = Bundle.main.url(forResource: "startengine", withExtension: "mp3") else { return }
//        do {
//            startSound = try AVAudioPlayer(contentsOf: url)
//            startSound?.volume = 1
//            startSound?.play()
//        } catch {
//            print("Error playing sound")
//        }
//    }
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

