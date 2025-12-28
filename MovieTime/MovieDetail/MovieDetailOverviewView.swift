//
//  MovieDetailOverviewView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import SwiftUI

struct MovieDetailOverviewView: View {
    let overview: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let overview = overview, !overview.isEmpty {
                MovieDetailSectionTitle(title: "Overview")

                Text(overview)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.9))
            }
        }
        .padding(.horizontal)
    }
}
