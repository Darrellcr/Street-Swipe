//
//  ExplosionAnimationView.swift
//  c5a09
//
//  Created by Felicia Stevany Lewa on 18/07/25.
//

import SwiftUI

struct ExplosionAnimationView: View {
    @State private var currentFrame = 0
    let frames: [UIImage]
    let timer = Timer.publish(every: 0.075, on: .main, in: .common).autoconnect()

    var body: some View {
        Image(uiImage: frames[currentFrame])
            .resizable()
            .scaledToFit()
            .frame(width: 500, height: 500)
            .onReceive(timer) { _ in
                if currentFrame < frames.count - 1 {
                    currentFrame += 1
                }
                else if currentFrame == frames.count - 1 {
                    currentFrame = 6
                }
            }
    }
}
