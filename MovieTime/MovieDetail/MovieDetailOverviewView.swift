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

                overviewText(overview)
            }
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private func overviewText(_ text: String) -> some View {
        if #available(iOS 16.0, *) {
            Text(text)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
                .scrollDismissesKeyboard(.immediately)
        } else {
            Text(text)
                .font(.body)
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(4)
        }
    }
}
