//
//  SearchResultsSectionView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import TMDBKit
import SwiftUI

struct SearchResultsSectionView: View {
    let searchQuery: String
    let searchType: SearchType
    let isLoading: Bool
    let searchResults: [SearchResultItem]
    let columns: [GridItem]

    private var currentState: SearchState {
        if searchQuery.isEmpty {
            return .empty(searchType: searchType)
        } else if isLoading {
            return .searching
        } else if searchResults.isEmpty {
            return .noResults
        } else {
            return .results(searchResults)
        }
    }

    var body: some View {
        ScrollView {
            switch currentState {
            case .results(let items):
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items) { item in
                        NavigationLink(value: item) {
                            SearchResultCardView(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
            default:
                if let config = currentState.stateViewConfig {
                    SearchStateView(config: config)
                }
            }
        }
    }
}

struct SearchStateView: View {
    let config: SearchStateViewConfig

    var body: some View {
        VStack(spacing: 16) {
            if config.showProgress {
                ProgressView()
                    .tint(.accentRed)
                    .scaleEffect(1.5)
                    .padding(.top, 100)
            } else if let icon = config.icon {
                Image(systemName: icon)
                    .font(.system(size: 60))
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.top, 100)
            }

            Text(config.title)
                .font(.title3)
                .foregroundColor(.white.opacity(0.6))

            if let subtitle = config.subtitle {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.4))
            }
        }
        .frame(maxWidth: .infinity)
    }
}
