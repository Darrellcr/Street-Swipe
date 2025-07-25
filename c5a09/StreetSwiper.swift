//
//  StreetSwiper.swift
//  c5a09
//
//  Created by Darrell Cornelius Rivaldo on 24/07/25.
//

import SwiftUI
import SwiftData

@main
struct StreetSwiper: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: BestScoreRecord.self)
    }
}
