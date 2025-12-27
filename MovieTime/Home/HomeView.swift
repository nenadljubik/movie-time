//
//  HomeView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 27.12.25.
//

import SwiftUI
import TMDBKit

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    private var columns: [GridItem] {
        let isCompact = horizontalSizeClass == .compact
        let isPortrait = verticalSizeClass == .regular

        if isCompact && isPortrait {
            return Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
        } else if isCompact && !isPortrait {
            return Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
        } else {
            return Array(repeating: GridItem(.flexible(), spacing: 20), count: 4)
        }
    }

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach([Movie.dummy(), Movie.dummy(id: 2),
                             Movie.dummy(id: 3),
                             Movie.dummy(id: 4),
                             Movie.dummy(id: 5)]) { movie in
                        MovieCardView(movie: movie)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Trending Movies")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
