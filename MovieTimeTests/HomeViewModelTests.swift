//
//  HomeViewModelTests.swift
//  MovieTimeTests
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import XCTest
import SwiftData
import TMDBKit
@testable import MovieTime

@MainActor
final class HomeViewModelTests: XCTestCase {
    var sut: HomeViewModel!
    var modelContainer: ModelContainer!
    var modelContext: ModelContext!
    var mockService: MockMovieService!

    override func setUp() async throws {
        try await super.setUp()

        // Create in-memory container for testing
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        modelContainer = try ModelContainer(
            for: CachedMovie.self,
            configurations: config
        )

        modelContext = ModelContext(modelContainer)

        // Initialize mock service
        mockService = MockMovieService()

        // Initialize view model with mock service
        sut = HomeViewModel(movieService: mockService)
        sut.configure(with: modelContext)
    }

    override func tearDown() async throws {
        sut = nil
        mockService = nil
        modelContext = nil
        modelContainer = nil
        try await super.tearDown()
    }

    // MARK: - Initial State Tests

    func testInitialState() {
        XCTAssertTrue(sut.movies.isEmpty, "Movies should be empty initially")
        XCTAssertFalse(sut.isLoading, "Should not be loading initially")
        XCTAssertTrue(sut.hasMorePages, "Should have more pages initially")
    }

    // MARK: - Cache Tests

    func testLoadFromCacheWhenCacheIsEmpty() async {
        mockService.movieResponses = [MockMovieService.createMockResponse(page: 1, movieCount: 0, totalPages: 1)]

        await sut.loadTrendingMovies()

        XCTAssertFalse(sut.isLoading, "Loading should complete")
        XCTAssertTrue(sut.movies.isEmpty, "Should have no movies")
        XCTAssertEqual(mockService.fetchTrendingMoviesCallCount, 1, "Should call API once")
    }

    func testSaveToCache() async throws {
        let movie1 = createMockMovie(id: 1, title: "Movie 1", popularity: 100.0)
        let movie2 = createMockMovie(id: 2, title: "Movie 2", popularity: 90.0)

        
        let cacheManager = SwiftDataManager<CachedMovie>(modelContext: modelContext)
        let cachedMovies = [CachedMovie(from: movie1), CachedMovie(from: movie2)]
        try cacheManager.save(cachedMovies)

        let fetchedMovies = try cacheManager.fetchAll(
            sortBy: [SortDescriptor(\.popularity, order: .reverse)]
        )

        XCTAssertEqual(fetchedMovies.count, 2)
        XCTAssertEqual(fetchedMovies[0].id, 1)
        XCTAssertEqual(fetchedMovies[1].id, 2)
    }

    // MARK: - Refresh Tests

    func testRefreshResetsState() async {
        sut.movies = [createMockMovie(id: 1, title: "Old Movie", popularity: 50.0)]
        mockService.movieResponses = [MockMovieService.createMockResponse(page: 1, movieCount: 5, totalPages: 3)]

        await sut.refresh()

        XCTAssertFalse(sut.isLoading, "Loading should complete")
        XCTAssertTrue(sut.hasMorePages, "Should have more pages after refresh")
        XCTAssertEqual(sut.movies.count, 5, "Should have loaded new movies")
    }

    // MARK: - Load More Tests

    func testLoadMoreIfNeededWithEmptyMoviesList() async {
        let movie = createMockMovie(id: 1, title: "Test", popularity: 50.0)

        await sut.loadMoreIfNeeded(currentItem: movie)

        XCTAssertTrue(sut.movies.isEmpty)
    }

    // MARK: - Loading State Tests

    func testLoadingStateTogglesDuringLoad() async {
        mockService.movieResponses = [MockMovieService.createMockResponse(page: 1, movieCount: 10, totalPages: 3)]

        XCTAssertFalse(sut.isLoading, "Should not be loading initially")

        await sut.loadTrendingMovies()

        XCTAssertFalse(sut.isLoading, "Should not be loading after completion")
        XCTAssertEqual(sut.movies.count, 10, "Should have loaded movies")
    }

    // MARK: - Edge Cases

    func testLoadWhenNoMorePages() async {
        sut.hasMorePages = false
        let initialMovieCount = sut.movies.count

        await sut.loadTrendingMovies()

        XCTAssertEqual(sut.movies.count, initialMovieCount)
        XCTAssertFalse(sut.isLoading)
    }

    // MARK: - Cache Integration Tests

    func testCacheClearOnRefresh() async throws {
        let movie = createMockMovie(id: 200, title: "Old Cached Movie", popularity: 50.0)
        let cacheManager = SwiftDataManager<CachedMovie>(modelContext: modelContext)
        try cacheManager.save([CachedMovie(from: movie)])

        let cachedMovies = try cacheManager.fetchAll(sortBy: [])
        XCTAssertEqual(cachedMovies.count, 1)

        mockService.movieResponses = [MockMovieService.createMockResponse(page: 1, movieCount: 3, totalPages: 2)]

        await sut.refresh()

        XCTAssertFalse(sut.isLoading, "Loading should complete")
        XCTAssertEqual(sut.movies.count, 3, "Should have 3 new movies")

        let newCachedMovies = try cacheManager.fetchAll(sortBy: [])
        XCTAssertEqual(newCachedMovies.count, 3, "Cache should have 3 new movies")
    }

    // MARK: - API Integration Tests

    func testLoadTrendingMoviesSuccess() async {
        mockService.movieResponses = [MockMovieService.createMockResponse(page: 1, movieCount: 20, totalPages: 5)]

        await sut.loadTrendingMovies()

        XCTAssertEqual(sut.movies.count, 20, "Should have 20 movies")
        XCTAssertFalse(sut.isLoading, "Should not be loading")
        XCTAssertTrue(sut.hasMorePages, "Should have more pages")
        XCTAssertEqual(mockService.fetchTrendingMoviesCallCount, 1, "Should call API once")
        XCTAssertEqual(mockService.lastRequestedPage, 1, "Should request page 1")
    }

    func testLoadTrendingMoviesFailure() async {
        mockService.shouldFail = true

        await sut.loadTrendingMovies()

        XCTAssertTrue(sut.movies.isEmpty, "Should have no movies on error")
        XCTAssertFalse(sut.isLoading, "Should not be loading")
        XCTAssertEqual(mockService.fetchTrendingMoviesCallCount, 1, "Should attempt API call")
    }

    func testPaginationLoadsMultiplePages() async {
        mockService.movieResponses = [
            MockMovieService.createMockResponse(page: 1, movieCount: 10, totalPages: 3),
            MockMovieService.createMockResponse(page: 2, movieCount: 10, totalPages: 3),
            MockMovieService.createMockResponse(page: 3, movieCount: 10, totalPages: 3)
        ]

        await sut.loadTrendingMovies()
        XCTAssertEqual(sut.movies.count, 10, "Should have 10 movies from page 1")

        await sut.loadTrendingMovies()
        XCTAssertEqual(sut.movies.count, 20, "Should have 20 movies after page 2")

        await sut.loadTrendingMovies()
        XCTAssertEqual(sut.movies.count, 30, "Should have 30 movies after page 3")

        XCTAssertFalse(sut.hasMorePages, "Should not have more pages after reaching end")
        XCTAssertEqual(mockService.fetchTrendingMoviesCallCount, 3, "Should call API 3 times")
    }

    func testCacheIsUsedOnFirstLoad() async {
        let cachedMovie1 = createMockMovie(id: 500, title: "Cached 1", popularity: 95.0)
        let cachedMovie2 = createMockMovie(id: 501, title: "Cached 2", popularity: 90.0)
        let cacheManager = SwiftDataManager<CachedMovie>(modelContext: modelContext)
        try? cacheManager.save([CachedMovie(from: cachedMovie1), CachedMovie(from: cachedMovie2)])

        mockService.movieResponses = [MockMovieService.createMockResponse(page: 1, movieCount: 5, totalPages: 2)]

        await sut.loadTrendingMovies()
        
        XCTAssertEqual(sut.movies.count, 5, "Should have fresh API data")
        XCTAssertFalse(sut.isLoading, "Should complete loading")

        let updatedCache = try? cacheManager.fetchAll(sortBy: [])
        XCTAssertEqual(updatedCache?.count, 5, "Cache should have new data")
    }

    // MARK: - Helper Methods

    private func createMockMovie(id: Int, title: String, popularity: Double) -> Movie {
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
            popularity: popularity,
            releaseDate: "2024-01-01",
            video: false,
            voteAverage: 7.5,
            voteCount: 1000
        )
    }
}
