//
//  MovieDetailRatingBadgeView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import SwiftUI

struct MovieDetailRatingBadgeView: View {
    let voteAverage: Double?
    let voteCount: Int?

    var body: some View {
        HStack(spacing: 8) {
            ratingBadge
            voteCountText
        }
    }

    @ViewBuilder
    private var ratingBadge: some View {
        if let rating = voteAverage {
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.yellow)

                Text(String(format: "%.1f", rating))
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.1))
            )
        }
    }

    @ViewBuilder
    private var voteCountText: some View {
        if let voteCount = voteCount {
            Text("(\(formatVoteCount(voteCount)) votes)")
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
    }

    private func formatVoteCount(_ count: Int) -> String {
        if count >= 1000 {
            let thousands = Double(count) / 1000.0
            return String(format: "%.1fK", thousands)
        }
        return "\(count)"
    }
}
