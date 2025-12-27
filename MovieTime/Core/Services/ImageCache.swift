//
//  ImageCache.swift
//  MovieTime
//
//  Created by Ненад Љубиќ on 27.12.25.
//

import UIKit

final class ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let cacheDirectory: URL

    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100 // 100 MB

        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        cacheDirectory = paths[0].appendingPathComponent("ImageCache")

        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    func get(forKey key: String) -> UIImage? {
        // Check memory cache first
        if let image = cache.object(forKey: key as NSString) {
            return image
        }

        // Check disk cache
        let fileURL = cacheDirectory.appendingPathComponent(key.sanitized)
        if let data = try? Data(contentsOf: fileURL),
           let image = UIImage(data: data) {
            // Store in memory cache for next time
            cache.setObject(image, forKey: key as NSString)
            return image
        }

        return nil
    }

    func set(_ image: UIImage, forKey key: String) {
        // Store in memory cache
        cache.setObject(image, forKey: key as NSString)

        // Store in disk cache
        let fileURL = cacheDirectory.appendingPathComponent(key.sanitized)
        if let data = image.jpegData(compressionQuality: 0.8) {
            try? data.write(to: fileURL)
        }
    }

    func clear() {
        cache.removeAllObjects()
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
}

private extension String {
    var sanitized: String {
        self.replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: ":", with: "_")
    }
}
