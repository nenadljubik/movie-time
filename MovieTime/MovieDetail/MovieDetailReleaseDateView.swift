//
//  MovieDetailReleaseDateView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import SwiftUI

struct MovieDetailReleaseDateView: View {
    let releaseDate: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "calendar")
                .font(.subheadline)
                .foregroundColor(.accentRed)

            Text(formatReleaseDate(releaseDate))
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.8))
        }
    }

    private func formatReleaseDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMMM d, yyyy"
            return dateFormatter.string(from: date)
        }

        return dateString
    }
}
