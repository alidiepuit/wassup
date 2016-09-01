//
//  UIColor+FromRGBHex.swift
//  wassup
//
//  Created by MAC on 8/16/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit

extension UITextField {
    
    override func corner(rad: Int, border: Int, colorBorder: Int) {
        layer.cornerRadius = CGFloat(rad)
        layer.borderWidth = CGFloat(border)
        clipsToBounds = true
        layer.borderColor = UIColor.fromRgbHex(colorBorder).CGColor
        attributedPlaceholder = NSAttributedString(string:placeholder!,
            attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
    }
    
    func intentLeft(left: Int) {
        let spacerView = UIView(frame:CGRect(x:0, y:0, width:left, height:10))
        self.leftViewMode = UITextFieldViewMode.Always
        self.leftView = spacerView
    }
}