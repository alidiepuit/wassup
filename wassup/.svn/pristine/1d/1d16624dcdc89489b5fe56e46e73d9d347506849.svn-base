//
//  Tags.swift
//  wassup
//
//  Created by MAC on 8/17/16.
//  Copyright (c) 2016 MAC. All rights reserved.
//

import UIKit

class MapsModel: ModelBase {
    func getEventsOnMap(lat: Double, long: Double, keyword: String, tags: String, callback: ServiceResponse) {
        let modul = "event/getEventsOnMap"
        let dict:Dictionary<String, String> = ["lattitude"  : String(lat),
                                               "longtitude" : String(long),
                                               "keyword"    : keyword,
                                               "tags"       : tags,]
        self.callAPI("POST", module: modul, params: dict, callback: callback)
    }
}
