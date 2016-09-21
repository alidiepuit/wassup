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
    case UserRegistEvent = 5
    case ActivityLog
    case Article
    case Host
    case CommentArticle
    case Tag = 10
    case Users
}

public enum ActivityType: String {
    case Checkin = "%@ tại %@"
    case CheckinHasFeeling = "%@ đang %@ tại %@"
    case Comment = "%@ đã bình luận %@"
    case UserRegistEvent = "%@ đã quan tâm hoạt động %@"
    case PostActivity = "%@ mới đăng hoạt động %@"
    case PostArticle = "%@ mới đăng bài viết %@"
}

public enum CollectionType: String {
    case Feed = "6"
    case Article = "7"
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
