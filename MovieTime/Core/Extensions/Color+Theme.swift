//
//  Color+Theme.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 27.12.25.
//

import SwiftUI

extension Color {
    // Hex color initializer
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(red) / 255,
            green: Double(green) / 255,
            blue: Double(blue) / 255,
            opacity: Double(alpha) / 255
        )
    }

    // App theme colors
    static let appBackground = LinearGradient(
        colors: [
            Color(hex: "#141418"),  // Dark navy blue
            Color(hex: "#1F1426"),  // Dark purple
            Color(hex: "#141418")   // Dark navy blue
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardBackground = Color(hex: "#262633")  // Dark slate
    static let accentRed = Color(hex: "#E62E45")       // Crimson red
}
