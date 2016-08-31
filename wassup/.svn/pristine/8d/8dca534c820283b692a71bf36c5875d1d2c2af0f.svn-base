//
//  Tags.swift
//  wassup
//
//  Created by MAC on 8/17/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit

class TagsModel: ModelBase {
    func getRecommandtionTags(callback: ServiceResponse) {
        let modul = "tag/getRecommandtionTags"
        self.callAPI("GET", module: modul, params: nil, callback: callback)
    }
    
    func saveRecommandtionTags(tags: Array<String>, callback: ServiceResponse) {
        let modul = "u_user/saveRecommendations"
        let joiner = ","
        let dict = ["tags": tags.joinWithSeparator(joiner),
            "login_style": User.sharedInstance.login_style,
            "user_token": User.sharedInstance.token]
        self.callAPI("POST", module: modul, params: dict, callback: callback)
    }
}
