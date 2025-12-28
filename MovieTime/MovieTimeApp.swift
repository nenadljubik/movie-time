//
//  MovieTimeApp.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 25.12.25.
//

import SwiftUI
import SwiftData
import TMDBKit

@main
struct MovieTimeApp: App {
    init() {
        TMDBConfiguration.configure(accessToken: AppConfiguration.tmdbAccessToken)

        configureNavigationBar()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.light)
        }
        .modelContainer(for: [CachedMovie.self, FavoriteMovie.self])
    }

    private func configureNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.accentRed)]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
