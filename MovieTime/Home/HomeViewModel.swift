//
//  HomeViewModel.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 27.12.25.
//

import Foundation
import SwiftData
import TMDBKit
import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var hasMorePages = true
    @Published var appAlert: AppAlert?

    private var currentPage = 1
    private let movieService: TMDBMoviesServiceProtocol
    private var cacheManager: SwiftDataManager<CachedMovie>?

    init(movieService: TMDBMoviesServiceProtocol = TMDBMoviesService()) {
        self.movieService = movieService
    }

    func configure(with modelContext: ModelContext) {
        self.cacheManager = SwiftDataManager<CachedMovie>(modelContext: modelContext)
    }

    func loadTrendingMovies() async {
        guard !isLoading && hasMorePages else { return }

        isLoading = true

        // Step 1: First thing first, we're loading from cach. If there is anything cached, we show it to the user
        if currentPage == 1, let cachedMovies = loadFromCache() {
            movies = cachedMovies
        }

        // Step 2: Proceeding with fetching new data
        do {
            let response = try await movieService.fetchTrendingMovies(page: currentPage)

            guard let results = response.results else {
                isLoading = false
                return
            }

            // Step 3: We're checking if we're on the first page which means first time entering the screen
            if currentPage == 1 {
                // If it's first page, we're storing the new data in cache and replacing the cached data
                // that was previously presented
                saveToCache(results)
                movies = results
            } else {
                movies.append(contentsOf: results)  // Otherwise we just append the fresh data to the previous one
            }

            if let totalPages = response.totalPages {
                hasMorePages = currentPage < totalPages
            }

            currentPage += 1
            isLoading = false
        } catch {
            isLoading = false
            appAlert = .info(title: error.localizedDescription, message: nil, dismissTitle: "OK", dismissAction: {})
        }
    }

    private func loadFromCache() -> [Movie]? {
        guard let cacheManager = cacheManager else { return nil }

        guard let cachedMovies = try? cacheManager.fetchAll(
            sortBy: [SortDescriptor(\.popularity, order: .reverse)]
        ) else {
            return nil
        }

        let movies = cachedMovies.map { $0.toMovie() }
        return movies.isEmpty ? nil : movies
    }

    private func saveToCache(_ movies: [Movie]) {
        guard let cacheManager = cacheManager else { return }

        // We're clearing the previously cached movies
        try? cacheManager.deleteAll()

        // After that, we're storing the new data
        let cachedMovies = movies.map { CachedMovie(from: $0) }
        try? cacheManager.save(cachedMovies)
    }

    func loadMoreIfNeeded(currentItem movie: Movie) async {
        guard !movies.isEmpty else { return }

        let thresholdIndex = movies.index(movies.endIndex, offsetBy: -5)
        if let currentIndex = movies.firstIndex(where: { $0.id == movie.id }),
           currentIndex >= thresholdIndex {
            await loadTrendingMovies()
        }
    }

    func refresh() async {
        currentPage = 1
        movies = []
        hasMorePages = true
        await loadTrendingMovies()
    }
}
