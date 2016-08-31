//
//  ItemSearch.swift
//  wassup
//
//  Created by MAC on 8/20/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class ItemSearch: UIView {

    var contentView:UIView?
    // other outlets
    @IBOutlet weak var labelCategory: UILabel!
    
    @IBInspectable var labelCategoryCornerRadius:CGFloat {
        get {
            return labelCategory.layer.cornerRadius
        }
        set(rad) {
            labelCategory.layer.cornerRadius = rad
            labelCategory.layer.masksToBounds = true
        }
    }
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        contentView = self.loadViewFromNib()
        contentView!.frame = self.bounds
        contentView!.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        self.addSubview(contentView!)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "ItemSearch", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }

}
