//
//  Feeds.swift
//  wassup
//
//  Created by MAC on 8/25/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

public enum ObjectType: Int32 {
    case Event = 1
    case Follow
    case Checkin
    case Comment
    case UserRegistEvent
    case ActivityLog
    case Article
    case Host
    case CommentArticle
    case Tag
    case Users
}

class Filter: ModelBase {
    func getProvince(callback: ServiceResponse) {
        let model = "district/getProvince"
        self.callAPI("POST", module: model, params: nil, callback: callback)
    }
    
    func getDistrict(id: String, objectType: ObjectType, callback: ServiceResponse) {
        let model = "district/getDistrict"
        let data = ["city_alias" : id,
                    "object_type": String(objectType.rawValue)]
        self.callAPI("POST", module: model, params: data, callback: callback)
    }
}
