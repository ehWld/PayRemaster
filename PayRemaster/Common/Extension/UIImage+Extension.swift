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
    
    func setImage(with urlString: String, useCache: CacheType = .none, _ completion: ((UIImage) -> Void)? = nil) {
        if useCache == .memory,
           let image = ImageNSCache.shared.load(key: urlString) {
            self.image = image
            return
        }
        
        let publisher: AnyPublisher<Data, Error> = HTTPClient.shared.request(urlString: urlString)
        let cancellable = publisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                guard case .failure(let error) = completion else { return }
                print(error)
            } receiveValue: { imageData in
                guard let image = UIImage(data: imageData) else { return }
                self.image = image
                ImageNSCache.shared.write(key: urlString, image: image)
                guard let completion = completion else { return }
                completion(image)
            }
        UIImageView.cancellables[self.hashValue] = cancellable
    }
    
    func cancelImage() {
        UIImageView.cancellables.removeValue(forKey: self.hashValue)
    }
}

extension UIImage {
    func crop(with mask: UIImage) -> UIImage? {
        guard let cgImage = self.cgImage, let cgMask = mask.cgImage else {
            return nil
        }
        UIGraphicsBeginImageContext(self.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context.clip(to: rect, mask: cgMask)
        context.draw(cgImage, in: rect)
        return UIImage(cgImage: context.makeImage()!)
    }
}
