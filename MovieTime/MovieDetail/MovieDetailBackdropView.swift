//
//  MovieDetailBackdropView.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 28.12.25.
//

import SwiftUI

struct MovieDetailBackdropView: View {
    let backdropPath: String?

    var body: some View {
        Group {
            if let backdropPath = backdropPath {
                CachedAsyncImage(
                    url: URL(string: "https://image.tmdb.org/t/p/w1280\(backdropPath)")
                ) { image in
                    image
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fill)
                } placeholder: {
                    placeholderView
                }
                .frame(maxWidth: .infinity)
                .clipped()
                .overlay(gradientOverlay)
            }
        }
    }

    private var placeholderView: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .aspectRatio(16/9, contentMode: .fill)
            .overlay(
                ProgressView()
                    .tint(.white)
            )
    }

    private var gradientOverlay: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(hex: "#141418").opacity(0),
                Color(hex: "#141418").opacity(0.3),
                Color(hex: "#141418").opacity(0.7)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
