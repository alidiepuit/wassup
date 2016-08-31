//
//  CellFollower.swift
//  wassup
//
//  Created by MAC on 8/29/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class CellFollower: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var btnFollowed: UIButton!
    
    var userId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatar.corner(30, border: 0, colorBorder: 0x000000)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func clickFollow(sender: AnyObject) {
        let md = User()
        md.followUser(userId)
        btnFollow.hidden = true
        btnFollowed.hidden = false
    }
}
