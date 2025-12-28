//
//  MovieDetailContentView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import SwiftUI
import TMDBKit

struct MovieDetailContentView: View {
    let movie: Movie
    let isCompact: Bool

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                MovieDetailBackdropView(backdropPath: movie.backdropPath)

                VStack(alignment: .leading, spacing: 24) {
                    MovieDetailPosterAndInfoView(
                        movie: movie,
                        isCompact: isCompact
                    )
                    MovieDetailOverviewView(overview: movie.overview)
                    MovieDetailStatsView(movie: movie)
                    MovieDetailAdditionalInfoView(movie: movie)
                }
                .padding(.top, 24)
            }
            .padding(.bottom, 32)
        }
        .ignoresSafeArea(edges: .top)
    }
}
