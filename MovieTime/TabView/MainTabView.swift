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
        }
        .tint(.accentRed)
    }
}

#Preview {
    MainTabView()
}
