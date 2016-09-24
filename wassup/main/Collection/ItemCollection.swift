//
//  Collection.swift
//  wassup
//
//  Created by MAC on 9/24/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class ItemCollection: NSObject {
    var name:String!
    var avatar:NSData!
    var totalEvent = 0
    var totalHost = 0
    var totalArticle = 0
    var id = ""
    
    init(name:String, avatar:NSData) {
        self.name = name
        self.avatar = avatar
    }
    
    func exportDictionary() -> Dictionary<String,AnyObject> {
        return ["name": name,
                "icon": "",
         "total_event": totalEvent,
          "total_host": totalHost,
       "total_article": totalArticle,
                  "id": id,
        ]
    }
}
