//
//  MovieTimeApp.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 25.12.25.
//

import SwiftUI
import TMDBKit

@main
struct MovieTimeApp: App {
    init() {
        TMDBConfiguration.configure(accessToken: AppConfiguration.tmdbAccessToken)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
