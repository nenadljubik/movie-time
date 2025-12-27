//
//  AppConfiguration.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 27.12.25.
//

import Foundation

enum AppConfiguration {
    static var tmdbAccessToken: String {
        // Read from Xcode environment variables (set in scheme)
        if let token = ProcessInfo.processInfo.environment["TMDB_ACCESS_TOKEN"], !token.isEmpty {
            return token
        }

        // Fallback to Info.plist (from xcconfig)
        if let token = Bundle.main.object(forInfoDictionaryKey: "TMDB_ACCESS_TOKEN") as? String {
            return token
        }

        fatalError("TMDB_ACCESS_TOKEN not found in environment variables or Info.plist")
    }

    static var apiEnvironment: String {
        ProcessInfo.processInfo.environment["API_ENVIRONMENT"] ?? "development"
    }
}
