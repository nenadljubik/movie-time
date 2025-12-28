//
//  FavoritesManagerProtocol.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import Foundation
import TMDBKit

@MainActor
protocol FavoritesManagerProtocol {
    func isFavorited(movieId: Int) -> Bool
    func toggleFavorite(movie: Movie) throws
    func fetchAll() throws -> [FavoriteMovie]
    func removeFavorite(movieId: Int) throws
}
