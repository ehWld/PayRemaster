//
//  ImageCache.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/05.
//

import UIKit

protocol ImageCache {
    func load(key: String) -> UIImage?
    func write(key: String, image: UIImage)
}

class ImageNSCache: ImageCache {
    static let shared = ImageNSCache()

    private let memoryCache: NSCache<NSString, UIImage>

    private init() {
        memoryCache = NSCache<NSString, UIImage>()
    }

    func load(key: String) -> UIImage? {
        if let cachedImage = memoryCache.object(forKey: key as NSString) {
            return cachedImage
        } else {
            return nil
        }
    }

    func write(key: String, image: UIImage) {
        memoryCache.setObject(image, forKey: key as NSString)
    }
}
