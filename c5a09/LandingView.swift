//
//  LandingView.swift
//  c5a09
//
//  Created by Felicia Stevany Lewa on 15/07/25.
//

import AVFoundation
import SwiftUI

struct LandingView: View {
    @Binding var isGameStarted: Bool
    
    @State private var isPressed = false
    @State private var isAnimating = false
    @State private var startSound: AVAudioPlayer?
    
    @State private var animateTop = false
    @State private var animateBottom = false

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
            
            VStack {
                Spacer()
                Button(action: {
                    playTapSound()
                    isPressed = true
                    isAnimating = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                        isPressed = false
                        isAnimating = false
                        animateTop = true
                        animateBottom = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                    isGameStarted = true
                        }
                    }
                }) {
                    Image("engine start button")
                        .resizable()
                        .frame(width: isAnimating ? 100 : 130, height: isAnimating ? 100 : 130)
                        .position(x: UIScreen.main.bounds.width / 2 + 25, y: UIScreen.main.bounds.height - 188)
                        .animation(.easeOut(duration: 0.2), value: isPressed)
                }
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


#Preview {
    LandingView(isGameStarted: .constant(false))
}
