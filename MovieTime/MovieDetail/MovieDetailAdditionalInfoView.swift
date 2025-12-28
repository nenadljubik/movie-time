//
//  MovieDetailAdditionalInfoView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import SwiftUI
import TMDBKit

struct MovieDetailAdditionalInfoView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            originalLanguageSection
        }
    }

    @ViewBuilder
    private var originalLanguageSection: some View {
        if let originalLanguage = movie.originalLanguage {
            VStack(alignment: .leading, spacing: 12) {
                MovieDetailSectionTitle(title: "Original Language")

                Text(originalLanguage.uppercased())
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal)
            }
        }
    }
}
