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
    
    var indexPath:NSIndexPath!
    var image:UIImage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func close(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("DESELECT_IMAGE_COMMENT", object: nil, userInfo: ["indexPath":indexPath])
    }
}
