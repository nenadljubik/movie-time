//
//  MovieDetailStatsView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import SwiftUI
import TMDBKit

struct MovieDetailStatsView: View {
    let movie: Movie

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            MovieDetailSectionTitle(title: "Statistics")

            LazyVGrid(columns: columns, spacing: 16) {
                popularityCard
                ratingCard
                voteCountCard
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var popularityCard: some View {
        if let popularity = movie.popularity {
            MovieDetailStatCard(
                title: "Popularity",
                value: String(format: "%.0f", popularity),
                icon: "flame.fill",
                color: .orange
            )
        }
    }

    @ViewBuilder
    private var ratingCard: some View {
        if let voteAverage = movie.voteAverage {
            MovieDetailStatCard(
                title: "Rating",
                value: String(format: "%.1f/10", voteAverage),
                icon: "star.fill",
                color: .yellow
            )
        }
    }

    @ViewBuilder
    private var voteCountCard: some View {
        if let voteCount = movie.voteCount {
            MovieDetailStatCard(
                title: "Votes",
                value: formatVoteCount(voteCount),
                icon: "person.3.fill",
                color: .blue
            )
        }
    }

    private func formatVoteCount(_ count: Int) -> String {
        if count >= 1000 {
            let thousands = Double(count) / 1000.0
            return String(format: "%.1fK", thousands)
        }
        return "\(count)"
    }

    private func formatCurrency(_ amount: Int) -> String {
        if amount >= 1_000_000 {
            let millions = Double(amount) / 1_000_000.0
            return String(format: "$%.1fM", millions)
        } else if amount >= 1000 {
            let thousands = Double(amount) / 1000.0
            return String(format: "$%.1fK", thousands)
        }
        return "$\(amount)"
    }
}
