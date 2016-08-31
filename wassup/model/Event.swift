//
//  Feeds.swift
//  wassup
//
//  Created by MAC on 8/25/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class Host: ModelBase {
    func listFollows(eventId: String, callback: ServiceResponse) {
        let model = "host/getUserFollows"
        let dict = ["id": eventId,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style,
                    ]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func listCheckins(eventId: String, callback: ServiceResponse) {
        let model = "host/getUserCheckins"
        let dict = ["id": eventId,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style,
                    ]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
}
