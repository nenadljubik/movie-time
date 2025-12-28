//
//  FavoritesView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import SwiftUI
import SwiftData
import TMDBKit

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    @Environment(\.modelContext) private var modelContext
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

            contentView
        }
        .navigationTitle("Favorites")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: Movie.self) { movie in
            MovieDetailView(movie: movie)
        }
        .onAppear {
            viewModel.configure(with: modelContext)
            viewModel.loadFavorites()
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading {
            loadingView
        } else if viewModel.favoriteMovies.isEmpty {
            emptyStateView
        } else {
            favoritesGridView
        }
    }

    private var loadingView: some View {
        ProgressView()
            .tint(.accentRed)
            .scaleEffect(1.5)
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "heart.slash")
                .font(.system(size: 60))
                .foregroundColor(.white.opacity(0.3))

            Text("No Favorites Yet")
                .font(.title3)
                .foregroundColor(.white.opacity(0.6))

            Text("Tap the heart icon on movies you love to add them here")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.4))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }

    private var favoritesGridView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.favoriteMovies) { movie in
                    NavigationLink(value: movie) {
                        MovieCardView(movie: movie)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
}

#Preview {
    NavigationStack {
        FavoritesView()
    }
}
