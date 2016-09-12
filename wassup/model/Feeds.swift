//
//  Feeds.swift
//  wassup
//
//  Created by MAC on 8/25/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class Feeds: ModelBase {
    func listEventFeeds(eventId: String, index page:Int, top:Int, callback: ServiceResponse) {
        let model = "event/getEventFeeds"
        let dict = ["event_id": eventId,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style,
                    "index": getIndex(page),
                    "top": CONVERT_STRING(top)]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func getFeeds(index page:Int, callback: ServiceResponse) {
        let model = "feed/getFeeds"
        let dict = ["user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style,
                    "index": getIndex(page),
                    ]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func getMyPost(userId: String, index page: Int, callback: ServiceResponse) {
        let model = "feed/getMyPost"
        let dict = ["user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style,
                    "user_id": userId,
                    "index": getIndex(page)
        ]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func getOwnerActivities(userId: String, index page: Int, callback: ServiceResponse) {
        let model = "feed/getOwnerActivities"
        let dict = ["user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style,
                    "user_id": userId,
                    "index": getIndex(page)
        ]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
}
