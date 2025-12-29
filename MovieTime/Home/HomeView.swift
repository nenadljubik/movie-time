//
//  HomeView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 27.12.25.
//

import SwiftUI
import SwiftData
import TMDBKit

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
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

            gridView
        }
        .navigationTitle("Trending Movies")
        .navigationBarTitleDisplayMode(.large)
        .navigationDestination(for: Movie.self) { movie in
            MovieDetailView(movie: movie)
        }
        .onAppear {
            viewModel.configure(with: modelContext)
        }
        .task {
            if viewModel.movies.isEmpty {
                await viewModel.loadTrendingMovies()
            }
        }
    }

    var gridView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                moviesList
                loadingIndicator
            }
            .padding()
        }
        .accessibilityIdentifier("HomeMoviesGrid")
        .refreshable {
            await viewModel.refresh()
        }
    }

    private var moviesList: some View {
        ForEach(viewModel.movies) { movie in
            NavigationLink(value: movie) {
                MovieCardView(movie: movie)
            }
            .buttonStyle(.plain)
            .accessibilityIdentifier("MovieCard")
            .onAppear {
                Task {
                    await viewModel.loadMoreIfNeeded(currentItem: movie)
                }
            }
        }
    }

    @ViewBuilder
    private var loadingIndicator: some View {
        if viewModel.isLoading {
            ProgressView()
                .tint(.accentRed)
                .frame(maxWidth: .infinity)
                .gridCellColumns(columns.count)
                .padding()
                .accessibilityIdentifier("LoadingIndicator")
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
