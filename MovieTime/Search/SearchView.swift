//
//  SearchView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import SwiftUI
import TMDBKit

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(\.verticalSizeClass) private var verticalSizeClass
    @Namespace private var animation

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    private var isPortrait: Bool {
        verticalSizeClass == .regular
    }

    private var columns: [GridItem] {
        if isCompact && isPortrait {
            return Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
        } else if isCompact && !isPortrait {
            return Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
        } else {
            return Array(repeating: GridItem(.flexible(), spacing: 20), count: 4)
        }
    }

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 24) {
                SearchBarView(
                    searchQuery: $viewModel.searchQuery,
                    searchType: viewModel.searchType
                )

                SearchTypeSelectorView(
                    selectedType: $viewModel.searchType,
                    namespace: animation
                )

                SearchResultsSectionView(
                    searchQuery: viewModel.searchQuery,
                    searchType: viewModel.searchType,
                    isLoading: viewModel.isLoading,
                    searchResults: viewModel.searchResults,
                    columns: columns
                )
            }
            .padding()
        }
        .appAlert(error: $viewModel.appAlert)
        .navigationDestination(for: SearchResultItem.self) { item in
            switch item {
            case .movie(let movie):
                MovieDetailView(movie: movie)
            case .tvShow:
                Text("TV Show details coming soon")
            }
        }
    }
}

#Preview {
    NavigationStack {
        SearchView()
    }
}
