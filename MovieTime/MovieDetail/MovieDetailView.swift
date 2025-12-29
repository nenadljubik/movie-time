//
//  MovieDetailView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import SwiftUI
import SwiftData
import TMDBKit

struct MovieDetailView: View {
    let movie: Movie
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = MovieDetailViewModel()

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            MovieDetailContentView(
                movie: movie,
                isCompact: isCompact
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                favoriteButton
            }
        }
        .onAppear {
            viewModel.configure(with: modelContext)
            viewModel.checkFavoriteStatus(for: movie)
        }
    }

    private var favoriteButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                viewModel.toggleFavorite(for: movie)
            }
        } label: {
            Image(systemName: viewModel.isFavorited ? "heart.fill" : "heart")
                .font(.system(size: 22))
                .foregroundColor(viewModel.isFavorited ? .accentRed : .accentRed)
                .symbolEffect(.bounce, value: viewModel.isFavorited)
        }
        .accessibilityIdentifier("FavoriteButton")
    }
}
