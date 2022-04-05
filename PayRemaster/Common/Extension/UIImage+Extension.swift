//
//  UIImage+Extension.swift
//  PayRemaster
//
//  Created by heizel.nut on 2022/04/05.
//

import UIKit
import Combine

extension UIImageView {
    static private var cancellables: [Int: AnyCancellable] = [:]
    
    func setImage(with urlString: String, useCache: CacheType = .none) {
        if useCache == .memory,
           let image = ImageNSCache.shared.load(key: urlString) {
            self.image = image
            return
        }
        
        let publisher: AnyPublisher<Data, Error> = HTTPClient.shared.request(urlString: urlString)
        let cancellable = publisher.sink { completion in
                guard case .failure(_) = completion else { return }
            } receiveValue: { imageData in
                guard let image = UIImage(data: imageData) else { return }
                self.image = image
                ImageNSCache.shared.write(key: urlString, image: image)
            }
        UIImageView.cancellables[self.hashValue] = cancellable
    }
    
    func cancelImage() {
        UIImageView.cancellables.removeValue(forKey: self.hashValue)
    }
}
