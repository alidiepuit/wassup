//
//  CellProfileHeaderFavorite.swift
//  wassup
//
//  Created by MAC on 9/12/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class CellProfileHeaderFavorite: UITableViewCell {

    @IBOutlet weak var tagListView: TagListView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func initData(data:Dictionary<String,AnyObject>) {
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
