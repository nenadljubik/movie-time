//
//  SearchBarView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchQuery: String
    let searchType: SearchType

    let gradientBorder = LinearGradient(
        colors: [
            Color.accentRed.opacity(0.5),
            Color.accentRed,
            Color.accentRed.opacity(0.8),
            Color.accentRed.opacity(0.5)
        ],
        startPoint: .leading,
        endPoint: .trailing
    )

    var body: some View {
        ZStack {
            // Gradient border capsule
            Capsule()
                .strokeBorder(gradientBorder,
                              lineWidth: 1.5)
                .frame(height: 50)

            // Search field
            HStack(spacing: 12) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.accentRed)
                    .font(.system(size: 20))

                UIKitSearchTextField(
                    text: $searchQuery,
                    placeholder: "Search \(searchType.rawValue.lowercased())..."
                )
                .frame(height: 50)
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 50)
    }
}
