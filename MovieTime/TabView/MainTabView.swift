//
//  MainTabView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 27.12.25.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "film.stack")
            }

            NavigationStack {
                SearchView()
            }
            .tabItem {
                Label("Search", systemImage: "magnifyingglass")
            }

            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
            .accessibilityIdentifier("FavoritesTab")
        }
        .tint(.accentRed)
    }
}

#Preview {
    MainTabView()
}
