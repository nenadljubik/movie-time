//
//  Movie+Extensions.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 27.12.25.
//

import Foundation
import TMDBKit

extension Movie {
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }

    var backdropURL: URL? {
        guard let backdropPath = backdropPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w1280\(backdropPath)")
    }
}
