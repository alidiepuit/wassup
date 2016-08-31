//
//  Search.swift
//  wassup
//
//  Created by MAC on 8/24/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class Search: ModelBase {
    func getIndex(page: Int) -> String {
        var idx = 0
        if page <= 1 {
            idx = 0
        } else {
            idx = (page-1)*10
        }
        return String(idx)
    }
    
    func getSeed() -> String{
        let ran = arc4random_uniform(9999) + 1;
        return String(ran)
    }
    
    func keyword(keyword: String, index page: Int, callback: ServiceResponse) {
        let model = "search/get"
        let dict = ["keyword": keyword,
                    "index": getIndex(page),
                    "seed": getSeed(),
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func eventDetailEvent(id: String, callback: ServiceResponse) {
        let model = "event/getEvent"
        let dict = ["id": id,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func eventDetailHost(id: String, callback: ServiceResponse) {
        let model = "host/getHost"
        let dict = ["id": id,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func eventDetailBlog(id: String, callback: ServiceResponse) {
        let model = "article/getArticle"
        let dict = ["id": id,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func events(hasTop: Int, index page: Int, keyword: String, action: String, districtId: String, callback: ServiceResponse) {
        let model = "event/getHotEvent"
        
        let dict = ["has_top": String(hasTop),
                    "index": getIndex(page),
                    "keyword": keyword,
                    "action": action,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style,
                    "longtitude": String(Utils.sharedInstance.location.long),
                    "lattitude": String(Utils.sharedInstance.location.lat),
                    "distance": "100",
                    "district_id": districtId]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func hosts(hasTop: Int, index page: Int, keyword: String, action: String, districtId: String, callback: ServiceResponse) {
        let model = "host/getHotHost"
        let dict = ["has_top": String(hasTop),
                    "index": getIndex(page),
                    "keyword": keyword,
                    "action": action,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style,
                    "longtitude": String(Utils.sharedInstance.location.long),
                    "lattitude": String(Utils.sharedInstance.location.lat),
                    "distance": "100",
                    "district_id": districtId]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func blogs(hasTop: Int, index page: Int, keyword: String, action: String, districtId: String, callback: ServiceResponse) {
        let model = "article/getHotArticle"
        let dict = ["has_top": String(hasTop),
                    "index": getIndex(page),
                    "keyword": keyword,
                    "action": action,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style,
                    "longtitude": String(Utils.sharedInstance.location.long),
                    "lattitude": String(Utils.sharedInstance.location.lat),
                    "distance": "100",
                    "district_id": districtId]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func hot(hasTop: Int, index page: Int, keyword: String, action: String, districtId: String, callback: ServiceResponse) {
        let model = "event/getHotObject"
        let dict = ["index": getIndex(page),
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style,]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
}