//
//  CellTag.swift
//  wassup
//
//  Created by MAC on 8/30/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class CellTag: UITableViewCell {

    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var name: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
