//
//  SearchState.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import TMDBKit

enum SearchState {
    case empty(searchType: SearchType)
    case searching
    case noResults
    case results([Movie])

    var stateViewConfig: SearchStateViewConfig? {
        switch self {
        case .empty(let searchType):
            return SearchStateViewConfig(
                icon: "magnifyingglass",
                title: "Search for \(searchType.rawValue.lowercased())"
            )
        case .searching:
            return SearchStateViewConfig(
                icon: nil,
                title: "Searching...",
                showProgress: true
            )
        case .noResults:
            return SearchStateViewConfig(
                icon: "film.stack",
                title: "No results found",
                subtitle: "Try searching with different keywords"
            )
        case .results:
            return nil
        }
    }
}
