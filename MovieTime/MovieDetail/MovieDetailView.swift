//
//  MovieDetailView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import SwiftUI
import TMDBKit

struct MovieDetailView: View {
    let movie: Movie
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private var isCompact: Bool {
        horizontalSizeClass == .compact
    }

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            MovieDetailContentView(
                movie: movie,
                isCompact: isCompact
            )
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}
