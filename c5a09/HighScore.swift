//
//  HighScore.swift
//  c5a09
//
//  Created by Nicholas Sindoro on 24/07/25.
//

import Foundation
import SwiftData

@Model
final class HighScore {
    var value: Int
    var updatedAt: Date

    init(value: Int, updatedAt: Date = .now) {
        self.value = value
        self.updatedAt = updatedAt
    }
}
