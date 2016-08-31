//
//  CellFeed.swift
//  wassup
//
//  Created by MAC on 8/23/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class CellFeed: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!

    @IBOutlet weak var btnRight: UIView!
    @IBOutlet weak var btnLeft: UIView!
    @IBOutlet weak var icLike: UIImageView!
    @IBOutlet weak var icSave: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTimeAgo: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    func initCell(data: Dictionary<String, AnyObject>) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
