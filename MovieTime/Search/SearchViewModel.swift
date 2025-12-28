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
    @Published var searchResults: [Movie] = [.dummy(), .dummy(), .dummy(), .dummy()]
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        setupSearchThrottling()
    }

    // MARK: - Throttled Search Setup

    private func setupSearchThrottling() {
        $searchQuery
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                // TODO: Implement actual API search based on searchType
            }
            .store(in: &cancellables)


        $searchType
            .dropFirst() // Skip initial value
            .sink { [weak self] _ in
                // TODO: Implement actual API search based on searchType
            }
            .store(in: &cancellables)
    }
}
