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

            gridView
        }
        .navigationTitle("Trending Movies")
        .navigationBarTitleDisplayMode(.large)
        .task {
            if viewModel.movies.isEmpty {
                await viewModel.loadTrendingMovies()
            }
        }
    }

    var gridView: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(viewModel.movies) { movie in
                    MovieCardView(movie: movie)
                        .onAppear {
                            Task {
                                await viewModel.loadMoreIfNeeded(currentItem: movie)
                            }
                        }
                }

                if viewModel.isLoading {
                    ProgressView()
                        .tint(.accentRed)
                        .frame(maxWidth: .infinity)
                        .gridCellColumns(columns.count)
                        .padding()
                }
            }
            .padding()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
