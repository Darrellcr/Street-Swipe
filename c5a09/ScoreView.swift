//
//  ScoreView.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 24/07/25.
//

import Foundation
import SwiftUI

struct ScoreView: View {
    @State private var best = 0

    var body: some View {
        VStack {
            Text("Best: \(best)")
            Button("Submit 1234") {
                Task { @MainActor in
                    HighScoreStore.shared.submit(1234)
                    best = HighScoreStore.shared.bestValue()
                }
            }
            Button("Reset") {
                Task { @MainActor in
                    HighScoreStore.shared.reset()
                    best = HighScoreStore.shared.bestValue()
                }
            }
        }
        .task { @MainActor in
            best = HighScoreStore.shared.bestValue()
        }
    }
}

#Preview {
    ScoreView()
}
