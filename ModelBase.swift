//
//  ModelBase.swift
//  App568Play
//
//  Created by SSG on 4/25/16.
//  Copyright © 2016 Ramotion. All rights reserved.
//

import Foundation

var API: String {return "http://dev.wassup.com.vn/app/api/"}

public class ModelBase: NSObject{
    
    public func callAPI(method: String, module: String, params:Dictionary<String, String>?, callback: ServiceResponse?) {
        let api = API + module
        let connector:Connector = Connector()
        connector.callService(method, serviceURL: api, params: params, callback: callback)
    }
}
