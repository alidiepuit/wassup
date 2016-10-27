//
//  Language.swift
//  wassup
//
//  Created by MAC on 8/23/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

func Localization(id:String) -> String {
    return Language.sharedInstance.getString(id)
}

class Language: NSObject {
    static var sharedInstance = Language()
    var data:Dictionary<String, String>?
    override init() {
        super.init()
        initResource()
    }
    
    func initResource() {
        let path = NSBundle.mainBundle().pathForResource(User.sharedInstance.language, ofType: "strings")
        data = NSDictionary(contentsOfFile: path!) as? Dictionary<String,String>
    }
    
    func getString(id: String) -> String{
        let sid = id.lowercaseString
        guard let res = data![sid] else {
            return id
        }
        return res
    }
}
