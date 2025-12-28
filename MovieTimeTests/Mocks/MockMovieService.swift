//
//  MockMovieService.swift
//  MovieTimeTests
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import Foundation
import TMDBKit
@testable import MovieTime

final class MockMovieService: TMDBMoviesServiceProtocol {
    var shouldFail = false
    var movieResponses: [MovieResponse] = []
    var fetchTrendingMoviesCallCount = 0
    var lastRequestedPage: Int?

    private var currentResponseIndex = 0

    func fetchTrendingMovies(page: Int) async throws -> MovieResponse {
        fetchTrendingMoviesCallCount += 1
        lastRequestedPage = page

        if shouldFail {
            throw NSError(domain: "MockError", code: -1)
        }

        guard currentResponseIndex < movieResponses.count else {
            return MovieResponse(page: page, results: [], totalPages: 1, totalResults: 0)
        }

        let response = movieResponses[currentResponseIndex]
        currentResponseIndex += 1
        return response
    }

    static func createMockResponse(page: Int, movieCount: Int, totalPages: Int) -> MovieResponse {
        guard movieCount > 0 else {
            return MovieResponse(page: page, results: [], totalPages: totalPages, totalResults: 0)
        }

        let movies = (1...movieCount).map { index in
            Movie(
                adult: false,
                backdropPath: "/backdrop\(index).jpg",
                id: (page - 1) * movieCount + index,
                title: "Mock Movie \((page - 1) * movieCount + index)",
                originalLanguage: "en",
                originalTitle: "Mock Movie \((page - 1) * movieCount + index)",
                overview: "Mock overview for movie \((page - 1) * movieCount + index)",
                posterPath: "/poster\(index).jpg",
                mediaType: "movie",
                genreIds: [28, 12],
                popularity: Double(100 - index),
                releaseDate: "2024-01-0\(index)",
                video: false,
                voteAverage: 7.5,
                voteCount: 1000
            )
        }

        return MovieResponse(
            page: page,
            results: movies,
            totalPages: totalPages,
            totalResults: totalPages * movieCount
        )
    }
}
