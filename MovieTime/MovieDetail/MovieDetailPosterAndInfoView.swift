//
//  MovieDetailPosterAndInfoView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import SwiftUI
import TMDBKit

struct MovieDetailPosterAndInfoView: View {
    let movie: Movie
    let isCompact: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            posterImage

            VStack(alignment: .leading, spacing: 12) {
                titleText
                releaseDateSection
                ratingSection
            }

            Spacer(minLength: 0)
        }
        .padding(.horizontal)
        .offset(y: -40)
    }

    private var posterImage: some View {
        Group {
            if let posterPath = movie.posterPath {
                CachedAsyncImage(
                    url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
                ) { image in
                    image
                        .resizable()
                        .aspectRatio(2/3, contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(2/3, contentMode: .fill)
                }
                .frame(width: isCompact ? 120 : 180)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.5), radius: 12, x: 0, y: 6)
            }
        }
    }

    private var titleText: some View {
        Text(movie.title ?? "Untitled")
            .font(isCompact ? .title2 : .largeTitle)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .fixedSize(horizontal: false, vertical: true)
    }

    @ViewBuilder
    private var releaseDateSection: some View {
        if let releaseDate = movie.releaseDate {
            MovieDetailReleaseDateView(releaseDate: releaseDate)
        }
    }

    private var ratingSection: some View {
        MovieDetailRatingBadgeView(
            voteAverage: movie.voteAverage,
            voteCount: movie.voteCount
        )
    }
}
