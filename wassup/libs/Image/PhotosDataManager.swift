//
//  PhotosDataManager.swift
//  GlacierScenics
//
//  Created by Todd Kramer on 1/30/16.
//  Copyright © 2016 Todd Kramer. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class PhotosDataManager {
    
    static let sharedManager = PhotosDataManager()

    let decoder = ImageDecoder()
    let photoCache = AutoPurgingImageCache(
        memoryCapacity: 100 * 1024 * 1024,
        preferredMemoryUsageAfterPurge: 60 * 1024 * 1024
    )

    //MARK: - Image Downloading
    
    func getNetworkImage(urlString: String, completion: (UIImage -> Void)) -> (ImageRequest) {
        let queue = decoder.queue.underlyingQueue
        let request = Alamofire.request(.GET, urlString)
        let imageRequest = ImageRequest(request: request)
        imageRequest.request.response(
            queue: queue,
            responseSerializer: Request.imageResponseSerializer(),
            completionHandler: { response in
                guard let image = response.result.value else {
                    return
                }
                let decodeOperation = self.decodeImage(image) { image in
                    completion(image)
                    self.cacheImage(image, urlString: urlString)
                }
                imageRequest.decodeOperation = decodeOperation
            }
        )
        return imageRequest
    }

    func decodeImage(image: UIImage, completion: (UIImage -> Void)) -> DecodeOperation {
        let decodeOperation = DecodeOperation(image: image, decoder: self.decoder, completion: completion)
        self.decoder.queue.addOperation(decodeOperation)
        return decodeOperation
    }
    
    //MARK: - Image Caching

    func cacheImage(image: Image, urlString: String) {
        photoCache.addImage(image, withIdentifier: urlString)
    }

    func cachedImage(urlString: String) -> Image? {
        return photoCache.imageWithIdentifier(urlString)
    }
    
}
