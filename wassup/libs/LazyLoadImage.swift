//
//  LazyLoadImage.swift
//  wassup
//
//  Created by MAC on 9/22/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class LazyLoadImage: NSObject {
    
    static var image:UIImageView!
    static var indicator:UIActivityIndicatorView!
    static var cancelsTask = false
    static var activeImageURL:NSURL!
    static var task:NSURLSessionDataTask!
    
    class func showImageForView(imageView: UIImageView, link: String) {
        let url = NSURL(string: link)!
        activeImageURL = url
        image = imageView
        indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        indicator.frame = image.frame
        
        task = UIImageLoader.defaultLoader().loadImageWithURL(url, hasCache: loadCache, sendingRequest: sendingRequest, requestCompleted: {
            (error: NSError!, image: UIImage!, loadedFromSource: UIImageLoadSource!) in
            if !self.cancelsTask && !(self.activeImageURL.absoluteString == url.absoluteString) {
                return
            }
            self.indicator.hidden = true
            self.indicator.stopAnimating()
            if loadedFromSource == UIImageLoadSource.Disk {
                self.image.image = image
            }
        })
    }
    
    class func loadCache(image: UIImage!, loadedFromSource: UIImageLoadSource!) -> Void {
        indicator.hidden = true
        self.image.image = image
    }
    
    class func sendingRequest(didHaveCachedImage: Bool!) {
        if !didHaveCachedImage {
            indicator.startAnimating()
            indicator.hidden = false
        }
    }
}
