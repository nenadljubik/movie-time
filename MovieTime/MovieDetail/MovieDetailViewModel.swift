//
//  MovieDetailViewModel.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import Foundation
import Combine
import SwiftData
import TMDBKit

@MainActor
final class MovieDetailViewModel: ObservableObject {
    @Published var isFavorited = false

    private var favoritesManager: FavoritesManagerProtocol?

    func configure(with modelContext: ModelContext) {
        self.favoritesManager = FavoritesManager(modelContext: modelContext)
    }

    func checkFavoriteStatus(for movie: Movie) {
        guard let favoritesManager = favoritesManager,
              let movieId = movie.id else { return }

        isFavorited = favoritesManager.isFavorited(movieId: movieId)
    }

    func toggleFavorite(for movie: Movie) {
        guard let favoritesManager = favoritesManager else { return }

        do {
            try favoritesManager.toggleFavorite(movie: movie)
            isFavorited.toggle()
        } catch {
            print("Error toggling favorite: \(error)")
        }
    }
}
