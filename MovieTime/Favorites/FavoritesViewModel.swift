//
//  FavoritesViewModel.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import Foundation
import Combine
import SwiftData
import TMDBKit

@MainActor
final class FavoritesViewModel: ObservableObject {
    @Published var favoriteMovies: [Movie] = []
    @Published var isLoading = false

    private var favoritesManager: FavoritesManager?

    func configure(with modelContext: ModelContext) {
        self.favoritesManager = FavoritesManager(modelContext: modelContext)
    }

    func loadFavorites() {
        guard let favoritesManager = favoritesManager else { return }

        isLoading = true
        do {
            let favorites = try favoritesManager.fetchAll()
            favoriteMovies = favorites.map { $0.toMovie() }
            isLoading = false
        } catch {
            print("Error loading favorites: \(error)")
            isLoading = false
        }
    }
}
