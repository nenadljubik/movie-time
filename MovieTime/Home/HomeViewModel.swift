//
//  HomeViewModel.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 27.12.25.
//

import Foundation
import TMDBKit
import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var hasMorePages = true

    private var currentPage = 1
    private let movieService: TMDBMoviesService

    init(movieService: TMDBMoviesService = TMDBMoviesService()) {
        self.movieService = movieService
    }

    func loadTrendingMovies() async {
        guard !isLoading && hasMorePages else { return }

        isLoading = true

        do {
            let response = try await movieService.fetchTrendingMovies(page: currentPage)

            guard let results = response.results else {
                isLoading = false
                return
            }

            movies.append(contentsOf: results)

            if let totalPages = response.totalPages {
                hasMorePages = currentPage < totalPages
            }

            currentPage += 1
            isLoading = false
        } catch {
            isLoading = false
        }
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
