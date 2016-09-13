//
//  NSMutableData.swift
//  wassup
//
//  Created by MAC on 9/13/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

extension NSMutableData {
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}