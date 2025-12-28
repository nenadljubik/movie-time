//
//  Movie+Hashable.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import Foundation
import TMDBKit

extension Movie: Hashable {
    public static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
