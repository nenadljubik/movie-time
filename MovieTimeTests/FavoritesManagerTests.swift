//
//  FavoritesManagerTests.swift
//  MovieTimeTests
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import XCTest
import SwiftData
import TMDBKit
@testable import MovieTime

@MainActor
final class FavoritesManagerTests: XCTestCase {

    var sut: FavoritesManagerProtocol!
    var modelContainer: ModelContainer!
    var modelContext: ModelContext!

    override func setUp() async throws {
        try await super.setUp()

        // Create in-memory container for testing
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(
            for: FavoriteMovie.self,
            configurations: config
        )

        modelContext = ModelContext(modelContainer)

        sut = FavoritesManager(modelContext: modelContext)
    }

    override func tearDown() async throws {
        modelContext = nil
        modelContainer = nil
        sut = nil
        
        try await super.tearDown()
    }
    
    // MARK: - Toggle Favorite Tests
    
    func testToggleFavoriteAddsMovie() throws {
        let movie = createMockMovie(id: 1, title: "Test Movie")

        try sut.toggleFavorite(movie: movie)

        let favorites = try sut.fetchAll()
        XCTAssertTrue(favorites.contains(where: { $0.id == movie.id }), "The movie should be added to favorites")
        XCTAssertEqual(favorites.count, 1, "Should have exactly one favorite")
    }

    func testToggleFavoriteRemovesMovie() throws {
        let movie = createMockMovie(id: 2, title: "Test Movie 2")
        try sut.toggleFavorite(movie: movie)

        try sut.toggleFavorite(movie: movie)

        let favorites = try sut.fetchAll()
        XCTAssertFalse(favorites.contains(where: { $0.id == movie.id }), "The movie should be removed from favorites")
        XCTAssertTrue(favorites.isEmpty, "Favorites should be empty")
    }

    func testToggleFavoriteDoesNotDuplicate() throws {
        let movie = createMockMovie(id: 3, title: "Test Movie 3")

        try sut.toggleFavorite(movie: movie)
        try sut.toggleFavorite(movie: movie)
        try sut.toggleFavorite(movie: movie)

        let favorites = try sut.fetchAll().filter { $0.id == movie.id }
        XCTAssertEqual(favorites.count, 1, "Toggling favorite multiple times should not create duplicates")
    }

    // MARK: - Is Favorited Tests

    func testIsFavoritedReturnsTrue() throws {
        let movie = createMockMovie(id: 4, title: "Favorited Movie")
        try sut.toggleFavorite(movie: movie)

        let result = sut.isFavorited(movieId: 4)

        XCTAssertTrue(result, "isFavorited should return true for a movie in favorites")
    }

    func testIsFavoritedReturnsFalse() {
        let result = sut.isFavorited(movieId: 999)

        XCTAssertFalse(result, "isFavorited should return false for a movie not in favorites")
    }

    // MARK: - Fetch All Tests

    func testFetchAllReturnsEmptyWhenNoFavorites() throws {
        let favorites = try sut.fetchAll()

        XCTAssertTrue(favorites.isEmpty, "fetchAll should return empty array when no favorites")
    }

    func testFetchAllReturnsAllFavorites() throws {
        let movie1 = createMockMovie(id: 10, title: "Movie 1")
        let movie2 = createMockMovie(id: 11, title: "Movie 2")
        let movie3 = createMockMovie(id: 12, title: "Movie 3")

        try sut.toggleFavorite(movie: movie1)
        try sut.toggleFavorite(movie: movie2)
        try sut.toggleFavorite(movie: movie3)

        let favorites = try sut.fetchAll()

        XCTAssertEqual(favorites.count, 3, "fetchAll should return all 3 favorites")
        XCTAssertTrue(favorites.contains(where: { $0.id == 10 }))
        XCTAssertTrue(favorites.contains(where: { $0.id == 11 }))
        XCTAssertTrue(favorites.contains(where: { $0.id == 12 }))
    }

    // MARK: - Remove Favorite Tests
    func testRemoveFavoriteById() throws {
        let movie = createMockMovie(id: 30, title: "Movie to Remove")
        try sut.toggleFavorite(movie: movie)

        try sut.removeFavorite(movieId: 30)

        let favorites = try sut.fetchAll()
        XCTAssertFalse(favorites.contains(where: { $0.id == 30 }), "Movie should be removed from favorites")
    }

    // MARK: - Helper Methods
    private func createMockMovie(id: Int, title: String) -> Movie {
        Movie(
            adult: false,
            backdropPath: "/backdrop.jpg",
            id: id,
            title: title,
            originalLanguage: "en",
            originalTitle: title,
            overview: "Test overview for \(title)",
            posterPath: "/poster.jpg",
            mediaType: "movie",
            genreIds: [28, 12],
            popularity: 75.0,
            releaseDate: "2024-01-01",
            video: false,
            voteAverage: 7.5,
            voteCount: 1000
        )
    }
}
