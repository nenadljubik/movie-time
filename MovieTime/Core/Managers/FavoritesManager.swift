//
//  FavoritesManager.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import Foundation
import SwiftData
import TMDBKit

@MainActor
final class FavoritesManager {
    private let dataManager: SwiftDataManager<FavoriteMovie>

    init(modelContext: ModelContext) {
        self.dataManager = SwiftDataManager(modelContext: modelContext)
    }

    func isFavorited(movieId: Int) -> Bool {
        let predicate = #Predicate<FavoriteMovie> { favorite in
            favorite.id == movieId
        }

        do {
            let favorites = try dataManager.fetch(predicate: predicate, sortBy: [])
            return !favorites.isEmpty
        } catch {
            return false
        }
    }

    func toggleFavorite(movie: Movie) throws {
        guard let movieId = movie.id else { return }

        if isFavorited(movieId: movieId) {
            let predicate = #Predicate<FavoriteMovie> { favorite in
                favorite.id == movieId
            }
            let favorites = try dataManager.fetch(predicate: predicate, sortBy: [])
            if let favorite = favorites.first {
                try dataManager.delete(favorite)
            }
        } else {
            let favoriteMovie = FavoriteMovie(from: movie)
            try dataManager.save(favoriteMovie)
        }
    }

    func fetchAll() throws -> [FavoriteMovie] {
        let sortDescriptor = SortDescriptor(\FavoriteMovie.favoritedAt, order: .reverse)
        return try dataManager.fetchAll(sortBy: [sortDescriptor])
    }

    func removeFavorite(movieId: Int) throws {
        let predicate = #Predicate<FavoriteMovie> { favorite in
            favorite.id == movieId
        }
        let favorites = try dataManager.fetch(predicate: predicate, sortBy: [])
        if let favorite = favorites.first {
            try dataManager.delete(favorite)
        }
    }
}
