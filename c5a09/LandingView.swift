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
    @Binding var isGameStarted: Bool
    
    @State private var isPressed = false
    @State private var isAnimating = false
    @State private var startSound: AVAudioPlayer?
    
    @State private var animateTop = false
    @State private var animateBottom = false
    
    let explosionFrames = loadExplosionFrames(from: "explosion", frameCount: 11)

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
                
                Image("ac and screen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width + 50, height: 380)
                    .offset(y: animateBottom ? UIScreen.main.bounds.height : 0)
                    .animation(.easeOut(duration: 2), value: animateBottom)
                
            }
            
            Image("engine start bg")
                .resizable()
                .frame(width: 120, height: 120)
                .position(x: UIScreen.main.bounds.width / 2 + 25, y: UIScreen.main.bounds.height - 180)
                .offset(y: animateBottom ? UIScreen.main.bounds.height - 180 : 0)
                .animation(.easeOut(duration: 1.5), value: animateBottom)
            
            VStack {
                Spacer()
                Button(action: {
                    playTapSound()
                    isPressed = true
                    isAnimating = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isPressed = false
                        isAnimating = false
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            animateTop = true
                            animateBottom = true
                            isGameStarted = true
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
                
                ExplosionAnimationView(frames: explosionFrames)
            }
        }
        .ignoresSafeArea()
    }
    func playTapSound() {
        guard let url = Bundle.main.url(forResource: "startengine", withExtension: "mp3") else { return }
        do {
            startSound = try AVAudioPlayer(contentsOf: url)
            startSound?.volume = 1
            startSound?.play()
        } catch {
            print("Error playing sound")
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
    LandingView(isGameStarted: .constant(false))
}

//            Button(action: {
//                isGameStarted = true
//            }) {
//                Image("engine start button")
//                    .resizable()
//                    .frame(width: isAnimating ? 115 : 130, height: isAnimating ? 115 : 130)
//                    .position(x: UIScreen.main.bounds.width / 2 + 25, y: UIScreen.main.bounds.height - 181)
//                    .scaleEffect(isPressed ? 0.7 : 1.0)
//                    .offset(y: isAnimating ? 80 : 0.8)
//                    .animation(.spring(response: 1), value: isPressed)
//                //                    .onTapGesture {
//                //                        playTapSound()
//                //                        isAnimating = true
//                //                        isPressed = true
//                //                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//                //                            isPressed = false
//                //                            isAnimating = false
//                //                            isGameStarted = true // lanjut ke game
//                //                        }
//                //                    }
//            }
