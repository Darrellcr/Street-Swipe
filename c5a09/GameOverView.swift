//
//  GameOverView.swift
//  c5a09
//
//  Created by Felicia Stevany Lewa on 15/07/25.
//
import SwiftUI

struct GameOverView: View {
    var onRestart: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("💥 Game Over")
                .font(.largeTitle.bold())
                .foregroundColor(.white)

            Button("Try Again") {
                onRestart()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding()
        .frame(maxWidth: 300)
        .background(Color.black.opacity(0.8))
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
#Preview {
    GameOverView(onRestart: { })
}
