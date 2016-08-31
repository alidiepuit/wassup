//
//  DemoCell.swift
//  wassup
//
//  Created by MAC on 8/22/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class DemoCell: UITableViewCell {

    @IBOutlet weak var content: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        initContent()
    }
    
    func initContent() {
        do {
            let path = NSBundle.mainBundle().pathForResource("test", ofType: "html")
            let str = try String(contentsOfFile: path!)
            let attr = try NSAttributedString(data: str.dataUsingEncoding(NSUTF8StringEncoding)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding], documentAttributes: nil)
            content.text = str
        }catch {
            
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}