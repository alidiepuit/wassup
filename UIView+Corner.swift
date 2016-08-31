//
//  UIColor+FromRGBHex.swift
//  wassup
//
//  Created by MAC on 8/16/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit

extension UIView {
    
    func corner(rad: Int, border: Int, colorBorder: Int) {
        layer.cornerRadius = CGFloat(rad)
        layer.borderWidth = CGFloat(border)
        clipsToBounds = true
        layer.borderColor = UIColor.fromRgbHex(colorBorder).CGColor
    }
}

extension UIView {
    func loadViewFromNib(name: String) -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: name, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
}