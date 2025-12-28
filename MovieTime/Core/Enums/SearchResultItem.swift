//
//  SearchResultItem.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import Foundation
import TMDBKit

enum SearchResultItem: Identifiable {
    case movie(Movie)
    case tvShow(TVShow)

    var id: Int {
        switch self {
        case .movie(let movie):
            return movie.id ?? 0
        case .tvShow(let tvShow):
            return tvShow.id ?? 0
        }
    }

    var title: String {
        switch self {
        case .movie(let movie):
            return movie.title ?? "Unknown Title"
        case .tvShow(let tvShow):
            return tvShow.name ?? "Unknown Title"
        }
    }

    var posterPath: String? {
        switch self {
        case .movie(let movie):
            return movie.posterPath
        case .tvShow(let tvShow):
            return tvShow.posterPath
        }
    }

    var overview: String? {
        switch self {
        case .movie(let movie):
            return movie.overview
        case .tvShow(let tvShow):
            return tvShow.overview
        }
    }

    var rating: Double? {
        switch self {
        case .movie(let movie):
            return movie.voteAverage
        case .tvShow(let tvShow):
            return tvShow.voteAverage
        }
    }

    var releaseInfo: String? {
        switch self {
        case .movie(let movie):
            return movie.releaseDate
        case .tvShow(let tvShow):
            return tvShow.firstAirDate
        }
    }

    var mediaType: String {
        switch self {
        case .movie:
            return "Movie"
        case .tvShow:
            return "TV Show"
        }
    }

    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }

    var posterLowResURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(posterPath)")
    }
}
