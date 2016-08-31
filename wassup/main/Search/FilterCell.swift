//
//  FilterCell.swift
//  wassup
//
//  Created by MAC on 8/26/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class FilterCell: UITableViewCell {

    static let iden = "FilterCell"
    
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
