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
    
    func lock() {
        if let _ = viewWithTag(10) {
            //View is already locked
        }
        else {
            let lockView = UIView(frame: bounds)
            lockView.backgroundColor = UIColor(white: 0.0, alpha: 0.75)
            lockView.tag = 10
            lockView.alpha = 0.0
            let activity = UIActivityIndicatorView(activityIndicatorStyle: .White)
            activity.hidesWhenStopped = true
            activity.center = lockView.center
            lockView.addSubview(activity)
            activity.startAnimating()
            addSubview(lockView)
            
            UIView.animateWithDuration(0.2) {
                lockView.alpha = 1.0
            }
        }
    }
    
    func unlock() {
        if let lockView = viewWithTag(10) {
            UIView.animateWithDuration(0.2, animations: {
                lockView.alpha = 0.0
            }) { finished in
                lockView.removeFromSuperview()
            }
        }
    }
    
    func fadeOut(duration: NSTimeInterval) {
        UIView.animateWithDuration(duration) {
            self.alpha = 0.0
        }
    }
    
    func fadeIn(duration: NSTimeInterval) {
        UIView.animateWithDuration(duration) {
            self.alpha = 1.0
        }
    }
}