//
//  SearchViewModel.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import Foundation
import SwiftUI
import Combine
import TMDBKit

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var searchType: SearchType = .movies
    @Published var searchResults: [SearchResultItem] = []
    @Published var isLoading = false
    @Published var appAlert: AppAlert?

    private let searchService: TMDBSearchService
    private var cancellables = Set<AnyCancellable>()

    init(searchService: TMDBSearchService = TMDBSearchService()) {
        self.searchService = searchService
        setupSearchThrottling()
    }

    // MARK: - Throttled Search Setup

    private func setupSearchThrottling() {
        $searchQuery
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.handleSearch(keyword: query)
            }
            .store(in: &cancellables)
    }

    private func searchMovies(keyword: String) {
        Task {
            isLoading = true
            do {
                let searchResponse = try await searchService.searchMovies(with: keyword)

                guard let movies = searchResponse.results else {
                    isLoading = false
                    return
                }

                withAnimation {
                    searchResults = movies.map { .movie($0) }
                    isLoading = false
                }
            } catch {
                appAlert = .info(title: error.localizedDescription,
                                 message: nil,
                                 dismissTitle: "OK",
                                 dismissAction: {})
                isLoading = false
            }
        }
    }

    private func handleSearch(keyword: String) {
        guard !keyword.isEmpty else {
            searchResults = []
            return
        }

        switch searchType {
        case .movies:
            searchMovies(keyword: keyword)
        case .tvShows:
            searchTVShows(keyword: keyword)
        }
    }

    private func searchTVShows(keyword: String) {
        Task {
            isLoading = true
            do {
                let searchResponse = try await searchService.searchTvShows(with: keyword)

                guard let tvShows = searchResponse.results else {
                    isLoading = false
                    return
                }

                withAnimation {
                    searchResults = tvShows.map { .tvShow($0) }
                    isLoading = false
                }
            } catch {
                appAlert = .info(title: error.localizedDescription,
                                 message: nil,
                                 dismissTitle: "OK",
                                 dismissAction: {})
                isLoading = false
            }
        }
    }
}
