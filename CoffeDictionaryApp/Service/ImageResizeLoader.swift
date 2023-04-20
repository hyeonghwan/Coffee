//
//  KingFisherImageResize.swift
//  CoffeDictionaryApp
//
//  Created by 박형환 on 2023/04/20.
//

import UIKit
import Kingfisher

extension UIImage{
    func resize(to size: CGSize) -> UIImage?{
        let newSize = size
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}

enum ImageResizeLoader{
    
    static func resizeImage(_ url: String, completion: @escaping (ResizedImage?) -> () ) {
        if let url = URL(string: url) {
            let cacheKey = url.absoluteString
            
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let imageResult):
                    let resizedImage = imageResult.image.resize(to: CGSize(width: 200, height: 200))
                    
                    let cache = ImageCache.default
                    
                    if let resizedImage{
                        cache.store(resizedImage, forKey: cacheKey)
                    }
                    completion(resizedImage)
                    
                case .failure(let error):
                    print("Error loading image: \(error)")
                }
            }
        }
    }
}
