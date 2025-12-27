//
//  ImageLoader.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 27.12.25.
//

import SwiftUI
import Combine

@MainActor
final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false

    private var cancellable: AnyCancellable?
    private let cache = ImageCache.shared

    func load(url: URL?, lowResURL: URL? = nil) {
        guard let url = url else { return }

        let cacheKey = url.absoluteString

        // Check cache first
        if let cachedImage = cache.get(forKey: cacheKey) {
            self.image = cachedImage
            return
        }

        isLoading = true

        // Load low-res first if available
        if let lowResURL = lowResURL {
            loadImage(from: lowResURL, isLowRes: true)
        }

        // Then load high-res
        loadImage(from: url, isLowRes: false)
    }

    private func loadImage(from url: URL, isLowRes: Bool) {
        let cacheKey = url.absoluteString

        // Check cache
        if let cachedImage = cache.get(forKey: cacheKey) {
            if !isLowRes {
                self.image = cachedImage
                self.isLoading = false
            } else if self.image == nil {
                self.image = cachedImage
            }
            return
        }

        // Download image
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] downloadedImage in
                guard let self = self, let downloadedImage = downloadedImage else { return }

                // Cache the image
                self.cache.set(downloadedImage, forKey: cacheKey)

                // Update UI with high-res or low-res
                if !isLowRes {
                    self.image = downloadedImage
                    self.isLoading = false
                } else if self.image == nil {
                    self.image = downloadedImage
                }
            }
    }

    func cancel() {
        cancellable?.cancel()
    }
}
