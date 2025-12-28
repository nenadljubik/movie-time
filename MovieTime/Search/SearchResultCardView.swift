//
//  SearchResultCardView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import SwiftUI
import TMDBKit

struct SearchResultCardView: View {
    let item: SearchResultItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            posterImage

            VStack(alignment: .leading, spacing: 4) {
                titleText
                ratingView
                mediaTypeBadge
            }
            .padding(.horizontal, 4)
        }
    }

    // MARK: - Subviews

    private var posterImage: some View {
        Group {
            if let posterURL = item.posterURL {
                CachedAsyncImage(url: posterURL,
                                 lowResURL: item.posterLowResURL) { image in
                    image
                        .resizable()
                        .aspectRatio(2/3, contentMode: .fill)
                } placeholder: {
                    placeholderView
                }
            } else {
                placeholderView
            }
        }
        .frame(height: 240)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var placeholderView: some View {
        ZStack {
            Color.gray.opacity(0.3)
            Image(systemName: item.mediaType == "Movie" ? "film" : "tv")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.5))
        }
    }

    private var titleText: some View {
        Text(item.title)
            .font(.subheadline.weight(.semibold))
            .foregroundColor(.white)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
    }

    private var ratingView: some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.system(size: 12))
                .foregroundColor(.yellow)

            if let rating = item.rating {
                Text(String(format: "%.1f", rating))
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            } else {
                Text("N/A")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
        }
    }

    private var mediaTypeBadge: some View {
        Text(item.mediaType)
            .font(.caption2.weight(.medium))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(item.mediaType == "Movie" ? Color.accentRed.opacity(0.8) : Color.blue.opacity(0.8))
            )
    }
}

#Preview {
    SearchResultCardView(item: .movie(.dummy(id: 2)))
        .frame(width: 160)
        .background(Color.appBackground)
}
