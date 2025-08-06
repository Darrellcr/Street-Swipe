//
//  StreetSwipe.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 24/07/25.
//

import SwiftUI
import SwiftData

@main
struct StreetSwipe: App {
    var body: some Scene {
        WindowGroup {
            LeaderboardView()
        }
        .modelContainer(for: BestScoreRecord.self)
    }
}
