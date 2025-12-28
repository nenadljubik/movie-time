//
//  CachedMovie.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 27.12.25.
//

import Foundation
import SwiftData
import TMDBKit

@Model
final class CachedMovie {
    @Attribute(.unique) var id: Int
    var adult: Bool?
    var backdropPath: String?
    var title: String?
    var originalLanguage: String?
    var originalTitle: String?
    var overview: String?
    var posterPath: String?
    var mediaType: String?
    var genreIds: [Int]?
    var popularity: Double?
    var releaseDate: String?
    var video: Bool?
    var voteAverage: Double?
    var voteCount: Int?
    var cachedAt: Date

    init(from movie: Movie) {
        self.id = movie.id ?? 0
        self.adult = movie.adult
        self.backdropPath = movie.backdropPath
        self.title = movie.title
        self.originalLanguage = movie.originalLanguage
        self.originalTitle = movie.originalTitle
        self.overview = movie.overview
        self.posterPath = movie.posterPath
        self.mediaType = movie.mediaType
        self.genreIds = movie.genreIds
        self.popularity = movie.popularity
        self.releaseDate = movie.releaseDate
        self.video = movie.video
        self.voteAverage = movie.voteAverage
        self.voteCount = movie.voteCount
        self.cachedAt = Date()
    }

    // Convert to TMDBKit Movie for UI
    func toMovie() -> Movie {
        Movie(
            adult: self.adult,
            backdropPath: self.backdropPath,
            id: self.id,
            title: self.title,
            originalLanguage: self.originalLanguage,
            originalTitle: self.originalTitle,
            overview: self.overview,
            posterPath: self.posterPath,
            mediaType: self.mediaType,
            genreIds: self.genreIds,
            popularity: self.popularity,
            releaseDate: self.releaseDate,
            video: self.video,
            voteAverage: self.voteAverage,
            voteCount: self.voteCount
        )
    }
}
