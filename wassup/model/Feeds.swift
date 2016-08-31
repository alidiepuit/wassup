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
        var idx = 0
        if page <= 1 {
            idx = 0
        } else {
            idx = (page-1)*10
        }
        let dict = ["event_id": eventId,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style,
                    "index": CONVERT_STRING(idx),
                    "top": CONVERT_STRING(top)]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
}
