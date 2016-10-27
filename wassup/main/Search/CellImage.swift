//
//  CellImage.swift
//  wassup
//
//  Created by MAC on 8/25/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class CellImage: UICollectionViewCell {

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var indexPath:NSIndexPath!
    var image:UIImage!
    var cancelsTask = false
    var task:NSURLSessionDataTask!
    var activeImageURL:NSURL!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        indicator.startAnimating()
        indicator.hidden = true
        cancelsTask = false
    }
    
    override func prepareForReuse() {
        if cancelsTask {
            task.cancel()
        }
    }
    
    func setShot(str: String) {
        let url = NSURL(string: str)!
        activeImageURL = url
        task = UIImageLoader.defaultLoader().loadImageWithURL(url, hasCache: loadCache, sendingRequest: sendingRequest, requestCompleted: {
            (error: NSError!, image: UIImage!, loadedFromSource: UIImageLoadSource!) in
            if !self.cancelsTask && !(self.activeImageURL.absoluteString == url.absoluteString) {
                return
            }
            self.indicator.hidden = true
            self.indicator.stopAnimating()
            if loadedFromSource == UIImageLoadSource.Disk {
                self.img.image = image
            }
        })
    }
    
    func loadCache(image: UIImage!, loadedFromSource: UIImageLoadSource!) -> Void {
        indicator.hidden = true
        img.image = image
    }

    func sendingRequest(didHaveCachedImage: Bool!) {
        if !didHaveCachedImage {
            indicator.startAnimating()
            indicator.hidden = false
        }
    }
    
    @IBAction func close(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("DESELECT_IMAGE_COMMENT", object: nil, userInfo: ["indexPath":indexPath])
    }
}
