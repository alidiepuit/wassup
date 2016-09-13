//
//  Feeds.swift
//  wassup
//
//  Created by MAC on 8/25/16.
//  Copyright © 2016 MAC. All rights reserved.
//

import UIKit

class Collection: ModelBase {
    func getMyCollections(callback: ServiceResponse) {
        let model = "u_user/getCollections"
        let dict = ["user_id": User.sharedInstance.userId,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style,
                    ]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func getCollections(userId:String, callback: ServiceResponse) {
        let model = "user/getCollections"
        let dict = ["user_id": userId,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style,
                    ]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func bookmark(collectionId: String, objectId: String, objectType: String, callback: ServiceResponse) {
        let model = "u_user/bookmark"
        let dict = ["collection_id": collectionId,
                    "object_id": objectId,
                    "object_type": objectType,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style,
                    ]
        self.callAPI("POST", module: model, params: dict, callback: callback)
    }
    
    func createCollection(collectionName: String, icon: NSData, callback: ServiceResponse) {
        let model = "u_user/createCollection"
        let dict = ["collection_name": collectionName,
                    "icon": icon,
                    "user_token": User.sharedInstance.token,
                    "login_style": User.sharedInstance.login_style,
                    ]
        self.callAPI(model, params: dict, callback: callback)
    }
}
