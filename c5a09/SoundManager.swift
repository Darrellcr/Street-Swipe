//
//  SoundManager.swift
//  c5a09
//
//  Created by Felicia Stevany Lewa on 22/07/25.
//

import Foundation
import AVFoundation

class SoundManager: ObservableObject {
    var backgroundMusicPlayer: AVAudioPlayer?
    var startSound: AVAudioPlayer?
    
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "street_swipe_full_BGM", withExtension: "wav") else {
            print("Music file not found")
            return
        }
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.numberOfLoops = -1 // Loop forever
            backgroundMusicPlayer?.volume = 0.2
            backgroundMusicPlayer?.play()
        } catch {
            print("Error loading music: \(error)")
        }
    }

    func playTapSound() {
        guard let url = Bundle.main.url(forResource: "startengine", withExtension: "mp3") else { return }
        do {
            startSound = try AVAudioPlayer(contentsOf: url)
            startSound?.volume = 0.7
            startSound?.play()
        } catch {
            print("Error playing sound")
        }
    }
}
