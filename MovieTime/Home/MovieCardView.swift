//
//  MovieCardView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 27.12.25.
//

import SwiftUI
import TMDBKit

struct MovieCardView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            posterImage
            movieInfo
        }
    }

    private var posterImage: some View {
        imageView
            .aspectRatio(2/3, contentMode: .fit)
            .cornerRadius(12)
            .clipped()
            .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
    }

    private var movieInfo: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(movie.title ?? "Untitled")
                .font(.headline)
                .lineLimit(1)
                .foregroundColor(.white)

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(.accentRed)
                Text(String(format: "%.1f", movie.voteAverage ?? 0.0))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }

            Text(movie.overview ?? "")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
                .lineLimit(2)
        }
    }

    var imageView: some View {
        CachedAsyncImage(
            url: movie.posterURL,
            lowResURL: movie.posterLowResURL
        ) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle()
                .fill(Color.cardBackground)
                .overlay(
                    ProgressView()
                        .tint(.white)
                )
        }
    }
}
