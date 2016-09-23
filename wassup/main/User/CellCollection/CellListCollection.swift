//
//  CellListCollection.swift
//  wassup
//
//  Created by MAC on 9/13/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class CellListCollection: UITableViewCell {

    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var radioBtn: SSRadioButton!
    
    var id = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func initData(data: Dictionary<String,AnyObject>) {
        name.text = CONVERT_STRING(data["name"])
        Utils.loadImage(img, link: CONVERT_STRING(data["icon"]))
        info.text = "\(CONVERT_STRING(data["total_event"])) hoạt động | \(CONVERT_STRING(data["total_host"])) địa điểm | \(CONVERT_STRING(data["total_article"])) bài viết"
        id = CONVERT_STRING(data["id"])
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
